
echo " create or replace TABLE WHQANALYSIS ( Description Varchar (512), START_TIME TIMESTAMP_LTZ(0), END_TIME TIMESTAMP_LTZ(0), WAREHOUSE_NAME VARCHAR(16777216), AVG_RUNNING NUMBER(38,2), AVG_QUEUED_LOAD NUMBER(38,2), AVG_QUEUED_PROVISIONING NUMBER(38,2), AVG_BLOCKED NUMBER(38,2)); " > setupsql 

# average number of queries queued because the warehouse was overloaded 
> loadqsql
for i in `cat whlist`
do 
  echo " INSERT INTO INO.DBC.WHQANALYSIS SELECT 'Load Q', * FROM TABLE(snowflake.information_schema.warehouse_load_history( date_range_start => dateadd('day',-14,Current_Date()), date_range_end   => Current_Date(), warehouse_name   => '$i')) WHERE (      avg_queued_load > 0 ) ; " >> loadqsql 
done 

# Average number queries queued because the warehouse was being provisioned 
> provqsql
for i in `cat whlist`
do 
  echo " INSERT INTO INO.DBC.WHQANALYSIS SELECT 'Provisioning Q', * FROM TABLE(snowflake.information_schema.warehouse_load_history( date_range_start => dateadd('day',-14,Current_Date()), date_range_end   => Current_Date(), warehouse_name   => '$i')) WHERE (      Avg_queued_provisioning > 0 ) ; " >> provqsql 
done 

#Average number of queries blocked by a transaction lock
> blocksql
for i in `cat whlist`
do 
  echo " INSERT INTO INO.DBC.WHQANALYSIS SELECT 'Blocked', * FROM TABLE(snowflake.information_schema.warehouse_load_history( date_range_start => dateadd('day',-14,Current_Date()), date_range_end   => Current_Date(), warehouse_name   => '$i')) WHERE (      avg_blocked > 0 ) ; " >> blocksql 
done 

# average number of queries executed 

> activesql
for i in `cat whlist`
do 
  echo " INSERT INTO INO.DBC.WHQANALYSIS SELECT 'Active', * FROM TABLE(snowflake.information_schema.warehouse_load_history( date_range_start => dateadd('day',-14,Current_Date()), date_range_end   => Current_Date(), warehouse_name   => '$i')) WHERE (      avg_running > 0 ) ; " >> activesql 
done 

