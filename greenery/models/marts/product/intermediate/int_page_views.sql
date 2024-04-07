WITH EVENTS AS (
    SELECT *
    FROM {{ ref('stg_postgres_events') }}
),
page_views AS (
    SELECT created_at,
        event_id,
        user_id,
        session_id,
        product_id,
        page_url
    FROM EVENTS
    WHERE event_type = 'page_view'
)
SELECT *
FROM page_views
