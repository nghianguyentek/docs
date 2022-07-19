{
**********************************************************************
*      ENERGY Utility Billing and Information System
**********************************************************************
* Copyright        : Hansen Technologies Ltd
* Developed By     : Hansen Technologies Ltd
* Marketing Rights : Hansen Technologies Ltd
*                    P O Box 37-580   Parnell 1151 Auckland
*                    Telephone +64-9-373 0400   Fax +64-9-373 0402
**********************************************************************
* Author        : Irina Simes
* Date Created  : 15 May 2017
*
**********************************************************************
* DESCRIPTION : Schema Changes for Job ## automatically set by build tools ##
* Add PTJ Flex Fields
* END
**********************************************************************
* Notes :
* Source location: /opt/peace/PeaceInternalDevelopmentTools/template/SCHEMA_SCRIPT_TEMPLATE.4gl
**********************************************************************
}

database energy

define
  v_status                 integer,
  v_owner                  varchar(30)

main
  define
    v_count                integer,
    v_success              integer,
    v_stmt                 varchar(1500),
    v_schema               varchar(30),
    v_table                varchar(30),
    v_column               varchar(30),
    v_datatype             varchar(50),
    v_nullable             varchar(30),
    v_idxname              varchar(30),
    v_idxcols              varchar(60),
    v_unique               varchar(6),
    v_col_str              varchar(200),
    v_nulls                varchar(30),
    v_sys_attr_code        varchar(5),
    v_sys_attr_descr       varchar(30),
    v_trigger_id           varchar(11),
    v_trigger_descr        varchar(30),
    v_col_key              varchar(100),
    v_col_referenced       varchar(100),
    v_values_str           varchar(1000),
    v_tab_altered          varchar(30),
    v_tab_referenced       varchar(30),
    v_country              varchar(3),
    v_col_type             varchar(30),
    v_collength            integer,
    v_length               integer,
    v_scale                integer,
    v_cons_name            varchar(50),
    v_constraint           varchar(1500),
    v_comment              varchar(30),
    v_old_colname          varchar(30),
    v_new_colname          varchar(30),
    v_oldtabname           varchar(30),
    v_newtabname           varchar(30),
    v_col_upd              varchar(30),
    v_val_upd              varchar(500),
    v_where                varchar(500),
    v_default_val          varchar(30),
    v_token_num            integer,
    v_token_name           varchar(200),
    v_token_descr          varchar(200),
    v_entity_type          char(1),
    v_rows_inserted        integer,
    v_nb_board_usage_cols  varchar(50),
    v_nb_noticeboard_cols  varchar(300),
    v_nb_predefined_text_cols  varchar(100),
    v_pre_text_arr         array[11] of varchar(50),
    v_current_seq          integer,
    v_pre_text_ind         integer,
    v_field_id             integer,
    v_field_code           varchar(30)

  whenever error continue

  let v_status = 0

  call database_connect("energy")
  call warn_dev_about_P808_table_partitions();

  begin work

  display "\n-------------------------------------------------------------"
  display "----   Upgrading from PEACE Release ",get_baseline()
  display "----"
  display "----       BEGIN - Schema changes for P900-250"
  display "-------------------------------------------------------------"

  let v_schema = '"energydb".'

  if licensee("OE") then

    if v_status = 0 then
      let v_success = add_a_ff_field('Coordination Req', 2250)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('Coordinating Name', 2260)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('Coordinating Phone', 2270)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('MFN Supply Off', 5000)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('MFN Priority', 5010)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('Concurrent Supply Approved', 5010)
    end if

    if v_status = 0 then
      let v_success = update_a_ff_field('Metering Required')
    end if

    if v_status = 0 then
      let v_success = update_a_ff_field('Switching Service Required')
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('Metering Safety Certificate ID', 2280)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('MSC Method Sent', 2290)
    end if

    if v_status = 0 then
      let v_success = update_a_ff_field_priority('Registered Contractor ID', 2300)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('Registered Contractor Name', 2310)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('REC Business Name', 2320)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('REC Attendance Required', 2330)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('REC Phone', 2330)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('REC Form Reference', 2340)
    end if

    if v_status = 0 then
      let v_success = add_a_ff_field('REC Form Number', 2340)
    end if

  end if # en_licensee = "OE"

  #---------- Display outcome of job --------------------
  if v_status = 0 then
    commit work
    if v_success then
        display "\n- INFO : All processes completed successfully (and committed)."
    else
        display "\n- WARN : One or more processes reported non-fatal warnings (v_success=", v_success, "), work has been committed."
    end if
  else
    display "\n- WARN : rolling back work"
    rollback work
    display "\n- WARN : Processes failed, the status ",v_status, " exists."
  end if


  display "-------------------------------------------------------------"
  display "           END - Schema changes for P900-250"
  display "-------------------------------------------------------------"

end main

#----------------------------------------------------------------------#
function database_connect(pv_dbname)
#----------------------------------------------------------------------#
  define
    pv_dbname           varchar(128),
    v_oracle_user       varchar(128),
    v_encryptedfile     varchar(500),
    v_source            varchar(500),
    v_username          varchar(500),
    v_password          varchar(500),
    v_db_connection     varchar(1500),
    v_status            integer,
    v_schema_no         smallint,
    error_message       varchar(1500),
    v_lookup            array[6] of varchar(20),
    v_oracle_sid        varchar(500)

  let pv_dbname = pv_dbname clipped
  let v_status = 0
  let error_message = "database_connect('", pv_dbname, "').", "  FATAL ERROR -"
  let v_lookup[1] = "energy";
  let v_lookup[2] = "energytou";
  let v_lookup[3] = "aux_hist";
  let v_lookup[4] = "acct";
  let v_lookup[5] = "energysm";
  let v_lookup[6] = "aep_edi";


  database pv_dbname
  let v_status = status
  if v_status != 0 then
    let error_message = error_message clipped, " Failed to connect using $FGLPROFILE settings."
  end if

  if v_status = 0 then
    let v_oracle_user = null
    select user into v_oracle_user from dual
    let v_status = status
    if v_status != 0 then
      let error_message = error_message clipped,
        " Failed to select user from Oracle after $FGLPROFILE connection."
    end if
    if v_status = 0 and v_oracle_user = "ENERGYNULL" then

      call get_db_conn_info(pv_dbname) returning v_encryptedfile, v_username, v_password, v_source

      let v_db_connection = pv_dbname, "+source='", v_source,
        "',username='", v_username, "',password='", v_password, "'"
      database v_db_connection

      let v_status = status
      if v_status != 0 then
        let error_message = error_message clipped,
          " Unable to connect to user '", v_username,
          "' at source '", v_source, "'.",
          " Please check that the file '", v_encryptedfile,
          "' is set up correctly.",
          " Refer to setup_db_conn_info.sh -h for more information."
      end if
    end if
  end if
  if v_status <> 0 then
    let error_message = error_message clipped,
      " Cannot continue running."
    display error_message
    call fatal_error()
    exit program -1
  end if

end function

#----------------------------------------------------------------------#
function licensee(pv_licensee_code)
#----------------------------------------------------------------------#
# Determine if licensee code is valid
  define pv_licensee_code like en_licensee.licensee_code

  define v_count          smallint

  let v_count = 0

  select count(*) into v_count from en_licensee
   where licensee_code = pv_licensee_code
  let v_status = status
  if v_status <> 0 then
    display "* ERROR : Failed to select count from en_licensee"
    call fatal_error()
  end if

  return (v_count > 0)
end function

#----------------------------------------------------------------------#
function get_baseline()
#----------------------------------------------------------------------#
  define v_lic_ver like en_licensee.licensee_version

  select licensee_version into v_lic_ver from en_licensee
  let v_status = status
  if v_status <> 0 then
    display "* ERROR : Failed to select from en_licensee"
    call fatal_error()
  end if
  return v_lic_ver

end function

#----------------------------------------------------------------------#
function fatal_error()
#----------------------------------------------------------------------#
  define v_stmt      varchar(100),
         v_isam_err  integer,
         v_isam_char varchar(30);

  if sqlca.sqlerrd[2] < 0 then
    let v_isam_err = sqlca.sqlerrd[2]
    let v_isam_char = v_isam_err
    let v_stmt = "select concat('ORA-',lpad(replace('",v_isam_char,"','-',''),5,'0')) from dual"
    prepare sel_lpad from v_stmt
    execute sel_lpad into v_isam_char
    display ""
    display "#------------------------------------------------#"
    display "#-- Oracle Error: ",v_isam_char,"                    --#"
    display "#------------------------------------------------#"
  end if

  display ""
  display "#------------------------------------------------#"
  display "#--                                            --#"
  display "#--      A fatal error has occurred.           --#"
  display "#--           Status is ",v_status,"            --#"
  display "#--           Program stopping.                --#"
  display "#--                                            --#"
  display "#------------------------------------------------#"
  display ""

  exit program 1

end function

#----------------------------------------------------------------------#
function setup_account(pv_user)
#----------------------------------------------------------------------#
  define pv_user             varchar(200)

  define v_run_str           char(200)


  display "============================================================"
  display "Giving full access permissions to ",pv_user," user"
  display "============================================================"

  let v_run_str =  "$ENERGY/bin/sec_add_user_with_full_access ", pv_user
  run v_run_str

  let v_status = status
  case v_status
    when 0
      display "- INFO : Setup ", pv_user, " successfully "

    otherwise
      display "* ERROR ", v_status, " occurred while setup user ", pv_user
      call fatal_error()

   end case

end function

#----------------------------------------------------------------------#
function add_a_check_constraint(pv_tab_altered,
                                pv_constraint_name,
                                pv_constraint)
#----------------------------------------------------------------------#
  define pv_tab_altered     varchar(30),
         pv_constraint_name varchar(50),
         pv_constraint      varchar(1500)

  define v_stmt             varchar(1600),
         v_success          smallint

  let v_success = 0

  display "\nAdd check constraint on ",pv_tab_altered,", ",pv_constraint

  let v_stmt = "alter table ",pv_tab_altered," add constraint ",
               pv_constraint_name," check (",pv_constraint,")"

  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : table ",pv_tab_altered," altered successfully."
      let v_success = 1

    when -743
      display "- WARN : constraint name already exists on the table."
      let v_status = 0

    when -577
      display "- WARN : a constraint of the same type already exists on the column set."
      let v_status = 0

    when -625
      display "- WARN : a constraint of the same type already exists on the column set."
      let v_status = 0

    when -6372
      display "- WARN : this constraint already exists on ",pv_tab_altered
      let v_status = 0

    otherwise
      display "* ERROR ",v_status," occurred while altering table ",
              pv_tab_altered
      call fatal_error()

  end case
  return v_success
end function

#----------------------------------------------------------------------#
function add_a_foreign_key(pv_tab_child, pv_tab_referenced, pv_col_child,
                           pv_col_referenced, pv_constraint_name, pv_idxname, pv_unique)
#----------------------------------------------------------------------#
  define pv_tab_child      varchar(30),
         pv_tab_referenced varchar(30),
         pv_col_child      varchar(1000),
         pv_col_referenced varchar(500),
         pv_constraint_name varchar(30),
         pv_idxname        varchar(30),
         pv_unique         varchar(6)

  define v_stmt            varchar(4000),
         v_count           smallint,
         v_pk_name         varchar(30),
         v_cons_def        varchar(1000),
         v_exists          smallint,
         v_str_pos         smallint,
         v_length          smallint,
         fv_status         smallint,
         v_success         smallint

  let v_success = 0

  if pv_idxname is null then
    # Normally, index will share the name of the constraint, but there are a
    # few edge cases where they differ. The main one is where the foreign key
    # columns are also the primary key, because of a 1:1 relationship. In this
    # case, the primary key index should be used.
    let pv_idxname = pv_constraint_name
  end if

  display "\nAltering table ",pv_tab_child,",",
          " add foreign key ",pv_constraint_name," on ",pv_col_child

  let v_stmt = "alter table ",pv_tab_child,
               " add constraint ",pv_constraint_name,
               " foreign key (",pv_col_child,")",
               " references ",pv_tab_referenced,"(",pv_col_referenced,")"

  # Creates an index to be used as a foreign key
  let v_exists = create_an_index(pv_tab_child, pv_idxname, pv_unique, pv_col_child)

  # Check if constraint already exists
  let pv_col_child = canonicalize_index_definition(pv_col_child)
  let v_cons_def = get_constraint_definition(pv_tab_child, pv_constraint_name)
  if v_cons_def is not null then
    # Already exists
    if pv_col_child = v_cons_def then
      # Correct
      display "- INFO : foreign key ", pv_constraint_name, " already exists and is correct (", v_cons_def, ")"
      return 1 # Return success (rather than failure) as we have validated that the existing key is correct.
    else
      # Not correct!!!
      display "* ERROR : foreign key ", pv_constraint_name, " already exists with definition (",v_cons_def,") but should be (",upshift(pv_col_child),")"
      call fatal_error()
    end if
  end if

  # Doesn't exist, so create it
  if v_status = 0 or v_status = -350 then
    execute immediate v_stmt
    let fv_status = status
  else
    let fv_status = v_status
  end if

  if fv_status = -6372 then

    #check if parent record exists
    let v_count = -1
    let v_stmt = build_SQL(pv_tab_child, pv_tab_referenced,
                           pv_col_child, pv_col_referenced)
    prepare sel_csr from v_stmt
    execute sel_csr into v_count
    let v_status = status
    if v_status <> 0 then
      display "* ERROR : SQL failed when checking for parent/child records",
              " for Foreign Key ",v_status
      call fatal_error()
      #if the index was created for the FK (being here means the FK failed) then drop it
      if v_exists then
        let v_stmt = "drop index ", pv_idxname
        execute immediate v_stmt
        let v_status = status
        if v_status <> 0 then
          display "Failed to drop index ",pv_idxname
        end if
      end if
      call fatal_error()
    end if
    # v_count holds number of records that don't exist in parent table
    if v_count > 0 then
      let fv_status = -525
    else
      #check if the referenced column is a PK
      # v_count now holds number of columns that don't exist in primary key
      let v_count = -1
      let v_pk_name = get_primary_index_name(pv_tab_referenced)
      let pv_col_referenced = downshift(convert_col_str(pv_col_referenced))
      let v_stmt = "select count(column_name) from user_cons_columns",
        " where table_name = upper('",pv_tab_referenced,
        "') and constraint_name = upper('",v_pk_name,
        "') and lower(column_name) not in (",pv_col_referenced,")"
      prepare sel_count_s from v_stmt
      execute sel_count_s into v_count
      let v_status = status
      if v_status <> 0 then
        display "SQL failed in check if referenced column is part of primary key"
        return v_success
      end if

      #if a column is not in the PK or there is a mismatch of the number of columns
      #between child and parent table
      if v_count > 0 then
        let fv_status = -297
      end if
    end if

    #if the index was created for the FK (being here means the FK failed) then drop it
    if v_exists then
      let v_stmt = "drop index ", pv_idxname
      execute immediate v_stmt
      let v_status = status
      if v_status <> 0 then
        display "Failed to drop index ",pv_idxname
        call fatal_error()
      end if
    end if
  end if

  case fv_status
    when 0
      display "- INFO : table ",pv_tab_child," altered successfully"
      let v_success = 1

    when -6372
      display "* ERROR : Failed to create FK ", pv_constraint_name,"."
      display "          (possibly mismatch of datatypes for columns)"
      let v_status = fv_status
      call fatal_error()

    when -743
      display "- WARN : Foreign key constraint already exists on the table "
      let v_status = 0

    when -577
      display "* ERROR : a constraint of the same type already exists ",
              "on the column set ",pv_col_child," "
      let v_status = fv_status
      call fatal_error()

    when -625
      display "- WARN : constraint ",pv_constraint_name, " already exists "
      let v_status = 0

    when -525
      display "* ERROR : Failed to create foreign key ",pv_constraint_name,"."
      display "        - data in child table ",
        pv_tab_child," does not exist in parent table ",  pv_tab_referenced
      display "        - You may need to remove the orphaned data from ", pv_tab_child
      let v_status = fv_status
      call fatal_error()

    when -297
      display "* ERROR : Referenced column for FK is not part of complete Primary Key"
      let v_status = fv_status
      call fatal_error()

    when -350
      display "* ERROR : another index with the same column(s) already exists "
      call fatal_error()

    when -371
      display "* ERROR : the column(s) contains one or more duplicate rows"
      let v_status = fv_status
      call fatal_error()

    otherwise
      display "* ERROR ",fv_status," occurred while altering table ", pv_tab_child
      let v_status = fv_status
      call fatal_error()

  end case
  return v_success
