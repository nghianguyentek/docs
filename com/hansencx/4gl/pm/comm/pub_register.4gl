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
* Author        : C Tan                                              *
* Date Created  : 02/07/2002                                         *
* Program Title : add service                                        *
*                                                                    *
**********************************************************************
* Description :                                                      *
*                                                                    *
**********************************************************************
* Notes :                                                            *
*                                                                    *
*                                                                    *
**********************************************************************
* Modified By   Date      Description
*
* Stephen       20/02/03  CQ113060 added functions
*  Rodley                  pub_get_register_display5,
*                          pub_get_register_display4,
*                          pub_get_register_display2
*
* Steve R       29/04/03  CQ118269 Removed redundant error message that
*                         was present after the call to get_calcode_met
*                         and enclosed the same function in an if
*                         statement to check if v_calcode is NULL. Also
*                         gave more meaning to the error message if
*                         there is a NULL calibration code.
*
*
* Diane So     12/03/03  CQ114625 Obsolete Structure 14 Tariff       *
*                        removed calls to val_xb_premise()           *
*                                                                    *
*
* A Young       23/06/03  CQ120637 removed redundant error message
*                         in pub_get_register_display5()
**********************************************************************
}

globals ",globals/debug_globals.4gl"

database energy

DEFINE
  v_status             integer,
  v_count              integer,
  v_error              smallint,
  v_suberr             integer,
  v_errmsg             integer,
  v_success            integer,
  log_error            smallint,
  error_message        char(60),
  v_err_msg            char(100),
  v_debug_str          char(150),
  v_flag               smallint,
  v_tmp_str            char(400),
  v_changedate         datetime year to second,
  v_user               char(15)



#Validate a register.
#-----------------------------------------------------------------------------
function pub_v_register(pv_register_rec, pv_tariffclass, pv_install_date)
#-----------------------------------------------------------------------------

  define
    pv_register_rec     record like pm_register.*,
    pv_tariffclass      like tm_tariff.tariffclass,
    pv_install_date     date,
    v_company_code      like tm_tariff.company_code,
    v_company_code2     like tm_tariff.company_code,
    v_division_code     like pm_division.division_code,
    v_tariffclass       like tm_tariff.tariffclass,
    v_tariff_unit       like b_units.unit_abbrev,
    v_servicetype       like pm_service.servicetype,
    v_type_consumption  like pm_service.type_consumption,
    v_sql               char(200),
    v_date_effective    date,
    v_need_base_regs    smallint

  if g_is_debug_on then
    call disp_debug(1,"function pub_v_register")

    let v_debug_str = "pv_register_rec.premnum:",pv_register_rec.premnum
    call disp_debug(2,v_debug_str)
    let v_debug_str = "pv_register_rec.servicenum:",pv_register_rec.servicenum
    call disp_debug(2,v_debug_str)
    let v_debug_str = "pv_register_rec.util_type:",pv_register_rec.util_type
    call disp_debug(2,v_debug_str)
    let v_debug_str = "pv_register_rec.calcode:",pv_register_rec.calcode
    call disp_debug(2,v_debug_str)
    let v_debug_str = "pv_tariffclass:",pv_tariffclass
    call disp_debug(2,v_debug_str)
    let v_debug_str = "pv_install_date:",pv_install_date
    call disp_debug(2,v_debug_str)
  end if

  let v_error = false
  let v_suberr = 0
  let v_tariffclass = null

  if pv_tariffclass is not null then
    if pub_tariff_is_obsolete(pv_tariffclass, pv_register_rec.util_type) then
      let v_error = true
      let v_suberr = 3114    #Obsolete Tariff
      return v_error, v_suberr, pv_tariffclass
    end if

    declare tm_tariff_c cursor for
      select date_effective, company_code
        from tm_tariff
        where tariffclass = pv_tariffclass
          and util_type   = pv_register_rec.util_type
          and date_effective <= pv_install_date
          order by date_effective desc

    open tm_tariff_c
    fetch tm_tariff_c into v_date_effective, v_company_code
    let v_status = status
    close tm_tariff_c

    if v_status <> 0 then
      let v_error = true
      let v_suberr = 3115    #Invalid tariff (not effective)
      return v_error, v_suberr, pv_tariffclass
    end if

    if multi_company() then
      select company_code into v_company_code2
        from pm_division
        where division_code in
        (select division_code from pm_premise
           where premnum = pv_register_rec.premnum
        )

      if v_company_code <> v_company_code2 then
        let v_error  = true
        let v_suberr = 3116    #Premise and tariff company not the same
        return v_error, v_suberr, pv_tariffclass
      end if
    end if
    let v_tariffclass = pv_tariffclass
  else

    #Get default tariff
    select division_code into v_division_code
      from pm_premise
      where premnum = pv_register_rec.premnum

    select type_consumption into v_type_consumption
      from pm_service
      where servicenum = pv_register_rec.servicenum
        and util_type = pv_register_rec.util_type
        and premnum = pv_register_rec.premnum

    declare tariffclass_c cursor for
      select tariffclass into v_tariffclass
        from pm_tar_default
        where util_type = pv_register_rec.util_type
          and   type_consumption = v_type_consumption
          and   division_code = v_division_code

    #end Get default tariff

    foreach tariffclass_c into v_tariffclass

      let v_debug_str = "default tariff is ", v_tariffclass
      call disp_debug(20, v_debug_str)

      #### Check tariff structure
      if pub_tarstr_cl(v_tariffclass,"15",pv_register_rec.util_type) then
      let v_count = 0
        let v_sql ="select count(*)",
                   "  from ", pv_register_rec.util_type clipped, "b_meter_install ",
                   "  where premnum = ", pv_register_rec.premnum,
                   "    and servicenum = ", pv_register_rec.servicenum,
                   "    and status_meter = 'C' "
        prepare v_sql_statement from v_sql
        declare meterservice_c cursor for v_sql_statement

        open meterservice_c
        fetch meterservice_c into v_count
        close meterservice_c

        if v_count <= 0 then
          let v_error = true
          let v_suberr = 3120    #No maximum demand measuring
          return v_error, v_suberr, null
        end if
      end if
      #### end Check tariff structure

      #### Check demand unit
      call get_dep_dmd_unit(pv_register_rec.util_type, v_tariffclass, pv_install_date)
        returning v_tariff_unit, v_need_base_regs

      if v_tariff_unit is not NULL then
        select servicetype into v_servicetype
          from pm_service
          where premnum = pv_register_rec.premnum
            and util_type = pv_register_rec.util_type
            and servicenum = pv_register_rec.servicenum

        if v_servicetype = 'S' then
          let v_error = true
          let v_suberr = 3121    #Set demand unit code not valid for sub services
          return v_error, v_suberr, null
        end if

        let pv_register_rec.unit_code = get_unit_code_using_reg_descr(v_tariff_unit)
      end if
      #### end Check demand unit

      let v_count = 0
      select count(*) into v_count
        from b_units
        where unit_code = pv_register_rec.unit_code

      if v_count <= 0 then
        let v_error = true
        let v_suberr = 3173    #Unit code is invalid
        return v_error, v_suberr, null
      end if

      let v_count = 0
      select count(*) into v_count
        from b_calibration
        where calcode = pv_register_rec.calcode

      if v_count <= 0 then
        let v_error = true
        let v_suberr = 3123    #Invalid calc code
        return v_error, v_suberr, null
      end if

    end foreach

    call disp_debug(1,"end function pub_v_register")
    return v_error, v_suberr, null #no error occur
  end if

  #### Check tariff structure
  if pub_tarstr_cl(v_tariffclass,"15",pv_register_rec.util_type) then
    let v_count = 0
    let v_sql ="select count(*)",
               "  from ", pv_register_rec.util_type clipped, "b_meter_install ",
               "  where premnum = ", pv_register_rec.premnum,
               "    and servicenum = ", pv_register_rec.servicenum,
               "    and status_meter = 'C' "
    prepare v_sql_stmt from v_sql
    declare meterserv_c cursor for v_sql_stmt

    open meterserv_c
    fetch meterserv_c into v_count
    close meterserv_c

    if v_count <= 0 then
      let v_error = true
      let v_suberr = 3120    #No maximum demand measuring
      return v_error, v_suberr, v_tariffclass
    end if
  end if
  #### end Check tariff structure

  #### Check demand unit
  call get_dep_dmd_unit(pv_register_rec.util_type, v_tariffclass, pv_install_date)
    returning v_tariff_unit, v_need_base_regs

  if v_tariff_unit is not NULL then
    select servicetype into v_servicetype
      from pm_service
      where premnum = pv_register_rec.premnum
        and util_type = pv_register_rec.util_type
        and servicenum = pv_register_rec.servicenum

    if v_servicetype = 'S' then
      let v_error = true
      let v_suberr = 3121    #Set demand unit code not valid for sub services
      return v_error, v_suberr, v_tariffclass
    end if
    let pv_register_rec.unit_code = v_tariff_unit
  end if
  #### end Check demand unit

  let v_count = 0
  select count(*) into v_count
    from b_units
    where unit_code = pv_register_rec.unit_code

  if v_count <= 0 then
    let v_error = true
    let v_suberr = 3173    #Unit code is invalid
    return v_error, v_suberr, v_tariffclass
  end if

  let v_count = 0
  select count(*) into v_count
    from b_calibration
    where calcode = pv_register_rec.calcode

  if v_count <= 0 then
    let v_error = true
    let v_suberr = 3123    #Invalid calc code
    return v_error, v_suberr, v_tariffclass
  end if

  call disp_debug(1,"end function pub_v_register")
  return v_error, v_suberr, v_tariffclass

