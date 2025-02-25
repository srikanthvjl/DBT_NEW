{{ 
    config(materialized ='incremental',
    unique_key='LOANNUMBER,ALTID',
    merge_update_columns=['OWNER','DESCRIPTION','MONTHLYAMOUNT',current_timestamp(),'BORROWERPOSITION'],
    incremental_strategy='merge')}}

select * from DBT_LEARN.DBT_SREDDY.TBL_OTHER_INCOME_SOURCES_DELTA

{% if is_incremental() %}
where LOAD_DTTM >=(select nvl(max(load_dttm),'1900-01-01 00:00:00.000') from {{this}})
{% endif %}