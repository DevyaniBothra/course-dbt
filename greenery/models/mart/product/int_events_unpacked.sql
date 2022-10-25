with unpack as (
    select  
         coalesce(poi.product_id, pe.product_id) product_id_coalesce
        , pe.event_id --note that the event id is no longer unique, since it can be the same if >1 products were checked out or shipped in a single event
        , pe.session_id
        , pe.user_id
        , pe.page_url
        , pe.created_at
        , pe.event_type
    from {{ ref('stg_order_items') }} poi
    
    full outer join {{ref('stg_events')}} pe
        on poi.order_id = pe.order_id
)

select
{{ dbt_utils.surrogate_key(['product_id_coalesce', 'event_id']) }} as surrogate_key
    , product_id_coalesce
    , event_id 
    , session_id
    , user_id
    , page_url
    , created_at
    , event_type
from unpack