end function

#Add a register
#------------------------------------------------------------------------------
function pub_a_register(pv_register_rec, pv_stmt_excl, pv_tariffclass,
                        pv_reg_install_date)
#------------------------------------------------------------------------------
  define
    pv_register_rec     #record like pm_register.*,
    record
      premnum     like pm_register.premnum,
      servicenum  like pm_register.servicenum,
      util_type   like pm_register.util_type,
      registernum like pm_register.registernum,
      reg_descr   like pm_register.reg_descr,
      unit_code   like pm_register.unit_code,
      calcode     like pm_register.calcode,
      changeuser  like pm_register.changeuser,
      changedate  datetime year to second
    end record,
    pv_stmt_excl        smallint,
    pv_reg_install_date date,
    pv_tariffclass      like tm_tariff.tariffclass

  define
    v_count             smallint,
    v_main_priceoption  smallint,
    v_success           smallint,
    v_stmt              char(200),
    v_pm_tariff_id      like pm_tariff.pm_tariff_id,
    v_tariffclass       like pm_tariff.tariffclass,
    v_division_code     like pm_division.division_code,
    v_type_consumption  like pm_service.type_consumption,
    v_stmt_excl_rec     record like pm_stmt_exclusion.*


  if g_is_debug_on then
    call disp_debug(1,"function pub_a_register")

    let v_debug_str = "registernum:", pv_register_rec.registernum,
                      "; pv_stmt_excl:", pv_stmt_excl,
                      "; pv_reg_install_date:", pv_reg_install_date,
                      "; pv_tariffclass:", pv_tariffclass

    call disp_debug(2, v_debug_str)
  end if

  let v_error = false
  let v_suberr = 0
  let v_count = 0
  let v_success = true
  let v_changedate = current
  let v_user = getlogname()


  # some pre-processing before add a new register
  call pre_add_register(pv_register_rec.premnum, pv_register_rec.util_type,
                        pv_register_rec.servicenum, pv_register_rec.registernum,
                        pv_reg_install_date)
    returning v_success

  if v_success then

    let pv_register_rec.changedate = v_changedate
    let pv_register_rec.changeuser = v_user

    insert into pm_register values (pv_register_rec.*)

    let v_status = status

    if v_status <> 0 then
      let v_error = true
      let v_suberr = v_status
      return v_error, v_suberr
    end if

    if v_status = 0 and pv_tariffclass is null then

      # get default tariff
      select division_code into v_division_code
        from pm_premise
        where premnum = pv_register_rec.premnum

      let v_debug_str = "v_division_code = ", v_division_code
      call disp_debug(20, v_debug_str)

      select type_consumption into v_type_consumption
        from pm_service
        where servicenum = pv_register_rec.servicenum
          and util_type = pv_register_rec.util_type
          and premnum = pv_register_rec.premnum

      let v_debug_str = "v_type_consumption = ", v_type_consumption
      call disp_debug(20, v_type_consumption)

      declare v_tariffclass_c cursor for
        select tariffclass from pm_tar_default
          where util_type        = pv_register_rec.util_type
            and type_consumption = v_type_consumption
            and division_code    = v_division_code

      declare tariff_id_c cursor for
        select max(pm_tariff_id) from pm_tariff

      open tariff_id_c

      foreach v_tariffclass_c into v_tariffclass

        if v_count = 0 then
          let v_main_priceoption = true
        else
          let v_main_priceoption = false
        end if

        let v_debug_str = "v_count: ", v_count,
                          "  default tariff = ", v_tariffclass,
                          "  v_main_priceoption = ", v_main_priceoption
        call disp_debug(20, v_debug_str)

        # insert price options
        call pub_a_pm_tariff(0, pv_register_rec.premnum,
                             pv_register_rec.util_type,
                             pv_register_rec.servicenum,
                             pv_register_rec.registernum,
                             v_tariffclass, pv_reg_install_date, null,
                             v_main_priceoption, pv_reg_install_date, null)
          returning v_error, v_status, v_pm_tariff_id

        if v_error then
          let error_message = "pub_l_register() Failed add pv_tariffclass"
          call err_handler(true, v_status, error_message)
        end if

        let v_count = v_count + 1

      end foreach
      close tariff_id_c

    ##CQ109633 Begin
    else
      if v_status = 0 and pv_tariffclass <> 0 then
        #When call from BUI register maintenance page, the tariffclass pass in
        # is always 0, if it is not zero, the tariffclass is passed in through
        # API, add it into database.
        call pub_a_pm_tariff(0, pv_register_rec.premnum,
                             pv_register_rec.util_type,
                             pv_register_rec.servicenum,
                             pv_register_rec.registernum,
                             pv_tariffclass, pv_reg_install_date, null,
                             true, pv_reg_install_date, null)
          returning v_error, v_status, v_pm_tariff_id
        if v_error then
          let error_message = "pub_l_register() Failed add pv_tariffclass"
          call err_handler(true, v_status, error_message)
        end if
      end if
      ##CQ109633 End.

    end if

    if v_status <> 0 then
      let v_error = true
      let v_suberr = v_status
      return v_error, v_suberr
    end if

    if pv_stmt_excl then

      let v_stmt_excl_rec.premnum = pv_register_rec.premnum
      let v_stmt_excl_rec.util_type = pv_register_rec.util_type
      let v_stmt_excl_rec.servicenum = pv_register_rec.servicenum
      let v_stmt_excl_rec.registernum = pv_register_rec.registernum

      call pub_a_stmt_exclusion(v_stmt_excl_rec.*)
        returning v_error, v_suberr
    end if

  end if # end v_success


  if g_is_debug_on then
    let v_debug_str = "v_error:", v_error,
                      "; v_suberr:", v_suberr
    call disp_debug(2, v_debug_str)

    call disp_debug(1,"end function pub_a_register")
  end if

  return v_error, v_suberr

