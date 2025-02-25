create or replace sequence SEQ_DW_JOB_EXECUTION_LOG_JOB_RUN_ID start with 1 increment by 1 order;

create or replace sequence SEQ_AUDIT_LOG start with 1 increment by 1 order;



CREATE OR REPLACE PROCEDURE MRC_SBX_PLF.FOM_CONFIG.example_procedure_1()
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
AS
$$

try {
  var sqlCmd = "";
  var sqlStmt = "";
  var result = "";
  var exe_qry_table ="";

var resultArraySchema = [];
var resultArrayTargetTable = [];
var resultError=[];
var resultList = [];

    // Example query to get some data (replace with your actual SQL logic)
    sqlCmd= `select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE ='MRC_SBX_PLF' AND DATASOURCE_SCHEMA = 'FOM_ENCOMPASS' AND JOB_ID IN (1,2)`;
    
    // Execute the query and fetch the results
    SqlStmt= snowflake.createStatement( {sqlText: sqlCmd} );
	exe_qry_table = SqlStmt.execute();
	exe_qry_table.next();
    
    while (exe_qry_table.next()) {
        var value = exe_qry_table.getColumnValue(5);  // Get the first column value (since we are selecting one column)
        resultList.push(value);  // Add the value to the resultList array
    }
    
  // Return the resultList as a string (you can also return it as JSON or process it as needed)
    return "Values stored in list: " + resultList.join(', ');  // Joins values with commas
    
} catch (err) {
    // Catch and return any errors that occur
    return "Error: " + err.message;
}

$$;


select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where JOB_ID in (1,2);
select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG at (OFFSET =>-60*20)
where JOB_ID in (1,2);
INSERT INTO MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG(
select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG BEFORE(STATEMENT => '01b9376d-0003-9f2e-0002-712e03a0fa6a')
where JOB_ID in (1));

describe table MRC_SBX_PLF.FOM_CONFIG.TBL_AUDIT;
select * from MRC_SBX_PLF.DATA_FOM.DYNAMIC_PRACTICE;

--https://xr73945.us-central1.gcp.snowflakecomputing.com

update MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG 
SET ACTIVE_STATUS =FALSE,
FILTER_CONDITION=''
where JOB_ID in (1);

update MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG 
SET JOB_ID =2
where DATASOURCE_DATABASE ='MRC_SBX_PLF' AND DATASOURCE_SCHEMA = 'FOM_ENCOMPASS' AND DATASOURCE_TARGET_TABLE ='TBL_ENC_EMPLOYMENT';

delete from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where JOB_ID =1;


update MRC_SBX_PLF.FOM_ENCOMPASS.TBL_ENC_BORROWER_DELTA
SET LOAD_DTTM=CURRENT_TIMESTAMP();


update MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG 
SET TABLE_COLUMNS='LOANNUMBER,ALTID,OWNER,ADDRESSCITY,ADDRESSPOSTALCODE,ADDRESSSTATE,ADDRESSSTREETLINE1,COUNTRYCODE,UNITNUMBER,UNITTYPE,CURRENTEMPLOYMENTINDICATOR,EMPLOYERNAME,PHONENUMBER,POSITIONDESCRIPTION,TIMEONJOBTERMYEARS,TIMEONJOBTERMMONTHS,STARTDATE,ENDDATE,MONTHLYINCOMEAMOUNT,EMPLOYMENTMONTHLYINCOMEAMOUNT,SELFEMPLOYEDINDICATOR,MILITARYEMPLOYER,SPECIALEMPLOYERRELATIONSHIPINDICATOR,BASEPAYAMOUNT,OVERTIMEAMOUNT,BONUSAMOUNT,COMMISSIONSAMOUNT,OTHERAMOUNT,MILITARYENTITLEMENT,OWNERSHIPINTERESTTYPE,LOAD_DTTM'
where DATASOURCE_DATABASE='MRC_SBX_PLF' AND DATASOURCE_SCHEMA='FOM_ENCOMPASS' AND DATASOURCE_SOURCE_TABLE='TBL_ENC_EMPLOYMENT_DELTA';

