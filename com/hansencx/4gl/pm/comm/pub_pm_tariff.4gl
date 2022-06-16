#Copyright 2007, First Data Corporation | All Rights Reserved.
#Developed by First Data New Zealand Ltd.  http://www.firstdatautilities.com/
#Contents: First Data Utilities confidential

database energy

globals ",globals/debug_globals.4gl"

define
  v_status            integer,
  v_err_code          integer,
  v_err_sub           integer,
  v_err_msg           char(500),
  v_debug_str         char(500),
  v_sel_str           char(500),
  v_changeuser        char(35),
  v_changedate        date

#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
function pub_a_dummy_pm_tariff(pv_pm_tariff_rec, pv_main_tariff,
                               pv_mt_startdate, pv_mt_enddate)
#-------------------------------------------------------------------------------
# This function adds a new row in pm_tariff for the data passed in,
# if the tariff is set as the main tariff,
# added a new row in pm_tariff_main as well

  # parameters
  define
    pv_pm_tariff_rec record like pm_tariff.*,
    pv_main_tariff       smallint,
    pv_mt_startdate like pm_tariff_main.start_date,
    pv_mt_enddate   like pm_tariff_main.end_date

  # local variables
  define
    v_pm_tariff_id  like pm_tariff.pm_tariff_id

  if g_is_debug_on then
    call disp_debug(1, "function pub_a_dummy_pm_tariff")
  end if

  if pv_pm_tariff_rec.pm_tariff_id > 0 then
    let pv_pm_tariff_rec.pm_tariff_id = -pv_pm_tariff_rec.pm_tariff_id
  end if

  if pv_pm_tariff_rec.pm_tariff_id is null then
    let pv_pm_tariff_rec.pm_tariff_id = 0
  end if

  call priv_a_pm_tariff(pv_pm_tariff_rec.*, pv_main_tariff, pv_mt_startdate,
                        pv_mt_enddate)
    returning v_err_code, v_err_sub, v_pm_tariff_id

  if g_is_debug_on then
    call disp_debug(1, "end function pub_a_dummy_pm_tariff")
  end if

  return v_err_code, v_err_sub, v_pm_tariff_id

end function


#-------------------------------------------------------------------------------
function pub_a_pm_tariff(pv_pm_tariff_rec, pv_main_tariff,
                         pv_mt_startdate, pv_mt_enddate)
#-------------------------------------------------------------------------------
# This function adds a new row in pm_tariff for the data passed in,
# if the tariff is set as the main tariff,
# added a new row in pm_tariff_main as well

  # parameters
  define
    pv_pm_tariff_rec record like pm_tariff.*,
    pv_main_tariff       smallint,
    pv_mt_startdate like pm_tariff_main.start_date,
    pv_mt_enddate   like pm_tariff_main.end_date

  # local variables
  define
    v_pm_tariff_id  like pm_tariff.pm_tariff_id

  if g_is_debug_on then
    call disp_debug(1, "function pub_a_pm_tariff")
  end if

  let pv_pm_tariff_rec.pm_tariff_id = 0

  call priv_a_pm_tariff(pv_pm_tariff_rec.*, pv_main_tariff, pv_mt_startdate,
                        pv_mt_enddate)
    returning v_err_code, v_err_sub, v_pm_tariff_id

  if g_is_debug_on then
    call disp_debug(1, "end function pub_a_pm_tariff")
  end if

  return v_err_code, v_err_sub, v_pm_tariff_id

end function



#-------------------------------------------------------------------------------
function priv_a_pm_tariff(pv_pm_tariff_rec, pv_main_tariff,
                         pv_mt_startdate, pv_mt_enddate)