end function


#Method to lock a register.
#-----------------------------------------------------------------------------
function pub_l_register(pv_premnum,pv_servicenum,pv_registernum,pv_util_type)
#-----------------------------------------------------------------------------

  define
    pv_premnum like pm_register.premnum,
    pv_servicenum like pm_register.servicenum,
    pv_registernum like pm_register.registernum,
    pv_util_type like pm_register.util_type

  define
    v_locked_reg_rec #record like pm_register.*,
    record
      premnum     like pm_register.premnum,
      servicenum  like pm_register.servicenum,
      util_type   like pm_register.util_type,
      registernum like pm_register.registernum,
      reg_descr   like pm_register.reg_descr,
      unit_code   like pm_register.unit_code,
      calcode     like pm_register.calcode,
      changeuser  like pm_register.changeuser,
      changedate  datetime year to second
    end record,
    v_cal_factor like b_calibration.calfactor,
    v_stmt_excl smallint,
    v_count smallint,
    v_sel_stmt char(256)

    call disp_debug(1,"function pub_l_register start")

    let v_debug_str = "pv_premnum:", pv_premnum, ":pv_servicenum:",pv_servicenum,
                      "pv_util_type:", pv_util_type, ":pv_registernum:",pv_registernum
    call disp_debug(9, v_debug_str)

    #initialize variables
    let v_error = 0
    let v_suberr  = 0

    whenever error call pub_log_and_continue

    let v_sel_stmt =
      "select * from pm_register ",
      " where premnum = ",pv_premnum,
        " and servicenum = ",pv_servicenum,
        " and util_type = '",pv_util_type,"'",
        " and registernum  = ",pv_registernum,
      " for update "

    if db_get_database_type() = "ORA" then
      let v_sel_stmt = v_sel_stmt clipped, " nowait"
    end if

    prepare update_eg_p from v_sel_stmt
    declare update_reg_c cursor for update_eg_p

    open update_reg_c

    let v_status = status

    if v_status <> 0 then
        let v_error = 2
        let error_message = "pub_l_register():could not open the cursor for update"
    else
      fetch update_reg_c into v_locked_reg_rec.*
      let v_status = status
      if v_status <> 0 then
        let v_error = 1
        let error_message = "pub_l_register(): could not fetch row for update"
      end if

    end if

    if v_status <> 0 then
      let log_error = TRUE
      call err_handler(log_error, v_status, error_message)
      let v_suberr  = v_status
    end if

    #Does the register have statement exclusion.
    if v_error = 0 then
      select count(*) into v_count from pm_stmt_exclusion
        where premnum = v_locked_reg_rec.premnum
          and util_type = v_locked_reg_rec.util_type
          and servicenum = v_locked_reg_rec.servicenum
          and registernum = v_locked_reg_rec.registernum

      let v_stmt_excl = (v_count > 0)

    end if

    call disp_debug(1, "end function pub_l_register")


    return v_error, v_suberr, v_locked_reg_rec.*, v_stmt_excl

end function


#Update a register.
#-----------------------------------------------------------------------------
function pub_u_register( pv_register_rec, pv_stmt_excl)
#-----------------------------------------------------------------------------

  define
    pv_register_rec      #record like pm_register.*,
    record
      premnum     like pm_register.premnum,
      servicenum  like pm_register.servicenum,
      util_type   like pm_register.util_type,
      registernum like pm_register.registernum,
      reg_descr   like pm_register.reg_descr,
      unit_code   like pm_register.unit_code,
      calcode     like pm_register.calcode,
      changeuser  like pm_register.changeuser,
      changedate  datetime year to second
    end record,
    pv_stmt_excl         smallint

  define
    v_reg_install_date   date,                          #CQ109633
    v_stmt_excl_rec      record like pm_stmt_exclusion.*,
    v_locked_stmt_ex_rec record like pm_stmt_exclusion.*,
    v_installnum         like eb_meter_install.installnum

  call disp_debug(1, "function pub_u_register()")

  let v_debug_str = "param pv_premnum = ", pv_register_rec.premnum
  call disp_debug(2, v_debug_str)

  #initialize variables
  let v_error = 0
  let v_suberr  = 0
  let v_changedate = current
  let v_user = getlogname()

  let pv_register_rec.changedate = v_changedate
  let pv_register_rec.changeuser = v_user

  update pm_register
    set pm_register.* = pv_register_rec.*
    where current of update_reg_c

  let v_status = status

  if v_status <> 0 then
    let v_suberr = v_status
    let error_message = "pub_u_premise: error updating premise"
    call err_handler(true, v_status, error_message)
    let v_error = 1
  end if

  close update_reg_c

  let v_stmt_excl_rec.premnum = pv_register_rec.premnum
  let v_stmt_excl_rec.util_type = pv_register_rec.util_type
  let v_stmt_excl_rec.servicenum = pv_register_rec.servicenum
  let v_stmt_excl_rec.registernum = pv_register_rec.registernum

  #Check what is in pm_stmt_exclusion before trying to add OR delete one!
  select count(*) into v_count from pm_stmt_exclusion
    where premnum = pv_register_rec.premnum
      and util_type = pv_register_rec.util_type
      and servicenum = pv_register_rec.servicenum
      and registernum = pv_register_rec.registernum

  if pv_stmt_excl then
    if v_count = 0 then
      call pub_a_stmt_exclusion(v_stmt_excl_rec.*)
        returning v_error, v_suberr
    end if

  else
    if v_count > 0 then

      call pub_l_stmt_exclusion(v_stmt_excl_rec.*)
        returning v_error, v_suberr, v_locked_stmt_ex_rec.*
      call pub_d_stmt_exclusion() returning v_error, v_suberr
    end if

  end if

  #We need to update the record in mm_e_metinst_reg if there is one
  # this is to make sure everything for config changes is up to date

  call get_curr_meter_installnum(pv_register_rec.premnum, pv_register_rec.util_type,
                                 pv_register_rec.servicenum)
  returning  v_installnum

  update mm_e_metinst_reg
    set  unit_code = pv_register_rec.unit_code,
         calcode   =  pv_register_rec.calcode,
         reg_descr = pv_register_rec.reg_descr
    where installnum = v_installnum
    and   registernum = pv_register_rec.registernum

  let v_status = status

  if v_status <> 0 then
    let v_suberr = v_status
    let error_message = "pub_u_premise: error updating mm_e_metinst_reg failed"
    call err_handler(true, v_status, error_message)
    let v_error = 1
  end if

  call disp_debug(1, "end function pub_u_register()")
  return v_error, v_suberr