end function

#----------------------------------------------------------------------#
function add_a_primary_key(pv_table, pv_column, pv_idxname)
#----------------------------------------------------------------------#

  define pv_table      varchar(30),
         pv_column     varchar(1000),
         pv_idxname    varchar(30)

  define v_count       integer,
         v_stmt        varchar(300),
         v_exists      smallint,
         v_success     smallint

  let v_success = 0

  # Creates a unique index to be used as a primary key
  let v_exists = create_an_index(pv_table, pv_idxname, "unique", pv_column)

  display "\nAltering table ",pv_table,", adding primary key ",pv_idxname

  let v_stmt = "alter table ", pv_table,
               " add constraint ", pv_idxname,
                " primary key (", pv_column, ")"

  if v_status = 0 then
    execute immediate v_stmt
    let v_status = status
  end if

  case v_status
    when 0
      display "- INFO : table ", pv_table, " altered successfully"
      let v_success = 1

    when -743
      let v_count = check_PK(pv_table, pv_column,pv_idxname, v_exists)
      if v_status <> 0 then
        call fatal_error()
      end if

    when -704
      let v_count = check_PK(pv_table, pv_column,pv_idxname, v_exists)
      if v_status <> 0 then
        call fatal_error()
      end if

    when -6372
      #get SQL statement to test for null values
      let v_stmt = build_SQL(pv_table,"",pv_column,"")

      prepare select_csr from v_stmt
      let v_status = status
      if v_status <> 0 then
        display "* ERROR : prepare statement for checking nulls in PK column(s)"
        call fatal_error()
      end if
      execute select_csr into v_count
      if v_status <> 0 then
        display "* ERROR : select statement for checking nulls in PK column(s)"
        call fatal_error()
      end if

      if v_count > 0 then
        display "* ERROR : data in column(s) used to create primary key contains null values"
        let v_status = -703
        call fatal_error()
      else
        display "Primary key already exists on the table "
        let v_count = check_PK(pv_table, pv_column, pv_idxname, v_exists)
        if v_status <> 0 then
          call fatal_error()
        end if
      end if

    when -703
      display "* ERROR : data in column used to create primary key contains null values"
      call fatal_error()

    otherwise
      display "* ERROR ", v_status, " occurred while altering table ",pv_table
      call fatal_error()

  end case
  return v_success
end function

#----------------------------------------------------------------------#
function build_SQL(pv_table,pv_table_ref,pv_column,pv_col_ref)
#----------------------------------------------------------------------#
# returns a built up a string to test for :
# PK - check for null values
# FK - check if parent record exists
  define
    pv_column      varchar(500),
    pv_col_ref     varchar(500),
    pv_table_ref   varchar(500),
    pv_table       varchar(30),
    pv_func        varchar(50),

    v_stmt         varchar(4000),
    v_str_pos      smallint,
    v_char_counter smallint,
    v_flag         smallint,
    v_length       smallint,
    v_col_string   varchar(500),
    v_fk_name      varchar(30),
    v_count        smallint,
    v_array        array[16,2] of varchar(31)

  if pv_table_ref is not null then   #when "FK"
    #first get columns for child table
    let v_str_pos = 1
    let v_char_counter = 1
    let v_flag = 1
    let v_length = length(pv_column)
    #iterate until comma
    while v_str_pos < v_length
      while pv_column[v_str_pos] <> ','
        #ignoring spaces
        if pv_column[v_str_pos] <> ' ' then
          #assign characters
          let v_col_string[v_char_counter] = pv_column[v_str_pos]
        end if
        #increment counters
        let v_str_pos = v_str_pos + 1
        let v_char_counter = v_char_counter + 1
      end while
      #increment for comma
      let v_str_pos = v_str_pos + 1

      #assign column name into the array
      let v_array[v_flag,1] = v_col_string clipped
      let v_col_string = null
      let v_char_counter = 1
      let v_flag = v_flag + 1
    end while
    #then get columns for referenced table
    let v_str_pos = 1
    let v_char_counter = 1
    let v_flag = 1
    let v_length = length(pv_col_ref)
    #iterate until comma
    while v_str_pos < v_length
      while pv_col_ref[v_str_pos] <> ','
        #ignoring spaces
        if pv_col_ref[v_str_pos] <> ' ' then
          #assign characters
          let v_col_string[v_char_counter] = pv_col_ref[v_str_pos]
        end if
        #increment counters
        let v_str_pos = v_str_pos + 1
        let v_char_counter = v_char_counter + 1
      end while
      #increment for comma
      let v_str_pos = v_str_pos + 1
      #assign column name into the array
      let v_array[v_flag,2] = v_col_string clipped
      let v_col_string = null
      let v_char_counter = 1
      let v_flag = v_flag + 1
    end while
    let v_str_pos = 1
    let v_stmt = "select count( distinct("
    for v_str_pos = 1 to v_flag - 1
      if v_str_pos > 1 then
        let v_stmt = v_stmt,")) + count( distinct("
      end if
      let v_stmt = v_stmt,v_array[v_str_pos,1]
    end for
    let v_str_pos = 1
    let v_stmt = v_stmt,")) from ",pv_table," where ",
      v_array[v_str_pos,1]," not in ", "(select distinct(",v_array[v_str_pos,2],")",
      " from ",pv_table_ref,") "
    let v_str_pos = v_str_pos + 1
    while v_array[v_str_pos,1] is not null
      let v_stmt = v_stmt," or ",v_array[v_str_pos,1]," not in (select distinct(",
        v_array[v_str_pos,2], ") from ",pv_table_ref,")"
      let v_str_pos = v_str_pos + 1
    end while

  else #when PK
    let v_stmt = "select count(*) from ",pv_table," where "
    let v_str_pos = 1
    let v_char_counter = 1
    let v_flag = 0
    let v_length = length(pv_column)

    while v_str_pos < v_length
      while v_str_pos <= v_length
		# Can't test for this in the 'while' condition, as
		# 4gl/Genero doesn't do lazy-evaluation of expressions.
        if pv_column[v_str_pos] = ',' then
          exit while
        end if
        if pv_column[v_str_pos] <> ' ' then
          let v_col_string[v_char_counter] = pv_column[v_str_pos]
          let v_char_counter = v_char_counter + 1
        end if
        let v_str_pos = v_str_pos + 1
      end while
      if v_flag > 0 then
        let v_stmt = v_stmt," or "
      end if
      let v_stmt = v_stmt, v_col_string," is null "
      let v_str_pos = v_str_pos + 1
      let v_col_string = null
      let v_char_counter = 1
      let v_flag = v_flag + 1
    end while
  end if
  return v_stmt

end function

#-------------------------------------------------
function build_col_str(pv_table)
#-------------------------------------------------
# fetches the columns for the PK and return this as a columns in quotes string
  define pv_table    varchar(30),
         v_col_rec   varchar(200),
         v_col_str   varchar(200),
         v_counter   smallint,
         v_char      char(1),
         v_part      varchar(6),
         v_stmt      varchar(500),
         v_tab_id    integer

  let v_col_str = "temp_value"
  let v_counter = 1

  select tabid into v_tab_id from systables where tabname = lower(pv_table)

  while v_col_str is not null

    let v_char = v_counter
    let v_part = "part",v_char
    let v_stmt =
      "select colname from syscolumns where tabid = ",v_tab_id,
      " and colno = ",
        " (select ",v_part," from sysindexes",
         " where idxname = ",
         " (select trim(lower(idxname))",
           " from sysconstraints",
           " where constrtype = 'P'",
           " and tabid = ",v_tab_id,"))"

    prepare sel_con_str from v_stmt
    let v_status = status
    if v_status = 0 then
      execute sel_con_str into v_col_str
      let v_status = status
    end if

    case v_status
      when 0
        if v_counter > 1 then
          let v_col_rec = v_col_rec,","
        end if
        let v_col_rec = v_col_rec clipped, v_col_str
        let v_counter = v_counter + 1

      when 100
        let v_col_str = null

      otherwise
        call fatal_error()
    end case

  end while

  return convert_col_str(v_col_rec)
end function

#----------------------------------------------------------------------#
function check_PK(pv_table, pv_col_str, pv_idxname, pv_exists)
#----------------------------------------------------------------------#
# compares actual columns in PK with those passed in as parameters
  define pv_table      varchar(30),
         pv_idxname    varchar(30),
         pv_col_str    varchar(200),
         pv_exists     smallint,
         v_idx_name    varchar(30),
         v_stmt        varchar(500),
         v_col_stmt    varchar(500),
         v_col_stmt_db varchar(500),
         v_count       smallint,
         v_same_idx    smallint,
         v_index       varchar(30),
         v_column      varchar(200)

  let v_same_idx = 0
  call downshift(convert_col_str(pv_col_str)) returning v_col_stmt
  let v_index = get_primary_index_name(pv_table)
  if  downshift(v_index) = downshift(pv_idxname) then
    let v_same_idx = 1
  end if

  let v_stmt =
      "select lower(column_name) from user_cons_columns",
        " where table_name = upper('",pv_table,"')",
        " and lower(constraint_name) = '",v_index,"'",
        " and lower(column_name) not in (",v_col_stmt,")"

  prepare sel_PK_col_s from v_stmt
  let v_status = status
  if v_status <> 0 then
    display "* ERROR occurred preparing statement sel_PK_col_s"
    call fatal_error()
  end if
  declare sel_PK_col_c cursor for sel_PK_col_s
  if v_status <> 0 then
    display "* ERROR occurred declaring cursor sel_PK_col_c"
    call fatal_error()
  end if

  let v_count = 0
  foreach sel_PK_col_c
    let v_count = v_count + 1
  end foreach

 #------------------------------------------------------------------------------
  if v_same_idx then
    if v_count > 0 then
      display "* ERROR : PK already exists with same name but different column(s)"
      let v_status = -743
    else
      display "- INFO : PK already exists with same name and same column(s)"
      let v_status = 0
    end if
  else
    if v_count > 0 then
      display "* ERROR : PK already exists with different name and different column(s)"
      let v_status = -743
      if pv_exists then
        let v_stmt = "drop index ", pv_idxname
        execute immediate v_stmt
        let v_status = status
        if v_status <> 0 then
          display "Failed to drop index ",pv_idxname
          call fatal_error()
        end if
      end if
    else
      display "* ERROR : PK already exists with different name and same column(s)"
      let v_status = -743
    end if
  end if

  return v_count
end function

#----------------------------------------------------------------------#
function count_columns_in_string(pv_column_string)
#----------------------------------------------------------------------#
# counts number of commas contained in the column string + 1
  define pv_column_string  varchar(300),
         v_str_pos         smallint,
         v_col_count       smallint,
         v_length          smallint

      let v_col_count = 1
      let v_length = length(pv_column_string)
      for v_str_pos = 1 to v_length
        if pv_column_string[v_str_pos] = ',' then
          let v_col_count = v_col_count + 1
        end if
      end for
  return v_col_count
end function

#----------------------------------------------------------------------#
function convert_col_str(pv_column)
#----------------------------------------------------------------------#
# converts a comma separated string to columns in quotes
  define pv_column       varchar(200),
         v_str_pos       smallint,
         v_char_counter  smallint,
         v_length        smallint,
         v_col_string    varchar(200)

  let v_str_pos = 1
  let v_char_counter = 2
  let v_length = length(pv_column)

  let v_col_string = "'"

  while v_str_pos < v_length
    while v_str_pos <= v_length
      # Can't test for this in the 'while' condition, as
      # 4gl/Genero doesn't do lazy-evaluation of expressions.
      if pv_column[v_str_pos] = ',' then
        exit while
      end if
      if pv_column[v_str_pos] <> ' ' then
        let v_col_string[v_char_counter] = pv_column[v_str_pos]
        let v_char_counter = v_char_counter + 1
      end if
      let v_str_pos = v_str_pos + 1
    end while
    if v_str_pos <> v_length and v_str_pos <> (v_length+1) then
      let v_col_string = v_col_string,"','"
      let v_char_counter = v_char_counter + 3
      let v_str_pos = v_str_pos + 1
    end if
  end while
  let v_col_string =v_col_string, "'"

  return v_col_string
end function

#----------------------------------------------------------------------#
function get_primary_index_name(pv_table)
#----------------------------------------------------------------------#
  define pv_table      varchar(30),
         pv_constrtype char(1)

  define v_stmt        varchar(1000),
         v_index_name  varchar(30)

  display "         Retrieving primary index name for ",pv_table

  let v_stmt = "select trim(lower(index_name))",
               "  from user_indexes",
               " where table_name = upper('",pv_table clipped,"')",
               "   and uniqueness = 'UNIQUE'",
               "   and index_name like '%IDX1'"

  prepare idx_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute idx_csr into v_index_name
    let v_status = status
  end if

  case v_status
    when 0
      # Do nothing.
    when 100
      display "- WARN : Primary unique index  does NOT exist on ",pv_table
      let v_status = 0
      let v_index_name = null
    otherwise
      display "* ERROR ", v_status, " occurred while retrieving",
              " an index name for ",pv_table
      call fatal_error()
  end case

  return v_index_name
end function

#----------------------------------------------------------------------#
function add_a_column_with_default(pv_table, pv_column, pv_datatype,
                                   pv_default_val)
#----------------------------------------------------------------------#
#NOTE: this function simply appends a new column to the end of a table.
  define pv_table       varchar(30),
         pv_column      varchar(30),
         pv_datatype    varchar(50),
         pv_default_val varchar(30)

  define v_stmt         varchar(250),
         v_success      smallint

  let v_success = 0

  display "\nAltering table ",pv_table,", adding column ",pv_column

  if check_column_exists(pv_table, pv_column) then
    display "- WARN : column ",pv_column," already exists"
    return v_success
  end if

  # Alter a table
  let v_stmt = "alter table ",pv_table,
    " add(",pv_column," ",pv_datatype," default ",pv_default_val," not null)"

  execute immediate v_stmt
  let v_status = status

  # Check the status of the job.
  if v_status = 0 then
    display "- INFO : column added successfully."
    let v_success = 1
  else
    display "* ERROR: ",v_status," occurred while adding column ",
            pv_column," to ",pv_table
    call fatal_error()
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function add_null_column(pv_table, pv_column, pv_datatype)
#----------------------------------------------------------------------#
#NOTE: this function simply appends a new column to the end of a table.
#NOTE2: It can be used only for adding "NULLABLE" columns.
  define pv_table       varchar(30),
         pv_column      varchar(30),
         pv_datatype    varchar(50)

  define v_stmt         varchar(250),
         v_success      smallint

  let v_success = 0

  display "\nAltering table ",pv_table,", adding column ",pv_column

  if check_column_exists(pv_table, pv_column) then
    display "- WARN : column already exists"
    return v_success
  end if

  # Alter a table
  let v_stmt = "alter table ",pv_table," add (",pv_column," ",pv_datatype,")"

  execute immediate v_stmt
  let v_status = status

  # Check the status of the job.
  if v_status = 0 then
    display "- INFO : column added successfully."
    let v_success = 1
  else
    display "* ERROR ",v_status," occurred while adding column ",
            pv_column," to ",pv_table
    call fatal_error()
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function already_not_null(pv_table, pv_column)
#----------------------------------------------------------------------#
# Returns true/false depending on whether a column is not null.
  define  pv_table      varchar(30),
          pv_column     varchar(30)

  define  v_count       integer,
          v_stmt        varchar(300)

  let v_stmt = "select count(*)",
               " from user_tab_columns",
               " where table_name = upper('",pv_table,"')",
               " and   column_name = upper('",pv_column,"')",
               " and   nullable = 'N'"

  prepare nn_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute nn_csr into v_count
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while checking ",
            pv_table,", column ",pv_column
    call fatal_error()
  end if

  return (v_count > 0)
