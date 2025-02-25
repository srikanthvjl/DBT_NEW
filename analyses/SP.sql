CREATE OR REPLACE PROCEDURE ENT_KYC.DI.SP_LOAD_TO_DI_INCR("SCHEMA" VARCHAR(100), "TBLNAME" VARCHAR(100))
RETURNS VARCHAR(16777216)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$

/***********************************************************************************************************************
** Description: This Procedure created to merge Base table from Delta Stream objects
** Execution command: call ENT_KYC.DI.SP_LOAD_TO_DI_INCR('Schema Name','Target Table Name');
******************************************************************************************** 
** Change History
********************************************************************************************
** No.     Date         Author         Description 
** ----    --------     --------       ------------------------------------
** 1    2024-05-07    Srikanth          SP is created

***********************************************************************************************************************/

  var sqlCmd = "";
  var sqlStmt = "";
  var result = "";
  var exe_qry_table ="";


/***************************************************************
        DECLARE Variables from CONFIG_CREATE_MERGE_QUERY table
***************************************************************/

sqlCmd= `select * from ENT_KYC.STG.TBL_DYN_MRG_CONFIG where DATASOURCE_DATABASE ='ENT_KYC' AND DATASOURCE_SCHEMA ='`+SCHEMA+`' AND DATASOURCE_TARGET_TABLE ='`+TBLNAME+`' AND ACTIVE_STATUS = TRUE`;
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
      USING 
	`+exe_qry_table.getColumnValue(2)+`.`+exe_qry_table.getColumnValue(3)+`.`+exe_qry_table.getColumnValue(4)+` src
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
		 CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.START_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) START_TIME,
		 CAST(CONVERT_TIMEZONE('America/North_Dakota/Center', CAST(B.END_TIME AS TIMESTAMP_TZ(9))) AS TIMESTAMP_NTZ(9)) END_TIME,
         B.QUERY_TEXT,
        '`+exe_qry_table.getColumnValue(4)+`' as SOURCE,
        '`+exe_qry_table.getColumnValue(5)+`' as TARGET,
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
    result += "\\\\\\\\\\\n  Message: " + err.message;
    result += "\\\\\\\\\nStack Trace:\\\\\\\\\\\\n" + err.stackTraceTxt; 
	
/** update Error for Merge Failure into Audit Table**/

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
$$;