end function

#-----------------------------------------------------------------------------
function pub_d_register( pv_register_rec, pv_stmt_excl, pv_removal_date)
#-----------------------------------------------------------------------------

  define
    pv_register_rec      #record like pm_register.*,
    record
      premnum     like pm_register.premnum,
      servicenum  like pm_register.servicenum,
      util_type   like pm_register.util_type,
      registernum like pm_register.registernum,
      reg_descr   like pm_register.reg_descr,
      unit_code   like pm_register.unit_code,
      calcode     like pm_register.calcode,
      changeuser  like pm_register.changeuser,
      changedate  datetime year to second
    end record,
    pv_stmt_excl         smallint,
    pv_removal_date      date                           #CQ109633

  define
    v_reg_install_date   date,                          #CQ109633
    v_success            smallint,
    v_last_register      smallint,
    v_stmt_excl_rec      record like pm_stmt_exclusion.*,
    v_locked_stmt_ex_rec record like pm_stmt_exclusion.*

  call disp_debug(1, "function pub_d_register()")

  let v_debug_str = "param pv_premnum = ", pv_register_rec.premnum
  call disp_debug(2, v_debug_str)
  let v_debug_str = " pv_util_type = ", pv_register_rec.util_type
  call disp_debug(2, v_debug_str)
  let v_debug_str = " pv_servicenum = ", pv_register_rec.servicenum
  call disp_debug(2, v_debug_str)

  let v_error = 0
  let v_success = true

  # some pre-processing before delete register
  call pre_del_register(pv_register_rec.premnum, pv_register_rec.util_type,
                        pv_register_rec.servicenum, pv_register_rec.registernum,
                        pv_removal_date)
    returning v_success, v_last_register

  if v_success then

    delete from pm_register
      where premnum = pv_register_rec.premnum
      and servicenum = pv_register_rec.servicenum
      and registernum = pv_register_rec.registernum
      and util_type = pv_register_rec.util_type

    let v_status = status
    if v_status <> 0 then
      let error_message = "DELETE REJECTED - can't delete estimation factors."
      call err_handler(true, v_status, error_message)
      let v_error = 1
      let v_suberr = v_status

    end if
    close update_reg_c

    let v_stmt_excl_rec.premnum = pv_register_rec.premnum
    let v_stmt_excl_rec.util_type = pv_register_rec.util_type
    let v_stmt_excl_rec.servicenum = pv_register_rec.servicenum
    let v_stmt_excl_rec.registernum = pv_register_rec.registernum

    if pv_stmt_excl then

      call pub_l_stmt_exclusion(v_stmt_excl_rec.*) returning v_error,
                                                 v_suberr, v_locked_stmt_ex_rec.*
      call pub_d_stmt_exclusion() returning v_error, v_suberr

    end if
  else
     let v_error = 100
  end if # end v_success

  call disp_debug(1, "end function of pub_d_register")

  return v_error, v_suberr

end function


#-------------------------------------------------------------------------------
function pre_add_register(pv_premnum, pv_util_type, pv_servicenum,
                          pv_registernum, pv_change_date)
#-------------------------------------------------------------------------------

# parameters
define
  pv_premnum     like pm_register.premnum,
  pv_util_type   like pm_register.util_type,
  pv_servicenum  like pm_register.servicenum,
  pv_registernum like pm_register.registernum,
  pv_tariffclass like tm_tariff.tariffclass,
  pv_change_date like pm_register.changedate

# local variable
define
  v_success          smallint,
  v_count            integer,
  v_change_date      like pm_register.changedate

# record
define
  v_pm_tariff_rec record like pm_tariff.*

  if (g_is_debug_on = 1) then
    call disp_debug(1, "function pre_add_register")

    let v_debug_str = "pv_premnum = ", pv_premnum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_util_type = ", pv_util_type
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_servicenum = ", pv_servicenum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_registernum = ", pv_registernum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_change_date = ", pv_change_date
    call disp_debug(2, v_debug_str)
  end if

  let v_success = true

  # count the number of registers of service
  select count (*) into v_count
    from pm_register
    where premnum = pv_premnum
      and util_type = pv_util_type
      and servicenum = pv_servicenum

  let v_status = status
  if v_status = 0 then

    # if no register attached to the service:
    # (if there ARE registers attached to this service then we don't need to do
    # anything because the service POption has been terminated already!)
    if v_count = 0 then
      ## We are going to add the first register on the register.
      # update pm_tariff for the service
      declare pm_tariff_c cursor for
        select * from pm_tariff
          where premnum    = pv_premnum
            and util_type  = pv_util_type
            and servicenum = pv_servicenum
            and registernum = 0
            and (end_date is null
            or end_date >= pv_change_date)

      let v_status = status
      if v_status = 0 then

        foreach pm_tariff_c into v_pm_tariff_rec.*

          if v_pm_tariff_rec.start_date <= pv_change_date then

            #If it's the same date we can't use the minus one on
            #the date so we will set the end to the same date
            if v_pm_tariff_rec.start_date = pv_change_date then
              update pm_tariff set end_date = pv_change_date
                where pm_tariff_id = v_pm_tariff_rec.pm_tariff_id
            else
              # end all effective price options in pm_tariff
              update pm_tariff set end_date = pv_change_date - 1
                where pm_tariff_id = v_pm_tariff_rec.pm_tariff_id
            end if

            let v_status = status
            if v_status = 0 then

              #If it's the same date we can't use the minus one on
              #the date so we will set the end to the same date
              if v_pm_tariff_rec.start_date = pv_change_date then
                update pm_tariff_main set end_date = pv_change_date
                  where pm_tariff_id = v_pm_tariff_rec.pm_tariff_id
                  and ( end_date >= pv_change_date or end_date is null)
              else
                # end all effective price options in pm_tariff_main
                update pm_tariff_main set end_date = pv_change_date - 1
                  where pm_tariff_id = v_pm_tariff_rec.pm_tariff_id
                  and ( end_date >= pv_change_date or end_date is null)
              end if

              let v_status = status
            end if

          else # start_date > pv_change_date

            # Delete all future price option
            call pub_d_pm_tariff(v_pm_tariff_rec.pm_tariff_id)
              returning v_error, v_suberr
            if v_error <> 0 then
              let v_status = v_suberr
              exit foreach
            end if

          end if # date
        end foreach

        #Clear the future main price options.
        delete from pm_tariff_main
         where pm_tariff_id in
                 (select pm_tariff_id from pm_tariff
                   where premnum = pv_premnum
                     and util_type = pv_util_type
                     and servicenum = pv_servicenum
                     and registernum = 0)
           and pm_tariff_main.start_date > pv_change_date
        let v_status = status
        if v_status <> 0 then
          let v_err_msg = "pre_add_register(): Failed delete pm_tariff_main:",
                          " premnum : ", pv_premnum, " ", pv_util_type,
                          "-", pv_servicenum
          call log_error_debug(v_err_msg, null, null, v_status)
        end if

      end if # v_status

      if v_status != 0 then
        let v_success = false
        let v_err_msg = "Database error occured."
        call log_error_debug( v_err_msg, null, null, v_status )
      end if

    end if # v_count = 0
  end if # v_status = 0

  let v_debug_str = "v_success = ", v_success
  call disp_debug(2, v_debug_str)

  call disp_debug(1, "end function pre_add_register")

  return v_success

