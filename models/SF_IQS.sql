
Q) Snowflake Architecture

Snowflake is simple in 3 layer Architecture

1.Cloud Services Layer,
2.Query Processing layer
3.Data Lake Layer

Q) What are the different types for snowflake Editions and which Edition using in your Current Project ?

	Snowflake Editions:
	Standard,
	Enterprise,
	Business Critical
	VPS (Virtual Private Snowflake)

/*********************************************************************************************************************/

Q) which layer will execute the query and how the result show up in Snowflake.


/*********************************************************************************************************************/

Q)How the data lake stores data and how the data organized in Data Lake layer

Datalake stores the data in Micro Pratitions and snowflake organizes each Micro partition with 16 MB of Compressed Data


/*********************************************************************************************************************/

Q) How the data loading in snowflake happening in your project ?

/*********************************************************************************************************************/
Q) What are the different types of snowflake tables ?
 pemanent tables,Temporary tables,Transient tables,External tables, Dynamic tables, Iceberg tables

/*********************************************************************************************************************/

Q)Difference between sowflake tables?

/*********************************************************************************************************************/

Q) How the Copy Statement work in Snowflake?

/*********************************************************************************************************************/
Q) How to validate Errors before loading data into snowflake?

/*********************************************************************************************************************/
Q) What type of files have you loaded in snowflake?

/*********************************************************************************************************************/

Q) what are the different types of Stages in snowflake ?

 Internal stages:
 1.User Stage and 
 2.Table Stage  both can be consider as type of Internal stages in Snowflake

 3.External Stage: External storage layer used to perform data loading in to snowflake can be called as External Stage
 Ex: AWS S3,Azure BOLB, Google Cloud Storage.

/*********************************************************************************************************************/
Q)Can you explain Difference between Views and Materialized Views ?

/*********************************************************************************************************************/

Q)Can you Explain User Previlages Hiraricy to grant access to any Partcular warehouse,Database and tables.

/*********************************************************************************************************************/

Q)How many Types of Warehouse offered in Snowflake and uses

 Snowflake offers two types of virtual warehouses:  Standard and Snowpark-optimized. 
 
 Standard: This is the commonly used type and suitable for most general workloads.

 Snowpark-optimized: This type is recommended for memory-intensive workloads, such as machine learning training, and provides significantly more memory than standard warehouses.

/*********************************************************************************************************************/

Q) What are the ETL Tools Used for Dataloading in your projects?

/*********************************************************************************************************************/
 

Q) Is Each load will create new Micro partitions in snowflake ?
Yes


/*********************************************************************************************************************/
Q) what will happen to the micropartition for the record incase any update happen in Existing tables how the data retreives from duplicate partitons?

Snowflake create new partitions for each load irrespective of New/updated records
Snince snowflake is columnar database, snowflake assign versioning for each partition, in case of updated records everytime when we qery the data from tables it uses latest version micropartitions for retreving data.


/*********************************************************************************************************************/
Q)how to improve the query performance in snowflake if a query takes longer time to execute?


/*********************************************************************************************************************/

Q) What are the techniques to improve query performance in snowflake with out incresing the warehouse size?

We can better query run time by defining clustering keys for frequently used not null columns and can create serachoptimization on table or columns which are frequently used to filter data in SQL Queries


/*********************************************************************************************************************/
Q)Can you Explain about how the clusting Keys and Search Optimization works in snowflake to improve qery performance?


/*********************************************************************************************************************/


Q)What are the snowflake fetures and how many used in your current project?

	Snowflake Basic fetures are 
	Data sharing,Time Travel,Cloning,Scalability,Dynamic tables,Streams,Tasks

Serverless features: 
	Snowflake offers several serverless features that incur additional charges when utilized. These features use Snowflake-managed compute resources rather than user-managed virtual warehouses. Here are some key serverless features that may result in additional costs:

	Snowpipe: This feature automates the continuous loading of data into Snowflake. It uses serverless compute resources to ingest data as it arrives1.

	Search Optimization Service: This service improves query performance by optimizing the search paths for data. It uses serverless compute resources to maintain search optimization1.

	Materialized Views Maintenance: Snowflake automatically maintains materialized views, which can incur additional charges for the compute resources used1.

	Tasks: Snowflake tasks allow you to schedule SQL statements, including stored procedures, to run automatically. Serverless compute resources are used to execute these tasks1.

	Streams and Tasks: When used together, streams and tasks can automate data pipelines, with serverless compute resources handling the processing


Features used in my current Project 
	1.Streams
	2.Timetravel
	3.Cloning
	
	
/*********************************************************************************************************************/

Q) What are the Different types of Snowflake Streams ?
There are 2 different types of Snowflake Streams
1. Snowflake Streams ( which are normal these streams will capture Both Insert and deleted changes in Base table)
2. Append_Only=true which capture only new Inserted records from Base tables

	
/*********************************************************************************************************************/

Q) What are the  Additional columns having Snowflake Streams ?
	1.Metadata$ACTION
	2.Metadata$update
	3.Metadata$RowID
/*********************************************************************************************************************/

