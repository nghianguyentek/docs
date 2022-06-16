{
**********************************************************************
*      ENERGY Utility Billing and Information System                 *
**********************************************************************
* Copyright        : Peace Computers New Zealand Limited             *
* Developed By     : Peace Computers New Zealand Limited             *
* Marketing Rights : Peace Computers New Zealand Limited             *
*                    P O Box 37-580   Parnell   Auckland             *
*                    Telephone 0-9-307 3974   Facsimile 0-9-307 3973 *
**********************************************************************
* Author        : Sajeewa Dayaratne                                  *
* Date Created  : 20/03/2003                                         *
* Program Title : pub_component.4gl                                  *
* Function(s)   : Tariff Product Dependancy Maintence Functions      *
**********************************************************************
}

globals ",globals/debug_globals.4gl"

database energy
  define
    v_debug_str        char(400),
    v_status           integer

{*
 * Adds or Deletes rows from pm_reg_prod_comp table
 * @param pv_mode
 *        'A' to Add
 *        'D' to delete, and reset dependency
 *        'U' to update,
 *        'T' to test (no data insert)
 *        'R' to remove entry only, no reset dependency
 *}
function pub_proc_pm_reg_prod_comp(pv_mode, pv_pm_tariff_id)

  #Parameters
  define
    pv_mode             char(1),
    pv_pm_tariff_id     like pm_tariff.pm_tariff_id

  define
    v_require_manual_setup smallint

  #Local Variables
  define
    v_pm_tariff_rec     record like pm_tariff.*,
    v_pm_reg_prod_comp_rec record like pm_reg_prod_comp.*,
    v_tariff            like tm_tariff.tariffclass,
    v_tar_idx           smallint,
    v_tar_max           smallint,
    v_tar_arr           array[1000] of integer,
    v_comp_type         like tm_component.comp_type,
    v_comp_id           like tm_component.comp_id,
    v_min_reg           smallint,
    i                   smallint,
    v_changeuser        char(10),
    v_changedate        date,
    v_no_rows           smallint,
    v_dependency_rows   smallint,
    v_premise_params    char(1),
    v_allow_disable     smallint,
    v_bill_comp         char(1)


  if g_is_debug_on then
    call disp_debug(1, "function pub_proc_pm_reg_prod_comp")

    let v_debug_str = "pv_mode: ", pv_mode
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_pm_tariff_id: ", pv_pm_tariff_id
    call disp_debug(2, v_debug_str)
  end if

  whenever error call pub_log_and_continue

  let v_changeuser = getlogname()
  let v_changedate = today
  let v_require_manual_setup = false

  select * into v_pm_tariff_rec.*
    from pm_tariff
    where pm_tariff_id = pv_pm_tariff_id
  let v_status = status

  if v_status = 0 and (pv_mode = "D" or pv_mode = "R")  then
    delete from pm_reg_prod_comp
      where pm_tariff_id = pv_pm_tariff_id
    let v_status = status
  end if

  if v_status = 0 and pv_mode = "D" then
    #delete mode is called when a register is deleted, so it is
    #a good idea to reset the dependency
    declare upd_reg_prod_comp_c cursor for
      select * from pm_reg_prod_comp
        where pm_tariff_id in
          (select pm_tariff_id from pm_tariff
            where premnum = v_pm_tariff_rec.premnum
              and util_type = v_pm_tariff_rec.util_type)
          and base_service  = v_pm_tariff_rec.servicenum
          and base_register = v_pm_tariff_rec.registernum
      order by pm_tariff_id, comp_type, comp_id
      for update
    foreach upd_reg_prod_comp_c into v_pm_reg_prod_comp_rec.*
      let v_status = status
      if v_status != 0 then
        exit foreach
      end if

      select min(base_register) into v_min_reg
        from pm_reg_prod_comp
        where pm_tariff_id = v_pm_reg_prod_comp_rec.pm_tariff_id
          and comp_type = v_pm_reg_prod_comp_rec.comp_type
          and comp_id = v_pm_reg_prod_comp_rec.comp_id
          and base_service = 0
      if v_min_reg is null or v_min_reg >= 0 then
        let v_min_reg = -1
      else
        let v_min_reg = v_min_reg - 1
      end if

      #reset the dependency
      update pm_reg_prod_comp
        set base_service  = 0,
            base_register = v_min_reg,
            changeuser    = v_changeuser,
            changedate    = v_changedate
        where current of upd_reg_prod_comp_c

      call pub_component_info(v_comp_type, v_comp_id)
        returning v_dependency_rows, v_premise_params, v_allow_disable

      if v_allow_disable then
        #disabling component has to be separated because
        #component might have two rows of dependency, so need to disable
        #both
        update pm_reg_prod_comp
          set bill_comp = "N",
              changeuser    = v_changeuser,
              changedate    = v_changedate
          where pm_tariff_id = v_pm_reg_prod_comp_rec.pm_tariff_id
            and comp_type = v_pm_reg_prod_comp_rec.comp_type
            and comp_id = v_pm_reg_prod_comp_rec.comp_id
      end if
    end foreach
  end if

  if v_status = 0 and (pv_mode = "A" or pv_mode = "U" or pv_mode = "T") then
    # Get tariffclass and related tariffclass into v_tar_arr
    let v_tar_idx = 1
    let v_tar_max = 1
    let v_tar_arr[v_tar_max] = v_pm_tariff_rec.tariffclass
    while true
      declare related_tar_c cursor for
        select distinct related_tariff from tm_related_tar
          where util_type = v_pm_tariff_rec.util_type
            and tariffclass = v_tar_arr[v_tar_idx]
      foreach related_tar_c into v_tariff
        let v_tar_max = v_tar_max + 1
        let v_tar_arr[v_tar_max] = v_tariff
      end foreach
      if v_tar_idx = v_tar_max or v_tar_max > 1000 then
        exit while
      else
        let v_tar_idx = v_tar_idx + 1
      end if
    end while

    # For all tariffclass in v_tar_arr, insert product component of
    # the tariffclass into pm_reg_prod_comp
    for v_tar_idx = 1 to v_tar_max
      declare component_c cursor for
        select distinct comp_type, comp_id from tm_product p, tm_component c
        where p.util_type = v_pm_tariff_rec.util_type
          and p.tariffclass = v_tar_arr[v_tar_idx]
          and (p.date_effective <= v_pm_tariff_rec.end_date or
            v_pm_tariff_rec.end_date is null)
          and c.prod_num = p.prod_num
          and not exists (select 1 from pm_reg_prod_comp
            where pm_tariff_id = pv_pm_tariff_id
              and comp_type = c.comp_type
              and comp_id = c.comp_id)


      foreach component_c into v_comp_type, v_comp_id

        call pub_component_info(v_comp_type, v_comp_id)
          returning v_dependency_rows, v_premise_params, v_allow_disable

        let v_bill_comp = "Y"
        if v_dependency_rows > 0 then
          #Dependency required, so do not enable automatically. Therefore
          #it requires manual setup
          let v_no_rows = v_dependency_rows
          if v_allow_disable then
            let v_bill_comp = "N"
          end if
          let v_require_manual_setup = true
        else
          let v_no_rows = 1
        end if

        if pv_mode = "T" then
          #If in testing mode, no need to insert anything
        else
          for i = 1 to v_no_rows
            insert into pm_reg_prod_comp values
              (v_comp_type, v_comp_id, v_bill_comp, 0, -i,
              v_changeuser, v_changedate, pv_pm_tariff_id)
          end for
        end if
      end foreach
    end for
  end if

  if g_is_debug_on then
    call disp_debug(1, "end function pub_proc_pm_reg_prod_comp")
  end if

  return v_require_manual_setup

