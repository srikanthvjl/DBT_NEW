CREATE OR REPLACE PROCEDURE ENT_KYC.STG.SP_DYNAMIC_MERGE("SCHEMA_NAME" VARCHAR(100), "TBLNAME" VARCHAR(100))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$

/***********************************************************************************************************************
** Description: This Procedure created to merge Base table from Delta Stream objects
** Execution command: call ENT_KYC.STG.SP_DYNAMIC_MERGE('Schema Name','Target Table Name');
******************************************************************************************** 
** Change History
********************************************************************************************
** No.     Date         Author         Description 
** ----    --------     --------       ------------------------------------
** 1    2024-04-29    	Srikanth		SP is created
** 2	2024-05-08	Srikanth		SP is updated according to Config table changes.
** 3	2024-05-24	Srikanth		SP is updated with Audit table to Mapping table changes.
** 4    2024-06-03	Srikanth		SP is replaced with Qualify and removed distinct from Source table fro merge operation.
** 5    2024-06-05	Srikanth		SP updated the merge statement from “select *” to  select table_columns.

***********************************************************************************************************************/

  var sqlCmd = "";
  var sqlStmt = "";
  var result = "";
  var exe_qry_table ="";
 

/***************************************************************
        DECLARE Variables from CONFIG_CREATE_MERGE_QUERY table
***************************************************************/

sqlCmd= `select * from ENT_KYC.STG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE ='ENT_KYC' AND DATASOURCE_SCHEMA ='`+SCHEMA_NAME+`' AND DATASOURCE_TARGET_TABLE ='`+TBLNAME+`' AND ACTIVE_STATUS = TRUE`;
SqlStmt= snowflake.createStatement( {sqlText: sqlCmd} );
exe_qry_table = SqlStmt.execute();
exe_qry_table.next();


/***************************************************************
        Initialize MERGE Statement 
***************************************************************/

 try{ 
    sqlCmd = `MERGE INTO `+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(5)+` IL 
	USING 
	(
    SELECT `+exe_qry_table.getColumnValue(13)+` FROM `+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(4)+`
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
    
    var Insert_status_SP = `INSERT INTO ENT_KYC.STG.TBL_AUDIT_LOG
		 select ENT_KYC.STG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
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
    result += "\\\\\\\\\\\\n  Message: " + err.message;
    result += "\\\\\\\\\\\\nStack Trace:\\\\\\\\\\\n" + err.stackTraceTxt; 
    
    var Insert_status_SP = `INSERT INTO ENT_KYC.STG.TBL_AUDIT_LOG 
			select 
			ENT_KYC.STG.SEQ_AUDIT_LOG.NEXTVAL as EXECUTION_ID,
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