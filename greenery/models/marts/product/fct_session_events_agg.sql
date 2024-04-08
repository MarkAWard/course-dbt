{{ 
    config(materialized = 'table') 
}} 


SELECT session_id,
    user_id,
    min(created_at) AS started_at,
    max(created_at) AS ended_at,
    datediff('seconds', min(created_at), max(created_at)) / 60 AS duration_minutes,
    COUNT(*) AS num_events,
    sum(iff(event_type = 'page_view', 1, 0)) AS total_page_views,
    sum(iff(event_type = 'add_to_cart', 1, 0)) AS total_add_to_carts,
    sum(iff(event_type = 'checkout', 1, 0)) AS total_checkout,
    sum(iff(event_type = 'package_shipped', 1, 0)) AS total_package_shipped,
    max(order_id) AS order_id
FROM {{ ref('stg_postgres_events') }}
GROUP BY session_id,
    user_id
