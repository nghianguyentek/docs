# Hansen terms
## Tariff
*Wrong term*

In general, a tariff is an (exported or imported) charge, usually based on the utility consumption in a deregulated energy market. In CIS, it means price.
### Schema
#### ENERGYDB.TM_TARIFF
#### ENERGYDB.TM_TARIFF_CLASS
For what?
### Related terms
- [NTC](#ntc-network-tariff-code)
- [Register](#register)
## NTC (Network Tariff Code)
*Wrong term*
### Schema
#### MKTSOLNDB.CATS_NETWORK_TARIFF_CODES
`MKTSOLNDB.CATS_NETWORK_TARIFF_CODES` contains NTC information (mostly of NEMMCO).
#### MKTSOLNDB.CATS_PARTICIPANTS
In MS, a NTC must exist in `MKTSOLNDB.CATS_PARTICIPANTS` (i.e, `PARTICIPANTID`).
#### ENERGYDB.TM_PRICE_COMP_INFO
`ENERGYDB.TM_PRICE_COMP_INFO` contains mappings between [ENERGYDB.TM_TARIFF](#energydbtm_tariff)#TARIFFCLASS (`PRICE_COMP_CODE`) and the corresponding NTC (`PARTICIPANT_CODE`).

*WTF: Because `PARTICIPANT_CODE` datatype is `CHAR(10)`, we have to use `TRIM(PARTICIPANT_CODE)` for every comparison.*
### Related terms
- [Tariff](#tariff)
## Register
A register is identified by `PREMNUM`, `SERVICENUM`, `UTIL_TYPE`, and `REGISTERNUM`.
### Schema
#### ENERGYDB.PM_REGISTER
#### ENERGYDB.PM_TARIFF
`ENERGYDB.PM_TARIFF` contains the relationship between register and [tariff](#tariff) (`TARIFFCLASS`).
### Related terms
- [Tariff](#tariff)