#-------------------------------------------------------------------------------
# This function adds a new row in pm_tariff for the data passed in,
# if the tariff is set as the main tariff,
# added a new row in pm_tariff_main as well

  # parameters
  define
    pv_pm_tariff_rec record like pm_tariff.*,
    pv_main_tariff       smallint,
    pv_mt_startdate like pm_tariff_main.start_date,
    pv_mt_enddate   like pm_tariff_main.end_date

  # local variables
  define
    v_pm_tariff_id  like pm_tariff.pm_tariff_id,
    v_chg_dep_reg   smallint

  if g_is_debug_on then
    call disp_debug(1, "function priv_a_pm_tariff")
  end if

  if en_debug(2) then
    let v_debug_str = "pm_tariff_id = ", pv_pm_tariff_rec.pm_tariff_id
    call disp_debug(2, v_debug_str)
    let v_debug_str = "premnum = ", pv_pm_tariff_rec.premnum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "util_type = ", pv_pm_tariff_rec.util_type
    call disp_debug(2, v_debug_str)
    let v_debug_str = "servicenum = ", pv_pm_tariff_rec.servicenum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "registernum = ", pv_pm_tariff_rec.registernum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "tariffclass = ", pv_pm_tariff_rec.tariffclass
    call disp_debug(2, v_debug_str)
    let v_debug_str = "start_date = '", pv_pm_tariff_rec.start_date, "'"
    call disp_debug(2, v_debug_str)
    let v_debug_str = "end_date = '", pv_pm_tariff_rec.end_date, "'"
    call disp_debug(2, v_debug_str)

    let v_debug_str = "pv_main_tariff = ", pv_main_tariff
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_mt_startdate = ", pv_mt_startdate
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_mt_enddate = ", pv_mt_enddate
    call disp_debug(2, v_debug_str)
  end if

  # initialisation
  let v_err_code = 0
  let v_err_sub = 0
  let v_status = 0
  # check mandatory column for table
  if pv_pm_tariff_rec.premnum is null or
     pv_pm_tariff_rec.util_type is null or
     pv_pm_tariff_rec.servicenum is null or
     pv_pm_tariff_rec.tariffclass is null or
     pv_pm_tariff_rec.start_date is null then

    let v_err_code = 1
    let v_err_sub = v_status
    let v_err_msg = "priv_a_pm_tariff : null in not null column"
    call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )

  end if

  if v_err_code = 0 then

    # validate registernum
    if pv_pm_tariff_rec.registernum is null then
      let pv_pm_tariff_rec.registernum = 0
    end if

    if pv_pm_tariff_rec.pm_tariff_id < 0 then

      # Dummy price option
      whenever error continue

      # insert into pm_tariff
      insert into pm_tariff values (pv_pm_tariff_rec.*)
      let v_status = status

      case v_status
        when 0
        # No problems
          let v_pm_tariff_id = pv_pm_tariff_rec.pm_tariff_id
        when -268
          # unique index violated, use generated pm_tariff_id as for non dummy
          let pv_pm_tariff_rec.pm_tariff_id = 0
          let v_status = 0
        otherwise
          # error
          let v_err_code = 1
          let v_err_sub = v_status
          let v_err_msg = "priv_a_pm_tariff : Insert dummy pm_tariff failed."
          call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
      end case

      whenever error call pub_log_and_continue

    end if

    if v_status = 0 and pv_pm_tariff_rec.pm_tariff_id = 0 then
      select pm_tariff_srl.nextval into v_pm_tariff_id from dual
      if g_is_debug_on then
        call disp_debug(10, "New v_pm_tariff_id = " || v_pm_tariff_id )
      end if
      let v_status = status
      if v_status = 0 and v_pm_tariff_id <> 0 then
        let pv_pm_tariff_rec.pm_tariff_id = v_pm_tariff_id
        insert into pm_tariff values (pv_pm_tariff_rec.*)
        let v_status = status
      end if
    end if
    if v_status = 0 and pv_pm_tariff_rec.pm_tariff_id <> 0 then
      if pv_main_tariff then
        insert into pm_tariff_main values (v_pm_tariff_id, pv_mt_startdate,
                                           pv_mt_enddate)
        let v_status = status
        if v_status <> 0 then
          let v_err_code = 1
          let v_err_sub = v_status
          let v_err_msg =
            "pub_a_pm_tariff : Insert to pm_tariff_main failed. ",
            "Premise: ", pv_pm_tariff_rec.premnum using '<<<<<<<<<&',
            " Utility: ", pv_pm_tariff_rec.util_type,
            " Service: ", pv_pm_tariff_rec.servicenum using '<<<<<<<<<&',
            " Register: ", pv_pm_tariff_rec.registernum using '<<<<<<<<<&',
            " Tariffclass: ", pv_pm_tariff_rec.tariffclass using '<<<<<<<<<&',
            " Main tariff start date: ", pv_mt_startdate,
            " Main tariff end date: ",  pv_mt_enddate
          call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
        end if
      end if # end if pv_main_tariff
    else
      let v_err_code = 1
      let v_err_sub = v_status
      let v_err_msg = "pub_a_pm_tariff : Insert to pm_tariff failed. ",
            "Premise: ", pv_pm_tariff_rec.premnum using '<<<<<<<<<&',
            " Utility: ", pv_pm_tariff_rec.util_type,
            " Service: ", pv_pm_tariff_rec.servicenum using '<<<<<<<<<&',
            " Register: ", pv_pm_tariff_rec.registernum using '<<<<<<<<<&',
            " Tariffclass: ", pv_pm_tariff_rec.tariffclass using '<<<<<<<<<&',
            " Start Date: ", pv_pm_tariff_rec.start_date,
            " End Date: ", pv_pm_tariff_rec.end_date
      call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
    end if

  end if

  if v_err_code = 0 then
    call pub_proc_pm_reg_prod_comp("A", v_pm_tariff_id)
    returning v_chg_dep_reg
  end if

  if g_is_debug_on then
    let v_debug_str = "v_err_code = ", v_err_code
    call disp_debug(2, v_debug_str)
    let v_debug_str = "v_err_sub = ", v_err_sub
    call disp_debug(2, v_debug_str)
    let v_debug_str = "v_pm_tariff_id = ", v_pm_tariff_id
    call disp_debug(2, v_debug_str)
    call disp_debug(1, "end function priv_a_pm_tariff")
  end if

  return v_err_code, v_err_sub, v_pm_tariff_id

end function


#-------------------------------------------------------------------------------
function pub_u_pm_tariff(pv_pm_tariff_rec, pv_main_tariff,
                         pv_mt_startdate, pv_mt_enddate)
#-------------------------------------------------------------------------------
# This function updates a row in pm_tariff for the data passed in,
# if the tariff is set as the main tariff,
# maintain the data in pm_tariff_main as well

# parameters
define
  pv_pm_tariff_rec record like pm_tariff.*,
  pv_main_tariff       smallint,
  pv_mt_startdate like pm_tariff_main.start_date,
  pv_mt_enddate   like pm_tariff_main.end_date

