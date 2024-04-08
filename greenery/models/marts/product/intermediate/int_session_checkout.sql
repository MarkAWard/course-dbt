WITH EVENTS AS (
    SELECT *
    FROM {{ ref('stg_postgres_events') }}
    WHERE event_type = 'checkout'
)

SELECT 
    event_id,
    user_id,
    session_id,
    order_id,
    created_at
FROM EVENTS