end function

function pub_require_pm_reg_prod_comp(pv_premnum,     pv_servicenum,
                                      pv_util_type,   pv_registernum,
                                      pv_date)
  #parameters
  define
    pv_premnum          like pm_premise.premnum,
    pv_servicenum       like pm_service.servicenum,
    pv_util_type        like pm_service.util_type,
    pv_registernum      like pm_register.registernum,
    pv_date             date

  define
    v_require_manual_setup smallint

  define
    v_pm_tariff_id      like pm_tariff.pm_tariff_id

  whenever error call pub_log_and_continue

  let v_require_manual_setup = false

  declare pm_tariff_c cursor for
    select pm_tariff_id from pm_tariff
      where premnum = pv_premnum
        and util_type = pv_util_type
        and servicenum = pv_servicenum
        and registernum = pv_registernum
        and start_date <= pv_date
        and (end_date is null or end_date >= pv_date)

  foreach pm_tariff_c into v_pm_tariff_id
    call pub_proc_pm_reg_prod_comp("T", v_pm_tariff_id)
      returning v_require_manual_setup
    if v_require_manual_setup then
      exit foreach
    end if
  end foreach

  return v_require_manual_setup

end function


function pub_component_info(pv_comp_type, pv_comp_id)
  define
    pv_comp_type  like tm_component.comp_type,
    pv_comp_id    like tm_component.comp_id

  define
    v_dependency_rows smallint,
    v_premise_params  char(1),
    v_allow_disable   smallint

  define
    v_comp_type_rec   record like tm_prod_comp_type.*,
    v_prod_units      like tm_comp_var_step.prod_units,
    v_base_units      like tm_comp_var_step.prod_units,
    v_default_pfq     like tm_comp_excess_chg.default_pfq,
    v_sum_demand      char(1)

  whenever error call pub_log_and_continue

  select * into v_comp_type_rec.*
    from tm_prod_comp_type
    where comp_type = pv_comp_type
  let v_status = status

  if v_comp_type_rec.base_registers = "Y" then
    let v_dependency_rows = 1
  else
    let v_dependency_rows = 0
  end if
  let v_premise_params = v_comp_type_rec.premise_params
  let v_allow_disable = true

  case
    when v_status != 0
      #not found

    when pv_comp_type = "var_step"
      select prod_units, base_units into v_prod_units, v_base_units
        from tm_comp_var_step
        where comp_id = pv_comp_id
      if v_prod_units = v_base_units then
        #It's a nightsaver disguised in var_step
        let v_dependency_rows = 0
        let v_allow_disable = false
      end if

    when pv_comp_type = "pwr_fact"
      let v_dependency_rows = 2

    when pv_comp_type = "chargecred"
      select sum_demand into v_sum_demand
        from tm_comp_chargecred
        where comp_id = pv_comp_id
      if v_sum_demand = "Y" then
        let v_dependency_rows = 2
      end if

    when pv_comp_type = "excess_chg"
      let v_allow_disable = false
      select default_pfq, prod_units
        into v_default_pfq, v_prod_units
        from tm_comp_excess_chg
        where comp_id = pv_comp_id
      if v_default_pfq is null and v_prod_units = "kW" then
        let v_dependency_rows = 2
      else
        let v_dependency_rows = 0
      end if

    when pv_comp_type = "stand_chg" or
         pv_comp_type = "pso_levy" or
         pv_comp_type = "capa_chg"
      let v_allow_disable = false
  end case

  return v_dependency_rows, v_premise_params, v_allow_disable

end function

function pub_refresh_pm_reg_prod_comp(pv_premnum)
  define pv_premnum like pm_premise.premnum
  define v_pm_tariff_id like pm_tariff.pm_tariff_id
  define v_dummy smallint

  declare refresh_pm_tariff_c cursor for
    select pm_tariff_id from pm_tariff
      where premnum = pv_premnum

  foreach refresh_pm_tariff_c into v_pm_tariff_id
    call pub_proc_pm_reg_prod_comp("A", v_pm_tariff_id)
      returning v_dummy
  end foreach

end function