end function

# ----------------------------------------------------------------------#
function alter_column_to_notnull (pv_table, pv_column)
# ----------------------------------------------------------------------#
# redefine a column as "Not Null"
# Note: To avoid a -530 error, first update rows containing null values to
# valid values
  define pv_table      varchar(30),
         pv_column     varchar(30),
         pv_datatype   varchar(50)

  define v_stmt        varchar(500),
         v_success     smallint

  let v_success = 0

  display "\nAltering table ",pv_table,", modifying column ",pv_column,
          " to Not Null"

  if not check_column_exists(pv_table, pv_column) then
    display "* ERROR: column ",pv_column," to be altered does not exist"
    call fatal_error()
  end if

  if already_not_null(pv_table, pv_column) then
    display "- WARN : column ",pv_column," is already Not Null"
    return 1
  end if

  if check_null_values(pv_table,pv_column) then
    display "* ERROR : Null values exist in ",pv_table,".",pv_column
    display "          Cannot convert to not null !"
    let v_status = -530
    call fatal_error()
  end if

  let v_stmt = "alter table ",pv_table,
               " modify ( ",pv_column," not null)"

  execute immediate v_stmt
  let v_status = status

  if v_status = 0 then
    display "- INFO : column ",pv_column," altered successfully."
    let v_success = 1
  else
    display "* ERROR: failed to alter column ",pv_column,
            ", status ",v_status
    call fatal_error()
  end if
  return v_success
end function

# --------------------------------------------------------------------#
function alter_column_to_null (pv_table, pv_column)
# --------------------------------------------------------------------#
# redefine a column as "Nulls Allowed"
  define pv_table      varchar(30),
         pv_column     varchar(30),
         pv_datatype   varchar(50)

  define v_stmt        varchar(500),
         v_consname    varchar(30),
         v_success     smallint

  let v_success = 0

  display "\nAltering table ",pv_table,", modifying column ",pv_column,
          " to Null Allowed"

  if not check_column_exists(pv_table, pv_column) then
    display "* ERROR: column ",pv_column," to be altered does not exist"
    call fatal_error()
  end if

  if not already_not_null(pv_table, pv_column) then
    display "- WARN : column ",pv_column," is already Null"
    return 1
  end if

  # Note: the following method is not foolproof
  select a.constraint_name into v_consname
    from user_constraints a, user_cons_columns b
   where a.constraint_name = b.constraint_name
     and a.table_name = upper(pv_table)
     and a.constraint_type = 'C'
     and b.column_name = upper(pv_column)
  let v_status = status

  if v_status = 0 then
    let v_stmt = "alter table ",pv_table,
                 " drop constraint ",v_consname
    execute immediate v_stmt
    let v_status = status
  end if

  if v_status = 0 then
    display "- INFO : column ",pv_column," altered successfully."
    let v_success = 1
  else
    display "* ERROR: failed to alter column ",pv_column,
            ", status ",v_status
    call fatal_error()
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function check_col_attr(pv_table, pv_column)
#----------------------------------------------------------------------#
  define  pv_table      varchar(30),
          pv_column     varchar(30)

  define  v_collength  integer,
          v_length     integer,
          v_scale      integer,
          v_col_code   integer,
          v_col_type   varchar(30),
          v_stmt       varchar(300)

  let v_stmt = "select data_type, data_length, data_precision, data_scale",
               " from user_tab_columns",
               " where table_name = upper('",pv_table,"')",
               "   and column_name = upper('",pv_column,"')"

  prepare col_attr_csr from v_stmt
  execute col_attr_csr into v_col_type, v_collength, v_length, v_scale
  let v_status = status

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while checking ",
            pv_table,", column ",pv_column
    call fatal_error()
  end if

  if v_collength is null then
    let v_collength = 0
  end if

  if v_length is null then
    let v_length = 0
  end if

  if v_scale is null then
    let v_scale = 0
  end if

  return v_col_type, v_collength, v_length, v_scale

end function

#----------------------------------------------------------------------#
function check_column_exists(pv_table, pv_column)
#----------------------------------------------------------------------#
# Returns true/false depending on whether a column exists.
  define pv_table    varchar(30),
         pv_column   varchar(30)

  define v_stmt     varchar(500),
         v_count    integer

  let v_stmt = "select count(*)",
               " from user_tab_columns",
               " where table_name = upper('",pv_table,"')",
               " and column_name = upper('",pv_column,"')"

  prepare col_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute col_csr into v_count
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while checking for",
            " existence of column in ",pv_table
    call fatal_error()
  end if

  return (v_count > 0)

end function

#----------------------------------------------------------------------#
function check_column_no(pv_table, pv_column)
#----------------------------------------------------------------------#
# Returns column_id/colno of a column.
  define pv_table    varchar(30),
         pv_column   varchar(30)

  define v_stmt      varchar(500),
         v_col_no    integer

  let v_stmt = "select column_id",
               " from user_tab_columns",
               " where table_name = upper('",pv_table,"')",
               " and column_name = upper('",pv_column,"')"

  prepare colno_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute colno_csr into v_col_no
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while checking for",
            " existence of column in ",pv_table
    call fatal_error()
  end if

  return v_col_no

end function

#----------------------------------------------#
function check_null_values(pv_table,pv_column)
#----------------------------------------------#
# Checking nulls in column
  define pv_table      varchar(30),
         pv_column     varchar(30),
         pv_datatype   varchar(50),
         pv_nullable   varchar(8)

  define v_stmt        varchar(100),
         v_count       integer

  let v_count = 0

  display "Checking for null values in column ",pv_column," in table ",pv_table

  let v_stmt = "select count(*) from ",pv_table,
               " where ",pv_column," is null"

  prepare col_val from v_stmt
  let v_status = status
  if v_status = 0 then
    execute col_val into v_count
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while checking for",
            " null values in column ",pv_column," table ",pv_table
    call fatal_error()
  end if

  if v_count > 0 then
    display "- WARN : There are NULL VALUES in column ",pv_column
  else
    display "- INFO : no null values found in column ",pv_column
  end if

  return v_count

end function

#--------------------------------------------------------------------#
function check_procedure_exists(pv_procedure)
#--------------------------------------------------------------------#
# Returns true/false depending on whether a procedure exists.
  define pv_procedure   varchar(30)

  define v_count        integer,
         v_stmt         varchar(500)

  let v_stmt = "select count(*)",
               "  from user_objects",
               " where object_name = upper('",pv_procedure clipped,"')"

  prepare chk_prc_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute chk_prc_csr into v_count
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while checking for",
            " existence of ",pv_procedure
    call fatal_error()
  end if

  return (v_count > 0)

end function

#----------------------------------------------------------------------#
function check_table_exists(pv_table)
#----------------------------------------------------------------------#
# Returns true/false depending on whether a table exists.
  define pv_table   varchar(30)

  define v_count    integer,
         v_stmt     varchar(500)

  let v_stmt = "select count(*)",
               " from user_tables",
               " where table_name = upper('",pv_table clipped,"')"

  prepare chk_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute chk_csr into v_count
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while checking for",
            " existence of ",pv_table
    call fatal_error()
  end if

  return (v_count > 0)

end function

#----------------------------------------------------------------------
function convert_date(pv_date)
#----------------------------------------------------------------------
# Converts the date to a string in the format used by the currently
# connected database. This function should be used when a SQL statement
# is constructed using the date as a literal.
  define pv_date date

  define v_date_str char(35)

  # Set the default date string format.
  let v_date_str = "'",pv_date,"'"

  # Determine the correct format based on the database type.
  # The Oracle-specific SQL function to_date() is used.
  let v_date_str = "to_date('",pv_date,"','",
                     get_date_format() clipped,"')"

  return v_date_str

end function

#----------------------------------------------------------------------#
function create_an_index(pv_table, pv_index, pv_unique, pv_col_str)
#----------------------------------------------------------------------#
  define pv_table       varchar(30),
         pv_index       varchar(30),
         pv_unique      varchar(6),
         pv_col_str     varchar(200)

  define v_btree        varchar(20),
         v_stmt         varchar(500),
         v_count        integer,
         v_ret_val      smallint,
         v_index_def    varchar(1000),
         v_col_str      varchar(200)

  # Ensure the passed-in column string is consistently formatted
  let v_col_str = canonicalize_index_definition(pv_col_str)

  display "Creating index ",pv_index," on table ",pv_table," for (",v_col_str, ")"

  let v_count = 0

  select count(*) into v_count from user_indexes
    where index_name = upper(pv_index)

  if v_count > 0 then
    # Index of this name already exists; does it match?
    let v_index_def = get_index_definition(pv_table, pv_index)
    if v_index_def == upshift(v_col_str) then
      # If it matches, fine - nothing to do.
      display "- INFO : index ", pv_index," already exists and is correct (", v_index_def, ")"
      return 1 # Return success (rather than failure) as we have validated that the existing index is correct.
    else
      # If not a match, abort - existing index should be dropped first if we're changing it.
      display "* ERROR : index ", pv_index, " already exists with definition (",v_index_def,") but should be (",upshift(v_col_str),")"
      call fatal_error()
    end if
  end if

  let v_btree = ""

  let v_stmt = "create ",pv_unique," index ",v_owner,pv_index,
               " on ",pv_table," (", v_col_str, ") ",v_btree

  execute immediate v_stmt
  let v_status = status
  case v_status
    when 0
      display "- INFO : index ", pv_index, " created successfully"
      let v_ret_val = 1

    when -350
      display "* ERROR : another index with the same column(s) already exists "
      call fatal_error()

    when -371
      display "* ERROR : there are duplicate values in column(s) ", v_col_str
      call fatal_error()

    otherwise
      display "* ERROR: ", v_status, " creating index ", pv_index
      call fatal_error()
  end case

  return v_ret_val
end function

#--------------------------------------------------------#
function canonicalize_index_definition(pv_col_str)
#--------------------------------------------------------#
  define
    pv_col_str varchar(1000),
    v_col_str  varchar(1000),
    v_count    integer

  # Process the passed-in column string for consistent formatting (separated by comma+space, not just comma)
  let v_col_str = ''
  for v_count = 1 to length(pv_col_str)

    # Remove unnecessary spaces
    if pv_col_str[v_count] == ' ' and v_count < length(pv_col_str) then
      # Double-if statement is to ensure we only do the lookahead if we're not at the
      # end of the string, as reading beyond end of string breaks on HP. Can't do all
      # the checks in one line, because 4gl apparently doesn't lazy-evaluate expressions.
      if pv_col_str[v_count+1] == ' ' or pv_col_str[v_count+1] == ',' then
        continue for
      end if
    end if
    # Append a space afer comma if not already present
    if pv_col_str[v_count] == ',' and v_count < length(pv_col_str) then
      # Double-if, for same reason as above.
      if pv_col_str[v_count+1] != ' ' then
        let v_col_str = v_col_str, ", "
        continue for
      end if
    end if

    # Otherwise just append the character
    if v_col_str is null then
      let v_col_str = pv_col_str[v_count]
    else
      let v_col_str = v_col_str || pv_col_str[v_count]
    end if
  end for

  return v_col_str
end function

#--------------------------------------------------------#
function create_a_synonym(pv_table, pv_db_name, pv_owner)
#--------------------------------------------------------#
  define pv_table    varchar(30),
         pv_db_name  varchar(30),
         pv_owner    varchar(30)

  define v_count     smallint,
         v_stmt      varchar(500),
         v_success   smallint

  let v_success = 0

  display "\nCreate synonym for table ",pv_table

  select count(*) into v_count
    from all_synonyms
   where table_name = upper(pv_table)
  let v_status = status

  if v_status <> 0 then
    display "* ERROR: ",v_status," Failed to select synonym info."
    call fatal_error()
  end if

  case
    when v_count > 0
      display "- WARN : Synonym ",pv_table," already exists"
      let v_success = 1

    when v_count = 0
      let v_stmt = "create synonym ",pv_table," for ",pv_owner,".",
                 pv_table clipped

      prepare tab_syn from v_stmt
      let v_status = status
      if v_status = 0 then
        execute tab_syn
        let v_status = status
      end if

      if v_status = 0 then
        display "- INFO : Synonym ",pv_table," created successfully."
        let v_success = 1
      else
        display "* ERROR: ",v_status," Failed to create synonym ",pv_table,"."
        call fatal_error()
      end if
  end case
  return v_success
end function

#----------------------------------------------------------------------#
function create_a_table(pv_table)
#----------------------------------------------------------------------#
  define pv_table     varchar(30)

  define v_stmt       varchar(4000),
         v_success    smallint

  let v_success = 0

  display "\nCreating table ", pv_table

  if check_table_exists(pv_table) then
    display "- WARN : table ",pv_table," already exists"
    return 1
  end if

  let v_stmt = get_table_def_string(pv_table)
  if v_stmt = "" then
    display "* ERROR: no definition found for table ", pv_table
    let v_status = -9999
    call fatal_error()
  end if

  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : table ", pv_table, ", created successfully"
      let v_success = 1
      if not grant_privileges(pv_table) then
        display "- WARN : created table successfully but failed to grant privileges on ",pv_table
      end if

    otherwise
      display "* ERROR: ", v_status, ", creating table ", pv_table
      call fatal_error()
  end case
  return v_success
end function

#----------------------------------------------------------------------#
function get_table_def_string(pv_table)
#----------------------------------------------------------------------#
  define pv_table varchar(30),
         v_stmt   varchar(4000)

  let v_stmt = "create table ", pv_table, " ("

  case pv_table

  when ""
    let v_stmt = NULL
  otherwise
    let v_stmt = NULL
  end case

  let v_stmt = v_stmt, ")"

  return v_stmt

end function

#----------------------------------------------------------------------#
function set_comments(pv_table, pv_column, pv_comment)
#----------------------------------------------------------------------#
#  Important Note - For Oracle Only
#  Comments will be needed if the table has any of the following datatypes -
#  Integer,Serial,Interval,Float,SmallFloat,Date,Datetime
#  For Text/Clob columns modify $ENERGY/tools/etc/TABLENAME.sch
#-----------------------------------------------------------------------#

  define pv_table    varchar(30),
         pv_column   varchar(30),
         pv_comment  varchar(30);

  define v_stmt      varchar(500),
         v_success   smallint

  let v_success = 0
  let v_stmt = "comment on column ",pv_table,".",pv_column," is 'IFX:",pv_comment,"'"
  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      let v_success = 1

    otherwise
      display "* ERROR: ",v_status," Failed to set comment on column ",pv_table,
              ".",pv_column,"."
      call fatal_error()
  end case

  return v_success
