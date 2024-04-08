{{ 
    config(materialized = 'table') 
}} 


WITH product_view AS (
    SELECT 
        session_id,
        user_id,
        product_id,
        min(created_at) AS created_at
    FROM {{ ref('int_page_views') }}
    GROUP BY 1, 2, 3
),
add_to_cart AS (
    SELECT 
        session_id,
        user_id,
        product_id,
        min(created_at) AS created_at
    FROM {{ ref('int_product_add_to_cart') }}
    GROUP BY 1, 2, 3
),
checkout AS (
    SELECT 
        session_id,
        user_id,
        order_id,
        min(created_at) AS created_at
    FROM {{ ref('int_session_checkout') }}
    GROUP BY 1, 2, 3
),
product AS (
    SELECT *
    FROM {{ ref('stg_postgres_products') }}
)
SELECT 
    pv.session_id,
    pv.user_id,
    pv.product_id,
    p.name as product_name,
    pv.created_at AS viewed_at,
    iff(atc.session_id IS NOT NULL, 1, 0) AS added_to_cart,
    atc.created_at AS added_to_cart_at,
    iff(c.session_id IS NOT NULL, 1, 0) AS checked_out,
    c.created_at AS checked_out_at,
    iff(atc.session_id IS NOT NULL AND c.session_id IS NOT NULL, 1, 0) AS converted,
    c.order_id
FROM product_view pv
JOIN product p 
    ON pv.product_id = p.product_id
LEFT JOIN add_to_cart atc 
    ON pv.session_id = atc.session_id
    AND pv.product_id = atc.product_id
LEFT JOIN checkout c
    ON pv.session_id = c.session_id