call MRC_SBX_PLF.FOM_CONFIG.SP_DYNAMIC_MERGE ('FOM_ENCOMPASS','TBL_ENC_BORROWER');
call MRC_SBX_PLF.FOM_CONFIG.SP_DYNAMIC_MERGE ('FOM_ENCOMPASS','TBL_ENC_EMPLOYMENT');
call MRC_SBX_PLF.FOM_CONFIG.SP_MULTY_MERGE_TEST();
call MRC_SBX_PLF.FOM_CONFIG.WRAPPER_PROCEDURE_TEST2();
call MRC_SBX_PLF.FOM_CONFIG.WRAPPER_PROCEDURE_TEST3();
call MRC_SBX_PLF.FOM_CONFIG.WRAPPER_PROCEDURE_TEST4();
call MRC_SBX_PLF.FOM_CONFIG.WRAPPER_PROCEDURE_TEST5();
call MRC_SBX_PLF.FOM_CONFIG.example_procedure();
call MRC_SBX_PLF.FOM_CONFIG.example_procedure_1();
select * from MRC_SBX_PLF.FOM_CONFIG.TBL_AUDIT order by STARTTIME desc;
SELECT EXECUTION_STATUS,ERROR_MESSAGE,START_TIME,END_TIME,* FROM table(MRC_SBX_PLF.information_Schema.query_history_by_user()) where start_time > '2024-12-26 21:15:48.163 -0600' order by 2 desc ;
select current_timestamp();
SELECT EXECUTION_STATUS,ERROR_MESSAGE,START_TIME,END_TIME,* FROM table(MRC_SBX_PLF.information_Schema.query_history_by_user()) where QUERY_ID='01b94e25-0003-a5bb-0002-712e03ae80ca';

SELECT EXECUTION_STATUS,CASE WHEN EXECUTION_STATUS ='SUCCESS' AND ERROR_MESSAGE is null then 'SUCCESS' else EXECUTION_STATUS||':'||ERROR_MESSAGE end ERROR_MESSAGE,START_TIME,END_TIME,* FROM table(MRC_SBX_PLF.information_Schema.query_history_by_user()) where QUERY_ID='01b94e2c-0003-a5bb-0002-712e03ae812a';

SELECT CASE WHEN  A.EXECUTION_STATUS = 'FAILED_WITH_ERROR' AND B.ACTIVE_STATUS = FALSE THEN 'Table Status is Inactive in Config table' else A.EXECUTION_STATUS END as EXECUTION_STATUS from table(MRC_SBX_PLF.INFORMATION_SCHEMA.QUERY_HISTORY_BY_USER()) A
       LEFT JOIN (SELECT  DATASOURCE_DATABASE,DATASOURCE_SCHEMA,DATASOURCE_SOURCE_TABLE,DATASOURCE_TARGET_TABLE,ACTIVE_STATUS from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where DATASOURCE_SCHEMA ='FOM_ENCOMPASS' AND DATASOURCE_TARGET_TABLE = 'TBL_ENC_EMPLOYMENT')B
       ON A.DATABASE_NAME=B.DATASOURCE_DATABASE AND A.SCHEMA_NAME =B.DATASOURCE_SCHEMA       
                 WHERE A.QUERY_ID = (SELECT LAST_QUERY_ID(-3));