end function

#----------------------------------------------------------------------#
function delete_a_row(pv_table, pv_where_conditions_str)
#----------------------------------------------------------------------#
  define pv_table                varchar(30),
         pv_where_conditions_str varchar(1000)

  define v_stmt                  varchar(1200),
         v_success               smallint

  display "\nDeleting from ",pv_table
  let v_success = 0
  let v_stmt = "delete from ",pv_table,
               " where ",pv_where_conditions_str
  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : ",sqlca.sqlerrd[3]," row(s) deleted."
      let v_success = 1

    when 100
      display "- WARN : Row(s) do not exist."

    otherwise
      call fatal_error()
  end case

  return v_success
end function

#---------------------------------------------------------#
function delete_stop_rule(pv_del_rule_id,pv_read_status_type)
#---------------------------------------------------------#
  define pv_del_rule_id     like b_stop_rule.rule_id,
         pv_read_status_type like b_stop_rule.read_status_type,
         v_count            integer,
         v_exist            integer,
         v_table            varchar(30),
         v_stmt             varchar(500),
         v_rule_type        char(1),
         v_del_rule_seq     like b_stop_rule.rule_seq,
         v_bas_rule_seq     like bas_rule.bas_rule_seq,
         v_rule_id          like bas_rule.rule_id,
         v_success          smallint,
         v_read_status_type char(1),
         rule_rec record    like b_stop_rule.*;

  display "\nDeleting stop rule ",pv_del_rule_id
  let v_table = "b_stop_rule"
  let v_count = 0
  let v_success = 0

  # Identify the stop rule type - an A rule or S rule?
  let v_stmt = "select substr('",pv_del_rule_id,"', 0, 1) from en_licensee"

  prepare rule_type_s from v_stmt
  let v_status = status

  if v_status = 0 then
    execute rule_type_s into v_rule_type
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR: ",v_status," Failed to identify the rule type."
    call fatal_error()
  end if

  # Check if rule exists
  select count(*) into v_count
    from b_stop_rule
   where rule_id = pv_del_rule_id
  let v_status = status

  if v_status <> 0 then
    display "* ERROR: ",v_status," Failed to select count(*) from b_stop_rule."
    call fatal_error()
  end if


  if v_rule_type = "S" then

    if v_count = 0 then
      display "- WARN : Rule ",pv_del_rule_id," to be deleted does not exist."
    else

      begin work

      # Get rule sequence for an S rule
      select rule_seq into v_del_rule_seq
        from b_stop_rule
       where rule_id = pv_del_rule_id
      let v_status = status

      if v_status <> 0 then
        display "* ERROR: ",v_status," Failed to select rule_seq of ",pv_del_rule_id,"."
        call fatal_error()
      end if

      # Delete an S rule from b_stop_rule
      if v_status = 0 then

        delete from b_stop_rule
          where rule_id = pv_del_rule_id
        let v_status = status

        case v_status
          when 0
            display "- INFO : Rule ",pv_del_rule_id," deleted successfully ",
                    "from table ",v_table,"."
            display "**  Remember to remove the blocker rules.  **"
            let v_success = 1

          when  -746
            rollback work
            display "* WARN: ",v_status," Unable to delete ",pv_del_rule_id," from ",v_table,
                    "- Rollback all Unprocessed readings first."
            call fatal_error()

          otherwise
            rollback work
            display "* ERROR: ",v_status," Rollback all processes."
            call fatal_error()
        end case
      end if

      display "rule_seq greater than or equal to ",v_del_rule_seq,
              " will be updated"

      declare cur_del_rule_seq_c cursor with hold for
        select rule_id from b_stop_rule
         where rule_id like 'S%'
           and read_status_type = pv_read_status_type
      let v_status = status
      if v_status <> 0 then
        display "* ERROR : declare cursor cur_del_rule_seq_c failed"
        call fatal_error()
      end if

      foreach cur_del_rule_seq_c into rule_rec.*
        update b_stop_rule set rule_seq = rule_seq - 1
         where rule_seq > v_del_rule_seq
           and rule_id = rule_rec.rule_id
        let v_status = status

        if v_status <> 0 then
          rollback work
          display "* ERROR: ",v_status," Failed to adjust rule sequences."
          call fatal_error()
        end if
      end foreach

      if v_status = 0 then
        display "- INFO : Rule sequences successfully adjusted."
        let v_success = 1
      end if

      commit work

    end if
  else # A rules

    # Check if the A rule exists in bas_rule.
    # If the rule is enabled, it should exist in bas_rule.
    # If the rule is disabled, it should not exist in bas_rule.
    select count(*) into v_exist
      from bas_rule
     where rule_id = pv_del_rule_id
    let v_status = status

    if v_status <> 0 then
      display "* ERROR: ",v_status," Failed to select count(*) from bas_rule."
      call fatal_error()
    end if


    if v_exist = 0 then # A rule not in bas_rule

      display "- INFO : Rule ",pv_del_rule_id," to be deleted does not exist in bas_rule."

      if v_count = 0 then # A rule not in b_stop_rule
        display "- INFO : Rule ",pv_del_rule_id," to be deleted does not exist in b_stop_rule."
      else # A rule exists in b_stop_rule
        if v_status = 0 then
          let v_success = disable_triggers(v_table)
        end if

        begin work

        delete from b_stop_rule
          where rule_id = pv_del_rule_id
        let v_status = status

        case v_status
          when 0
            display "- INFO : Rule ",pv_del_rule_id," deleted successfully ",
                    "from table ",v_table,"."
            display "**  Remember to remove the blocker rules.  **"
            let v_success = 1

          otherwise
            rollback work
            display "* ERROR: ",v_status," Rollback all processes."
            call fatal_error()
        end case

        commit work

        if v_status = 0 then
          let v_success = enable_triggers(v_table)
        end if

      end if
    else # A rule exists in bas_rule
      if v_count = 0 then # A rule not in b_stop_rule
        # This case shouldn't occur.
        display "- WARN: Please investigate why ",pv_del_rule_id," exists in bas_rule ",
                " while it does not exist in b_stop_rule."
      else # A rule exists in b_stop_rule

        {
        select b_stop_rule.read_status_type,
               bas_rule.rule_id,
               bas_rule.bas_rule_seq
          from bas_rule, b_stop_rule
         where bas_rule.rule_id = b_stop_rule.rule_id
         order by 1, 3
        }

        begin work

        # select read_status_type and bas_rule_seq
        select a.read_status_type, b.bas_rule_seq
          into v_read_status_type, v_bas_rule_seq
          from b_stop_rule a, bas_rule b
         where a.rule_id = b.rule_id
           and b.rule_id = pv_del_rule_id
        let v_status = status

        if v_status <> 0 then
          display "* ERROR: ",v_status," Failed to select from b_stop_rule and bas_rule."
          call fatal_error()
        end if

        display "bas_rule_seq greater than or equal to ",v_bas_rule_seq,
                " will be updated"

        declare cur_bas_rule_seq_c cursor with hold for

          select bas_rule.rule_id
            from bas_rule, b_stop_rule
           where bas_rule.rule_id = b_stop_rule.rule_id
             and bas_rule.rule_id != pv_del_rule_id
             and bas_rule.bas_rule_seq > v_bas_rule_seq
             and b_stop_rule.read_status_type = v_read_status_type

        let v_status = status
        if v_status <> 0 then
          display "* ERROR : declare cursor cur_bas_rule_seq_c failed"
          call fatal_error()
        end if

        # Delete rule
        if v_status = 0 then

          # Delete from b_stop_rule
          delete from b_stop_rule
            where rule_id = pv_del_rule_id
          let v_status = status

          case v_status
            when 0
              display "- INFO : Rule ",pv_del_rule_id," deleted successfully ",
                      "from table ",v_table,"."
              display "**  Remember to remove the blocker rules.  **"
              let v_success = 1

            when  -746
              rollback work
              display "* WARN: ",v_status," Unable to delete ",pv_del_rule_id," from ",v_table,
                      "- Rollback all Unprocessed readings first."
              call fatal_error()

            otherwise
              rollback work
              display "* ERROR: ",v_status," Rollback all processes."
              call fatal_error()
          end case
        end if

        # Delete from bas_rule
        delete from bas_rule
          where rule_id = pv_del_rule_id
        let v_status = status

        case v_status
          when 0
            display "- INFO : Rule ",pv_del_rule_id," deleted successfully ",
                    "from table bas_rule."
            let v_success = 1

          otherwise
            rollback work
            display "* ERROR: ",v_status," Rollback all processes."
            call fatal_error()
        end case

        display "rule_seq greater than or equal to ",v_bas_rule_seq,
                " will be updated"

        foreach cur_bas_rule_seq_c into v_rule_id
          update bas_rule set bas_rule_seq = bas_rule_seq - 1
           where rule_id = v_rule_id
          let v_status = status

          if v_status <> 0 then
            rollback work
            display "* ERROR: ",v_status," Failed to adjust rule sequences."
            call fatal_error()
          end if
        end foreach

        if v_status = 0 then
          display "- INFO : Rule sequences successfully adjusted."
          let v_success = 1
        end if

        commit work

      end if
    end if
  end if

  return v_success

end function

#------------------------------------------------------#
function delete_en_config(pv_config_name)
#------------------------------------------------------#
  define  pv_config_name like en_config.config_name,
          v_success      smallint

  let v_success = 0
  display "\nConfiguration change !"
  display " Deleting ",pv_config_name clipped ," from en_config."

  if not exist_config(pv_config_name) then
    display "- WARN : ",pv_config_name clipped ," does not exist."
  else
    begin work
    delete from en_config where lower(config_name) = pv_config_name
    let v_status = status
    if v_status = 0 then
      display "- INFO : ",pv_config_name clipped," was successfully deleted."
      let v_success = 1
      commit work
    else
      display "*- ERROR: ",v_status," Failed to delete ",pv_config_name clipped,"."
      rollback work
      call fatal_error()
    end if
  end if

  return v_success
end function

#----------------------------------------------------------------------#
function disable_a_foreign_key(pv_tab_altered, pv_col_key, pv_idxname)
#----------------------------------------------------------------------#
  define pv_tab_altered    varchar(30),
         pv_col_key        varchar(100),
         pv_idxname        varchar(30);

  define v_stmt            varchar(300),
         v_success         smallint

  let v_success = 0

  display "\nDisable foreign key for ",pv_tab_altered,",",
          pv_idxname," on ",pv_col_key

  let v_stmt = "alter table ",pv_tab_altered,
               " modify constraint ",pv_idxname," DISABLE"

  if v_status = 0 then
    execute immediate v_stmt
    let v_status = status
  end if

  case v_status
    when 0
      display "- INFO : table ",pv_tab_altered," altered successfully"
      let v_success = 1

    otherwise
      display "* ERROR ",v_status," occurred while altering table ",
              pv_tab_altered
      call fatal_error()
  end case

  return v_success

end function

#----------------------------------------------------------------------#
function disable_triggers(pv_table)
#----------------------------------------------------------------------#
  define pv_table  varchar(30)

  define v_stmt    varchar(1500),
         v_success smallint

  display "\nDisabling triggers on ",pv_table
  let v_success = 0

  let v_stmt = "alter table ",pv_table," disable all triggers"

  prepare sel_trigger1 from v_stmt
  let v_status = status
  if v_status = 0 then
    execute sel_trigger1
    let v_status = status
  end if
  if v_status <> 0 then
    display "* ERROR : Failed to disable triggers on ",pv_table
    call fatal_error()
  else
    display " INFO : disabled triggers successfully for table ",pv_table
    let v_success = 1
  end if

  return v_success
end function

#----------------------------------------------------------------------#
function drop_a_column(pv_table, pv_column)
#----------------------------------------------------------------------#
# NOTE: Use this ONLY for small tables - under, say, 50,000 rows.
  define pv_table      varchar(30),
         pv_column     varchar(30)

  define v_stmt        varchar(250),
         v_success     smallint

  let v_success = 0

  display "\nDropping column ",pv_table,".",pv_column

  if not check_column_exists(pv_table, pv_column) then
    display "- WARN : column doesn't exist"
    return v_success
  end if

  # Alter a table
  let v_stmt = "alter table ",pv_table," drop (",pv_column,")"

  execute immediate v_stmt
  let v_status = status

  # Check the status of the job.
  if v_status = 0 then
    display "- INFO : column dropped successfully"
    let v_success = 1
  else
    display "* ERROR ",v_status," occurred while dropping column ",
            pv_table,".",pv_column
    call fatal_error()
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function drop_a_check_constraint(pv_tab_altered, pv_constraint_name)
#----------------------------------------------------------------------#
  define pv_tab_altered     varchar(30),
         pv_constraint_name varchar(50)

  define v_stmt             varchar(300),
         v_success          smallint

  let v_success = 0

  display "\nDrop check constraint on ",pv_tab_altered,", ",pv_constraint_name

  let v_stmt = "alter table ",pv_tab_altered," drop constraint ",
               pv_constraint_name

  if v_status = 0 then
    execute immediate v_stmt
    let v_status = status
  end if

  case v_status
    when 0
      display "- INFO : table ",pv_tab_altered," altered successfully."
      let v_success = 1

    when -6372
      display "- WARN : constraint ",pv_constraint_name,
              " does not exist on table ",pv_tab_altered,"."
      let v_status = 0

    otherwise
      display "* ERROR ",v_status," occurred while altering table ",
              pv_tab_altered
      call fatal_error()

  end case
  return v_success
end function

#----------------------------------------------------------------------#
function drop_an_index(pv_table, pv_index)
#----------------------------------------------------------------------#
  define pv_table      varchar(30),
         pv_index      varchar(30)

  define v_stmt        varchar(500),
         v_cascade     varchar(7),
         v_count       integer,
         v_success     smallint

  let v_success = 0

  display "\nDropping constraint ",pv_index," on table ",pv_table

  # Check if it is a constraint first
  let v_count = 0

  let v_cascade = "cascade"
  select count(*) into v_count from user_constraints
    where constraint_name = upper(pv_index)
    and table_name = upper(pv_table)
  let v_status = status

  if v_status <> 0 then
    display "* ERROR : Failed to select count from system table for constraint ",pv_index
    call fatal_error()
  end if

  if v_count > 0 then
    let v_stmt = "alter table ",pv_table,
                 " drop constraint ",pv_index," ",v_cascade
    execute immediate v_stmt
    let v_status = status

    case v_status
      when 0
        display "- INFO : constraint ",pv_index," dropped successfully"

      otherwise
        display "* ERROR: ",v_status,", dropping constraint ",pv_index
        call fatal_error()
    end case
  else
    display "- WARN : constraint ",pv_index," doesn't exist"
  end if

  display "Dropping index ",pv_index," from table ",pv_table

  select count(*) into v_count from user_indexes
    where index_name = upper(pv_index)
    and table_name = upper(pv_table)
  let v_status = status
  if v_status <> 0 then
    display "* ERROR : Failed to select count from system table for index ",pv_index
    call fatal_error()
  end if

  if v_count = 0 then
    display "- WARN : index ",pv_index," doesn't exist"
    return 0
  end if

  let v_stmt = "drop index ",pv_index

  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : index ",pv_index," dropped successfully"
      let v_success = 1

    otherwise
      display "* ERROR: ",v_status," dropping index ",pv_index
      call fatal_error()
  end case
  return v_success
end function