define
  v_chg_dep_reg    smallint,
  v_success               smallint

  if g_is_debug_on then
    call disp_debug(1, "function pub_u_pm_tariff")
  end if

  if en_debug(2) then
    let v_debug_str = "pm_tariff_id = ", pv_pm_tariff_rec.pm_tariff_id
    call disp_debug(2, v_debug_str)
    let v_debug_str = "premnum = ", pv_pm_tariff_rec.premnum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "util_type = ", pv_pm_tariff_rec.util_type
    call disp_debug(2, v_debug_str)
    let v_debug_str = "servicenum = ", pv_pm_tariff_rec.servicenum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "registernum = ", pv_pm_tariff_rec.registernum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "tariffclass = ", pv_pm_tariff_rec.tariffclass
    call disp_debug(2, v_debug_str)
    let v_debug_str = "start_date = '", pv_pm_tariff_rec.start_date, "'"
    call disp_debug(2, v_debug_str)
    let v_debug_str = "end_date = '", pv_pm_tariff_rec.end_date, "'"
    call disp_debug(2, v_debug_str)

    let v_debug_str = "pv_main_tariff = ", pv_main_tariff
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_mt_startdate = ", pv_mt_startdate
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_mt_enddate = ", pv_mt_enddate
    call disp_debug(2, v_debug_str)
  end if

  # initialisation
  let v_err_code = 0
  let v_err_sub = 0
  let v_status = 0
  # check mandatory column for table
  if pv_pm_tariff_rec.premnum is null or
     pv_pm_tariff_rec.util_type is null or
     pv_pm_tariff_rec.servicenum is null or
     pv_pm_tariff_rec.tariffclass is null or
     pv_pm_tariff_rec.start_date is null then

    let v_err_code = 1
    let v_err_sub = v_status
    let v_err_msg = "pub_u_pm_tariff : null in not null column"
    call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )

  end if

  if v_err_code = 0 then

    # update pm_tariff
    update pm_tariff set * = pv_pm_tariff_rec.*
      where pm_tariff_id = pv_pm_tariff_rec.pm_tariff_id

    let v_status = status
    if v_status <> 0 then
      let v_err_code = 1
      let v_err_sub = v_status
      let v_err_msg = "pub_u_pm_tariff : Update pm_tariff failed."
      call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
    else
      # if main tariff is true
      if pv_main_tariff then

        # check if record already exists
        if lookup("pm_tariff_main", "pm_tariff_id",
                  pv_pm_tariff_rec.pm_tariff_id) then

          # update exist record in pm_tariff_main
          update pm_tariff_main
            set start_date = pv_mt_startdate,
                end_date = pv_mt_enddate
            where pm_tariff_id = pv_pm_tariff_rec.pm_tariff_id

          let v_status = status

        else

          # if not exist, insert a new record to pm_tariff_main
          insert into pm_tariff_main values (pv_pm_tariff_rec.pm_tariff_id,
                                              pv_mt_startdate,
                                              pv_mt_enddate)
          let v_status = status

        end if # end lookup

        if v_status <> 0 then
          let v_err_code = 1
          let v_err_sub = v_status
          let v_err_msg = "pub_u_pm_tariff : Update pm_tariff_main failed."
          call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
        end if

      else # not main tariff

        # delete main tariff
        if lookup("pm_tariff_main", "pm_tariff_id", pv_pm_tariff_rec.pm_tariff_id) then

          delete from pm_tariff_main
            where pm_tariff_id = pv_pm_tariff_rec.pm_tariff_id

          let v_status = status
          if v_status <> 0 then
            let v_err_code = 1
            let v_err_sub = v_status
            let v_err_msg = "pub_u_pm_tariff : Delete pm_tariff_main failed."
            call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
          end if
        end if

      end if # end pv_main_tariff
    end if # end v_status
  end if # end v_err_code = 0

  if v_err_code = 0 then
    call pub_proc_pm_reg_prod_comp("U", pv_pm_tariff_rec.pm_tariff_id)
    returning v_chg_dep_reg
  end if

  if g_is_debug_on then
    let v_debug_str = "v_err_code = ", v_err_code
    call disp_debug(2, v_debug_str)
    let v_debug_str = "v_err_sub = ", v_err_sub
    call disp_debug(2, v_debug_str)
    call disp_debug(1, "end function pub_u_pm_tariff")
  end if

  return v_err_code, v_err_sub

end function


#-------------------------------------------------------------------------------
function pub_d_pm_tariff(pv_pm_tariff_id)
#-------------------------------------------------------------------------------

  # parameters
  define
  pv_pm_tariff_id like pm_tariff.pm_tariff_id

  define #Local Variables
  v_chg_dep_reg    smallint,
  v_pm_tariff_rec record like pm_tariff.*

  if g_is_debug_on then
    call disp_debug(1, "function pub_d_pm_tariff")
  end if

  # initialisation
  let v_err_code = 0
  let v_err_sub = 0
  let v_status = 0
  # delete from pm_tariff_main if id exists
  if lookup("pm_tariff_main", "pm_tariff_id", pv_pm_tariff_id) then

    select * into v_pm_tariff_rec.*
      from pm_tariff
      where pm_tariff_id = pv_pm_tariff_id

    delete from pm_tariff_main
      where pm_tariff_id = pv_pm_tariff_id

    let v_status = status
    if v_status <> 0 then
      let v_err_code = 1
      let v_err_sub = v_status
      let v_err_msg = "pub_d_pm_tariff : Delete pm_tariff_main failed."
      call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
    end if
  end if

  if v_err_code = 0 then
    call pub_proc_pm_reg_prod_comp("D", pv_pm_tariff_id)
    returning v_chg_dep_reg
  end if

  # delete from pm_tariff
  if v_err_code = 0 then

    delete from pm_tariff
      where pm_tariff_id = pv_pm_tariff_id

    let v_status = status
    if v_status <> 0 then
      let v_err_code = 1
      let v_err_sub = v_status
      let v_err_msg = "pub_d_pm_tariff : Delete pm_tariff failed."
      call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
    end if
  end if

  if g_is_debug_on then
    let v_debug_str = "v_err_code = ", v_err_code
    call disp_debug(2, v_debug_str)
    let v_debug_str = "v_err_sub = ", v_err_sub
    call disp_debug(2, v_debug_str)

    call disp_debug(1, "end function pub_d_pm_tariff")
  end if

  return v_err_code, v_err_sub

end function


#-------------------------------------------------------------------------------
function pub_lock_pm_tariffs(pv_premnum, pv_servicenum, pv_registernum,
                             pv_util_type, pv_last_readingdate)
#-------------------------------------------------------------------------------
# This function locks all price options service/register
# that effective after last reading date in pm_tariff and pm_tariff_main.

