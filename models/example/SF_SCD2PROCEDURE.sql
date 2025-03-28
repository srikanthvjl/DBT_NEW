{C}REATE OR REPLACE TABLE SCD2_TABLE (
    CUST_ID INT,
    ACCT_NBR VARCHAR,
    Application_Status VARCHAR,
    effective_date TIMESTAMP_NTZ(9),
    end_date TIMESTAMP,
    is_current BOOLEAN
);

CREATE OR REPLACE TABLE TBL_CUST2 (
    CUST_ID INT,
    ACCT_NBR VARCHAR,
    Application_Status VARCHAR,
    effective_date TIMESTAMP_NTZ(9)
);



CREATE OR REPLACE STREAM TBL_CUST2_STREAM ON TABLE TBL_CUST2;

select * from DBT_LEARN.ENC.TBL_CUST2;
select * from DBT_LEARN.ENC.TBL_CUST2_STREAM;
select * from DBT_LEARN.ENC.SCD2_TABLE;

-- delete from DBT_LEARN.ENC.TBL_CUST2 where CUST_ID ='12346';
-- truncate table DBT_LEARN.ENC.SCD2_TABLE;

INSERT INTO TBL_CUST2 (CUST_ID,ACCT_NBR,Application_Status,effective_date) values('12345','2346795','open',current_timestamp()),('12346','2346796','open',current_timestamp()),('12347','2346797','open',current_timestamp());

INSERT INTO TBL_CUST2 (CUST_ID,ACCT_NBR,Application_Status,effective_date) values('12345','2346795','In-process',current_timestamp());

CALL process_scd2();
CALL process_scd21();

CREATE OR REPLACE PROCEDURE process_scd2()
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
{
    var sql_query = `
        MERGE INTO SCD2_TABLE AS target
        USING (
            SELECT CUST_ID,ACCT_NBR,Application_Status,effective_date
            FROM TBL_CUST2_STREAM
        ) AS source
        ON target.CUST_ID = source.CUST_ID target.ACCT_NBR = source.ACCT_NBR AND target.is_current = TRUE
        WHEN MATCHED THEN
            UPDATE SET target.end_date = CURRENT_TIMESTAMP(), target.is_current = FALSE
        WHEN NOT MATCHED THEN
            INSERT (CUST_ID,ACCT_NBR,Application_Status,effective_date, end_date, is_current)
            VALUES (source.CUST_ID, source.ACCT_NBR, source.Application_Status,source.effective_date, NULL, TRUE);
    `;
    var sqlStmt=snowflake.createStatement( {sqlText: sql_query} );
    var result = sqlStmt.execute();
    return "SCD Type 2 processing completed.";
}
$$;

CALL process_scd21();

CREATE OR REPLACE PROCEDURE process_scd21()
RETURNS STRING
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS $$
{
var sql_query = `BEGIN TRANSACTION`;
var sqlStmt=snowflake.createStatement( {sqlText: sql_query} );
var result = sqlStmt.execute();

        
    var sql_query = `
        -- Step 1: Update current record (end_date and is_current flag)
        UPDATE SCD2_TABLE TARGET
        SET end_date = SOURCE.effective_date,
            is_current = FALSE,
            TARGET.ACTION = SOURCE.ACTION
            FROM (SELECT CUST_ID,ACCT_NBR,effective_date,METADATA$ACTION,
                    CASE WHEN METADATA$ACTION ='INSERT' THEN 'UPDATE'
                            WHEN METADATA$ACTION ='DELETE' THEN METADATA$ACTION END AS ACTION 
                            FROM TBL_CUST2_STREAM) SOURCE
        WHERE 
            TARGET.CUST_ID =SOURCE.CUST_ID 
        AND TARGET.ACCT_NBR=SOURCE.ACCT_NBR
        AND TARGET.is_current = TRUE
        ;
        `;
        var sqlStmt=snowflake.createStatement( {sqlText: sql_query} );
        var result = sqlStmt.execute();

    var sql_query = `
        MERGE INTO SCD2_TABLE AS target
        USING (
            SELECT CUST_ID,ACCT_NBR,Application_Status,effective_date,METADATA$ACTION
            FROM TBL_CUST2_STREAM
        ) AS source
        ON target.CUST_ID = source.CUST_ID 
        AND target.ACCT_NBR = source.ACCT_NBR
        AND target.is_current = TRUE
        WHEN NOT MATCHED 
        AND source.METADATA$ACTION !='DELETE'
        THEN
            INSERT (CUST_ID,ACCT_NBR,Application_Status,effective_date, end_date, is_current,ACTION)
            VALUES (source.CUST_ID, source.ACCT_NBR, source.Application_Status,source.effective_date, NULL, TRUE,source.METADATA$ACTION);
    `;
    var sqlStmt=snowflake.createStatement( {sqlText: sql_query} );
    var result = sqlStmt.execute();
          
var sql_query = `COMMIT`;
var sqlStmt=snowflake.createStatement( {sqlText: sql_query} );
var result = sqlStmt.execute();

return "SCD Type 2 processing completed successfully.";
}
$$;