#------------------------------------------------------#
function drop_a_synonym(pv_table)
#------------------------------------------------------#
  define pv_table    varchar(30)

  define v_count     smallint,
         v_stmt      varchar(500),
         v_success   smallint

  let v_success = 0

  display "\nDrop synonym ",pv_table

  select count(*) into v_count
    from all_synonyms
   where table_name = upper(pv_table)
  let v_status = status
  if v_status <> 0 then
    display "* ERROR: ",v_status," Failed to select synonym info."
    call fatal_error()
  end if

  if v_count > 0 then
    let v_stmt = "drop synonym ",pv_table

    execute immediate v_stmt
    let v_status = status

    case v_status
      when 0
        display "- INFO : Synonym ",pv_table," dropped successfully"
        let v_success = 1

      otherwise
        display "* ERROR: ",v_status," dropping synonym ",pv_table
        call fatal_error()
    end case
  else
    display "- WARN : Synonym ",pv_table," does not exist to be dropped."
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function drop_a_table(pv_table)
#----------------------------------------------------------------------#
  define pv_table       varchar(30)

  define v_stmt         varchar(50),
         v_success      smallint

  display "\nDrop table ",pv_table
  let v_success = 0
  if not check_table_exists(pv_table) then
    display "- WARN : table ",pv_table," doesn't exist to be dropped"
    return v_success
  end if

  #-- Drop the table --#
  let v_stmt = "drop table ",pv_table

  prepare tab_drp from v_stmt
  let v_status = status
  if v_status = 0 then
    execute tab_drp
    let v_status = status
  end if

  #-- Check the status --#
  case v_status
    when 0
      display "- INFO : table ", pv_table, " dropped successfully"
      let v_success = 1

    when -6372
      display "* ERROR : ",pv_table," is referenced by FK in another table"
      display "          You must resolve this issue and rerun the script"
      call fatal_error()

    otherwise
      display "* ERROR: ", v_status, " dropping table ", pv_table
      call fatal_error()
  end case
  return v_success
end function

#------------------------------------------#
function drop_a_procedure(pv_procedure)
#------------------------------------------#
  define pv_procedure       varchar(30)

  define v_stmt             varchar(500),
         v_obj_type         varchar(20),
         v_success          smallint

  display "\nDrop procedure ",pv_procedure
  let v_success = 0
  let v_obj_type = "PROCEDURE"

  if not check_procedure_exists(pv_procedure) then
    display "- WARN : procedure/function ",pv_procedure," does not exist to be dropped"
    return 1
  end if

  # Check object type.
  let v_stmt = "select object_type",
               "  from user_objects",
               " where object_name = upper('",pv_procedure clipped,"')"
  prepare obj_type from v_stmt
  let v_status = status
  if v_status = 0 then
    execute obj_type into v_obj_type
    let v_status = status
  end if

  case v_obj_type
    when "PROCEDURE"
      let v_stmt = "drop procedure ",pv_procedure
    when "FUNCTION"
      let v_stmt = "drop function ",pv_procedure
    otherwise
      display "- INFO : The object type is ",v_obj_type
  end case

  prepare proc_drp from v_stmt
  let v_status = status

  if v_status = 0 then
    execute proc_drp
    let v_status = status
  end if

  case v_status
    when 0
      display "- INFO : procedure ",pv_procedure," dropped successfully"
      let v_success = 1

    otherwise
      display "* ERROR: ",v_status," dropping procedure ",pv_procedure
      call fatal_error()
  end case
  return v_success
end function

----------------------------------------------------------------------#
function enable_a_foreign_key(pv_tab_altered, pv_col_key, pv_idxname)
#----------------------------------------------------------------------#
  define pv_tab_altered    varchar(30),
         pv_col_key        varchar(100),
         pv_idxname        varchar(30);

  define v_stmt           varchar(300),
         v_success         smallint

  let v_success = 0

  display "\nEnable foreign key for ",pv_tab_altered,",",
          pv_idxname," on ",pv_col_key

  let v_stmt = "alter table ",pv_tab_altered,
               " modify constraint ",pv_idxname," ENABLE"

  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : table ",pv_tab_altered," altered successfully"
      let v_success = 1

    otherwise
      display "* ERROR occurred while altering table ",pv_tab_altered
      call fatal_error()
  end case

  return v_success
end function

#----------------------------------------------------------------------#
function enable_triggers(pv_table)
#----------------------------------------------------------------------#
  define pv_table  varchar(30)

  define v_stmt    varchar(1500),
         v_success smallint

  display "\nEnabling triggers on ",pv_table
  let v_success = 0
  let v_stmt = "alter table ",pv_table," enable all triggers"

  prepare sel_trigger2 from v_stmt
  let v_status = status
  if v_status = 0 then
    execute sel_trigger2
    let v_status = status
  end if

  case v_status
    when 0
      display " INFO : enabled triggers on ",pv_table
      let v_success = 1

    otherwise
      display "* ERROR : Failed to enable_triggers on ",pv_table
      call fatal_error()
  end case

  return v_success
end function

#-----------------------------------------------#
function exist_config(pv_colname)
#-----------------------------------------------#
  define
     pv_colname     like en_config.config_name,
     v_count        smallint

  let v_count = 0

  select count(*) into v_count
    from en_config
    where config_name = pv_colname
  let v_status = status
  if v_status <> 0 then
    display "* ERROR : Failed to select count from en_config"
    call fatal_error()
  end if

  return (v_count > 0)
end function

#----------------------------------------------------------------------#
function fatal_error_drop_table(pv_table)
#----------------------------------------------------------------------#
# Fatal Error Routine (Incl Drop Table)
  define pv_table       varchar(30),
         v_success      integer,
         v_temp_status  integer

  let v_temp_status = v_status
  display "#--------------------------------------------------------#"
  display "      A fatal error has occurred."
  display "           Status is ",v_temp_status
  let v_success = drop_a_table(pv_table)
  display ""
  display "           Program stopping."
  display "#--------------------------------------------------------#\n"

  exit program 1

end function

#-----------------------------------------------------#
function get_date_format()
#-----------------------------------------------------#
  define  v_dbdate    char(5),
          v_delimiter char(1),
          v_format    char(10)

  let v_delimiter = "/" -- default
  let v_format = NULL
  let v_dbdate = fgl_getenv("DBDATE")

  if length(fgl_getenv("DBDATE")) = 5 then
    case v_dbdate[5, 5]
      when "0"
        let v_delimiter = NULL
      when "."
        let v_delimiter = "."
      when "-"
        let v_delimiter = "-"
      otherwise
        #let v_delimiter = "/"
    end case

  end if

  case v_dbdate[1, 1]
    when "Y"
      case v_dbdate[2, 2]
        when "2"
          let v_format = "YY"
        when "4"
          let v_format = "YYYY"
        otherwise
          display "Wrong date format. Check your DBDATE value!"
      end case

      case v_dbdate[3, 3]
        when "M"
          let v_format = v_format clipped, v_delimiter clipped, "MM", v_delimiter clipped, "DD"
        when "D"
          let v_format = v_format clipped, v_delimiter clipped, "DD", v_delimiter clipped, "MM"
        otherwise
          display "Wrong date format. Check your DBDATE value!"
      end case

    when "M"
      let v_format = "MM", v_delimiter clipped, "DD"
      case v_dbdate[4, 4]
        when "2"
          let v_format = v_format clipped, v_delimiter clipped, "YY"
        when "4"
          let v_format = v_format clipped, v_delimiter clipped, "YYYY"
        otherwise
          display "Wrong date format. Check your DBDATE value!"
      end case

    when "D"
      let v_format = "DD", v_delimiter clipped, "MM"
      case v_dbdate[4, 4]
        when "2"
          let v_format = v_format clipped, v_delimiter clipped, "YY"
        when "4"
          let v_format = v_format clipped, v_delimiter clipped, "YYYY"
        otherwise
          display "Wrong date format. Check your DBDATE value!"
      end case

    otherwise

  end case

  return v_format
end function

#------------------------------------------------------------------------#
function get_foreign_constraint_name(pv_table, pv_column)
#------------------------------------------------------------------------#
  define pv_table         varchar(30),
         pv_column        varchar(30);

  define v_stmt           varchar(500),
         v_constrname     varchar(30),
         v_idxname        varchar(30);

  let v_stmt = "select distinct trim(lower(a.constraint_name))",
               "  from user_constraints a, user_cons_columns r, user_cons_columns b",
               " where a.table_name = upper('",pv_table clipped,"')",
               "   and a.r_constraint_name = r.constraint_name",
               "   and a.table_name = b.table_name",
               "   and a.constraint_type = 'R'",
               "   and r.column_name = upper('",pv_column clipped,"')",
               "   and b.column_name = upper('",pv_column clipped,"')"

  prepare fconst_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute fconst_csr into v_idxname
    let v_status = status
  end if

  case v_status
    when 0
      # Do nothing.
    when 100
      display "- WARN : No foreign constraint exists."
      let v_status = 0
      let v_idxname = null
    otherwise
      display "* ERROR ",v_status," occurred while retrieving",
              " a foreign key constraint name for ",pv_table
      call fatal_error()
  end case

  return v_idxname
end function

#--------------------------------------------------------------------#
function get_max_id (pv_tabname, pv_id_name, pv_const)
#--------------------------------------------------------------------#
# Retrieve the max available ID/NO from a table.
# pv_id_name: a numeric column supposed to be serial
# pv_tabname: a table name
# pv_const: optional where clause
  define pv_tabname  varchar(30),
         pv_id_name  varchar(30),
         pv_const    varchar(100)

  define v_count     integer,
         v_stmt      varchar(1000)

  let v_count = 0

  if pv_const is null then
    let pv_const = "where 1=1"
  end if

  # You may want to change the nvl value
  let v_stmt = "select nvl(max(",pv_id_name,") + 1, 1)",
               " from ",pv_tabname, " ",pv_const

  prepare sel_max_crs from v_stmt
  let v_status = status
  if v_status = 0 then
    execute sel_max_crs into v_count
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR - failed to select max(",pv_id_name,")",
            " from table ",pv_tabname
    call fatal_error()
  end if

  return v_count
end function

#----------------------------------------------------------------------#
function get_nonunique_index_name(pv_table)
#----------------------------------------------------------------------#
# This function is valid only if we know that a particular table has
# only one non unique index.
  define pv_table      varchar(30)

  define v_stmt        varchar(1000),
         v_index_name  varchar(30)

  display "       Retrieving non-unique index name for ",pv_table,"."

  let v_stmt = "select trim(lower(index_name))",
               "  from user_indexes",
               " where table_name = upper('",pv_table clipped,"')",
               "   and uniqueness = 'NONUNIQUE'"

  prepare idx_csr3 from v_stmt
  let v_status = status
  if v_status = 0 then
    execute idx_csr3 into v_index_name
    let v_status = status
  end if

  case v_status
    when 0
      # Do nothing.
    when 100
      display "- WARN : No non-unique index exists."
      let v_status = 0
      let v_index_name = null

    otherwise
      display "* ERROR ", v_status, " occurred while retrieving",
              " a non-unique index name for ",pv_table
      call fatal_error()
  end case

  return v_index_name
end function

#----------------------------------------------------------------------#
function get_primary_constraint_name(pv_table)
#----------------------------------------------------------------------#
  define pv_table      varchar(30)

  define v_stmt        varchar(1000),
         v_constrname  varchar(30)

  display "         Retrieving primary constraint name for ",pv_table,"."

  let v_stmt = "select trim(lower(constraint_name))",
               "  from user_constraints",
               " where table_name = upper('",pv_table clipped,"')",
               "   and constraint_type = 'P'"

  prepare const_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute const_csr into v_constrname
    let v_status = status
  end if

  case v_status
    when 0
      # Do nothing.
    when 100
      display "- WARN : No primary constraint exists."
      let v_status = 0
      let v_constrname = null
    otherwise
      display "* ERROR ", v_status, " occurred while retrieving",
              " a constraint name for ",pv_table
      call fatal_error()
  end case

  return v_constrname
end function

#----------------------------------------------------------------------#
function get_unique_index_name(pv_table)
#----------------------------------------------------------------------#
# This function is valid only if we know that a particular table has
# only one unique index.
  define pv_table      varchar(30)

  define v_stmt        varchar(1000),
         v_index_name  varchar(30)

  display "         Retrieving unique index name for ",pv_table

  let v_stmt = "select trim(lower(index_name))",
               "  from user_indexes",
               " where table_name = upper('",pv_table clipped,"')",
               "   and uniqueness = 'UNIQUE'"

  prepare idx_csr2 from v_stmt
  let v_status = status
  if v_status = 0 then
    execute idx_csr2 into v_index_name
    let v_status = status
  end if

  case v_status
    when 0
      # Do nothing.
    when 100
      display "- WARN : No unique index exists."
      let v_status = 0
      let v_index_name = null
    otherwise
      display "* ERROR ", v_status, " occurred while retrieving",
              " a unique index name for ",pv_table
      call fatal_error()
  end case

  return v_index_name
end function

#----------------------------------------------------------------------#
function get_index_definition(pv_table, pv_idxname)
#----------------------------------------------------------------------#
  define
    pv_table varchar(30),
    pv_idxname varchar(30)

  define
    v_column_name  varchar(40),
    v_column_expr  varchar(40),
    v_column_order varchar(4),
    v_column_def   varchar(50),
    v_index_def    varchar(1000)

  execute immediate "
    create or replace function temp_get_column_expression(
      pv_tablename in varchar2, pv_indexname in varchar2, pv_column_position in number) return varchar2
      as
        l_cursor   integer default dbms_sql.open_cursor;
        l_n        number;
        l_long_val varchar2(40) := null;
        l_long_len number;
      begin
        dbms_sql.parse (l_cursor,
          'select column_expression from user_ind_expressions'||
          ' where table_name = :tab'||
          ' and index_name = :idx'||
          ' and column_position = :pos',
          dbms_sql.native);
        dbms_sql.bind_variable(l_cursor, ':tab', pv_tablename);
        dbms_sql.bind_variable(l_cursor, ':idx',   pv_indexname);
        dbms_sql.bind_variable(l_cursor, ':pos',   pv_column_position);
        dbms_sql.define_column_long(l_cursor, 1);

        l_n := dbms_sql.execute(l_cursor);
        if (dbms_sql.fetch_rows(l_cursor) > 0) then
          dbms_sql.column_value_long(l_cursor, 1, 40, 0, l_long_val, l_long_len);
        end if;
        dbms_sql.close_cursor(l_cursor);

        return l_long_val;

      end temp_get_column_expression;
  "

  declare index_def_c cursor for
    select column_name, temp_get_column_expression(table_name, index_name, column_position), descend
    from user_ind_columns
    where table_name=upper(pv_table)
    and index_name=upper(pv_idxname)
    order by column_position

  foreach index_def_c into v_column_name, v_column_expr, v_column_order
    if v_column_expr is null then
      let v_column_def = v_column_name
    else
      let v_column_def = v_column_expr[2,length(v_column_expr)-1], " ", v_column_order
    end if
    if v_index_def is null then
      let v_index_def = v_column_def
    else
      let v_index_def = v_index_def, ", ", v_column_def
    end if
  end foreach

  execute immediate "drop function temp_get_column_expression"

  return v_index_def
end function

#----------------------------------------------------------------------#
function get_constraint_definition(pv_table, pv_constraint_name)
#----------------------------------------------------------------------#
  define
    pv_table varchar(30),
    pv_constraint_name varchar(30)

  define
    v_column_name  varchar(40),
    v_cons_def    varchar(1000)

  declare constraint_def_c cursor for
    select column_name
    from user_cons_columns
    where table_name=upper(pv_table)
    and constraint_name=upper(pv_constraint_name)
    order by position asc

  foreach constraint_def_c into v_column_name
    if v_cons_def is null then
      let v_cons_def = v_column_name
    else
      let v_cons_def = v_cons_def, ", ", v_column_name
    end if
  end foreach

  return v_cons_def