# parameters
define
  pv_premnum          like pm_tariff.premnum,
  pv_servicenum       like pm_tariff.servicenum,
  pv_registernum      like pm_tariff.registernum,
  pv_util_type        like pm_tariff.util_type,
  pv_last_readingdate date

  if g_is_debug_on then
    call disp_debug(1, "function pub_lock_pm_tariffs")
  end if

  if en_debug(2) then
    let v_debug_str = "pv_premnum = ", pv_premnum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_servicenum = ", pv_servicenum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_registernum = ", pv_registernum
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_util_type = ", pv_util_type
    call disp_debug(2, v_debug_str)
    let v_debug_str = "pv_last_readingdate = '", pv_last_readingdate, "'"
    call disp_debug(2, v_debug_str)
  end if

  # initialisation
  let v_err_code = 0
  let v_err_sub = 0
  let v_status = 0
 # if no register
  if pv_registernum is null then
    let pv_registernum = 0
  end if

  declare pm_priceoptions_c cursor for
    select * from pm_tariff
      where premnum = pv_premnum
        and servicenum = pv_servicenum
        and registernum = pv_registernum
        and (end_date is null
         or end_date >= pv_last_readingdate)
      for update

  let v_status = status

  if v_status = 0 then

    declare pm_mainpriceoptions_c cursor for
      select * from pm_tariff_main
        where pm_tariff_id = (
          select pm_tariff_id from pm_tariff
            where premnum = pv_premnum
              and servicenum = pv_servicenum
              and registernum = pv_registernum
              and (end_date is null
               or end_date >= pv_last_readingdate) )
        for update

    let v_status = status
    if v_status <> 0 then
      let v_err_code = 1
      let v_err_sub = v_status
      let v_err_msg = "pub_lock_pm_tariffs : Error occur while locking pm_tariff_main."
      call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
    end if

  else

    let v_err_code = 1
    let v_err_sub = v_status
    let v_err_msg = "pub_lock_pm_tariffs : Error occur while locking pm_tariff."
    call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )

  end if

  if g_is_debug_on then
    let v_debug_str = "v_err_code = ", v_err_code
    call disp_debug(2, v_debug_str)
    let v_debug_str = "v_err_sub = ", v_err_sub
    call disp_debug(2, v_debug_str)

    call disp_debug(1, "end function pub_lock_pm_tariffs")
  end if

  return v_err_code, v_err_sub

end function


#-------------------------------------------------------------------------------
function p_cfg_priceoption(pv_pm_tariff_rec, pv_main_tariff,
                           pv_mt_startdate, pv_mt_enddate, pv_operation)
#-------------------------------------------------------------------------------
# This function process the rate option following the pv_operation instruction.
# pv_operation : A - Add, U - Update, D - Delete

# parameters
define
  pv_operation         char(1),
  pv_main_tariff       smallint,
  pv_mt_startdate like pm_tariff_main.start_date,
  pv_mt_enddate   like pm_tariff_main.end_date

# record
define
  pv_pm_tariff_rec record like pm_tariff.*

# loccal variable
define
  v_pm_tariff_id integer

  if g_is_debug_on then
    call disp_debug(1, "function p_cfg_priceoption")
  end if

  # initialisation
  let v_err_code = 0
  let v_err_sub = 0
  let v_status = 0

  case pv_operation

    when "A" # ADD
      call pub_a_pm_tariff(pv_pm_tariff_rec.*, pv_main_tariff,
                           pv_mt_startdate, pv_mt_enddate)
        returning v_err_code, v_err_sub, v_pm_tariff_id

    when "U" # UPDATE
      call pub_u_pm_tariff(pv_pm_tariff_rec.*, pv_main_tariff,
                           pv_mt_startdate, pv_mt_enddate)
        returning v_err_code, v_err_sub

    when "D" # DELETE
      call pub_d_pm_tariff(pv_pm_tariff_rec.pm_tariff_id)
        returning v_err_code, v_err_sub

    otherwise
      let v_err_code = 1
      let v_err_msg = "p_cfg_priceoption : Not A, U or D."
      call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )

  end case

  if g_is_debug_on then
    let v_debug_str = "v_err_code = ", v_err_code
    call disp_debug(2, v_debug_str)
    let v_debug_str = "v_err_sub = ", v_err_sub
    call disp_debug(2, v_debug_str)
    call disp_debug(1, "end function p_cfg_priceoption")
  end if

  return v_err_code, v_err_sub, v_pm_tariff_id

end function


#-------------------------------------------------------------------------------
function get_main_priceoption(pv_premnum, pv_util_type, pv_servicenum,
                              pv_registernum, pv_date)
#-------------------------------------------------------------------------------
# This function retrieve the main price option of the service/register
# effective on pv_date.

