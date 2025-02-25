{{ config(materialized='table') }}
WITH TBL_CUST2 as (
    select 1 as CUST_ID,
    'PRAVEEN' as NAME,
    'Ordered' as Order_status,
    current_time() as datetime
)
Select * from TBL_CUST2