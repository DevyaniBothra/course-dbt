with orders as (
    select *
    from {{ ref('stg_orders') }}
)

, order_qty as (
    select order_id
    , count(distinct product_id) as product_lines
    , sum(quantity) as total_quantity
    from {{ ref('stg_order_items') }}
    group by order_id
)

, promos as (
    select *
    from {{ ref('stg_promos') }}
)

select    o.order_id
        , o.user_id
        , o.order_status
        , o.address_id
        , o.created_at
        , o.order_cost
        , o.shipping_cost
        , zeroifnull(p.discount) as promo_discount
        , o.order_total
        , o.shipping_service
        , o.estimated_delivery_at
        , o.delivered_at
        , timediff(hours, o.estimated_delivery_at, o.delivered_at) as delivery_delay
        , oq.product_lines as product_lines
        , oq.total_quantity as order_units

from orders o
left join order_qty oq
    on o.order_id = oq.order_id
left join promos p
    on o.promo_id = p.promo_id