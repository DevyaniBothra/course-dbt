Questions:
    1. How many users do we have?
        Select count(distinct order_id) from DEV_DB.DBT_BOTHRADEVYANI.STG_ORDERS;
        - 130
    2. On average, how many orders do we receive per hour?
        Select avg(cnt) from(
        Select count(distinct order_id) as cnt, hour(created_at) as hr 
        from DEV_DB.DBT_BOTHRADEVYANI.STG_ORDERS
        group by hr);
        - 15
    3. On average, how long does an order take from being placed to being delivered?
        Select avg(timestampdiff(hour, created_at, delivered_at)) as diff from DEV_DB.DBT_BOTHRADEVYANI.STG_ORDERS;
        - 93.40
    4. How many users have only made one purchase? Two purchases? Three+ purchases?
        Select sum (cnt1),sum (cnt2),sum (cnt3) from(
        Select 
        (coalesce((case when cnt =1 then count(user_id) else null end),0)) as cnt1,
        (coalesce((case when cnt =2 then count(user_id) else null end),0)) as cnt2,
        (coalesce((case when cnt >=3 then count(user_id) else null end),0)) as cnt3
        from(
            Select distinct user_id,count (order_id) as cnt 
            from DEV_DB.DBT_BOTHRADEVYANI.STG_ORDERS group by 1) 
        group by cnt order by cnt);
        - 1 purchase = 25
          2 purchase = 28
          3 purchase = 71
    5. On average, how many unique sessions do we have per hour?
        
        with sessions as 
            (Select hour(created_at) as hour, count(distinct session_id) as unique_sessions 
            from DEV_DB.DBT_PLE.STG_EVENTS group by 1)
        select avg(unique_sessions) from sessions;
        - 39.5