define
  # Parameters
  pv_premnum              like pm_premise.premnum,
  pv_util_type            like pm_service.util_type,

  pv_servicenum           like pm_service.servicenum,
  pv_registernum          like pm_register.registernum,
  pv_date                 date,

  # Loccal variable
  v_stmt                  char(400),
  v_success               smallint,
  v_tar_effective         date,

  # Returns
  v_price_option          record     # like priceOption object.
    pm_tariff_id            like pm_tariff.pm_tariff_id,
    price_option            like tm_tariff.tariffclass,
    priceoption_descr       like tm_tariff.descr_tariff,
    start_date              like pm_tariff.start_date,
    end_date                like pm_tariff.end_date,
    main_po                 smallint,
    main_start_date         like pm_tariff_main.start_date,
    main_end_date           like pm_tariff_main.end_date,
    process_type            char(1),
    registernum             like pm_tariff.registernum
  end record

  if g_is_debug_on then
    call disp_debug(1, "function get_main_priceoption")

    let v_debug_str = "  pv_premnum = ", pv_premnum,
                      "  pv_util_type = ", pv_util_type,
                      "  pv_servicenum = ", pv_servicenum,
                      "  pv_registernum = ", pv_registernum,
                      "  pv_date = ", pv_date
    call disp_debug(2, v_debug_str)
  end if

  # Set register number to 0 for non register service.
  if pv_registernum is null then
    let pv_registernum = 0
  end if

  if pv_date = "" or pv_date is null then
    let pv_date = getdedate()
  end if

  declare main_priceoption_c cursor for
    select pm_tariff.pm_tariff_id,
           pm_tariff.tariffclass,
           descr_tariff,
           pm_tariff.start_date,
           pm_tariff.end_date,
           1,               #CQ118830
           pm_tariff_main.start_date,
           pm_tariff_main.end_date,
           '',              #CQ118830
           pm_tariff.registernum,
           date_effective
      from pm_tariff, pm_tariff_main, tm_tariff
     where premnum =  pv_premnum
       and pm_tariff.util_type =  pv_util_type
       and servicenum =  pv_servicenum
       and registernum =  pv_registernum
       and pm_tariff.pm_tariff_id =  pm_tariff_main.pm_tariff_id
       and pm_tariff_main.start_date <=  pv_date
       and (pm_tariff_main.end_date is null or
           pm_tariff_main.end_date >= pv_date)
       and tm_tariff.util_type =  pv_util_type
       and pm_tariff.tariffclass = tm_tariff.tariffclass
       and date_effective <= pv_date
     order by pm_tariff_main.start_date desc, date_effective desc

  open main_priceoption_c
  fetch main_priceoption_c into v_price_option.*, v_tar_effective
  let v_status = status
  if g_is_debug_on then
    let v_debug_str = "  v_status = ", v_status, " Effective @ ", v_tar_effective
    call disp_debug(666, v_debug_str)
  end if

  if v_status <> 0 then
    let v_price_option.pm_tariff_id = 0
    let v_price_option.price_option = 0
    if v_status <> 100 then
      let v_err_code = 1
      let v_err_sub = v_status
      let v_err_msg = "get_main_priceoption : Cannot fetch pm_tariff_main"
      call log_error_debug( v_err_msg, v_err_code, null, v_err_sub )
    else
      call disp_debug(666, "No main tariff for the serv/reg @ the date")
    end if
  end if

  if g_is_debug_on then
    let v_debug_str = "Return: pm_tariff_id = ", v_price_option.pm_tariff_id,
                      "   main_priceoption = ", v_price_option.price_option,
                      "   priceoption_descr = ", v_price_option.priceoption_descr,
                      "   start_date = ", v_price_option.start_date,
                      "   end_date = ", v_price_option.end_date,
                      "   main_po = ", v_price_option.main_po,
                      "   main_start_date = ", v_price_option.main_start_date,
                      "   main_end_date = ", v_price_option.main_end_date,
                      "   process_type = ", v_price_option.process_type,
                      "   registernum = ", v_price_option.registernum
    call disp_debug(2, v_debug_str)

    call disp_debug(1, "end function get_main_priceoption")
  end if

  return v_price_option.*

end function #get_main_priceoption


#-------------------------------------------------------------------------------
function close_all_price_option()
#-------------------------------------------------------------------------------

  close pm_priceoptions_c

end function


#-------------------------------------------------------------------------------
function close_main_price_option()
#-------------------------------------------------------------------------------

  close main_priceoption_c

end function

#-------------------------------------------------------------------------------
function chg_main_priceoption(pv_premnum, pv_util_type, pv_servicenum,
                              pv_registernum, pv_new_tariff, pv_date)
#-------------------------------------------------------------------------------
# This function end the old main price option and set the passed in
# new tariff as the new main price option of the service/register
# effective on pv_date plus 1 day.

define
  # Parameters
  pv_premnum              like pm_premise.premnum,
  pv_util_type            like pm_service.util_type,
  pv_servicenum           like pm_service.servicenum,
  pv_registernum          like pm_register.registernum,
  pv_new_tariff           like tm_tariff.tariffclass,
  pv_date                 date,

  # Loccal variable
  v_pm_tariff             record like pm_tariff.*,
  v_price_option          record     # like priceOption object.
    pm_tariff_id            like pm_tariff.pm_tariff_id,
    price_option            like tm_tariff.tariffclass,
    priceoption_descr       like tm_tariff.descr_tariff,
    start_date              like pm_tariff.start_date,
    end_date                like pm_tariff.end_date,
    main_po                 smallint,
    main_start_date         like pm_tariff_main.start_date,
    main_end_date           like pm_tariff_main.end_date,
    process_type            char(1),
    registernum             like pm_tariff.registernum
  end record,

  # Returns
  v_success               smallint

  if g_is_debug_on then
    call disp_debug(1, "function chg_main_priceoption")
    let v_debug_str = "  pv_premnum = ", pv_premnum,
                      "  pv_util_type = ", pv_util_type,
                      "  pv_servicenum = ", pv_servicenum,
                      "  pv_registernum = ", pv_registernum,
                      "  pv_new_tariff = ", pv_new_tariff,
                      "  pv_date = ", pv_date
    call disp_debug(2, v_debug_str)
  end if

  initialize v_price_option.*, v_pm_tariff.* to null
  let v_success = false
  let v_pm_tariff.premnum = pv_premnum
  let v_pm_tariff.util_type = pv_util_type
  let v_pm_tariff.servicenum = pv_servicenum
  let v_pm_tariff.registernum = pv_registernum

  call get_main_priceoption(pv_premnum, pv_util_type, pv_servicenum,
                            pv_registernum, pv_date)
    returning v_price_option.*

  if v_price_option.pm_tariff_id is null or
     v_price_option.pm_tariff_id <= 0 then
    #There is no current main tariff.
    #Set pv_new_tariff as new main price option.
    let v_pm_tariff.pm_tariff_id = 0
    let v_pm_tariff.tariffclass = pv_new_tariff
    let v_pm_tariff.start_date = pv_date + 1
    let v_pm_tariff.end_date = null
    call pub_a_pm_tariff(v_pm_tariff.*,
                         true,
                         v_pm_tariff.start_date,
                         null)
      returning v_err_code, v_err_sub, v_pm_tariff.pm_tariff_id
    if v_err_code <> 0 then
      let v_err_msg = "chg_main_priceoption(): Failed set new main price option."
      call err_handler(TRUE, v_err_sub, v_err_msg)
      let v_success = false
    end if
  else
    #End the old main price option at one day before pv_date.
    let v_pm_tariff.pm_tariff_id = v_price_option.pm_tariff_id
    let v_pm_tariff.tariffclass = v_price_option.price_option  #CQ114625
    let v_pm_tariff.start_date = v_price_option.start_date
    let v_pm_tariff.end_date = pv_date
    call pub_u_pm_tariff(v_pm_tariff.*,
                         v_price_option.main_po,
                         v_price_option.main_start_date,
                         v_pm_tariff.end_date)
      returning v_err_code, v_err_sub
    if v_err_code <> 0 then
      let v_err_msg = "chg_main_priceoption(): Failed end the current main ",
                      "price option, id=", v_pm_tariff.pm_tariff_id
      call err_handler(TRUE, v_err_sub, v_err_msg)
    else
      #Set pv_new_tariff as new main price option.
      let v_pm_tariff.pm_tariff_id = 0
      let v_pm_tariff.tariffclass = pv_new_tariff
      let v_pm_tariff.start_date = pv_date + 1
      let v_pm_tariff.end_date = v_price_option.main_end_date
      call pub_a_pm_tariff(v_pm_tariff.*,
                           v_price_option.main_po,
                           v_pm_tariff.start_date,
                           v_price_option.main_end_date)
        returning v_err_code, v_err_sub, v_pm_tariff.pm_tariff_id
      if v_err_code <> 0 then
        let v_err_msg = "chg_main_priceoption(): Failed add new main price option."
        call err_handler(TRUE, v_err_sub, v_err_msg)
        let v_success = false
      else
        let v_success = true
      end if #v_err_code <> 0
    end if #v_err_code <> 0
  end if #v_price_option.pm_tariff_id <= 0

  if g_is_debug_on then
    let v_debug_str = "v_success = ", v_success
    call disp_debug(2, v_debug_str)

    call disp_debug(2, "end function chg_main_priceoption")
  end if

  return v_success