select * from MRC_SBX_PLF.FOM_ENCOMPASS.TBL_ENC_BORROWER_DELTA;
select * from MRC_SBX_PLF.FOM_ENCOMPASS.TBL_ENC_BORROWER;
SELECT DENSE_RANK() OVER(ORDER BY LOANNUMBER)RNK,* FROM MRC_SBX_PLF.FOM_ENCOMPASS.TBL_ENC_BORROWER_DELTA;
select length(LOANNUMBER),Length(BORROWERPOSITION),length(altid),length(LOAD_DTTM) from MRC_SBX_PLF.FOM_ENCOMPASS.TBL_ENC_BORROWER_DELTA;
select * from table(MRC_SBX_PLF.information_Schema.query_history_by_user()) order by start_time desc;
            where b.query_id = (select last_query_id(-1)
;

/*//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

CREATE OR REPLACE PROCEDURE MRC_SBX_PLF.FOM_CONFIG.EXAMPLE_PROCEDURE()
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
{
var sqlCmd = "";
var sqlStmt = "";
var result = "";
var exe_qry_table ="";
var resultArraySchema = [];
var resultArrayTargetTable = [];
var table_status =[];
var result_set = [];

// Example query to get some data (replace with your actual SQL logic)

    sqlCmd= `select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE ='MRC_SBX_PLF' AND DATASOURCE_SCHEMA = 'FOM_ENCOMPASS' AND JOB_ID IN (1,2)`;
    
    // Execute the query and fetch the results
    sqlStmt= snowflake.createStatement( {sqlText: sqlCmd} );
	exe_qry_table = sqlStmt.execute();
	//exe_qry_table.next();

// Loop through the result set and collect data into the array
    while (exe_qry_table.next()) {
        var Schema_value = exe_qry_table.getColumnValue(3);  // Get the Schema column value
		var TargetTable_value = exe_qry_table.getColumnValue(5);  // Get the Target table column value
        //resultArraySchema.push(Schema_value);
        resultArrayTargetTable.push(TargetTable_value);  // Push it into the resultArray
        //var Status_value = exe_qry_table.getColumnValue(14);
        table_status.push(exe_qry_table.getColumnValue(14));  // Push it into the resultArray
        
	}

try {   
        for (var j = 0;j < resultArrayTargetTable.length; j++) {
        var Target_table = resultArrayTargetTable[j]; 
        
        sqlStmt = snowflake.execute({sqlText: `call MRC_SBX_PLF.FOM_CONFIG.SP_DYNAMIC_MERGE('FOM_ENCOMPASS','${Target_table}')` }); 
       
        sqlCmd = `SELECT CASE WHEN EXECUTION_STATUS ='SUCCESS' AND ERROR_MESSAGE is null then 'SUCCESS' else EXECUTION_STATUS||':'||ERROR_MESSAGE end MESSAGE_STATUS from table(MRC_SBX_PLF.INFORMATION_SCHEMA.QUERY_HISTORY_BY_USER()) B WHERE B.QUERY_ID = (SELECT LAST_QUERY_ID(-3))`;
        sqlStmt = snowflake.createStatement( {sqlText: sqlCmd} );
        rs = sqlStmt.execute();
        
    while (rs.next()) {
        //var status = rs.getColumnValue(1);  // Get the Schema column value
        var message = "\n" +"FOM_ENCOMPASS."+`${Target_table}`+ ":" + rs.getColumnValue(1);
		result_set.push(message); // Push it into the resultArray
	}

 }
}

catch (err) {
var ERROR = "FAILED_WITH_ERROR: Code: " + err.code + " | State: " + err.state;

result = snowflake.execute({sqlText: `SELECT DATASOURCE_SCHEMA,DATASOURCE_SOURCE_TABLE,DATASOURCE_TARGET_TABLE,CASE WHEN ACTIVE_STATUS =FALSE THEN 'Table Status is Inactive in Config table. Hence Procedure developed not to throw as Error.' else '${ERROR}' END as ERROR from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE ='MRC_SBX_PLF' AND DATASOURCE_SCHEMA = 'FOM_ENCOMPASS' AND DATASOURCE_TARGET_TABLE ='${Target_table}'`});

result.next();

        var message = "\n" +"FOM_ENCOMPASS."+`${Target_table}`+ ":" + result.getColumnValue(4);;
		result_set.push(message); // Push it into the resultArray
    
    var Insert_status_SP = `INSERT INTO MRC_SBX_PLF.FOM_CONFIG.TBL_AUDIT 
			select 
			MRC_SBX_PLF.FOM_CONFIG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
			B.query_id as QUERY_ID,
			CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.START_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) START_TIME,
			CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.END_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) END_TIME,
            B.QUERY_TEXT,
            '`+result.getColumnValue(2)+`' as SOURCE,
            '`+result.getColumnValue(3)+`' as TARGET,
            B.EXECUTION_STATUS,
            --B.ERROR_MESSAGE as EXEC_MESSAGE,
            '`+result.getColumnValue(4)+`' as EXEC_MESSAGE,
		    B.ROWS_INSERTED,
		    0 as ROWS_UPDATED,
		    B.USER_NAME
			from table(MRC_SBX_PLF.information_Schema.query_history_by_user()) B
            where b.query_id = (select last_query_id(-2));
			`;
			var Execution_status_SP = snowflake.execute({sqlText: Insert_status_SP});
			Execution_status_SP.next();
    }
    
// Catch the error and throw a custom error message

var failed_message = result_set.join(', '); 
if (failed_message.match(/FAILED_WITH_ERROR/i)) {
        throw result_set.join(', ')+ ";";
    } else {
        return result_set.join(', ')+ ";";
    }
}



$$;

/*********************************************************************************************************************************************************
*********************************************************************************************************************************************************/


CREATE OR REPLACE PROCEDURE MRC_SBX_PLF.FOM_CONFIG.example_procedure_1()
  RETURNS STRING
  LANGUAGE JAVASCRIPT
  EXECUTE AS CALLER
AS
$$

try {
  var sqlCmd = "";
  var sqlStmt = "";
  var result = "";
  var exe_qry_table ="";

var resultArraySchema = [];
var resultArrayTargetTable = [];
var resultError= [];
var resultList = [];

    // Example query to get some data (replace with your actual SQL logic)
    sqlCmd= `select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE ='MRC_SBX_PLF' AND DATASOURCE_SCHEMA = 'FOM_ENCOMPASS' 
    AND JOB_ID IN (1,2)`;
    
    // Execute the query and fetch the results
    SqlStmt= snowflake.createStatement( {sqlText: sqlCmd} );
	exe_qry_table = SqlStmt.execute();
	//exe_qry_table.next();
    
    //var rowIndex = 1;
   while (exe_qry_table.next()) {
        var value = exe_qry_table.getColumnValue(5);  // Get the first column value (since we are selecting one column)
        resultList.push(value);  // Add the value to the resultList array
    }
    
  // Return the resultList as a string (you can also return it as JSON or process it as needed)
    return "Values stored in list: " + resultList.join(', ');  // Joins values with commas
    //return resultList;
} catch (err) {
    // Catch and return any errors that occur
    return "Error: " + err.message;
}

//return 'Success';

$$;

/*********************************************************************************************************************************************************
*********************************************************************************************************************************************************/

CREATE OR REPLACE PROCEDURE MRC_SBX_PLF.FOM_CONFIG.WRAPPER_PROCEDURE_TEST5()
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS CALLER
AS 
$$
DECLARE
error_message STRING;
result STRING;
temp_value STRING; 
BEGIN

/* get every database that we want to check */
let databases_q cursor for (
select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG
where DATASOURCE_DATABASE = 'MRC_SBX_PLF' AND DATASOURCE_SCHEMA = 'FOM_ENCOMPASS' AND JOB_ID IN (1,2)
);

/*open FOR loop over database cursor and assign variables*/
FOR dbs in databases_q DO
let Schema string := dbs.DATASOURCE_SCHEMA;
let Source_Table string := dbs.DATASOURCE_SOURCE_TABLE;
let Target_Table string := dbs.DATASOURCE_TARGET_TABLE;
let Table_Active_Status BOOLEAN := dbs.ACTIVE_STATUS;

BEGIN

call MRC_SBX_PLF.FOM_CONFIG.SP_DYNAMIC_MERGE(:Schema,:Target_Table);

EXCEPTION

WHEN OTHER THEN

let Exe_status cursor for (
SELECT * FROM table(MRC_SBX_PLF.information_Schema.query_history_by_user()) where query_id = (select last_query_id(-1))
);

for exe_message in Exe_status DO
let EXECUTION_STATUS string := exe_message.EXECUTION_STATUS;
let QUERY_TEXT string :='call MRC_SBX_PLF.FOM_CONFIG.SP_DYNAMIC_MERGE('||:Schema||','||:Target_Table||')';
let error_message string := 'Error in statement Merge executing for '|| :Target_Table;
LET result string := result || :error_message ||', ';

INSERT INTO MRC_SBX_PLF.FOM_CONFIG.TBL_AUDIT 
			select 
			MRC_SBX_PLF.FOM_CONFIG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
			B.query_id as QUERY_ID,
			CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.START_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) START_TIME,
			CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.END_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) END_TIME,
            :QUERY_TEXT as QUERY_TEXT,
            :Source_Table as SOURCE,
            :Target_Table as TARGET,
            B.EXECUTION_STATUS,
		    CASE WHEN :Table_Active_Status = FALSE Then :error_message ||':Table Status is Inactive in Config table' else B.ERROR_MESSAGE End as EXEC_MESSAGE,
		    B.ROWS_INSERTED,
		    0 as ROWS_UPDATED,
		    B.USER_NAME
			from table(MRC_SBX_PLF.information_Schema.query_history_by_user()) B
            where b.query_id = (select last_query_id(-2));
            


