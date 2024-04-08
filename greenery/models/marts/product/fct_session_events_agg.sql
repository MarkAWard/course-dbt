{{ 
    config(materialized = 'table') 
}} 


SELECT session_id,
    user_id,
    min(created_at) AS started_at,
    max(created_at) AS ended_at,
    datediff('seconds', min(created_at), max(created_at)) / 60 AS duration_minutes,
    COUNT(*) AS num_events,
    {{ sum_categorical('event_type', ['page_view', 'add_to_cart', 'checkout', 'package_shipped']) }},
    max(order_id) AS order_id
FROM {{ ref('stg_postgres_events') }}
GROUP BY session_id,
    user_id
