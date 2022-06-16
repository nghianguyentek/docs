# pub_register.4gl
## pre_del_register(pv_premnum, pv_util_type, pv_servicenum, pv_registernum, pv_change_date)
- 
## pub_d_register(pv_register_rec, pv_stmt_excl, pv_removal_date)
- `pv_register_rec`: the given `ENERGYDB.PM_REGISTER` record
- `pv_stmt_excl`: if true, deleting the corresponding `ENERGYDB.PM_STMT_EXCLUSION` record
- `pv_removal_date`:

Delete a register.

## pre_add_register(pv_premnum, pv_util_type, pv_servicenum, pv_registernum, pv_change_date)
- pv_premnum
- pv_util_type
- pv_servicenum
- pv_registernum
- pv_change_date

Only if there is no register is attached to the given service.
## pub_a_register(pv_register_rec, pv_stmt_excl, pv_tariffclass, pv_reg_install_date)
- pv_register_rec: the given `ENERGYDB.PM_REGISTER` record
- pv_stmt_excl: if true, adding the corresponding `ENERGYDB.PM_STMT_EXCLUSION` record
- pv_tariffclass:
- pv_reg_install_date

Add a register:
- Insert a new 