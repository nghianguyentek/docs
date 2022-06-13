# MS (Market Solution)
## Terms
| Term | Description                                                                                                                                                                                           |
|------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| LNSP | A Local Network Service Provider (aka DNSP-Distributed Network Service Provider or LDNSP-Local Distribution Network Service Provider) owns, operates, or controls the transmissions or distributions. |
| FRMP | A Financially Responsible Market Participant makes or receives payments, often a service retailer.                                                                                                    |
| LNSP | A Local Network Service Provider (aka DNSP-Distributed Network Service Provider or LDNSP-Local Distribution Network Service Provider) owns, operates, or controls the transmissions or distributions. |

## Schema
### Market participants
Market participants are stored in `MKTSOLNDB.PARTICIPANT_MAPPING`. Actually, `MKTSOLNDB.PARTICIPANT_MAPPING` keeps the one-one mappings between external participants and Peace's participants, `ENERGYDB.PM_MKT_PARTY` (Why?). Their roles, on the other hand, are stored in `MKTSOLNDB.PARTICIPANT_ROLE_MAPPING` and `ENERGYDB.PM_MKT_PARTY_ROLE`. There is also having a one-to-one relationship between `ENERGYDB.PM_MKT_PARTY_ROLE` and `ENERGYDB.PM_SYSTEM_ROLE` as
```roomsql
SELECT
	mpr.SYSTEM_ROLE,
	sr.DESCR,
	mpr.PARTICIPANT_ROLE,
	mpr.DESCR
FROM
	(
	SELECT
		SYSTEM_ROLE,
		PARTICIPANT_ROLE,
		DESCR
	FROM
		pm_mkt_party_role
	WHERE
		ID_TYPE = 'R'
	GROUP BY
		SYSTEM_ROLE,
		PARTICIPANT_ROLE,
		DESCR) mpr
JOIN pm_system_role sr ON
	mpr.SYSTEM_ROLE = sr.SYSTEM_ROLE;
```
#### NMI (National Meter Identifier) or PMID (Premise Market IDentifier)
There is a mapping between NMI and the corresponding premise and stored in `ENERGYDB.PM_EXTREF_MKTID`.
#### Public NTC (Network Tariff Code) flag
### External references
External references are stored in `ENERGYDB.PM_SVC_DELIV_PT` and `ENERGYDB.PM_SDP_ROLE` tables, and they have the one-to-many relationship on `SDP_CODE`.
#### pm_svc_deliv_pt table (Premise_Service_Delivery_Party?)
In the `ENERGYDB.PM_SVC_DELIV_PT` table, the `SDP_TYPE` decides the meanings and existences of `REF_NO1` and `REF_NO2`, including `UTIL_TYPE` (**It might be a bad design**). If it is:
- C(ustomer): `REF_NO1` holds customer number.
- P(remise): `REF_NO1` holds the premise number.
- M(etered Service): `REF_NO1` and `REF_NO2` hold the premise and service numbers, respectively, and `UTIL_TYPE` exists.
- U(nmetered Installation): `REF_NO1` contains the installation number.
#### pm_sdp_role table (Premise_Service-Delivery-Party_Role?)