END FOR;

END;

LET result string := result || :error_message ||', ';

END FOR;

LET final_result string := RTRIM(:result,',');

return :result;

END

$$;

/*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////*/

CREATE OR REPLACE PROCEDURE MRC_SBX_PLF.FOM_CONFIG.SP_DYNAMIC_MERGE("SCHEMA_NAME" VARCHAR(100), "TBLNAME" VARCHAR(100))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$

/***********************************************************************************************************************
** Description: This Procedure created to merge Base table from Delta Stream objects
** Execution command: call MRC_SBX_PLF.FOM_CONFIG.SP_DYNAMIC_MERGE('Schema Name','Target Table Name');
******************************************************************************************** 
** Change History
********************************************************************************************
** No.     Date         Author         Description 
** ----    --------     --------       ------------------------------------
** 1    2024-04-29    	Srikanth        SP is created
** 2	2024-05-08	  	Srikanth		SP is updated according to Mapping table changes.
** 3	2024-05-24		Srikanth		SP is updated with Audit table to Mapping table changes.
** 4    2024-06-03		Srikanth		SP is replaced with Qualify and removed distinct from Source table fro merge operation.
** 5    2024-06-05		Srikanth		SP updated the merge statement from “select *” to  select table_columns.
** 6    2024-10-16  	Srikanth		SP updated with the filter condition to merge data from DELTA to BASE table.

***********************************************************************************************************************/

  var sqlCmd = "";
  var sqlStmt = "";
  var result = "";
  var exe_qry_table ="";