end function


#----------------------------------------------------------------------#
function grant_privileges(pv_table)
#----------------------------------------------------------------------#
#NOTE: This function is designed to be used only in ORACLE databases

#NOTE: If the object schema is not "energydb" then in addition to the
#      "energy_user_role" also add the appropriate role for the schema
#      as in "energytou_user_role", "energysm_user_role" etc.
#Ex.   "grant all on ",pv_table," to energy_user_role, energysm_user_role"
  define  pv_table      varchar(30)

  define  v_count       integer,
          v_stmt        varchar(200),
          v_success     smallint

  let v_success = 0

  display "Granting privileges for table ",pv_table

  let v_count = -1

  select count(*) into v_count from user_tables
    where table_name = upper(pv_table)
  let v_status = status
  if v_status <> 0 then
    display "* ERROR : Failed to select count from user_tables"
    call fatal_error()
  end if

  if v_count = 0 then
    display "* ERROR : table ",pv_table," does not exist"
  else
    let v_stmt = "grant all on ",pv_table," to energy_user_role"

    prepare tab1_priv from v_stmt
    let v_status = status
    if v_status = 0 then
      execute tab1_priv
      let v_status = status
    end if

    if v_status = 0 then
      display "- INFO : privileges on ",pv_table,
              " granted successfully"
      let v_success = 1
    else
      display "* ERROR ",v_status," : privileges not granted on ",
              pv_table
      call fatal_error()
    end if
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function informix_code_to_datatype(pv_code)
#----------------------------------------------------------------------#
  define pv_code smallint

  if pv_code >= 256 then
    let pv_code = pv_code - 256
  end if

  case pv_code
    when 0
      return "CHAR"
    when 1
      return "SMALLINT"
    when 2
      return "INTEGER"
    when 3
      return "FLOAT"
    when 4
      return "SMALLFLOAT"
    when 5
      return "DECIMAL"
    when 6
      return "SERIAL"
    when 7
      return "DATE"
    when 8
      return "MONEY"
    when 9
      return "NULL"
    when 10
      return "DATETIME"
    when 11
      return "BYTE"
    when 12
      return "TEXT"
    when 13
      return "VARCHAR"
    when 14
      return "INTERVAL"
    when 15
      return "NCHAR"
    when 16
      return "NVARCHAR"
    when 17
      return "INT8"
    when 18
      return "SERIAL8"
    when 19
      return "SET"
    when 20
      return "MULTISET"
    when 21
      return "LIST"
    when 22
      return "ROW"
    when 23
      return "COLLECTION"
    when 24
      return "ROWREF"
    otherwise
      return ""
  end case

end function

#----------------------------------------------------------------------#
function informix_datatype_to_code(pv_datatype)
#----------------------------------------------------------------------#
  define pv_datatype varchar(30)

  case upshift(pv_datatype)
    when "CHAR"
      return 0
    when "SMALLINT"
      return 1
    when "INTEGER"
      return 2
    when "FLOAT"
      return 3
    when "SMALLFLOAT"
      return 4
    when "DECIMAL"
      return 5
    when "SERIAL"
      return 6
    when "DATE"
      return 7
    when "MONEY"
      return 8
    when "NULL"
      return 9
    when "DATETIME"
      return 10
    when "BYTE"
      return 11
    when "TEXT"
      return 12
    when "VARCHAR"
      return 13
    when "INTERVAL"
      return 14
    when "NCHAR"
      return 15
    when "NVARCHAR"
      return 16
    when "INT8"
      return 17
    when "SERIAL8"
      return 18
    when "SET"
      return 19
    when "MULTISET"
      return 20
    when "LIST"
      return 21
    when "ROW"
      return 22
    when "COLLECTION"
      return 23
    when "ROWREF"
      return 24
    otherwise
      return null
  end case

end function

#----------------------------------------------------------------------#
function insert_a_row(pv_table, pv_col_str, pv_values_str)
#----------------------------------------------------------------------#
# Returns a count of the number of rows successfully inserted.
  define pv_table       varchar(30),
         pv_col_str     varchar(500),
         pv_values_str  varchar(1000)

  define v_stmt         varchar(1500),
         v_success      smallint

  display "\nInserting data into ",pv_table
  let v_success = 0
  let v_stmt = "insert into ",pv_table," (",pv_col_str,")",
               " values (", pv_values_str, ")"
  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0       # Things are ok
      let v_success = 1

    when -239    # Duplicate row, also OK
      display '- WARN : Record already inserted in table ',pv_table
      let v_status = 0

    when -268    # Duplicate row, also OK
      display '- WARN : Record already inserted in table ',pv_table
      let v_status = 0

    otherwise
      call fatal_error()
  end case
  return v_success
end function

#----------------------------------------------------------------------#
function insert_stop_rule(pv_new_rule_id,
                          pv_after_rule_id,
                          pv_read_status_type,
                          pv_rule_descr,
                          pv_side_effects,
                          pv_threshold_ok)
#----------------------------------------------------------------------#
# Modify b_stop_rule, setting up a new "S" rule pv_new_rule_id
# that must be applied after to pv_after_rule_id. This will
# involve incrementing the rule_seq of all rules >= pv_after_rule_id
#
# NOTE 1: If pv_after_rule_id is NULL, the sequence of the new S rule
#       will be max(rule_seq) + 1.
#
#       If the new rule is an A rule, it's a simple insertion.
#
# NOTE 2: When calling this function, pass NULL for pv_after_rule_id
#         if either
#            the new rule is an S rule and to be added at the end
#         or the new rule is an A rule.

   define pv_new_rule_id      like b_stop_rule.rule_id,
          pv_after_rule_id    like b_stop_rule.rule_id,
          pv_read_status_type like b_stop_rule.read_status_type,
          pv_rule_descr       like b_stop_rule.rule_descr,
          pv_side_effects     like b_stop_rule.side_effects,
          pv_threshold_ok     like b_stop_rule.threshold_ok;

   define v_count          integer,
          v_table          varchar(30),
          v_stmt           varchar(500),
          v_rule_type      char(1),
          v_rule_seq       smallint,
          v_const          varchar(100),
          v_after_rule_seq like b_stop_rule.rule_seq,
          v_success        smallint

   define rule_rec record like b_stop_rule.*;

   display "\nInserting new stop rule ",pv_new_rule_id
   let v_table = "b_stop_rule"
   let v_count = 0
   let v_rule_seq = NULL
   let v_success = 0

   # Identify the stop rule type - an A rule or S rule?
   let v_stmt = "select substr('",pv_new_rule_id,"', 0, 1)",
                " from en_licensee"

   prepare a_rule_type_s from v_stmt
   let v_status = status

   if v_status = 0 then
     execute a_rule_type_s into v_rule_type
     let v_status = status
   end if

   if v_status <> 0 then
     display "* ERROR: ",v_status," Failed to select substring."
     call fatal_error()
   end if

   # Now to insert the rule
   display "- Insert ",pv_new_rule_id," into ",v_table,"."

   # Check if rule already exists
   select count(*) into v_count
     from b_stop_rule
    where rule_id = pv_new_rule_id
   let v_status = status

   if v_status <> 0 then
     display "* ERROR: ",v_status," Failed to select count(*) from b_stop_rule."
     call fatal_error()
   end if

   if v_count = 1 then
     display "- WARN : Rule ",pv_new_rule_id," already exists."
     return 0
   else
     begin work
     # Increment rule_seq for all 'S' reading rules > v_after_rule_seq

     if v_rule_type = "S" then
       if pv_after_rule_id is not null or pv_after_rule_id <> "" then

         select rule_seq into v_after_rule_seq
           from b_stop_rule
          where rule_id = pv_after_rule_id
         let v_status = status

         if v_status <> 0 then
           rollback work
           display "* ERROR: ",v_status," Failed to select rule_seq of ",pv_after_rule_id,"."
           call fatal_error()
         end if

         # rule_seq for the new rule to be added
         let v_rule_seq = v_after_rule_seq + 1

         display "rule_seq greater than or equal to ",v_after_rule_seq,
                 " will be updated"

         declare cur_upd_rule_seq_c cursor with hold for
           select rule_id from b_stop_rule
            where rule_id like 'S%'
              and read_status_type = pv_read_status_type
         let v_status = status

         if v_status <> 0 then
           rollback work
           display "* ERROR: ",v_status," Failed to declare cursor cur_upd_rule_seq_c for ",v_table,"."
           call fatal_error()
         end if

         foreach cur_upd_rule_seq_c into rule_rec.*
           update b_stop_rule set rule_seq = rule_seq + 1
            where rule_seq > v_after_rule_seq
              and rule_id = rule_rec.rule_id
           let v_status = status

           case
             when v_status = -746
               rollback work
               display "* ERROR: ",v_status," Unable to update data in ",v_table,
                       "- Rollback all Unprocessed readings first."
               call fatal_error()
             when v_status = 0
               # Do nothing
             otherwise
               rollback work
               display "* ERROR: ",v_status," Failed to adjust rule sequences."
               call fatal_error()
           end case

         end foreach

         display "- INFO : Rule sequences successfully adjusted"

       else
         let v_const = "where rule_id like 'S%' and read_status_type = '",
                        pv_read_status_type clipped,"'"

         # rule_seq for the new rule to be added
         let v_rule_seq = get_max_id (v_table, "rule_seq", v_const)
       end if
     end if

     # Insert the new rule
     insert into b_stop_rule
       (rule_id,
        read_status_type,
        rule_seq,
        rule_descr,
        side_effects,
        threshold_ok
       )
     values
       (pv_new_rule_id,
        pv_read_status_type,
        v_rule_seq,
        pv_rule_descr,
        pv_side_effects,
        pv_threshold_ok
       )
     let v_status = status

     case
       when v_status = -746
         rollback work
         display "* ERROR: ",v_status," Unable to insert ",pv_new_rule_id," into ",v_table,
                 "- Rollback all Unprocessed readings first."
         call fatal_error()
       when v_status = 0
         commit work
         display "- INFO : Rule ",pv_new_rule_id," inserted successfully ",
                 "into ",v_table
         display "**  Remember to remove the blocker rules.  **"
         let v_success = 1
       otherwise
         rollback work
         display "* ERROR: ",v_status," Cannot insert rule ",
                 pv_new_rule_id," into ",v_table
         call fatal_error()
     end case

   end if
  return v_success
end function

#----------------------------------------------------------------------#
function is_it_unique_index(pv_idxname)
#----------------------------------------------------------------------#
  define pv_idxname    varchar(30);

  define v_stmt        varchar(1000),
         v_count       smallint;

  display "         Retrieving uniqueness for the index ",pv_idxname,"."

  let v_stmt = "select count(*)",
               "  from user_indexes",
               " where index_name = upper('",pv_idxname clipped,"')",
               "   and uniqueness = 'UNIQUE'"

  prepare unique_idx_csr from v_stmt
  let v_status = status
  if v_status = 0 then
    execute unique_idx_csr into v_count
    let v_status = status
  end if

  if v_status <> 0 then
    display "* ERROR ",v_status," occurred while retrieving count(*) for",
            pv_idxname,"."
    call fatal_error()
  end if

  return (v_count > 0)
end function

#------------------------------------------------------#
function rebuild_table()
#------------------------------------------------------#
#alter this function to replace table with actual details
#add schema details to get_table_def_string for new schema as swap_table
#need a test condition we can check to see if the script has already rebuilt the table.
  define v_table       varchar(30),
         v_stmt         varchar(1500),
         v_stmt_row     varchar(200),
         v_flag         integer,
         v_swaptable    varchar(30),
         v_tab_sch      varchar(500),
         v_success      integer,
         v_count        integer,
         v_inicount     integer,
         v_totcount     integer

  define table_rec record
    #define the table record .., e.g -
    column char(1)
  end record

  let v_table = "table"
  let v_swaptable = "swap_table"

  #---------------------------------------#
  display "Rebuilding table ",v_table,"."
  #---------------------------------------#

  let v_success = create_a_table(v_swaptable)
  if v_status <> 0 then
    display "* ERROR - Failed to create temporary table ",v_swaptable,"."
    call fatal_error()
  end if

  #----------------------------------------------#
  #-- Copy existing data to the new temp table --#
  #----------------------------------------------#
  display " - INFO: Copying data from ",v_table,"."

  #-- Obtain count of records to be transferred.--#
  let v_stmt = "select count(*) from ",v_table
  prepare count_table_stmt from v_stmt
  let v_status = status
  if v_status = 0 then
    execute count_table_stmt into v_inicount
    let v_status = status
  end if
  if v_status = 0 then
    display "  - INFO: There are ",v_inicount,
            " records to be transferred from ",v_table,"."
  else
    display "* ERROR: Failed to obtain count of records in ",v_table,"."
    call fatal_error()
  end if

  #-- Create cursor to select data from old table --#
  let v_stmt = "select * from ", v_table
  prepare sel_table_stmt from v_stmt
  let v_status = status
  if v_status <> 0 then
    display "* ERROR: Failed to prepare select statement for ",v_table,"."
    call fatal_error()
  end if

  declare sel_table_csr cursor with hold for sel_table_stmt

  open sel_table_csr
  let v_status = status
  if v_status <> 0 then
    display "* ERROR: Failed to open select cursor for ",v_table,"."
    call fatal_error()
  end if

  let v_count = 0
  let v_totcount = 0

  begin work

  foreach sel_table_csr into table_rec.*

    insert into swap_table
      (
      #add table schema details ....
      column
      )
    values
      (
      #add <table_rec>.<column> ....
      table_rec.column
      )

    let v_status = status
    if v_status <> 0 then
      let v_totcount = v_totcount + v_count
      display "* ERROR ",v_status," occurred while inserting records into ",
              v_swaptable,". Records inserted so far:",v_totcount,"."
      call fatal_error()
    end if

    let v_count = v_count + 1
    if v_count > 9999 then
      commit work
      begin work
      let v_totcount = v_totcount + v_count
      let v_count = 0
      display "   ... ",v_totcount," records transferred so far ..."
    end if

  end foreach

  let v_totcount = v_totcount + v_count
  if v_totcount = v_inicount then
    commit work
    display "  - INFO : ",v_totcount," records transferred from ",v_table,
            " successfully."
  else
    let v_status = 9999
    rollback work
    display "* ERROR: Incorrect number of records copied from table."
    display "        -- only ",v_totcount," records transferred."
    call fatal_error()
  end if

  #---------------------------------------#
  #-- Drop the old version of the table --#
  #---------------------------------------#
  if not drop_a_table(v_table) then
    display "Rebuild failed - rollback work"
    rollback work
    call fatal_error_drop_table(v_swaptable)
  end if

  #-------------------------------------------------------#
  #-- Rename the new temp table to permanent table name --#
  #-------------------------------------------------------#
  let v_success = rename_a_table(v_swaptable, v_table)

  let v_totcount = v_totcount + v_count
  if v_totcount = v_inicount then
    commit work
    display "- INFO : ",v_totcount," records transferred from ",v_table,
            " successfully."
    let v_success = 1
  else
    let v_status = -9999
    rollback work
    display "* ERROR: Incorrect number of records copied from table."
    display "        -- only ",v_totcount," records transferred."
    call fatal_error()
  end if
  return v_success

end function

#------------------------------------------------------------------#
function remove_duplicate_rows(pv_table, pv_col_1,pv_col_2,
                               pv_col_3,pv_col_4,pv_col_5,
                               pv_col_6,pv_col_7,pv_col_8)
