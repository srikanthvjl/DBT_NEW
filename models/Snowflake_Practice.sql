Create Database DBT_LEARN;
create SCHEMA SF_CLASS;
select current_account();
select current_region();
show tables;
IDBSHZO.GB28113
https://tk52314.europe-west3.gcp.snowflakecomputing.com

;

//current user's stage
list @~;

create or replace table TBL_CUST2(
File_name string,
file_row_num string,
CUST_ID varchar(18),
ACCT_NBR varchar(18),
Load_dttm datetime
);
select * from TBL_CUST2;
list @~;

CREATE FILE FORMAT my_csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  FIELD_DELIMITER = ','
 // NULL_IF = ('NULL', 'null')
  COMPRESSION = 'AUTO';

select * from INFORMATION_SCHEMA.FILE_FORMATS;
copy into TBL_CUST2
from(select metadata$filename,metadata$file_row_number,t.$1,t.$2,current_timestamp() from @~/TBL_CUST t)
file_format =(type ='CSV' field_optionally_enclosed_by='"' skip_header=1);

list @%TBL_CUST2;
copy into TBL_CUST2
from(select metadata$filename,metadata$file_row_number,t.$1,t.$2,current_timestamp() from @%TBL_CUST2/TBL_CUST2 t)
file_format =(type ='CSV' field_optionally_enclosed_by='"' skip_header=1 COMPRESSION = 'AUTO')
PURGE = TRUE;

select * from TBL_CUST2;
show file_format;

//Table stage
list @%TBL_CUST;

select * from TBL_CUST;
show tables;
drop table TBL_CUST;
undrop table TBL_CUST;
COPY INTO TBL_CUST
FILE_FORMAT = (TYPE = CSV);
copy into TBL_CUST
from @~;

COPY INTO TBL_CUST
  FROM @~
  //FILE_FORMAT = (FORMAT_NAME = my_csv_format)
  //TYPE = 'CSV'
  //FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  ON_ERROR = 'CONTINUE';
//SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY='"'
VALIDATION_MODE=RETURN_ERRORS
ON_ERROR =ABORT_STATEMENT;
PUT file://C:\Users\srika\Documents\Snowflake_Practice_CSV\TBL_CUST.csv @~;

drop table TBL_CUST1;
create transient table TBL_CUST1
(CUST_ID varchar(18),
ACCT_NBR varchar(18)
);

show tasks;


show streams;
SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS'; IN STREAM TBL_CUST1_stream;

create or replace stream TBL_CUST1_STREAM on table TBL_CUST1 append_only = true;

create or replace stream ENT_KYC.CUST_MSTR.TBL_ADDR_STREAM on table TBL_ADDR_DELTA append_only = true;

select * from DBT_LEARN.SF_CLASS.TBL_CUST;
select CUST_ID,TYPEOF(CUST_ID::VARIANT) from DBT_LEARN.SF_CLASS.TBL_CUST2;
//update DBT_LEARN.SF_CLASS.TBL_CUST2 set ACCT_NBR ='675432289,67543228' where CUST_ID =10248856;
SELECT CUST_ID,TYPEOF(cust_id) //,value as ACCT_NBR2
FROM DBT_LEARN.SF_CLASS.TBL_CUST2,
LATERAL STRTOK_SPLIT_TO_TABLE(ACCT_NBR,',') AS t;

SELECT id, value AS fruit
FROM fruits,
LATERAL TABLE(STRTOK_SPLIT_TO_TABLE(fruit_list, ',')) AS t;

select * from DBT_LEARN.SF_CLASS.TBL_CUST1;
select * from DBT_LEARN.SF_CLASS.TBL_CUST2;
create or replace view DBT_LEARN.SF_CLASS.VW_TBL_CUST2
as (
select * from DBT_LEARN.SF_CLASS.TBL_CUST2
);
Insert into DBT_LEARN.SF_CLASS.TBL_CUST1  select CUST_ID,ACCT_NBR from DBT_LEARN.SF_CLASS.TBL_CUST2;
select * from DBT_LEARN.SF_CLASS.TBL_CUST3;
select * from DBT_LEARN.SF_CLASS.TBL_CUST4;
select * from DBT_LEARN.SF_CLASS.TBL_CUST5;
select * from DBT_LEARN.SF_CLASS.TBL_CUST6;
select * from DBT_LEARN.SF_CLASS.TBL_CUST7;
select * from DBT_LEARN.SF_CLASS.TBL_CUST8;
select * from DBT_LEARN.SF_CLASS.TBL_CUST9;
select * from DBT_LEARN.SF_CLASS.TBL_CUST10;
select * from DBT_LEARN.SF_CLASS.TBL_CUST11;
select * from DBT_LEARN.SF_CLASS.TBL_CUST12;
select * from DBT_LEARN.SF_CLASS.TBL_CUST13;
select * from DBT_LEARN.SF_CLASS.TBL_CUST14;
select * from DBT_LEARN.SF_CLASS.TBL_CUST15;
select * from DBT_LEARN.SF_CLASS.TBL_CUST16;