Q) What are the difference between Return-Errors and Return_ALLERRORS in Copy statment validation mode?

/*********************************************************************************************************************/

	
/*********************************************************************************************************************/

Can you give syntax for time travel ?
	SELECT * FROM my_table BEFORE (STATEMENT => 'statement_id');
	SELECT * FROM my_table AT (TIMESTAMP => '2023-03-01 12:00:00'::TIMESTAMP);-- all ways timestamp should be ust Time
	SELECT * FROM my_table AT (OFFSET => -30*60);  -- 30 minutes ago

/*********************************************************************************************************************/

Q) How the data loading in snowflake happening in your project ?

/*********************************************************************************************************************/
Q) What are the different types of snowflake tables ?
	pemanent tables,Temporary tables,Transient tables,External tables, Dynamic tables, Iceberg tables

/*********************************************************************************************************************/

Q)Difference between sowflake tables?

/*********************************************************************************************************************/

Q) How the Copy Statement work in Snowflake?

/*********************************************************************************************************************/
Q) How to validate Errors before loading data into snowflake?

/*********************************************************************************************************************/
Q) What type of files have you loaded in snowflake?

/*********************************************************************************************************************/

Q) what are the different types of Stages in snowflake ?

	Internal stages:
	1.User Stage and 
	2.Table Stage  both can be consider as type of Internal stages in Snowflake

	3.External Stage: External storage layer used to perform data loading in to snowflake can be called as External Stage
	Ex: AWS S3,Azure BOLB, Google Cloud Storage.

/*********************************************************************************************************************/
Q)Can you explain Difference between Views and Materialized Views ?

/*********************************************************************************************************************/

Q)Can you Explain User Previlages Hiraricy to grant access to any Partcular warehouse,Database and tables.

/*********************************************************************************************************************/

Q)How many Types of Warehouse offered in Snowflake and uses

	Snowflake offers two types of virtual warehouses:  Standard and Snowpark-optimized. 
 
	Standard: This is the commonly used type and suitable for most general workloads.

	Snowpark-optimized: This type is recommended for memory-intensive workloads, such as machine learning training, and provides significantly more memory than standard warehouses.

/*********************************************************************************************************************/

Q) What are the ETL Tools Used for Dataloading in your projects?

/*********************************************************************************************************************/

Q) Can you Explain SCD1&SCD2 Transformations uisng Streams and Statement to execute these transformations ?


/*********************************************************************************************************************/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SQL Questions:
--------------

Q) Product Table Find Incremental Percentage of a Product Each day
PRODUCT	DATE	SALEPRICE
1	2024-12-10	20
1	2024-12-10	20
1	2024-12-11	20
1	2024-12-11	20
1	2024-12-11	20

select 
PRODUCT,Date,totalsales,
CASE 
    WHEN PreviousSales is NUll then NULL 
Else
    (totalsales-PreviousSales)/PreviousSales*100
END as Increment_percent
from (
select Product,DATE,totalsales,lag(totalsales) over (partition by PRODUCT order by DATE) as PreviousSales
from(

select PRODUCT,DATE,SALEPRICE,sum(SALEPRICE) over (partition by PRODUCT,DATE order by DATE) totalsales from CTE

)group by Product,DATE,totalsales)
group by all
;

/*********************************************************************************************************************/

Q) can you give the statement to caliculate runing sums of salesamount in SQL?

Ans) sum(salesamount) over( partition by product order by date) runningsums



/*********************************************************************************************************************/

Q) Find out customers who having highest sales from each city

CITY	SALEAMOUNT	CUSTOMER_NAME
Delhi	1000	Sathya
Mumbai	700	Ripu
Delhi	350	Ripu
Mumbai	100	Sathya
Delhi	800	Ripu
Mumbai	900	Sathya

Ans) select * from (
select City, Customer_name,sum(saleamount) saleamount,
row_number() over (partition by CITY order by sum(Saleamount) desc) rnk
from CTE
group by all ) where rnk =1;

CITY	CUSTOMER_NAME	SALEAMOUNT	RNK
Delhi	Ripu	1150	1
Mumbai	Sathya	1000	1

/*********************************************************************************************************************/

Q) Difference between Pivot and UNPIVOT

PIVOT is to transform rows in to columns

	SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days,
	[0], [1], [2], [3], [4]
	FROM
	(
	SELECT DaysToManufacture, StandardCost
	FROM Production.Product
	) AS SourceTable
	PIVOT
	(
	AVG(StandardCost)
	FOR DaysToManufacture IN ([0], [1], [2], [3], [4])
	) AS PivotTable;



UNPIVOT is to transform columns to rows

	Example : for customer having different paytipes in different columns we need to get the total pay we can transform to unpivot

	select paytype,pay,CUSTOMER,LOANNUMBER,CUSTROLETYPE from 
	(SELECT * FROM ENT_KYC.DI.EMPLOYMENT 
	UNPIVOT INCLUDE NULLS(PAY FOR PAYTYPE IN(BASEPAY,OVERTIMEPAY,BONUSPAY,COMMISSIONPAY,MILITARYENTITLEMENTS,OTHERPAY)) 
	WHERE LOANNUMBER IN('806467007')
	
/*********************************************************************************************************************/

Q) Find out each match with single opponent