end function


#-------------------------------------------------------------------------------
function pre_del_register(pv_premnum, pv_util_type, pv_servicenum,
                          pv_registernum, pv_change_date)
#-------------------------------------------------------------------------------

# parameters
define
  pv_premnum     like pm_register.premnum,
  pv_util_type   like pm_register.util_type,
  pv_servicenum  like pm_register.servicenum,
  pv_registernum like pm_register.registernum,
  pv_change_date like pm_register.changedate

# local variable
define
  v_success          smallint,
  v_last_register    smallint,
  v_reg_count        integer,
  v_inst_count       integer,
  v_table            char(20),
  v_stmt             char(150),
  v_reg_change_date  like pm_tariff.end_date,
  v_pm_tariff_id     like pm_tariff.pm_tariff_id,
  v_delete           smallint,
  v_count            integer,
  v_require          smallint

# record
define
  v_pm_tariff_rec      record like pm_tariff.*,
  v_pm_tariff_main_rec record like pm_tariff_main.*

  call disp_debug(1, "function pre_del_register")

  if (g_is_debug_on = 1) then
    let v_debug_str = "pv_premnum = ", pv_premnum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_util_type = ", pv_util_type
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_servicenum = ", pv_servicenum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_registernum = ", pv_registernum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_change_date = ", pv_change_date
    call disp_debug(2, v_debug_str)
  end if

  let v_success = true
  case pv_util_type
    when "E"
      let v_table = "eb_meter_install"
    when "G"
      let v_table = "gb_meter_install"
    when "W"
      let v_table = "wb_meter_install"
    otherwise
      # error
      let v_success = false
      let v_err_msg = "Utility type not correct."
      call log_error_debug( v_err_msg, null, null, null )
  end case

  let v_debug_str = "v_table = ", v_table
  call disp_debug(20, v_debug_str)

  # select the lastest end_date
  select max(end_date) into v_reg_change_date
    from pm_tariff
    where premnum     = pv_premnum
      and util_type   = pv_util_type
      and servicenum  = pv_servicenum
      and registernum = 0

  let v_status = status

  if v_reg_change_date is null then
    select min(start_date) into v_reg_change_date
      from pm_tariff
      where premnum   = pv_premnum
      and util_type   = pv_util_type
      and servicenum  = pv_servicenum
      and registernum > 0
    let v_status = status
  end if

  if v_status <> 0 then
    let v_success = false
    let v_err_msg = "Error when selecting lastest end date."
    call log_error_debug( v_err_msg, null, null, v_status )
  end if

  let v_debug_str = "v_reg_change_date = ", v_reg_change_date
  call disp_debug(20, v_debug_str)

  # count the number of registers
  select count(*) into v_reg_count
    from pm_register
    where premnum     = pv_premnum
      and util_type   = pv_util_type
      and servicenum  = pv_servicenum

  let v_status = status
  if v_status <> 0 then
    let v_success = false
    let v_err_msg = "Error when counting registers."
    call log_error_debug( v_err_msg, null, null, v_status )
  end if

  let v_debug_str = "v_reg_count = ", v_reg_count
  call disp_debug(20, v_debug_str)

  if v_reg_count = 1 then
    let v_last_register = true
  end if

  # count the number of meter installed
  if v_table is not null then

    let v_stmt = "select count(*) from ", v_table,
                 " where premnum = ", pv_premnum,
                 " and servicenum = ", pv_servicenum,
                 " and status_meter = 'P'"

    prepare v_stmt_p from v_stmt
    declare v_stmt_c cursor for v_stmt_p
    open v_stmt_c
    fetch v_stmt_c into v_inst_count
    let v_status = status
    close v_stmt_c

    if v_status <> 0 then
      let v_success = false
      let v_err_msg = "Error when counting meter installed."
      call log_error_debug( v_err_msg, null, null, v_status )
    end if
  end if

  if v_success then

    # no previous meter installation
    if v_inst_count = 0 then

      declare tariff_c cursor for
        select pm_tariff_id from pm_tariff
          where premnum     = pv_premnum
            and util_type   = pv_util_type
            and servicenum  = pv_servicenum
            and registernum = pv_registernum

      foreach tariff_c into v_pm_tariff_id

        # clear from pm_tariff and pm_tariff_main
        call pub_d_pm_tariff(v_pm_tariff_id)
          returning v_error, v_suberr

        if v_error <> 0 then
          let v_success = false
          let v_err_msg = "Error when clearing price option ",
                          "for no previous meter installation."
          call log_error_debug( v_err_msg, null, null, v_suberr )
        end if

      end foreach
      free tariff_c

      if v_last_register then

        # update pm_tariff
        update pm_tariff_main set end_date = null
         where pm_tariff_id in
               (select pm_tariff_id from pm_tariff
                 where premnum     = pv_premnum
                   and util_type   = pv_util_type
                   and servicenum  = pv_servicenum
                   and registernum = 0
                   and end_date    = v_reg_change_date)

        let v_status = status
        if v_status <> 0 then
          let v_success = false
          let v_err_msg = "Update Failed : cannot update pm_tariff_main for last register."
          call log_error_debug( v_err_msg, null, null, v_status )
        else
          update pm_tariff set end_date = null
           where premnum     = pv_premnum
             and util_type   = pv_util_type
             and servicenum  = pv_servicenum
             and registernum = 0
             and end_date    = v_reg_change_date

          let v_status = status
          if v_status <> 0 then
            let v_success = false
            let v_err_msg = "Update Failed : cannot update pm_tariff for last register."
            call log_error_debug( v_err_msg, null, null, v_status )
          end if
        end if

      end if

    else # v_inst_count != 0
         # service has previous meter installation

      declare delete_tariff_c cursor for
        select * from pm_tariff
          where premnum     = pv_premnum
            and util_type   = pv_util_type
            and servicenum  = pv_servicenum
            and registernum = pv_registernum
            and (end_date > pv_change_date or end_date is null)

      foreach delete_tariff_c into v_pm_tariff_rec.*

        # delete all future price options on register relative to
        # delete date
        let v_delete = (v_pm_tariff_rec.start_date > pv_change_date)

        # delete all price options on register that never has an unreversed
        #  reading associated, including meter removal reading
        # Only need to check for electricity for the moment
        if not v_delete then
          select count(*) into v_count
           from eb_reading
           where premnum     = pv_premnum
             and servicenum  = pv_servicenum
             and registernum = pv_registernum
             and reversed    = "N"
             and readdate    >= v_pm_tariff_rec.start_date
          if v_count = 0 then
            let v_delete = true
          end if
        end if

        if v_delete then

          # delete all price option attached to register
          call pub_d_pm_tariff(v_pm_tariff_rec.pm_tariff_id)
            returning v_error, v_suberr

          if v_error <> 0 then
            let v_success = false
            let v_err_msg = "Error when clearing price option."
            call log_error_debug( v_err_msg, null, null, v_suberr )
          end if

        else

          # update price option attached to register
          update pm_tariff set end_date = pv_change_date
            where pm_tariff_id = v_pm_tariff_rec.pm_tariff_id

          let v_status = status
          if v_status = 0 then

            select * into v_pm_tariff_main_rec.*
              from pm_tariff_main
              where pm_tariff_id = v_pm_tariff_rec.pm_tariff_id

            let v_status = status
            if v_status = 0 then

              # Delete all the register's main price options with their
              # start date later than the change date from pm_tariff_main
              if v_pm_tariff_main_rec.start_date > pv_change_date then

                delete from pm_tariff_main
                  where pm_tariff_id = v_pm_tariff_main_rec.pm_tariff_id

                let v_status = status
              else # start date <= change date

                update pm_tariff_main set end_date = pv_change_date
                  where pm_tariff_id = v_pm_tariff_rec.pm_tariff_id

                let v_status = status
              end if # end main start date
            end if # end v_status
          end if

          if v_status <> 100 and v_status <> 0 then
            let v_success = false
            let v_err_msg = "Error updating price option attached to register."
            call log_error_debug( v_err_msg, null, null, v_status )
          end if

        end if
      end foreach
      free delete_tariff_c

      if v_last_register then

        # insert new rows into pm_tariff
        insert into pm_tariff
          select 0, premnum, util_type, servicenum, 0,
                 tariffclass, pv_change_date + 1, ''  #CQ120201
            from pm_tariff
            where premnum     = pv_premnum
              and util_type   = pv_util_type
              and servicenum  = pv_servicenum
              and registernum = 0
              and end_date    = v_reg_change_date


        let v_status = status
        if v_status = 0 then

          # find the previous main price option
          select pm_tariff.* into v_pm_tariff_rec.*
            from pm_tariff, pm_tariff_main
            where premnum     = pv_premnum
              and util_type   = pv_util_type
              and servicenum  = pv_servicenum
              and registernum = 0
              and pm_tariff_main.end_date = v_reg_change_date
              and pm_tariff_main.pm_tariff_id = pm_tariff.pm_tariff_id

          let v_status = status
          if v_status = 0 then

            # match the new pm_tariff_id
            select max(pm_tariff_id) into v_pm_tariff_id
              from pm_tariff
              where premnum     = v_pm_tariff_rec.premnum
                and util_type   = v_pm_tariff_rec.util_type
                and servicenum  = v_pm_tariff_rec.servicenum
                and registernum = v_pm_tariff_rec.registernum
                and tariffclass = v_pm_tariff_rec.tariffclass

            let v_status = status
            if v_status = 0 then

              # insert a new row to pm_tariff_main
              insert into pm_tariff_main values
                (v_pm_tariff_id, pv_change_date + 1, null)
              let v_status = status
            end if
          end if
        end if

        if v_status <> 0 and v_status <> NOTFOUND then
          let v_success = false
          let v_err_msg = "Error when re-insert price option to service level."
          call log_error_debug( v_err_msg, null, null, v_status )
        else
          declare new_added_po_c cursor for
            select pm_tariff_id from pm_tariff
             where premnum     = pv_premnum
               and util_type   = pv_util_type
               and servicenum  = pv_servicenum
               and registernum = 0
               and start_date  = pv_change_date + 1
               and end_date    is null
          foreach new_added_po_c into v_pm_tariff_id
            call pub_proc_pm_reg_prod_comp("A", v_pm_tariff_id)
              returning v_require
          end foreach

        end if

      end if

    end if # v_inst_count
  end if # v_success

  let v_debug_str = "v_success = ", v_success
  call disp_debug(2, v_debug_str)

  call disp_debug(1, "end function pre_del_register")

  return v_success, v_last_register