insert into DBT_LEARN.SF_CLASS.TBL_CUST16 (CUST_ID,ACCT_NBR) values ('10248859','8794326798'),('10248858','8794326798'),('10248858','8794326798');

create or replace table TBL_CUST16 as select * from TBL_CUST where 1=1;
create or replace table TBL_CUST6 like TBL_CUST where 1=1;
create or replace table TBL_CUST6 clone TBL_CUST ;
create or replace transient table TBL_CUST7 clone TBL_CUST ;
create or replace temporary table TBL_CUST8 clone TBL_CUST ;
create or replace transient table TBL_CUST9 as select * from TBL_CUST;
create or replace transient table TBL_CUST10 as select * from TBL_CUST;
create or replace transient table TBL_CUST11 clone TBL_CUST;
create or replace table TBL_CUST12 like TBL_CUST;
create or replace table TBL_CUST13 clone TBL_CUST ;
create or replace table TBL_CUST14 as select * from TBL_CUST;
create or replace table TBL_CUST15 like TBL_CUST;
show tables;

select * from INFORMATION_SCHEMA.tables where table_name ilike ('TBL_CUST%');

select * from INFORMATION_SCHEMA.tables where table_name ilike ('TBL_CUST%');
select table_created,* from INFORMATION_SCHEMA.TABLE_STORAGE_METRICS where table_name ilike ('TBL_CUST%') order by 4,1 desc;


show storage; usage like 'TBL_CUST';


select * from MRC_SBX_PLF.FOM_CONFIG.SALES;

SELECT * FROM MRC_SBX_PLF.FOM_CONFIG.SALES
PIVOT
(SUM(SALESAMOUNT) FOR MONTH IN('Jan','Feb')) AS PIVOTTABLE;

with CTE as (
select 1 as NUM
UNION ALL 
select 0 
UNION ALL 
select 1
UNION ALL 
select 0
UNION ALL 
select NULL
),
CTE2 as (
select 1 as NUM2
UNION ALL 
select 0 
UNION ALL 
select 2
UNION ALL 
select 3
UNION ALL 
select NULL
)
Select * from CTE2
--JOIN CTE on CTE.NUM=CTE2.NUM2;
--LEFT JOIN CTE on CTE.NUM=CTE2.NUM2;
RIGHT JOIN CTE on CTE.NUM=CTE2.NUM2;


with CTE as (
select '123@gmail.com' as FullDomain_address
UNION 
select '2345@yahoo.com'
UNION 
select '34567@google.com'
)
select *,
split_part(REGEXP_SUBSTR(FullDomain_address, '@[^.]+'),'@',-1) AS domain,
REGEXP_SUBSTR(FullDomain_address, '@[^.]+') AS domain1,
split_part(FullDomain_address,'@',-1) DOMAIN2,
REGEXP_INSTR(FullDomain_address,'@',1),-1 as Domain3,
SUBSTR(FullDomain_address,REGEXP_INSTR(FullDomain_address,'@',1),-1) from CTE;


select * from DBT_LEARN.SF_CLASS.TBL_CUST2;

//TAG ROLE
Create or replace role TAG_ADMIN;

GRANT CREATE TAG ON SCHEMA DBT_LEARN.SF_CLASS TO ROLE TAG_ADMIN;
GRANT APPLY TAG ON ACCOUNT TO ROLE TAG_ADMIN;

//MASKING ROLE

CREATE OR REPLACE role MASKING_ADMIN;
GRANT CREATE MASKING POLICY ON SCHEMA  DBT_LEARN.SF_CLASS TO ROLE MASKING_ADMIN;
GRANT APPLY MASKING POLICY on ACCOUNT to ROLE MASKING_ADMIN;

CREATE OR REPLACE ROLE TAG_MASKING_ADMIN;

