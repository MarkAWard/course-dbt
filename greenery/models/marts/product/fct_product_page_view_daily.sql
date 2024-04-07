{{ 
    config(materialized = 'table') 
}} 

WITH page_views AS (
    SELECT *
    FROM {{ ref('int_page_views') }}
),
products AS (
    SELECT *
    FROM {{ ref('stg_postgres_products') }}
),
product_page_views AS (
    SELECT date_trunc(DAY, created_at) AS page_view_date,
        product_id,
        COUNT(event_id) AS page_view_count,
        COUNT(DISTINCT user_id) AS user_count
    FROM page_views
    GROUP BY page_view_date,
        product_id
),
final AS (
    SELECT pv.page_view_date,
        pv.product_id,
        p.name AS product_name,
        pv.page_view_count,
        pv.user_count
    FROM product_page_views pv
        JOIN products p ON pv.product_id = p.product_id
)
SELECT *
FROM final
