{{
    config(materialized = 'view')
}}

with funnel_counts as (
    select
        sum(iff(total_page_view > 0, 1, 0)) as pv_total,
        sum(iff(total_add_to_cart > 0, 1, 0)) as atc_total,
        sum(iff(total_checkout > 0, 1, 0)) as co_total,    
    from {{ ref('fct_session_events_agg') }}
),
stage_0 as (
    select
        0 as Funnel,
        'Page View Sessions' as Stage,
        pv_total as Total
    from funnel_counts
),
stage_1 as (
    select
        1 as Funnel,
        'Add to Cart Sessions' as Stage,
        atc_total as Total
    from funnel_counts
),
stage_2 as (
    select
        2 as Funnel,
        'Checkout Sessions' as Stage,
        co_total as Total
    from funnel_counts
),
funnel_base as (
    select * from stage_0
    union all
    select * from stage_1
    union all
    select * from stage_2
)
select 
    stage,
    total,
    round(total / (select max(total) from funnel_base) * 100, 2) as pct_of_total,
    round(total / coalesce(lag(total) over(order by funnel), total) * 100, 2) as pct_of_previous,
    round((coalesce(lag(total) over(order by funnel), total) - total) / coalesce(lag(total) over(order by funnel), total) * 100, 2) as pct_dropoff,
from funnel_base
order by funnel asc