end function


#------------------------------------------------------------------------------
# This function finds the start date of the first main tariff when the first
# register is added.
# If the register num is passed as zero to this function all the registers will
# be queried for an 'earliest main price option' date.
# This change date can then be used as a final date for the service priceoption
#------------------------------------------------------------------------------
function get_register_changedate(pv_premnum, pv_util_type,
                                 pv_servicenum, pv_registernum)
#------------------------------------------------------------------------------

# parameters
define
  pv_premnum     like pm_register.premnum,
  pv_util_type   like pm_register.util_type,
  pv_servicenum  like pm_register.servicenum,
  pv_registernum like pm_register.registernum

# variables
define
  v_sql               char(500),
  v_srv_enddate       date,
  v_reg_startdate     date

  call disp_debug(1, "function get_register_changedate")

  let v_reg_startdate = null
  let error_message = ""

  if pv_registernum is null or pv_registernum = 0 then
    #Parameter is wrong.
  else
    #Find the lastest date the main price option be neded at service level.
    let v_sql ="select max(pm_tariff_main.end_date)",
               " from pm_tariff_main, pm_tariff",
               " where pm_tariff_main.pm_tariff_id = pm_tariff.pm_tariff_id",
               " and premnum = ", pv_premnum,
               " and util_type = '", pv_util_type, "'",
               " and servicenum = ", pv_servicenum,
               " and registernum = 0"

    call disp_debug(7, v_sql)

    prepare v_sqlstmt from v_sql
    declare srv_enddate_c cursor for v_sqlstmt

    let v_status = status
    if v_status <> 0 then
      let error_message = "Declare cursor srv_enddate_c Failed."
      call err_handler(TRUE, v_status, error_message)
    else
      open srv_enddate_c
      fetch srv_enddate_c into v_srv_enddate
      let v_status = status
      if v_status <> 0 then
        let error_message = "Fetch cursor srv_enddate_c Failed."
        call err_handler(TRUE, v_status, error_message)
      else
        #The register install date should be one day after v_reg_startdate.
        let v_reg_startdate = v_srv_enddate + 1
      end if
      close srv_enddate_c
    end if
  end if

  if v_status = 0 then
    let v_debug_str = "v_reg_startdate = ", v_reg_startdate
  else
    let v_debug_str = "ERROR: ", error_message
  end if
  call disp_debug(2, v_debug_str)

  call disp_debug(1, "end function get_register_changedate")

  return v_reg_startdate

end function


#------------------------------------------------------------------------------
# Checks how many registers in effect at this service
#------------------------------------------------------------------------------

#CQ113060 start

function ANALOG_DISPLAY() return 'A' end function

function DIGITAL_DISPLAY() return 'D' end function