/***************************************************************
        DECLARE Variables from CONFIG_CREATE_MERGE_QUERY table
***************************************************************/

sqlCmd= `select * from MRC_SBX_PLF.FOM_CONFIG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE ='MRC_SBX_PLF' AND DATASOURCE_SCHEMA ='`+SCHEMA_NAME+`' AND DATASOURCE_TARGET_TABLE ='`+TBLNAME+`' AND ACTIVE_STATUS = TRUE`;
SqlStmt= snowflake.createStatement( {sqlText: sqlCmd} );
exe_qry_table = SqlStmt.execute();
exe_qry_table.next();


/***************************************************************
        Initialize MERGE Statement 
***************************************************************/

 try{ 
    sqlCmd = `MERGE INTO `+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(5)+` IL USING 
	(
    SELECT `+exe_qry_table.getColumnValue(13)+` FROM `+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(4)+` `+exe_qry_table.getColumnValue(15)+`
	QUALIFY 1= ROW_NUMBER() OVER(PARTITION BY `+exe_qry_table.getColumnValue(7)+` ORDER BY `+exe_qry_table.getColumnValue(8)+` DESC)
	)DL 
	ON `+exe_qry_table.getColumnValue(9)+` 
		WHEN MATCHED THEN
		UPDATE SET `+exe_qry_table.getColumnValue(10)+`
		WHEN NOT MATCHED THEN 
		`+exe_qry_table.getColumnValue(11)+``; /*--Insert_Set*/

    sqlStmt = snowflake.createStatement( {sqlText: sqlCmd} );
    rs = sqlStmt.execute();
    
    sqlCmd = `SELECT (select last_query_ID()) as QUERY_ID,"number of rows inserted", "number of rows updated" FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))`;
    sqlStmt = snowflake.createStatement( {sqlText: sqlCmd} );
    rs = sqlStmt.execute();
    rs.next();
    
    var Insert_status_SP = `INSERT INTO MRC_SBX_PLF.FOM_CONFIG.TBL_AUDIT
		 select MRC_SBX_PLF.FOM_CONFIG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
         B.query_id as QUERY_ID,
		 CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.START_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) START_TIME,
		 CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.END_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) END_TIME,
         B.QUERY_TEXT,
        '`+exe_qry_table.getColumnValue(4)+`' as SOURCE,
        '`+exe_qry_table.getColumnValue(5)+`' as TARGET,
         B.EXECUTION_STATUS,
		 B.ERROR_MESSAGE,
		 B.ROWS_INSERTED,
		 `+rs.getColumnValue(3)+` as ROWS_UPDATED,
		 B.USER_NAME
	     from table(`+exe_qry_table.getColumnValue(2)+`.information_Schema.query_history_by_user()) B
		 where b.query_id = (select last_query_id(-2))
         
         `;
         var Execution_status_SP = snowflake.execute({sqlText: Insert_status_SP});
			Execution_status_SP.next();

    result += "Merge completed Successfully : " + "Rows inserted: " + rs.getColumnValue(2) + ", Rows updated: " + rs.getColumnValue(3)

  }
  catch (err) {
    result =  "Failed: Code: " + err.code + " | State: " + err.state;
    result += "///////////////n  Message: " + err.message;
    result += "///////////////nStack Trace:///////////////n" + err.stackTraceTxt; 
    
    var Insert_status_SP = `INSERT INTO MRC_SBX_PLF.FOM_CONFIG.TBL_AUDIT 
			select 
			MRC_SBX_PLF.FOM_CONFIG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
			B.query_id as QUERY_ID,
			CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.START_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) START_TIME,
			CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.END_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) END_TIME,
            B.QUERY_TEXT,
            '`+exe_qry_table.getColumnValue(4)+`' as SOURCE,
            '`+exe_qry_table.getColumnValue(5)+`' as TARGET,
            B.EXECUTION_STATUS,
		    B.ERROR_MESSAGE,
		    B.ROWS_INSERTED,
		    0 as ROWS_UPDATED,
		    B.USER_NAME
			from table(`+exe_qry_table.getColumnValue(2)+`.information_Schema.query_history_by_user()) B
            where b.query_id = (select last_query_id(-1))
			
            `;
			var Execution_status_SP = snowflake.execute({sqlText: Insert_status_SP});
			Execution_status_SP.next();
    }

  return result;