#------------------------------------------------------------------#
# This function accepts 9 parameters consisting of table name and 8
# columns that make up the conditional clause
  define pv_table             varchar(30),
         pv_col_1             varchar(30),
         pv_col_2             varchar(30),
         pv_col_3             varchar(30),
         pv_col_4             varchar(30),
         pv_col_5             varchar(30),
         pv_col_6             varchar(30),
         pv_col_7             varchar(30),
         pv_col_8             varchar(30),
         v_swaptable          varchar(30),
         v_stmt               varchar(500),
         v_stmt_and           varchar(300),
         v_count              integer,
         v_inicount           integer,
         v_totcount           integer,
         v_rowid              varchar(18),
         v_success            smallint

  let v_success = 0

  display "\nRemoving duplicate rows from ",pv_table,"."

  #-- Obtain count of records to be deleted.--#
  let v_stmt = "select count(*) from ",pv_table,
                " a where a.rowid <> (select max (rowid)",
                " from ",pv_table," b",
                " where a.",pv_col_1," = b.",pv_col_1

  if pv_col_2 is not null then
    let v_stmt_and = " and a.",pv_col_2," = b.",pv_col_2
  end if
  if pv_col_3 is not null then
    let v_stmt_and = v_stmt_and," and a.",pv_col_3," = b.",pv_col_3
  end if
  if pv_col_4 is not null then
    let v_stmt_and = v_stmt_and," and a.",pv_col_4," = b.",pv_col_4
  end if
  if pv_col_5 is not null then
    let v_stmt_and = v_stmt_and," and a.",pv_col_5," = b.",pv_col_5
  end if
  if pv_col_6 is not null then
    let v_stmt_and = v_stmt_and," and a.",pv_col_6," = b.",pv_col_6
  end if
  if pv_col_7 is not null then
    let v_stmt_and = v_stmt_and," and a.",pv_col_7," = b.",pv_col_7
  end if
  if pv_col_8 is not null then
    let v_stmt_and = v_stmt_and," and a.",pv_col_8," = b.",pv_col_8
  end if
  let v_stmt = v_stmt,v_stmt_and,")"

  prepare count_dup_rec_s from v_stmt
  let v_status = status
  if v_status = 0 then
    execute count_dup_rec_s into v_inicount
    let v_status = status
  end if
  if v_status = 0 then
    display "- INFO : There are ",v_inicount,
            " duplicate records to be deleted from ",pv_table,"."
  else
    display "* ERROR: Failed to get count of duplicate records in ",pv_table,"."
    call fatal_error()
  end if

  if v_inicount > 0 then
    #-- Create cursor to select data from old table --#
    let v_stmt = "select a.rowid from ",pv_table,
                  " a where a.rowid <> (select max (rowid)",
                  " from ",pv_table ," b",
                  " where a.",pv_col_1," = b.",pv_col_1

    let v_stmt = v_stmt,v_stmt_and,")"

    prepare select_dup_rec_s from v_stmt
    let v_status = status
    if v_status <> 0 then
      display "* ERROR: Failed to prepare select statement for ",pv_table,"."
      call fatal_error()
    end if

    declare select_dup_rec_c cursor with hold for select_dup_rec_s
    let v_status = status
    if v_status <> 0 then
      display "* ERROR: Failed to declare select cursor for ",pv_table
      call fatal_error()
    end if

    let v_count = 0
    let v_totcount = 0

    begin work

    foreach select_dup_rec_c into v_rowid

      # Delete the duplicate rows
      # - deletes all duplicate rows except the one with Max Row id.
      let v_stmt = "delete from ",pv_table ," where rowid = '",v_rowid clipped,"'"
      execute immediate v_stmt
      let v_status = status
      if v_status <> 0 then
        let v_totcount = v_totcount + v_count
        display "* ERROR ",v_status," occurred while deleting a record from ",
                pv_table,". Duplicate records deleted so far:",v_totcount,"."
        call fatal_error()
      end if

      let v_count = v_count + 1
      if v_count > 9999 then
        commit work
        begin work
        let v_totcount = v_totcount + v_count
        let v_count = 0
        display "   ... ",v_totcount,"Duplicate records deleted so far ..."
      end if

    end foreach

    let v_totcount = v_totcount + v_count

    if v_totcount = v_inicount then
      commit work
      display "- INFO : ",v_totcount," duplicate records deleted from ",
              pv_table," successfully."
      let v_success = 1
    else
      let v_status = -9999
      rollback work
      display "* ERROR: Incorrect number of duplicate records deleted from table."
      display "        -- only ",v_totcount," duplicate records deleted."
      call fatal_error()
    end if

    display "- INFO : Duplicate records were successfully deleted from ",pv_table,"."
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function rename_a_column(pv_tabname, pv_old_colname, pv_new_colname)
#----------------------------------------------------------------------#
  define pv_tabname     varchar(30),
         pv_old_colname varchar(30),
         pv_new_colname varchar(30)

  define v_stmt         varchar(1500),
         v_success      smallint

  let v_success = 0

  display "\nAltering table ",pv_tabname,"."
  display "- Renaming ",pv_old_colname," to ",pv_new_colname

  #==== Check if column exists. ====
  if not check_column_exists(pv_tabname, pv_old_colname) then
    display "- WARN : column ",pv_old_colname," doesn't exist to",
            " be renamed"
    return v_success
  end if

  #===== Rename the column ====
  let v_stmt = "alter table ",pv_tabname," rename column ",pv_old_colname,
               " to ",pv_new_colname

  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : column ",pv_old_colname," renamed to ",
               pv_new_colname," successfully"
      let v_success = 1

    otherwise
      display "* ERROR: ",v_status," renaming column for ",pv_tabname
      call fatal_error()
  end case
  return v_success
end function

#----------------------------------------------------------------------#
function rename_a_table(pv_oldtabname, pv_newtabname)
#----------------------------------------------------------------------#
  define pv_oldtabname  varchar(30),
         pv_newtabname  varchar(30)

  define v_stmt         varchar(1500),
         v_success      smallint

  let v_success = 0

  display "\nRenaming table ",pv_oldtabname

  #==== Check if table exists. ====
  if not check_table_exists(pv_oldtabname) then
    display "- WARN : table ",pv_oldtabname," doesn't exist to",
            " be renamed"
    return v_success
  end if

  #===== Rename the table ====
  let v_stmt = "rename ",pv_oldtabname," to ", pv_newtabname

  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : table ", pv_oldtabname, " renamed to ",
               pv_newtabname, " successfully"
      let v_success = 1
      if not grant_privileges(pv_newtabname) then
        display "- WARN : Rename table successful but grant_privileges to ",
          pv_newtabname," failed"
      end if

    otherwise
      display "* ERROR: ", v_status, " renaming table ", pv_oldtabname
      call fatal_error()
  end case
  return v_success
end function

#----------------------------------------------------------------------#
function rename_an_index( pv_old_idxname, pv_new_idxname)
#----------------------------------------------------------------------#
  define pv_old_idxname varchar(30),
         pv_new_idxname varchar(30),
         v_success      smallint,
         v_count        smallint,
         v_stmt         varchar(200)

  let v_success = 0
  display "\nRenaming index ",pv_old_idxname

  #==== Check if index exists. ====
  let v_stmt = "select count(*)",
               " from user_indexes",
               " where index_name = upper('",pv_old_idxname clipped,"')"

  prepare sel_cnt_s from v_stmt
  let v_status = status
  if v_status = 0 then
    execute sel_cnt_s into v_count
    let v_status = status
  end if
  if v_status <> 0 then
    display "* ERROR : statement failed for select count from user_indexes"
    call fatal_error()
  end if

  if v_count = 0 then
    display "- WARN : index ",pv_old_idxname," doesn't exist to",
            " be renamed"
    return v_success
  end if

  #===== Rename the index ====
  if v_status = 0 then
    let v_stmt = "alter index ",pv_old_idxname," rename to ", pv_new_idxname
  end if

  execute immediate v_stmt
  let v_status = status

  case v_status
    when 0
      display "- INFO : Index ", pv_old_idxname, " renamed to ",
               pv_new_idxname, " successfully"
      let v_success = 1

    when 100
      display "- WARN : Index to be renamed does not exist"
      let v_success = 1
      let v_status = 0

    otherwise
      display "* ERROR: ", v_status, " renaming index ", pv_old_idxname
      call fatal_error()
  end case
  return v_success
end function

#------------------------------------------------------------------------#
function set_col_default_val(pv_table, pv_column, pv_datatype, pv_default)
#------------------------------------------------------------------------#
# Sets the default value for a column.
  define pv_table      varchar(30),
         pv_column     varchar(30),
         pv_datatype   varchar(50),
         pv_default    varchar(30)

  define v_stmt        varchar(100),
         v_success     smallint

  let v_success = 0

  display "\nAltering column ",pv_table,".",pv_column," to ",pv_datatype,
          " with default value of ",pv_default

  let v_stmt = "alter table ",pv_table," modify (",pv_column,
               " ",pv_datatype," default ",pv_default,")"

  execute immediate v_stmt
  let v_status = status

  # Check the status of the job.
  if v_status = 0 then
    display "- INFO : column altered successfully"
    let v_success = 1
  else
    display "* ERROR ",v_status," occurred while altering column ",
            pv_column," in ",pv_table
    call fatal_error()
  end if
  return v_success
end function

#----------------------------------------------------------------------#
function simple_alter_a_column(pv_table, pv_column, pv_datatype)
#----------------------------------------------------------------------#
  define pv_table      varchar(30),
         pv_column     varchar(30),
         pv_datatype   varchar(50)

  define v_stmt        varchar(100),
         v_success     smallint

  let v_success = 0

  display "\nAltering column ",pv_table,".",pv_column,
          " to ",pv_datatype

  let v_stmt = "alter table ",pv_table," modify (",pv_column,
                " ",pv_datatype,")"

  execute immediate v_stmt
  let v_status = status

  # Check the status of the job.
  if v_status = 0 then
    display "- INFO : column altered successfully"
    let v_success = 1
  else
    display "* ERROR ",v_status," occurred while altering column ",
            pv_column," in ",pv_table
    call fatal_error()
  end if
  return v_success
end function

#-------------------------------------------------------------------------#
function update_config(pv_config_name, pv_config_value)
#-------------------------------------------------------------------------#
# Insert or update the given configuration switch.
# WARNING: Do NOT assume the following logic of "Insert if not found" to be
#          appropriate in every case. Verify requirement with the designer.
  define pv_config_name  like en_config.config_name,
         pv_config_value like en_config.config_value

  define v_count         smallint,
         v_success       smallint,
         v_config        like en_config.config_value

  let v_success = 0
  display "\nSet configuration ",pv_config_name clipped,
          " to ",pv_config_value

  # Check if record exists in table
  select count(*) into v_count
    from en_config
   where config_name = pv_config_name
  let v_status = status
  if v_status <> 0 then
    display "* ERROR : failed to select count from en_config"
    call fatal_error()
  end if

  if v_count = 0 then
    # new configuration
    begin work
    insert into en_config (config_name, config_value)
      values (pv_config_name, pv_config_value)
    let v_status = status

    if v_status = 0 then
      commit work
      display "- INFO : configuration inserted successfully"
    else
      rollback work
      display "* ERROR ",v_status," : cannot insert configuration"
      call fatal_error()
    end if

    # OR
    # display "* ERROR : Configuration to be updated does Not exist"
    #

  else
    select config_value into v_config
      from en_config
     where config_name = pv_config_name
    let v_status = status
    if v_status <> 0 then
      display "* ERROR : failed to select config_value from en_config"
      call fatal_error()
    end if

    if pv_config_value <> v_config then
      # existing configuration
      begin work
      update en_config set config_value = pv_config_value
        where config_name = pv_config_name
      let v_status = status

      if v_status = 0 then
        commit work
        display "- INFO : configuration updated successfully"
        let v_success = 1
      else
        rollback work
        display "* ERROR ",v_status," : cannot update configuration"
        call fatal_error()
      end if
    else
      display "- WARN : ",pv_config_name," already has correct value ",v_config
      let v_success = 1
    end if
  end if
  return v_success
end function

#-----------------------------------------------------------------------------#
function update_rows(pv_table,pv_col_upd,pv_val_upd,pv_where)
#-----------------------------------------------------------------------------#
# update data where table contains < 10,000 rows
  define pv_table       varchar(30),
         pv_col_upd     varchar(30),
         pv_val_upd     varchar(500),
         pv_where       varchar(500)

  define v_stmt         varchar(1500),
         v_rec_count    integer

  display "\nUpdating rows for table ",pv_table
  let v_rec_count = 0
  let v_stmt = "select count(*) from ",pv_table,
               " where ",pv_where,
               " and (",pv_col_upd," <> ",pv_val_upd,
               " or ", pv_col_upd, " is null)"

  prepare sel_cur from v_stmt
  let v_status = status
  if v_status = 0 then
    execute sel_cur into v_rec_count
    let v_status = status
  end if
  if v_status <> 0 then
    display "* ERROR : Statement failed for select count from ",pv_table
    call fatal_error()
  end if

  if v_rec_count = 0 then
    display "- WARN : Row(s) do not exist in ",pv_table
    return 0
  else
    begin work
    let v_stmt = "update ",pv_table," set ",pv_col_upd," = ",pv_val_upd," where ",pv_where
    execute immediate v_stmt
    let v_status = status
    let v_rec_count = sqlca.sqlerrd[3]
  end if

  case v_status
    when 0       # Things are OK
      commit work

    otherwise
      rollback work
      call fatal_error()
  end case
  return v_rec_count

end function

#-----------------------------------------------------------------------------#
#Please complete v_stmt in the foreach block
function update_rows_large(pv_table,pv_col_upd,pv_val_upd,pv_where)
#-----------------------------------------------------------------------------#
# update data where table contains >= 10,000 rows
  define pv_table       varchar(30),
         pv_col_upd     varchar(30),
         pv_val_upd     varchar(500),
         pv_where       varchar(500)

  define v_stmt         varchar(1500),
         v_rec_count    integer,
         v_count        integer,
         v_totcount     integer,
         v_table_rec record
           column integer  #define actual table schema
         end record

  display "\nUpdating rows for (large) table ",pv_table
  let v_rec_count = 0
  let v_count = 0
  let v_stmt = "select count(*) from ",pv_table,
               " where ",pv_where,
               " and (",pv_col_upd," <> ",pv_val_upd,
               " or ", pv_col_upd, " is null)"

  prepare select_count_s from v_stmt
  let v_status = status
  if v_status = 0 then
    execute select_count_s into v_rec_count
    let v_status = status
  end if
  if v_status <> 0 then
    display "* ERROR : Statement failed for select count from ",pv_table
    call fatal_error()
  end if

  if v_rec_count = 0 then
    display "- WARN : Row(s) do not exist in ",pv_table
    return 0
  else

    begin work
    display v_rec_count," records selected for update"
    let v_stmt = "select * from ",pv_table,
                 " where ",pv_where,
                 " and ",pv_col_upd," <> ",pv_val_upd

    prepare sel_tab_s from v_stmt
    let v_status= status
    if v_status <> 0 then
      display "* ERROR : failed to prepare statement sel_table_s "
      call fatal_error()
    end if
    declare sel_tab_c cursor with hold for sel_tab_s
    let v_status= status
    if v_status <> 0 then
      display "* ERROR : failed to declare cursor sel_table_c "
      call fatal_error()
    end if

    foreach sel_tab_c into v_table_rec.*
      let v_status = status
      if v_status <> 0 then
        let v_totcount = v_totcount + v_count
        display "* ERROR ",v_status," occurred while updating records in ",
                pv_table,". Records updated so far:",v_totcount,"."
        call fatal_error()
      end if

