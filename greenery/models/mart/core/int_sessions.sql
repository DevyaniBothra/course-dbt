with postgres_events as (
    select *
    from {{ ref('stg_events') }}
)

select SESSION_ID
    , user_id
    , min(created_at) session_start
    , max(case when event_type != 'package_shipped' then created_at else NULL end) session_end --package shipping is recorded as an event, leading to unusually long sessions - we exclude it for that reason
    , timediff(second, min(created_at), max(case when event_type != 'package_shipped' then created_at else NULL end)) session_duration
    , listagg(distinct product_id, ', ') products_viewed
    , count(*) as total_events
    , count(distinct product_id) as total_products
    , sum(case when event_type = 'page_view' then 1 else 0 end) as page_views
    , sum(case when event_type = 'add_to_cart' then 1 else 0 end) as adds_to_cart
    , sum(case when event_type = 'checkout' then 1 else 0 end) as checkouts
    , sum(case when event_type = 'package_shipped' then 1 else 0 end) as packages_shipped

from stg_events 
group by SESSION_ID, user_id