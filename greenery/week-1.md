# Week 1 Project

## 1. How many users do we have?
Query:
```
SELECT
    COUNT(*)
FROM dev_db.dbt_markmawgmailcom.stg_postgres_users;
```
Result:
```
130
```

## 2. On average, how many orders do we receive per hour?
Query:
```
WITH hour_orders AS (
    SELECT
        DATE_TRUNC('hour', created_at),
        COUNT(*) as total
    FROM dev_db.dbt_markmawgmailcom.stg_postgres_orders
    GROUP BY 1
)
SELECT
    AVG(total)
FROM hour_orders;
```
Result:
```
7.520833
```

## 3. On average, how long does an order take from being placed to being delivered?
Query:
```
select
    concat(
        to_char(trunc(AVG(DATEDIFF('hour', created_at, delivered_at)) / 24)),
        ' days ',
        to_char(trunc(mod(AVG(DATEDIFF('hour', created_at, delivered_at)) / 24, 1) * 24)),
        ' hours'
    )
from dev_db.dbt_markmawgmailcom.stg_postgres_orders
where status = 'delivered';
```
Result:
```
3 days 21 hours
```

## 4. How many users have only made one purchase? Two purchases? Three+ purchases?

Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

Query:
```
WITH user_purchase_counts AS (
    SELECT
        user_id,
        COUNT(DISTINCT order_id) as total
    FROM dev_db.dbt_markmawgmailcom.stg_postgres_orders
    GROUP BY 1
)
SElECT
    SUM(IFF(total = 1, 1, 0)) as one_purchase,
    SUM(IFF(total = 2, 1, 0)) as two_purchases,
    SUM(IFF(total > 2, 1, 0)) as three_plus_purchases
FROM user_purchase_counts;
```
Result:
```
ONE_PURCHASE	TWO_PURCHASES	THREE_PLUS_PURCHASES
25	        28	        71
```

## 5. On average, how many unique sessions do we have per hour?
Query:
```
WITH hour_sessions AS (
    SELECT
        DATE_TRUNC('hour', created_at),
        COUNT(DISTINCT session_id) as total
    FROM dev_db.dbt_markmawgmailcom.stg_postgres_events
    GROUP BY 1
)
SELECT
    AVG(total)
FROM hour_sessions;
```
Result:
```
16.327586
```
