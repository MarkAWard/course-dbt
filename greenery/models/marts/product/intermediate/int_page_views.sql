WITH EVENTS AS (
    SELECT *
    FROM {{ ref('stg_postgres_events') }}
    WHERE event_type = 'page_view'
)

SELECT 
    event_id,
    user_id,
    session_id,
    product_id,
    page_url,
    created_at
FROM EVENTS
