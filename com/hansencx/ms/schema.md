# Schema
## ENERGYDB.PM_MKT_ROLE_CODE
`ENERGYDB.PM_MKT_ROLE_CODE` table contains available mappings between `PARTICIPANT_CODE` and `PARTICIPANT_ROLE`.

## MKTSOLNDB."TRANSACTION"
`MKTSOLNDB."TRANSACTION"` table contains all MS transactions.
```roomsql
SELECT
	TRANSACTION_ID,
	EXTERNAL_ID ,
	UNIQUE_SERVICE_ID,
	TRANSACTION_TYPE,
	CR_CODE,
	DIRECTION,
	CATS_REQUEST_ID,
	STATUS_CODE,
	MARKET_STATUS_CODE
FROM
	MKTSOLNDB."TRANSACTION"
```