#------------------------------------------------------------------------------
function pub_get_register_display5(
  pv_util_type,
  pv_meternum,
  pv_metermod,
  pv_installnum,
  pv_registernum,
  pv_date
)
#------------------------------------------------------------------------------
#: retrieve display information for an installed register at the given date
#: for gas, a register number of 1 refers to the uncorrected "register" of
#   a corrector; if no corrector is installed the function is unsuccessful
#: enhancement: the function should be unsuccessful when an electricity or
#:  water register of "0" is not installed
#: pv_installnum can be null, but it wil be better to have it, because
#: find_calcode_met() does not work when the meter is reversed after the date.
#: See CQ127996 for more details.


  # parameters
  define
    pv_util_type like pm_service.util_type,
    pv_meternum like eb_meter.meternum,
    pv_metermod like eb_meter.metermod,
    pv_installnum like eb_meter_install.installnum,
    pv_registernum like pm_register.registernum,
    pv_date date

  # return values
  define
    v_success smallint  # boolean
  define v_register_display_rec record
    type char,
    max_digits smallint,  # number of
    decimal_places smallint  # number of
  end record

  # local variables
  define
    v_call_id char(128),
    v_continue smallint,  # boolean
    v_gb_corr_install_rec record like gb_corr_install.*,
    v_calcode like b_calibration.calcode,
    v_num_dials like eb_meter.num_dials,
    v_inc_del_corr smallint,
    v_had_success smallint # boolean

  # debugging
  if g_is_debug_on then
    call disp_debug(1, "function pub_get_register_display5")
    let v_tmp_str = "pv_util_type = ", pv_util_type
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_meternum = ", pv_meternum
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_metermod = ", pv_metermod
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_installnum = ", pv_installnum
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_registernum = ", pv_registernum
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_date = ", pv_date
    call disp_debug(2, v_tmp_str)
  end if

  # initialization
  let v_success = true
  initialize v_register_display_rec.* to null
  let v_calcode = null
  let v_continue = true
  let v_inc_del_corr = true
  let v_call_id = "pub_get_register_display5",
    "[util_type='", pv_util_type clipped,
    "', meternum='", pv_meternum clipped,
    "', metermod='", pv_metermod clipped,
    "', installnum='",pv_installnum clipped,
    "', registernum='", pv_registernum using "-<<<<<<<<<<&",
    "', date='", pv_date, "']"

  # validation
  if pv_util_type is null then
    let v_tmp_str = "Illegal utility type: '' - ", v_call_id clipped
    call err_handler(true, 0, v_tmp_str)
    let v_success = false
    let v_continue = false
  end if

  if v_continue then
    if pv_registernum is null then
      let v_tmp_str = "Illegal register number: '' - ", v_call_id clipped
      call err_handler(true, 0, v_tmp_str)
      let v_success = false
      let v_continue = false
    end if
  end if

  if v_continue then
    if pv_util_type = "W" and pv_registernum != 0 then
      let v_tmp_str = "Illegal water meter register number: '",
        pv_registernum using "-<<<<<<<<<<&", "' - ", v_call_id clipped
      call err_handler(true, 0, v_tmp_str)
      let v_success = false
      let v_continue = false
    end if
  end if

  if v_continue then
    if pv_util_type = "G" then

      # hack: if registernum = 2 then ignore whether a corrector is installed
       # and instead retrieve display details for the gas meter itself
      if pv_registernum = 2 then
        let pv_registernum = 0
      else

        call pub_get_installed_corrector(pv_meternum, pv_metermod, pv_date,
                                         v_inc_del_corr)
          returning v_gb_corr_install_rec.*

        if v_gb_corr_install_rec.installnum is not null then
          case (pv_registernum)
            when 0
              let v_calcode = v_gb_corr_install_rec.corrcalcode
              let v_num_dials = v_gb_corr_install_rec.corrnumdials
            when 1
              let v_calcode = v_gb_corr_install_rec.uncorrcalcode
              let v_num_dials = v_gb_corr_install_rec.uncorrnumdials
            otherwise
              let v_tmp_str = "pub_get_register_display5: invalid corrector",
              " register number ", pv_registernum clipped,
              " for meter ", pv_meternum clipped,
              " model ", pv_metermod clipped,
              " util type ", pv_util_type
              call err_handler(true, 0, v_tmp_str)
              let v_success = false
              let v_continue = false
          end case

          if v_continue then
            call pub_get_register_display2(v_num_dials, v_calcode)
              returning v_had_success, v_register_display_rec.*

            if not v_had_success then
              let v_success = false
            end if

            let v_continue = false
          end if
        else
          # validate register number when gas corrector is not installed
          if pv_registernum != 0 then
            let v_tmp_str = "pub_get_register_display5(): failed to get",
              " calibration code for gas register",
              " number: ", pv_registernum clipped,
              " for meter: ", pv_meternum clipped,
              " util type: ", pv_util_type,
              " , as the meter was not installed."
            call err_handler(true, 0, v_tmp_str)
            let v_success = false
            let v_continue = false
          end if
        end if
      end if
    end if
  end if

  if v_continue then
    if pv_util_type != "W" and
      not (pv_util_type = "E" and pv_registernum = 0) then
      # An electric meter with "no registers" has no associated calcode!
      # a water meter has no associated calcode

      if pv_installnum is not null then
        call get_calcode_inst(pv_util_type,pv_installnum,pv_registernum)
          returning v_calcode
        let v_status = 0
      else
        call find_calcode_met(pv_util_type, pv_meternum, pv_metermod, pv_date,
          pv_registernum) returning v_calcode, v_status
      end if

      if v_status != 0 then
        if g_is_debug_on then
          let v_tmp_str = "pub_get_register_display5: find_calcode_met() did ",
            "not return status 0: ", v_status
          call disp_debug(891, v_tmp_str)
        end if
        let v_success = false
        let v_continue = false
      end if
    end if
  end if

  if v_continue then
    call pub_get_register_display4(
      pv_util_type,
      pv_meternum,
      pv_metermod,
      v_calcode
    ) returning v_had_success, v_register_display_rec.*

    if not v_had_success then
      let v_success = false
      let v_continue = false
    end if
  end if

  # debugging
  if (g_is_debug_on = 1) then
    call disp_debug(2, "function returning:")
    let v_tmp_str = "v_success = ", v_success
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.type = ",
      v_register_display_rec.type
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.max_digits = ",
      v_register_display_rec.max_digits
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.decimal_places = ",
      v_register_display_rec.decimal_places
    call disp_debug(2, v_tmp_str)
    call disp_debug(1, "end function pub_get_register_display5")
  end if

  return v_success, v_register_display_rec.*

end function # pub_get_register_display5


#------------------------------------------------------------------------------
function pub_get_register_display4(
  pv_util_type,
  pv_meternum,
  pv_metermod,
  pv_calcode
)
#------------------------------------------------------------------------------
#: retrieve register display information for a given meter and calibration code

  # parameters
  define pv_util_type like pm_service.util_type
  define pv_meternum like eb_meter.meternum
  define pv_metermod like eb_meter.metermod
  define pv_calcode like b_calibration.calcode

  # return values
  define v_success smallint  # boolean
  define v_register_display_rec record
    type char,
    max_digits smallint,  # number of
    decimal_places smallint  # number of
  end record

  # local variables
  define v_continue smallint  # boolean
  define v_num_dials like eb_meter.num_dials
  define v_had_success smallint  # boolean

  # debugging
  call disp_debug(1, "function pub_get_register_display4")
  if (g_is_debug_on = 1) then
    let v_tmp_str = "pv_util_type = ", pv_util_type
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_meternum = ", pv_meternum
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_metermod = ", pv_metermod
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_calcode = ", pv_calcode
    call disp_debug(2, v_tmp_str)
  end if

  # initialization
  let v_success = true
  initialize v_register_display_rec.* to null
  let v_continue = true

  call get_num_dials(
    pv_util_type,
    pv_meternum,
    pv_metermod
  ) returning v_num_dials

  if v_num_dials is null then
    let v_success = false
    let v_continue = false
  end if

  if v_continue then
    call pub_get_register_display2(v_num_dials, pv_calcode)
      returning v_had_success, v_register_display_rec.*

    if not v_had_success then
      let v_success = false
      let v_continue = false
    end if
  end if

  # debugging
  if (g_is_debug_on = 1) then
    call disp_debug(2, "function returning:")
    let v_tmp_str = "v_success = ", v_success
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.type = ",
      v_register_display_rec.type
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.max_digits = ",
      v_register_display_rec.max_digits
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.decimal_places = ",
      v_register_display_rec.decimal_places
    call disp_debug(2, v_tmp_str)
  end if
  call disp_debug(1, "end function pub_get_register_display4")

  return v_success, v_register_display_rec.*

