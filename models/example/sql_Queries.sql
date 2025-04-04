with CTE as (
select 'Delhi' as City, cast(1000 as INT) as saleamount, 'Sathya' as Customer_name
UNION ALL
select 'Mumbai' as City, cast(700 as INT) as saleamount, 'Ripu' as Customer_name
UNION ALL
select 'Delhi' as City, cast(350 as INT) as saleamount, 'Ripu' as Customer_name
UNION ALL
select 'Mumbai' as City, cast(100 as INT) as saleamount, 'Sathya' as Customer_name
UNION ALL
select 'Delhi' as City, cast(800 as INT) as saleamount, 'Ripu' as Customer_name
UNION ALL
select 'Mumbai' as City, cast(900 as INT) as saleamount, 'Sathya' as Customer_name
) 

--select * from CTE
select * from (
select City, Customer_name,sum(saleamount) saleamount,
row_number() over (partition by CITY order by sum(Saleamount) desc) rnk
from CTE
group by all ) where rnk =1;

CITY	SALEAMOUNT	CUSTOMER_NAME
Delhi	1000 Sathya
Mumbai	700	Ripu
Delhi	350	Ripu
Mumbai	100	Sathya
Delhi	800	Ripu
Mumbai	900	Sathya

CITY,CUSTOMER_NAME
DELHI RIPU
MUMBAI SATYA*/

select city,customer_name,row_number() over (partition by   )

select * from (
select City,CUSTOMER_NAME,sum(saleamount) over ( order by SALEAMOUNT DESC) RNK
from CTE
GROUP BY City,CUSTOMER_NAME 
)

;

/*************************************************************************************************/
select paytype,pay,* from (SELECT * FROM ENT_KYC.DI.EMPLOYMENT 
qualify 1 = DENSE_RANK() OVER(PARTITION BY LOANNUMBER ORDER BY DILOADDTTM DESC))EMPLOYMENT
UNPIVOT INCLUDE NULLS(PAY FOR PAYTYPE IN(BASEPAY,OVERTIMEPAY,BONUSPAY,COMMISSIONPAY,MILITARYENTITLEMENTS,OTHERPAY)) 
WHERE LOANNUMBER IN('806467007')
QUALIFY 1= ROW_NUMBER()OVER(PARTITION BY EMPLOYMENT.CUSTOMERID,EMPLOYMENT.LOANNUMBER,EMPLOYMENT.CUSTROLETYPECD,EMPLOYMENT.ID ORDER BY EMPLOYMENT.DILOADDTTM DESC);

SELECT * FROM ENT_KYC.DI.EMPLOYMENT where LOANNUMBER IN('806467007');


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

/////////////////////////////////////////////////////////////////////////////////////////////////


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

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--Time Differences:

select current_timestamp();
select current_session();
select to_timestamp('1732778329242111');
select to_timestamp('2024-11-28 07:18:49.242111','YYYY-MM-DD HH24:MI:SS.FF6');
select to_varchar(to_timestamp('2024-11-28 07:18:49.242111','YYYY-MM-DD HH24:MI:SS.FF6'),'YYYY-MM-DDTHH:MI:SS.FF6');
show pipes;
SELECT DATEDIFF(microsecond, '1970-01-01'::DATE, CURRENT_TIMESTAMP());

SELECT DATE_PART(epoch_microsecond, to_timestamp('2024-11-28 07:18:49.242111'));
show parameters like '%time%';
SELECT DATE_PART(epoch_microsecond, CURRENT_TIMESTAMP());

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN DATABASE ENT_KYC;
SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN SCHEMA ENT_KYC.CUST_MSTR;
SHOW PARAMETERS LIKE 'DATA_RETENTION_TIME_IN_DAYS' IN TABLE ENT_KYC.ENCOMPASS.TBL_BORROWER;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

with CTE as (
select 'srk@gmail.com' as Email_ID
UNION ALL
select 'srk1@gmail.com'
)
select EMAIL_ID,
regexp_instr(EMAIL_ID,'@'),
split_part(EMAIL_ID,'@',-1),
substr(EMAIL_ID,regexp_instr(EMAIL_ID,'@')+1) from CTE;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

with DEPENDENT_AGE_YEARS as (
SELECT * FROM ENT_KYC.DI.BORROWER,
LATERAL strtok_split_to_table(dependentsagesdescription,',')A
)
select CUSTOMERID,LOANNUMBER,array_agg(to_number(VALUE)) as dependentsagesdescription from DEPENDENT_AGE_YEARS  
where loannumber ='806393336' 
group by CUSTOMERID,loannumber
;

DEPENDENT_AGE_YEARS AS (
SELECT CUSTOMERID,LOANNUMBER,
ARRAY_AGG(TO_NUMBER(DEPENDENTSAGESDESCRIPTION)) AS DEPENDENTSAGESDESCRIPTION,
POSITIONNUMBER,CUSTROLETYPECD,BORROWERCLASSIFICATIONTYPE AS BORR_CLASSIFICATION_TYPE,DILOADDTTM 
FROM(
SELECT CUSTOMERID,LOANNUMBER,POSITIONNUMBER,CUSTROLETYPECD,BORROWERCLASSIFICATIONTYPE,
CASE WHEN REGEXP_COUNT(VALUE,'^[0-9]+$') = 1 THEN TO_NUMBER(VALUE) ELSE 0 END AS DEPENDENTSAGESDESCRIPTION,DILOADDTTM
FROM ENT_KYC.DI.BORROWER,
LATERAL STRTOK_SPLIT_TO_TABLE(TRANSLATE(REPLACE(DEPENDENTSAGESDESCRIPTION,' ','.'),$$.$$,','),',')A
) GROUP BY CUSTOMERID,LOANNUMBER,POSITIONNUMBER,CUSTROLETYPECD,BORR_CLASSIFICATION_TYPE,DILOADDTTM
QUALIFY ROW_NUMBER() OVER (PARTITION BY LOANNUMBER,POSITIONNUMBER,CUSTROLETYPECD,BORR_CLASSIFICATION_TYPE ORDER BY DILOADDTTM DESC,CUSTOMERID DESC) =1
)