###############################################################################
#Please complete this block to specify your own update logic
#let v_stmt =
###############################################################################

      execute immediate v_stmt
      let v_status= status
      if v_status <> 0 then
        display "* ERROR : failed to prepare statement sel_table_s ?"
        call fatal_error()
      end if

      let v_count = v_count + 1
      if v_count > 1000 then
        commit work
        begin work
        let v_totcount = v_totcount + v_count
        let v_count = 0
        display ' ... committed the ',v_totcount using "<<<<<<<<",' records updated so far ...'
      end if
    end foreach
  end if
  let v_totcount = v_totcount + v_count

  case v_status
    when 0       # Things are OK
      commit work

    otherwise
      rollback work
      call fatal_error()
  end case
  return v_totcount

end function

#----------------------------------------------------------------------#
function delete_token_and_lock(pv_token)
#----------------------------------------------------------------------#
  define pv_token              varchar(100)

  define v_success             smallint,
         v_table               varchar(30),
         v_where_condition_str varchar(500),
         v_token_num           integer,
         v_locknum             integer

  display "Deleting token ", pv_token

  select token_num into v_token_num
    from en_token
   where token_name = pv_token
  let v_status = status

  case
    when v_status = 0
      declare lock_c cursor for
        select locknum from sec_lock
          where token_num = v_token_num
      let v_status = status

      case
        when v_status = 0
          foreach lock_c into v_locknum
            #--------------------- SEC_UGROUPLOCK -----------------------#
            let v_table = "sec_ugrouplock"

            if v_status = 0 then
              let v_where_condition_str = "locknum = ",v_locknum
              let v_success = delete_a_row(v_table,v_where_condition_str)
            end if

            #--------------------- SEC_FGROUPLOCK -----------------------#
            let v_table = "sec_fgrouplock"

            if v_status = 0 then
              let v_where_condition_str = "locknum = ",v_locknum
              let v_success = delete_a_row(v_table,v_where_condition_str)
            end if

            #--------------------- SEC_USERLOCK -----------------------#
            let v_table = "sec_userlock"

            if v_status = 0 then
              let v_where_condition_str = "locknum = ",v_locknum
              let v_success = delete_a_row(v_table,v_where_condition_str)
            end if
          end foreach

        otherwise
          display "* ERROR: ",v_status," failed to select lock numbers for token ", pv_token
          call fatal_error()
      end case

      #--------------------- EN_HELP_MAP -----------------------#
      let v_table = "en_help_map"

      if v_status = 0 then
        let v_where_condition_str = "token_num = ",v_token_num
        let v_success = delete_a_row(v_table,v_where_condition_str)
      end if

      #--------------------- SEC_LOCK -----------------------#
      let v_table = "sec_lock"

      if v_status = 0 then
        let v_where_condition_str = "token_num = ",v_token_num
        let v_success = delete_a_row(v_table,v_where_condition_str)
      end if

      #--------------------- EN_TOKEN -----------------------#
      let v_table = "en_token"

      if v_status = 0 then
        let v_where_condition_str = "token_num = ",v_token_num
        let v_success = delete_a_row(v_table,v_where_condition_str)
      end if

    when v_status = 100
      let v_status = 0

    otherwise
      display "* ERROR: ",v_status," failed to select token_num for token ", pv_token
      call fatal_error()
  end case

  return v_success

end function

#----------------------------------------------------------------------#
function insert_token(pv_token_name, pv_token_descr, pv_entity_type, pv_lock_type)
#----------------------------------------------------------------------#
  define pv_token_name         varchar(29),
         pv_token_descr        varchar(70),
         pv_entity_type        char(1),
         pv_lock_type          integer

  define v_success             smallint,
         v_table               varchar(30),
         v_col_str             varchar(200),
         v_values_str          varchar(1000),
         v_token_num           integer

  let v_success = 0

  #---------- Insert data into en_token -------------------
  let v_table = "en_token"

  let v_col_str = "token_num, token_name, token_descr, entity_type"
  let v_values_str = "0, '", pv_token_name, "', '", pv_token_descr,
                     "', '", pv_entity_type, "'"

  if pv_lock_type is not null and pv_lock_type != " " then
    let v_col_str = v_col_str clipped, ", lock_type"
    let v_values_str = v_values_str clipped, ", ", pv_lock_type
  end if

  let v_success = insert_a_row(v_table, v_col_str, v_values_str)

  if v_status = 0 then
    select token_num into v_token_num
      from en_token
      where token_name = pv_token_name

    let v_status = status
    if v_status <> 0 then
      display "\nERROR : Selecting from table en_token."
      call fatal_error()
    end if
  end if

  return v_success, v_token_num

end function


#----------------------------------------------------------------------#
function insert_lock(pv_token_num, pv_lockname, pv_descr)
#----------------------------------------------------------------------#
  define pv_token_num          integer,
         pv_lockname           varchar(30),
         pv_descr              varchar(70)

  define v_success             smallint,
         v_table               varchar(30),
         v_column              varchar(30),
         v_col_str             varchar(200),
         v_values_str          varchar(1000),
         v_locknum             integer

  let v_success = 0

  #---------- Insert data into sec_lock -------------------
  let v_table = "sec_lock"
  let v_column = "locknum"
  let v_col_str = "locknum, lockname, descr, token_num"

  if v_status = 0 then
    let v_locknum = get_max_id(v_table, v_column, "")
    let v_values_str = v_locknum, ",'", pv_lockname, "', '", pv_descr, "', ", pv_token_num
    let v_success = insert_a_row(v_table, v_col_str, v_values_str)
  end if

  return v_success

end function

#----------------------------------------------------------------------#
function get_product_version()
#----------------------------------------------------------------------#
  define v_lic_ver  varchar(4),
         v_stmt     varchar(100)

  let v_stmt = "select substr(licensee_version, 0, 4) from en_licensee"
  prepare v_lic_stmt from v_stmt
  execute v_lic_stmt into v_lic_ver

  if v_status <> 0 then
    display "* ERROR : Failed to select from en_licensee"
    call fatal_error()
  end if
  return v_lic_ver

end function

#----------------------------------------------------------------------#
function add_a_ff_field(pv_field_code, pv_priority)
#----------------------------------------------------------------------#
  define
    pv_field_code          varchar(30),
    pv_priority            integer,

    v_table                varchar(30),
    v_table2               varchar(30),
    v_col_str              varchar(200),
    v_col_str2             varchar(200),
    v_field_id             integer,
    v_values_str           varchar(2000),
    v_cond_field_id        integer,
    v_param1               integer,
    v_success              smallint

  let v_success = TRUE

  let v_table = "ff_fields"
  let v_col_str = "FIELD_ID, FIELD_NAME, DATA_TYPE, ENTITY_TYPE, ENTITY_TYPE_ATTR, IS_CUSTOM, PRIORITY, READ_ONLY, DISPLAY_ONLY, SAVETO_CLASS, SEARCHABLE, DISPLAY_SUMMARY, WIDGET_TYPE, FIELD_CODE"

  let v_table2 = "ff_field_val"
  let v_col_str2 = "FIELD_VAL_ID, FIELD_ID, VALIDATION_RULE, PARAM1, PARAM2"

  let v_field_id = get_ptj_ff_field_id(pv_field_code)

  if v_field_id <> 0 then
     display "\n- WARN : PTJ Custom Field '" || pv_field_code || "' already exists."
     return v_success
  end if

  case  pv_field_code
    when 'Coordination Req'

      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'list', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '7', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', null, null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Yes', 'Yes'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'No', 'No'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'Coordinating Name'

      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '107', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_param1 =  get_ptj_ff_field_id('Coordination Req')
      let v_values_str = "0, " || v_field_id || ", 'CondIsReq', "|| v_param1 || ", 'Yes'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'Coordinating Phone'

      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '200', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_param1 =  get_ptj_ff_field_id('Coordination Req')
      let v_values_str = "0, " || v_field_id || ", 'CondIsReq', "|| v_param1 || ", 'Yes'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'MFN Priority'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '2', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'MFN Supply Off'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'list', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '40', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', null, null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Remove Fuse', 'Remove Fuse'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Remote', 'Remote'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Local Meter Disconnection', 'Local Meter Disconnection'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Pillar-Box Pit Or Pole-Top', 'Pillar-Box Pit Or Pole-Top|'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

   when 'Concurrent Supply Approved'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'list', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '7', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', null, null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Yes', 'Yes'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'No', 'No'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'Metering Safety Certificate ID'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '15', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'MSC Method Sent'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'list', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '10', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', null, null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Faxed', 'Faxed'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Email', 'Email'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'Online', 'Online'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

      let v_values_str = "0, " || v_field_id || ", 'LBValidVal', 'OnSite', 'OnSite'"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'Registered Contractor Name'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '107', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'REC Business Name'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '200', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'REC Phone'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '19', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'REC License Number'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '20', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'REC Attendance Required'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'boolean', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"
     let v_success = insert_a_row(v_table, v_col_str, v_values_str)

    when 'REC Form Reference'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '30', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    when 'REC Form Number'
      let v_values_str =
        "0, '" || pv_field_code ||
        "', 'text', 'PROC', 'MKTIF', 'Y'," ||
        pv_priority || ", 'N', 'N', 'PROC-MKTIF', 'N', 'N', 'TextBox', '" ||
        pv_field_code || "'"

      let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_values_str = "0, " || v_field_id || ", 'maxlength', '15', null"
      let v_success = insert_a_row(v_table2, v_col_str2, v_values_str)

    otherwise

  end case
  return v_success
end function

#----------------------------------------------------------------------#
function update_a_ff_field(pv_field_code)
#----------------------------------------------------------------------#
  define
    pv_field_code          varchar(30),
    pv_priority            integer,

    v_table                varchar(30),
    v_table2               varchar(30),
    v_col_str              varchar(200),
    v_field_id             integer,
    v_values_str           varchar(2000),
    v_col_upd              varchar(30),
    v_val_upd              varchar(500),
    v_where                varchar(500),
    v_row_count            integer,

    v_success              smallint

  let v_success = TRUE

  let v_table = "ff_fields"
  let v_table2 = "ff_field_val"
  let v_col_str = "FIELD_VAL_ID, FIELD_ID, VALIDATION_RULE, PARAM1, PARAM2"

  case  pv_field_code
    when 'Metering Required'
      let v_field_id = get_ptj_ff_field_id(pv_field_code)

      let v_col_upd = 'DATA_TYPE'
      let v_val_upd = "'text'"
      let v_where = "field_id = " || v_field_id
      let v_row_count = update_rows(v_table, v_col_upd, v_val_upd, v_where)

      if v_status = 0 then
        let v_success = update_a_ff_field_val(pv_field_code,'maxlength', '240')
      end if

    when 'Switching Service Required'
      let v_field_id = get_ptj_ff_field_id(pv_field_code)
      let v_col_upd = 'DATA_TYPE'
      let v_val_upd = "'text'"
      let v_where = "field_id = " || v_field_id
      let v_row_count = update_rows(v_table, v_col_upd, v_val_upd, v_where)

      if v_status = 0 then
        let v_success = update_a_ff_field_val(pv_field_code,'maxlength', '80')
      end if
    otherwise

  end case
  return v_success
end function

#----------------------------------------------------------------------#
function update_a_ff_field_priority(pv_field_code, pv_priority)
#----------------------------------------------------------------------#
  define
    pv_field_code          varchar(30),
    pv_priority            integer,

    v_field_id             integer,
    v_where                varchar(500),
    v_row_count            integer,

    v_success              smallint

  let v_success = TRUE
  let v_field_id = get_ptj_ff_field_id(pv_field_code)
  let v_where = "field_id = " || v_field_id
  let v_row_count = update_rows( "ff_fields", "PRIORITY", pv_priority, v_where)

  return v_success
end function

#----------------------------------------------------------------------#
function update_a_ff_field_val(pv_field_code, pv_validation_rule, pv_param1)
#----------------------------------------------------------------------#
  define
    pv_field_code          varchar(30),
    pv_validation_rule     varchar(10),
    pv_param1              varchar(200),

    v_table                varchar(30),
    v_col_str              varchar(200),
    v_field_id             integer,
    v_values_str           varchar(2000),
    v_col_upd              varchar(30),
    v_val_upd              varchar(500),
    v_where                varchar(500),
    v_count                integer,
    v_count2               integer,

    v_success              smallint

  let v_success = TRUE

  let v_table = "ff_field_val"
  let v_col_str = "FIELD_VAL_ID, FIELD_ID, VALIDATION_RULE, PARAM1, PARAM2"

  let v_field_id = get_ptj_ff_field_id(pv_field_code)

  case  pv_validation_rule
    when 'maxlength'

      select count(*) into v_count
        from ff_field_val
      where field_id =  v_field_id

      select count(*) into v_count2
        from ff_field_val
        where field_id =  v_field_id
        and validation_rule = 'maxlength'

      if v_count = 1 and v_count2 = 1 then
        #do nothing
      else
        let v_where = "field_id = " || v_field_id
        let v_success = delete_a_row(v_table, v_where)

        let v_values_str = "0, " || v_field_id || ", 'maxlength', " || pv_param1 ||
          ", null"
        let v_success = insert_a_row(v_table, v_col_str, v_values_str)
      end if

    otherwise

  end case
  return v_success
end function

#----------------------------------------------------------------------#
function get_ptj_ff_field_id(pv_field_code)
#----------------------------------------------------------------------#
  define
    pv_field_code    varchar(30),
    v_field_id       integer

  let v_field_id = 0

  select field_id into v_field_id
    from ff_fields
    where entity_type = 'PROC'
    and entity_type_attr = 'MKTIF'
    and (field_name =  pv_field_code or field_code = pv_field_code)

  case v_status
  when 0
    # Do nothing.
  when 100
    let v_status = 0
    let v_field_id = 0
  otherwise
    display "* ERROR ", v_status, " occurred while retrieving",
            " field_id for ", pv_field_code
    call fatal_error()
  end case

  return v_field_id
end function

#----------------------------------------------------------------------#
function warn_dev_about_P808_table_partitions()
#----------------------------------------------------------------------#
  if get_product_version() = "8.08" then
    display "[1;33;40mWARNING: It appears you are creating a schema script for Peace 8.08[0m\n"

    display "[1;30mPlease consider that Direct Energy have partitioned some tables on site"
    display "and your script may introduce changes that are undesirable or ones that"
    display "will not work\n"

    display "Tables (that we are aware of) which are affected by this are (last updated - 5 Dec 2016):[0;31m"

    display "AR_ALLOC"
    display "AR_DALLOC"
    display "AR_JOURNAL"
    display "AR_REVERSAL_HIST"
    display "AR_STATEMENT"
    display "AR_TRANSACTION"
    display "BK_CSH_HIST"
    display "CC_EVENT"
    display "CC_EVENT_PROCESS"
    display "EB_INVOICE"
    display "EB_INV_ITEM"
    display "GLI_TRANS"
    display "MKTSOLNDB.TRANSACTION"
    display "MKTSOLNDB.TRANSACTION_STATUS_HISTORY"
    display "PRT_PROCESS"
    display "PRT_PROCESS_TRANS"
    display "XB_INVOICE"
    display "XB_INV_ITEM"

    display "\n[1;30mOperations which should work are (not exhaustive): [0;31m"
    display "inserting/updating/deleting data"
    display "adding/deleting columns"
    display "changing column datatypes"
    display "adding/deleting triggers"


    display "\n[1;31mHowever, it is your responsibility to do some research on how your script will"
    display "affect partitioned tables (if at all), and to take the appropriate steps"
    display "to ensure your script is written with this in mind[0m\n"

    display "[1;32;40m\nOnce you have considered this you may delete the call to this function to get rid of this message"
    display "[0m"
    call fatal_error();
  end if

end function