$$;

WITH stats AS (
    SELECT 
        COUNT(*) AS record_count,
        --CUSTOMERID,
        ARRAY_AGG(data) AS data_array
    FROM GENESYS_ONEAPI.TBL_CUST_DETAILS
    WHERE TAXPAYERIDENTIFIER = '500604444'
)
SELECT 
    CASE
        WHEN record_count <=4 THEN data_array
        ELSE ARRAY_CONSTRUCT(OBJECT_CONSTRUCT('count', record_count))
    END AS result
FROM stats WHERE record_count > 0;

select distinct count(Acct_nbr) 
/*********************************************************************/


WITH stats AS (
    SELECT 
        COUNT(*) AS record_count,
        --DATA,
        ARRAY_AGG(data) AS data_array
    FROM GENESYS_ONEAPI.TBL_CUST_DETAILS
    WHERE (HOME_PHN_NBR ='214-222-3333' or MOB_PHN_NBR='214-222-3333')-- and CUSTOMERID ='110045655'
    --HOME_PHN_NBR in ('9726429780') or MOB_PHN_NBR in('9726429780')
    GROUP by ALL
)
SELECT --* from Stats;
    CASE 
        WHEN record_count = 1 THEN data_array[0]
        ELSE OBJECT_CONSTRUCT('count', record_count)
    END AS result
FROM stats
WHERE record_count > 0;


SELECT LOANNUMBER,DATA.value:borrowerPairApplications::INT AS borrowerPairApplications
FROM KYC_API.kyc_dashboard 
LATERAL FLATTEN(input => data:borrowerPairApplications) AS data;