GRANT ALL ON DATABASE DBT_LEARN TO ROLE TAG_MASKING_ADMIN;
GRANT ALL ON SCHEMA DBT_LEARN.SF_CLASS TO ROLE TAG_MASKING_ADMIN;
GRANT ALL ON TABLE DBT_LEARN.SF_CLASS.TBL_CUST1 TO ROLE TAG_MASKING_ADMIN;
GRANT ALL ON TABLE DBT_LEARN.SF_CLASS.TBL_CUST2 TO ROLE TAG_MASKING_ADMIN;
GRANT ALL ON VIEW DBT_LEARN.SF_CLASS.VW_TBL_CUST2 TO ROLE TAG_MASKING_ADMIN;
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE TAG_MASKING_ADMIN; //TOWNSHOES_WH IS THE NAME OF THE WAREHOUSE USED

GRANT ROLE TAG_MASKING_ADMIN TO USER SRIKANTHKONIREDDY; //WE GRANT THIS ROLE TO THE SELECTED USER

// FINALLY, WE GIVE TO TAG_MASKING_ADMIN, THE PRIVILEGES FROM THE 2 PREVIOUS CUSTOM ROLES

USE ROLE ACCOUNTADMIN;
GRANT ROLE TAG_ADMIN TO ROLE TAG_MASKING_ADMIN;
GRANT ROLE MASKING_ADMIN TO ROLE TAG_MASKING_ADMIN;

use role TAG_MASKING_ADMIN;

CREATE OR REPLACE TAG DBT_LEARN.SF_CLASS.MASKED_COLUMNS_TAG
	ALLOWED_VALUES 'SYSADMIN_MASKING';
    
show tags;

CREATE OR REPLACE MASKING POLICY DBT_LEARN.SF_CLASS.STRING_DATA_MASK AS (VAL STRING) RETURNS STRING ->
	CASE
		WHEN CURRENT_ROLE() NOT IN ('TAG_MASKING_ADMIN') THEN '***MASKED***'
	ELSE VAL
END;

ALTER TAG DBT_LEARN.SF_CLASS.MASKED_COLUMNS_TAG SET
MASKING POLICY DBT_LEARN.SF_CLASS.STRING_DATA_MASK;

ALTER SCHEMA SF_CLASS SET TAG 
DBT_LEARN.SF_CLASS.MASKED_COLUMNS_TAG = 'SYSADMIN_MASKING';


select * from DBT_LEARN.SF_CLASS.TBL_CUST1;
select * from DBT_LEARN.SF_CLASS.TBL_CUST2;
select * from DBT_LEARN.SF_CLASS.VW_TBL_CUST2;

use role sysadmin;

select * from DBT_LEARN.SF_CLASS.TBL_CUST1;
select * from DBT_LEARN.SF_CLASS.TBL_CUST2;
select * from DBT_LEARN.SF_CLASS.VW_TBL_CUST2;

grant role sysadmin to user SRIKANTHKONIREDDY;
use role ACCOUNTADMIN;
GRANT ALL ON WAREHOUSE COMPUTE_WH TO ROLE SYSADMIN;
GRANT ALL ON DATABASE DBT_LEARN TO ROLE SYSADMIN ;
GRANT ALL PRIVILEGES ON DATABASE DBT_LEARN TO ROLE SYSADMIN;
GRANT USAGE ON DATABASE DBT_LEARN TO ROLE SYSADMIN;
GRANT USAGE ON SCHEMA DBT_LEARN.SF_CLASS TO ROLE SYSADMIN;
GRANT SELECT,INSERT,DELETE,TRUNCATE ON ALL TABLES IN SCHEMA DBT_LEARN.SF_CLASS TO ROLE SYSADMIN;
GRANT SELECT ON ALL VIEWS IN SCHEMA DBT_LEARN.SF_CLASS TO ROLE SYSADMIN;
show tags;
alter table DBT_LEARN.SF_CLASS.TBL_CUST2 MODIFY COLUMN FILE_NAME SET TAG DBT_LEARN.SF_CLASS.MASKED_COLUMNS_TAG='SYSADMIN_MASKING';
alter table DBT_LEARN.SF_CLASS.TBL_CUST2 MODIFY COLUMN FILE_NAME UNSET TAG DBT_LEARN.SF_CLASS.MASKED_COLUMNS_TAG;

ALTER SCHEMA SF_CLASS UNSET TAG 
DBT_LEARN.SF_CLASS.MASKED_COLUMNS_TAG ='SYSADMIN_MASKING';

select * from DBT_LEARN.SF_CLASS.TBL_CUST2;