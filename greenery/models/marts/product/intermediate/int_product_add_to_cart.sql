WITH EVENTS AS (
    SELECT *
    FROM {{ ref('stg_postgres_events') }}
    WHERE event_type = 'add_to_cart'
)

SELECT 
    event_id,
    user_id,
    session_id,
    product_id,
    created_at
FROM EVENTS