select LISTAGG('SRC.'||COLUMN_NAME||'=TRG.'||COLUMN_NAME,',') as DATASOURCE_UPDATE_SET,
'INSERT('||(LISTAGG(COLUMN_NAME,',')||')VALUES('||LISTAGG('SRC.'||COLUMN_NAME,',')||')') as DATASOURCE_INSERT_SET
LISTAGG(COLUMN_NAME,',') as TABLE_COLUMNS from INFORMATION_SCHEMA.COLUMNS where table_name ='TBL_LOAN' and TABLE_SCHEMA ='DI';

CREATE OR REPLACE TABLE AGENT_ASSIT_PARSED_TBL AS
SELECT
  data:customerId::INT AS customerId,
  data:firstName::STRING AS firstName,
  data:lastName::STRING AS lastName,
  data:middleName::STRING AS middleName,
  data:suffixName::STRING AS suffixName,
  account.value:accountNumber::STRING AS accountNumber,
  account.value:borrowerPosition::INT AS borrowerPosition,
  account.value:brandName::STRING AS brandName,
  account.value:paymentStatus::STRING AS paymentStatus,
  address.value:addressLine1::STRING AS addressLine1,
  address.value:addressLine2::STRING AS addressLine2,
  address.value:addressType.code::STRING AS addressTypeCode,
  address.value:addressType.description::STRING AS addressTypeDescription,
  address.value:city::STRING AS city,
  address.value:countryCode::STRING AS countryCode,
  address.value:countryName::STRING AS countryName,
  address.value:county::STRING AS county,
  address.value:postalCode::STRING AS postalCode,
  address.value:stateCode::STRING AS stateCode
FROM ENT_KYC.AGENT_ASSIST.TBL_AGENT_ASSIST_API
-- Flatten the raw_data.accounts array
, LATERAL FLATTEN(input => data:accounts) AS account
-- Flatten the account.value.addresses array
, LATERAL FLATTEN(input => account.value:addresses) AS address
WHERE APIID = '537947';

select distinct top 1000  loannumber from KYC_API.TBL_KYC_DASHBOARD 
,lateral flatten(input=> DATA:borrowerPairApplications[0]) CTE
,lateral flatten(input=> CTE.THIS:borrowers) CTE2
,lateral flatten(input=> CTE2.value:digitalInfo) CTE3
where CTE3.THIS:username:: STRING not in ('null');

CREATE OR REPLACE PROCEDURE ENT_KYC.DI.SP_LOAD_TO_DI_INCR("SCHEMA" VARCHAR(100), "TBLNAME" VARCHAR(100))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS '

/***********************************************************************************************************************
** Description: This Procedure created to merge Base table from Delta Stream objects
** Execution command: call ENT_KYC.DI.SP_LOAD_TO_DI_INCR(''Schema Name'',''Target Table Name'');
******************************************************************************************** 
** Change History
********************************************************************************************
** No.     Date         Author         Description 
** ----    --------     --------       ------------------------------------
** 1    2024-05-07    	Srikanth        SP is created
** 2	2024-10-16		Srikanth		SP is updated with ACTIVE_STATUS from Config table.
***********************************************************************************************************************/

  var sqlCmd = "";
  var sqlStmt = "";
  var result = "";
  var exe_qry_table ="";


/***************************************************************
        DECLARE Variables from CONFIG_CREATE_MERGE_QUERY table
***************************************************************/

sqlCmd= `select * from ENT_KYC.STG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE =''ENT_KYC'' AND DATASOURCE_SCHEMA =''`+SCHEMA+`'' AND DATASOURCE_TARGET_TABLE =''`+TBLNAME+`'' AND ACTIVE_STATUS = TRUE`;
SqlStmt= snowflake.createStatement( {sqlText: sqlCmd} );
exe_qry_table = SqlStmt.execute();
exe_qry_table.next();