end function # pub_get_register_display4


#------------------------------------------------------------------------------
function pub_get_register_display2(pv_num_dials, pv_calcode)
#------------------------------------------------------------------------------
#: return display information given a registers number of dials and
#   calibration code

  # parameters
  define pv_num_dials like eb_meter.num_dials
  define pv_calcode like b_calibration.calcode

  # return values
  define v_success smallint  # boolean
  define v_register_display_rec record
    type char,
    max_digits smallint,  # number of
    decimal_places smallint  # number of
  end record

  # local variables
  define v_call_id char(128)
  define v_continue smallint  # boolean
  define v_calibration_rec record like b_calibration.*
  define v_had_success smallint  # boolean

  # debugging
  if (g_is_debug_on = 1) then
    call disp_debug(1, "function pub_get_register_display2")

    let v_tmp_str = "pv_num_dials = ", pv_num_dials
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "pv_calcode = ", pv_calcode
    call disp_debug(2, v_tmp_str)
  end if

  # initialization
  let v_success = true
  initialize v_register_display_rec.* to null
  let v_continue = true

  let v_call_id = "pub_get_register_display2",
    "[num_dials='", pv_num_dials using "-<<<<<<<<<<&",
    "', calcode='", pv_calcode clipped, "']"

  # validation
  if pv_num_dials is null or pv_num_dials < 0 then
    let v_tmp_str = "Illegal number of dials: '",
      pv_num_dials using "-<<<<<<<<<<&", "' - ", v_call_id clipped
    call err_handler(true, 0, v_tmp_str)
    let v_success = false
    let v_continue = false
  end if

  if v_continue then
    if pv_num_dials = 0 or pv_calcode is null then
      # a 'corrector only meter' has 0 number of dials!

      let v_register_display_rec.type = ANALOG_DISPLAY()
      let v_register_display_rec.max_digits = pv_num_dials
      let v_register_display_rec.decimal_places = 0
      let v_continue = false
    end if
  end if

  if v_continue then
    call pub_get_calibration(pv_calcode)
      returning v_had_success, v_calibration_rec.*

    if not v_had_success then
      let v_success = false
      let v_continue = false
    end if
  end if

  if v_continue then
    let v_register_display_rec.max_digits = pv_num_dials
    if v_calibration_rec.read_entry_type = "D" then  # decimal
      let v_register_display_rec.type = DIGITAL_DISPLAY()
      let v_register_display_rec.decimal_places =
        - pfgl_log10(v_calibration_rec.calfactor)
    else
      let v_register_display_rec.type = ANALOG_DISPLAY()
      let v_register_display_rec.decimal_places = 0
    end if
  end if

  # debugging
  if (g_is_debug_on = 1) then
    call disp_debug(2, "function returning:")
    let v_tmp_str = "v_success = ", v_success
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.type = ",
      v_register_display_rec.type
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.max_digits = ",
      v_register_display_rec.max_digits
    call disp_debug(2, v_tmp_str)
    let v_tmp_str = "v_register_display_rec.decimal_places = ",
      v_register_display_rec.decimal_places
    call disp_debug(2, v_tmp_str)
  end if
  call disp_debug(1, "end function pub_get_register_display2")

  return v_success, v_register_display_rec.*

end function # pub_get_register_display2
#CQ113060 end

function pub_is_a_future_reg(pv_premnum, pv_util_type, pv_servicenum, pv_registernum)

#This function is to return a boolean value about whether the register which we
#are looking at is a future register.
#The best way to check this is if the meter on the service is in the future and the
#register in mm_e_metinst_reg is attached to that meters installnum,
#then the register is in the future

  define
    pv_premnum  like pm_register.premnum,
    pv_util_type like pm_register.util_type,
    pv_servicenum  like pm_register.servicenum,
    pv_registernum like pm_register.registernum,

  #Local
    v_future  smallint,
    v_count   integer

  let v_future = false

  if pv_util_type = 'E' then
    select count(mm_e_metinst_reg.registernum)  into v_count
      from eb_meter_install, mm_e_metinst_reg
      where eb_meter_install.installnum = mm_e_metinst_reg.installnum
      and status_meter = 'F'
      and premnum = pv_premnum
      and servicenum = pv_servicenum
      and registernum = pv_registernum

    if v_count =1 then
      let v_future = true
    end if
  end if

  return v_future

end function


function pub_a_register_new(pv_register_rec, pv_stmt_excl,
                        pv_reg_install_date)
#------------------------------------------------------------------------------
  define
    pv_register_rec     record like pm_register.*,
    pv_stmt_excl        smallint,
    pv_reg_install_date date

  define
    v_count             smallint,
    v_main_priceoption  smallint,
    v_success           smallint,
    v_stmt              char(200),
    v_division_code     like pm_division.division_code,
    v_type_consumption  like pm_service.type_consumption,
    v_stmt_excl_rec     record like pm_stmt_exclusion.*


  if g_is_debug_on then
    call disp_debug(1,"function pub_a_register")

    let v_debug_str = "registernum:", pv_register_rec.registernum,
                      "; pv_stmt_excl:", pv_stmt_excl,
                      "; pv_reg_install_date:", pv_reg_install_date

    call disp_debug(2, v_debug_str)
  end if

  let v_error = false
  let v_suberr = 0
  let v_count = 0
  let v_success = true
  let v_changedate = current
  let v_user = getlogname()

# TODO register validation (
# pub_v_register add a new tariffclasses if tariffclass is not supplied)

  # some pre-processing before add a new register
  call pre_add_register(pv_register_rec.premnum, pv_register_rec.util_type,
                        pv_register_rec.servicenum, pv_register_rec.registernum,
                        pv_reg_install_date)
    returning v_success

  if v_success then

    let pv_register_rec.changedate = v_changedate
    let pv_register_rec.changeuser = v_user

    insert into pm_register values (pv_register_rec.*)

    let v_status = status

    if v_status <> 0 then
      let v_error = true
      let v_suberr = v_status
      return v_error, v_suberr
    end if

    if pv_stmt_excl then

      let v_stmt_excl_rec.premnum = pv_register_rec.premnum
      let v_stmt_excl_rec.util_type = pv_register_rec.util_type
      let v_stmt_excl_rec.servicenum = pv_register_rec.servicenum
      let v_stmt_excl_rec.registernum = pv_register_rec.registernum

      call pub_a_stmt_exclusion(v_stmt_excl_rec.*)
        returning v_error, v_suberr
    end if

  end if # end v_success


  if g_is_debug_on then
    let v_debug_str = "v_error:", v_error,
                      "; v_suberr:", v_suberr
    call disp_debug(2, v_debug_str)

    call disp_debug(1,"end function pub_a_register")
  end if

  return v_error, v_suberr

end function