end function
#chg_main_priceoption


#-------------------------------------------------------------------------------
function end_price_options(pv_premnum, pv_util_type, pv_servicenum,
                          pv_registernum, pv_date)
#-------------------------------------------------------------------------------
# This function end all current price options of the service/register,
# and delete any future price options for the service/register.

define
  # Parameters
  pv_premnum              like pm_premise.premnum,
  pv_util_type            like pm_service.util_type,
  pv_servicenum           like pm_service.servicenum,
  pv_registernum          like pm_register.registernum,
  pv_date                 date,

  # Loccal variable
  v_sel_stmt              char(500),

  #Returns
  v_success               smallint,
  v_pm_tariff_id          like pm_tariff.pm_tariff_id

  if g_is_debug_on then
    call disp_debug(1, "function end_price_options")
    let v_debug_str = "  pv_premnum = ", pv_premnum,
                      "  pv_util_type = ", pv_util_type,
                      "  pv_servicenum = ", pv_servicenum,
                      "  pv_registernum = ", pv_registernum,
                      "  pv_date = ", pv_date
    call disp_debug(2, v_debug_str)
  end if

  let v_success = true
  let v_err_msg = ""

  #End all current main price options.
  update pm_tariff_main
     set end_date = pv_date
   where pm_tariff_id in
         (select pm_tariff_id from pm_tariff
           where premnum = pv_premnum
             and util_type = pv_util_type
             and servicenum = pv_servicenum
             and registernum = pv_registernum
             and start_date <= pv_date
             and (end_date is null or end_date >= pv_date))
      and (end_date is null or end_date > pv_date)
  let v_status = status

  if v_status <> 0 then
    let v_err_msg = "end_price_options(): Failed end the current main price options."
    let v_success = false
  else
    #End all current price options.
    update pm_tariff
       set end_date = pv_date
     where premnum = pv_premnum
       and util_type = pv_util_type
       and servicenum = pv_servicenum
       and registernum = pv_registernum
       and start_date <= pv_date
       and (end_date is null or end_date >= pv_date)
    let v_status = status
    if v_status <> 0 then
      let v_err_msg = "end_price_options(): Failed end the current price options."
      let v_success = false
    end if
  end if #v_status <> 0

  if v_success then
    #Delete all future main price options.
    let v_sel_stmt =
      "select pm_tariff_id",
      "  from pm_tariff",
      " where premnum = ", pv_premnum,
      "   and util_type = '", pv_util_type, "'",
      "   and servicenum = ", pv_servicenum,
      "   and registernum = ", pv_registernum,
      "   and pm_tariff.start_date > ", convert_date(pv_date)
    if g_is_debug_on then
      call disp_debug(7, v_sel_stmt)
    end if

    prepare del_future_tar_s from v_sel_stmt
    declare del_future_tar_c cursor for del_future_tar_s

    foreach del_future_tar_c into v_pm_tariff_id
      call pub_d_pm_tariff(v_pm_tariff_id)
        returning v_err_code, v_err_sub
      if v_err_code <> 0 then
      let v_err_msg = "end_price_options(): Failed delete future price option:",
                      " pm_tariff_id = ", v_pm_tariff_id
        let v_success = false
      end if
      if not v_success then
        exit foreach
      end if
    end foreach

    #Clear the future main price options.
    delete from pm_tariff_main
      where pm_tariff_id in
              (select pm_tariff_id from pm_tariff
                where premnum = pv_premnum
                  and util_type = pv_util_type
                  and servicenum = pv_servicenum
                  and registernum = pv_registernum
                  and pm_tariff.start_date <= pv_date)
        and pm_tariff_main.start_date > pv_date

    if v_err_code <> 0 then
      let v_err_msg = "end_price_options(): Failed delete pm_tariff_main:",
                      " premnum : ", pv_premnum, " ", pv_util_type,
                      "-", pv_servicenum, "-", pv_registernum
      let v_success = false
    end if

  end if #v_success

  if not v_success then
    call err_handler(TRUE, v_status, v_err_msg)
  end if

  if g_is_debug_on then
    let v_debug_str = "v_success = ", v_success, "    msg:", v_err_msg
    call disp_debug(2, v_debug_str)

    call disp_debug(1, "end function end_price_options")
  end if

  return v_success

end function
#chg_main_priceoption



#-------------------------------------------------------------------------------
function service_start_date(pv_premnum, pv_util_type, pv_servicenum)
#-------------------------------------------------------------------------------
# This function find the service start date of the last effective period.

