{{
  config(
    materialized='table'
  )
}}

SELECT 
    promo_id,
    discount,
    status AS promo_status
FROM {{ source('postgres', 'promos') }}