WITH Teams AS (
    SELECT 'India' AS team
    UNION ALL
    SELECT 'Sri Lanka'
    UNION ALL
    SELECT 'Pakistan'
),
Matches AS (
    SELECT t1.team || ' VS ' || t2.team AS fight
    FROM Teams t1
    JOIN Teams t2
    WHERE t1.team < t2.team
)
SELECT fight
FROM Matches;

/*********************************************************************************************************************/

Q) how to get date time differences

--darte Time Differences:

select current_timestamp();
select current_session();
select to_timestamp('1732778329242111'); --this epoch_microsecondmicrosend and will give the timestamp in result for 
select to_timestamp('2024-11-28 07:18:49.242111','YYYY-MM-DD HH24:MI:SS.FF6');
select to_varchar(to_timestamp('2024-11-28 07:18:49.242111','YYYY-MM-DD HH24:MI:SS.FF6'),'YYYY-MM-DDTHH:MI:SS.FF6');
SELECT DATEDIFF(microsecond, '1970-01-01'::DATE, CURRENT_TIMESTAMP());

SELECT DATE_PART(epoch_microsecond, to_timestamp('2024-11-28 07:18:49.242111'));
show parameters like '%time%';
SELECT DATE_PART(epoch_microsecond, CURRENT_TIMESTAMP());

/*********************************************************************************************************************/

Q) how to find data retension period in snowflake

SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN DATABASE DB_NAME;
SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN SCHEMA DB_NAME.SCHEMA;
SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN TABLE DB_NAME.SCHEMA.TBL_NAME;

/*********************************************************************************************************************/

Q) Find out only domain names


with CTE as (
select 'srk@gmail.com' as Email_ID
UNION ALL
select 'srk1@gmail.com'
)
select EMAIL_ID,
regexp_instr(EMAIL_ID,'@'),
split_part(EMAIL_ID,'@',-1),
substr(EMAIL_ID,regexp_instr(EMAIL_ID,'@')+1) from CTE;




Q) Snowflake Architecture

Snowflake is simple in 3 layer Architecture

1.Cloud Services Layer,
2.Query Processing layer
3.Data Lake Layer


/*********************************************************************************************************************/

Q) which layer will execute the query and how the result show up in Snowflake.


/*********************************************************************************************************************/

Q)How the data lake stores data and how the data organized in Data Lake layer

Datalake stores the data in Micro Pratitions and snowflake organizes each Micro partition with 16 MB of Compressed Data


/*********************************************************************************************************************/

Q) Is Each load will create new Micro partitions in snowflake ?
Yes


/*********************************************************************************************************************/
Q) what will happen to the micropartition for the record incase any update happen in Existing tables how the data retreives from duplicate partitons?

Snowflake create new partitions for each load irrespective of New/updated records
Snince snowflake is columnar database, snowflake assign versioning for each partition, in case of updated records everytime when we qery the data from tables it uses latest version micropartitions for retreving data.


/*********************************************************************************************************************/
Q)how to improve the query performance in snowflake if a query takes longer time to execute?


/*********************************************************************************************************************/

Q) What are the techniques to improve query performance in snowflake with out incresing the warehouse size?

We can better query run time by defining clustering keys for frequently used not null columns and can create serachoptimization on table or columns which are frequently used to filter data in SQL Queries


/*********************************************************************************************************************/
Q)Can you Explain about how the clusting Keys and Search Optimization works in snowflake to improve qery performance?


/*********************************************************************************************************************/


Q)What are the snowflake fetures and how many used in your current project?

 Snowflake Basic fetures are 
 Data sharing,Time Travel,Cloning,Scalability,Dynamic tables,Streams,Tasks

Serverless features: 
 Snowflake offers several serverless features that incur additional charges when utilized. These features use Snowflake-managed compute resources rather than user-managed virtual warehouses. Here are some key serverless features that may result in additional costs:

 Snowpipe: This feature automates the continuous loading of data into Snowflake. It uses serverless compute resources to ingest data as it arrives1.

 Search Optimization Service: This service improves query performance by optimizing the search paths for data. It uses serverless compute resources to maintain search optimization1.

 Materialized Views Maintenance: Snowflake automatically maintains materialized views, which can incur additional charges for the compute resources used1.

 Tasks: Snowflake tasks allow you to schedule SQL statements, including stored procedures, to run automatically. Serverless compute resources are used to execute these tasks1.

 Streams and Tasks: When used together, streams and tasks can automate data pipelines, with serverless compute resources handling the processing


Features used in my current Project 
 1.Streams
 2.Timetravel
 3.Cloning
 
/*********************************************************************************************************************/

Can you give syntax for time travel ?
 SELECT * FROM my_table BEFORE (STATEMENT => 'statement_id');
 SELECT * FROM my_table AT (TIMESTAMP => '2023-03-01 12:00:00'::TIMESTAMP);-- all ways timestamp should be ust Time
 SELECT * FROM my_table AT (OFFSET => -30*60);  -- 30 minutes ago

/*********************************************************************************************************************/