define
  # Parameters
  pv_premnum              like pm_premise.premnum,
  pv_util_type            like pm_service.util_type,
  pv_servicenum           like pm_service.servicenum,

  # Loccal variable
  v_reg_end_date          date,
  v_srv_end_date          date,
  v_count                 smallint,

  #Returns
  v_srv_start_date        date

  if g_is_debug_on then
    call disp_debug(1, "function service_start_date")

    let v_debug_str = "  pv_premnum = ", pv_premnum,
                      "  pv_util_type = ", pv_util_type,
                      "  pv_servicenum = ", pv_servicenum
    call disp_debug(2, v_debug_str)

    call disp_debug(666, "Count the current register numbers")
  end if

  select count(pm_tariff_main.end_date)
    into v_count
    from pm_tariff_main, pm_tariff
   where premnum = pv_premnum
     and util_type = pv_util_type
     and servicenum = pv_servicenum
     and pm_tariff_main.pm_tariff_id = pm_tariff.pm_tariff_id
     and registernum > 0
     and pm_tariff_main.end_date is null

  let v_status = status

  let v_debug_str = " v_status = ", v_status
  call disp_debug(666, v_debug_str)

  if v_status <> 0 then
    let v_err_msg = "service_start_date(): Can't count the current registers"
    call err_handler(true, v_status, v_err_msg)
  else
    if g_is_debug_on then
      let v_debug_str = " v_count = ", v_count
      call disp_debug(666, v_debug_str)
    end if

    if v_count > 0 then
      #Registers are effective now.
      #Find out the last end date of service's price option.
      select max(pm_tariff_main.end_date)
        into v_srv_end_date
        from pm_tariff_main, pm_tariff
       where premnum = pv_premnum
         and util_type = pv_util_type
         and servicenum = pv_servicenum
         and pm_tariff_main.pm_tariff_id = pm_tariff.pm_tariff_id
         and registernum = 0

      let v_status = status
      if v_status <> 0 then
        let v_err_msg = "service_start_date(): Can't fetch v_srv_end_date"
        call err_handler(true, v_status, v_err_msg)
      else
        if g_is_debug_on then
          let v_debug_str = " v_srv_end_date = ", v_srv_end_date
          call disp_debug(666, v_debug_str)
        end if
      end if
    else
      let v_srv_end_date = null
    end if #v_count >0

    if v_status = 0 then
      if v_srv_end_date is not null then #CQ119531
      #Find the lastest end date of the register of the service.
        select max(pm_tariff_main.end_date)
          into v_reg_end_date
          from pm_tariff_main, pm_tariff
        where premnum = pv_premnum
          and util_type = pv_util_type
          and servicenum = pv_servicenum
          and registernum > 0
          and pm_tariff_main.pm_tariff_id = pm_tariff.pm_tariff_id
          and pm_tariff_main.end_date is not null
          and #(v_srv_end_date is null or #CQ119531 deleted as SQL error
              v_srv_end_date > pm_tariff_main.end_date #) #CQ119531
      #CQ119531
      else
        select max(pm_tariff_main.end_date)
          into v_reg_end_date
          from pm_tariff_main, pm_tariff
        where premnum = pv_premnum
          and util_type = pv_util_type
          and servicenum = pv_servicenum
          and registernum > 0
          and pm_tariff_main.pm_tariff_id = pm_tariff.pm_tariff_id
          and pm_tariff_main.end_date is not null
      end if

      let v_status = status
      if g_is_debug_on then
        let v_debug_str = " v_status = ", v_status,
                          "    v_reg_end_date = ", v_reg_end_date
        call disp_debug(666, v_debug_str)
      end if

      if v_status = 0 then
        if v_reg_end_date is null then
          #The service has never had register.
          select min(pm_tariff_main.start_date)
            into v_srv_start_date
            from pm_tariff_main, pm_tariff
           where premnum = pv_premnum
             and util_type = pv_util_type
             and servicenum = pv_servicenum
             and registernum = 0
             and pm_tariff_main.pm_tariff_id = pm_tariff.pm_tariff_id

          if g_is_debug_on then
            let v_debug_str = " v_srv_start_date = ", v_srv_start_date
            call disp_debug(666, v_debug_str)
          end if
        else
          #Service price option shoud start one day after v_srv_start_date.
          let v_srv_start_date = v_reg_end_date + 1
        end if #v_reg_end_date is null
      else
        let v_err_msg = "service_start_date(): Can't fetch v_srv_start_date"
        call err_handler(true, v_status, v_err_msg)
      end if
    end if #v_status = 0
  end if #v_status of count current registers.

  if g_is_debug_on then
    let v_debug_str = "v_srv_start_date = ", v_srv_start_date
    call disp_debug(2, v_debug_str)

    call disp_debug(2, "end function service_start_date")
  end if

  return v_srv_start_date

end function
#service_start_date

#####################################################################
# Function: pub_exist_pm_tariff
# Description: This function returns a true or false value as to
# whether a given tariff is current at a given premise, utility, service
# or regsiter at any time during a given date range.
# It was created to be used when automatically replacing obsolete tariffs.
# Refer to file pub_obsolete.4gl
#####################################################################
function pub_exist_pm_tariff(pv_premnum, pv_servicenum, pv_util_type,
  pv_registernum, pv_tariffclass, pv_start_period, pv_end_period)