/***************************************************************
        Initialize MERGE Statement 
***************************************************************/

 try{ 
 
	sqlCmd = `truncate table `+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(4)+``;
    sqlStmt = snowflake.createStatement( {sqlText: sqlCmd} );
    rs = sqlStmt.execute();
	
    sqlCmd = ``+exe_qry_table.getColumnValue(6)+``;
    sqlStmt = snowflake.createStatement( {sqlText: sqlCmd} );
    rs = sqlStmt.execute();
  
    sqlCmd = `MERGE INTO `+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(5)+` trg 
      USING (SELECT `+exe_qry_table.getColumnValue(13)+` FROM
	  `+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(4)+` `+exe_qry_table.getColumnValue(15)+` ) src
	ON `+exe_qry_table.getColumnValue(9)+` 
		THEN
		UPDATE SET `+exe_qry_table.getColumnValue(10)+`
		WHEN NOT MATCHED THEN 
		`+exe_qry_table.getColumnValue(11)+``; /*--Insert_Set*/

    sqlStmt = snowflake.createStatement( {sqlText: sqlCmd} );
    rs = sqlStmt.execute();

    sqlCmd = 
      `SELECT (select last_query_ID()) as QUERY_ID,"number of rows inserted", "number of rows updated"
        FROM TABLE(RESULT_SCAN(LAST_QUERY_ID()))`;
    sqlStmt = snowflake.createStatement( {sqlText: sqlCmd} );
    rs = sqlStmt.execute();
    rs.next();
	
/** Update Merge Status into Audit table **/
	
	var Insert_status_SP = `INSERT INTO ENT_KYC.STG.TBL_AUDIT_LOG
		 select ENT_KYC.STG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
         B.query_id as QUERY_ID,
		 CAST(CONVERT_TIMEZONE(''America/North_Dakota/Center'', CAST(B.START_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) START_TIME,
		 CAST(CONVERT_TIMEZONE(''America/North_Dakota/Center'', CAST(B.END_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) END_TIME,
         B.QUERY_TEXT,
        ''`+exe_qry_table.getColumnValue(4)+`'' as SOURCE,
        ''`+exe_qry_table.getColumnValue(5)+`'' as TARGET,
         B.EXECUTION_STATUS,
		 B.ERROR_MESSAGE,
		 `+rs.getColumnValue(2)+` as ROWS_INSERTED,
		 `+rs.getColumnValue(3)+` as ROWS_UPDATED,
		 B.USER_NAME
	     from table(`+exe_qry_table.getColumnValue(2)+`.information_Schema.query_history_by_user()) B
		 where b.query_id = (select last_query_id(-2))
         
         `;
         var Execution_status_SP = snowflake.execute({sqlText: Insert_status_SP});
			Execution_status_SP.next();

    result += "Merge completed Successfully : " + "Rows inserted: " + rs.getColumnValue(2) + ", Rows updated: " + rs.getColumnValue(3)

  }
  catch (err) {
    result =  "Failed: Code: " + err.code + " | State: " + err.state;
    result += "////////////n  Message: " + err.message;
    result += "////////////nStack Trace:////////////n" + err.stackTraceTxt; 
	
/** update Error for Merge Failure into Audit Table**/

		var Insert_status_SP = `INSERT INTO ENT_KYC.STG.TBL_AUDIT_LOG 
			select 
			ENT_KYC.STG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
			B.query_id as QUERY_ID,
			CAST(CONVERT_TIMEZONE(''America/North_Dakota/Center'', CAST(B.START_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) START_TIME,
			CAST(CONVERT_TIMEZONE(''America/North_Dakota/Center'', CAST(B.END_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) END_TIME,
            B.QUERY_TEXT,
            ''`+exe_qry_table.getColumnValue(4)+`'' as SOURCE,
            ''`+exe_qry_table.getColumnValue(5)+`'' as TARGET,
            B.EXECUTION_STATUS,
    		B.ERROR_MESSAGE,
    		0 as ROWS_INSERTED,
    		0 as ROWS_UPDATED,
    		B.USER_NAME
			from table(`+exe_qry_table.getColumnValue(2)+`.information_Schema.query_history_by_user()) B
            where b.query_id = (select last_query_id(-1))
			
            `;
			var Execution_status_SP = snowflake.execute({sqlText: Insert_status_SP});
			Execution_status_SP.next();
    }

  return result;
';