define
  #Parameters
  pv_premnum       like pm_tariff.premnum,
  pv_servicenum    like pm_tariff.servicenum,
  pv_util_type     like pm_tariff.util_type,
  pv_registernum   like pm_tariff.registernum,
  pv_tariffclass   like pm_tariff.tariffclass,
  pv_start_period  date,
  pv_end_period    date,
  #Local Variables
  v_count          smallint,
  v_exist          smallint,
  v_success        smallint

  if g_is_debug_on then
    call disp_debug(1, "function pub_exist_pm_tariff")
  end if

  whenever error call pub_log_and_continue

  #Initialize variables
  let v_count = 0
  let v_exist = false
  let v_success = true

  let v_sel_str =
  "select count(*) from pm_tariff",
    " where premnum = ?",
    " and servicenum = ?",
    " and util_type = ?",
    " and registernum = ?",
    " and tariffclass = ? ",
    " and (end_date >= ?" ,
    " or end_date is null)"

  if pv_end_period is not null then
    let v_sel_str = v_sel_str clipped,
    " and start_date <= ", convert_date(pv_end_period)
  end if

  prepare exist_pm_tariff_s from v_sel_str
  declare exist_pm_tariff_c cursor for exist_pm_tariff_s

  execute exist_pm_tariff_c into v_count
    using pv_premnum, pv_servicenum, pv_util_type, pv_registernum,
    pv_tariffclass, pv_start_period

  let v_status = status
  if v_status <> 0 then
    let v_success = false
  end if

  if v_success and v_count > 0 then
    let v_exist = true
  end if

  if g_is_debug_on then
    let v_debug_str = "v_exist: ", v_exist
    call disp_debug(2, v_debug_str)
    call disp_debug(1, "end function pub_exist_pm_tariff")
  end if

  return v_success, v_exist

end function

##CQ100640#####################################################################
# This function opens up a cursor to fetch information from the table
# pm_tariff, based on the parameters passed in.
# Returns "true" if cursor is successfully created, otherwise returns "false"
#
# pv_startdate & pv_enddate are the start and end dates of the period
# in which we look for tariffs current at the service/register.
#
function open_pm_tariffs(pv_premnum, pv_util_type, pv_servicenum,
  pv_registernum, pv_startdate, pv_enddate)
  define
    pv_premnum              like pm_tariff.premnum,
    pv_util_type            like pm_tariff.util_type,
    pv_servicenum           like pm_tariff.servicenum,
    pv_registernum          like pm_tariff.registernum,
    pv_startdate            like pm_tariff.start_date,
    pv_enddate              like pm_tariff.end_date

  define
    v_status                smallint,
    v_success               smallint,
    v_fetch_tariff_stmt     char(400),
    v_debug_str             char(100)

  call disp_debug(1, "function open_pm_tariffs")

  let v_fetch_tariff_stmt =
    "select * from pm_tariff",
      " where pm_tariff.premnum = ", pv_premnum,
        " and pm_tariff.util_type = '", pv_util_type clipped, "'",
        " and pm_tariff.servicenum = ", pv_servicenum,
        " and pm_tariff.registernum = ", pv_registernum,
        " and pm_tariff.start_date <= ", convert_date(pv_enddate),
        " and (pm_tariff.end_date >= ", convert_date(pv_startdate),
          " or pm_tariff.end_date is null)"

  prepare sql_s from v_fetch_tariff_stmt
  declare sql_c cursor with hold for sql_s
  let v_status = status
  if v_status <> 0 then
    let v_success = false
  else
    let v_success = true
  end if
  open sql_c
  let v_status = status
  if v_status <> 0 then
    let v_success = false
  end if

  let v_debug_str = "v_success : ",v_success
  call disp_debug(2,v_debug_str)

  call disp_debug(1, "end function open_pm_tariffs")
  return v_success
end function

##CQ100640#####################################################################
# This function fetches the information into recordset using the cursor opened
# in the function "open_tm_tariff".
# Parameters: None
# Return values: v_success, v_tariff_rec.*
# success = true
# - if fetch successfull and tariffclass has a value
# success = false
# - if fetch unsuccessfull or
# - tariffclass is null or
# - tariffclass = 0
# v_tariff_rec.* = a row from pm_tariff that matches the criteria passed to
# open_pm_tariffs
#
function fetch_pm_tariffs()
  define
    v_status                smallint,
    v_success               smallint,
    v_tariff_rec            record like pm_tariff.*,
    v_debug_str             char(100)

  call disp_debug(1, "function fetch_pm_tariffs")

  fetch sql_c into v_tariff_rec.*
  let v_status = status
  if v_status <> 0 then
    let v_success = false
  else
    let v_success = true
  end if


  if v_success then
    if v_tariff_rec.tariffclass is null or v_tariff_rec.tariffclass = 0 then
      let v_success = false
    end if
  end if

  if en_debug(2) then
    let v_debug_str = "v_success : ",v_success
    call disp_debug(2, v_debug_str)
    let v_debug_str = "v_tariff_rec.tariffclass : ",v_tariff_rec.tariffclass
    call disp_debug(2, v_debug_str)
  end if
  call disp_debug(1, "end function fetch_pm_tariffs")

  return v_success, v_tariff_rec.*
end function


##CQ100640#####################################################################
# This function closes the cursor created by the function "open_pm_tariffs".
function close_pm_tariffs()
  call disp_debug(1, "function close_pm_tariffs")
  close sql_c
  free sql_c
  call disp_debug(1, "end function close_pm_tariffs")
end function

# function to return the current network tariff code
function get_current_network_tariff(pv_tariffclass, pv_util_type, pv_date)

  define
    pv_tariffclass      like tm_tariff.tariffclass,
    pv_util_type        char(1),
    pv_date             date,
    v_participant_code  like tm_price_comp_info.participant_code

  if g_is_debug_on then
    call disp_debug(1, "function get_current_network_tariff")
  end if


  select participant_code into v_participant_code
    from tm_price_comp_info, tm_tariff
    where tm_price_comp_info.price_comp_code = tm_tariff.tariffclass
    and tm_price_comp_info.date_effective = tm_tariff.date_effective
    and tm_price_comp_info.util_type = tm_tariff.util_type
    and price_comp_code = pv_tariffclass
    and tm_price_comp_info.util_type = pv_util_type
    and tm_price_comp_info.date_effective = (select max(date_effective) from tm_tariff
                                              where tariffclass =  pv_tariffclass
                                              and date_effective <= pv_date
                                              and util_type = pv_util_type)
  if g_is_debug_on then
    call disp_debug(1, "returning ntc " || v_participant_code)
    call disp_debug(1, "end function get_current_network_tariff")
  end if

  return v_participant_code

end function
