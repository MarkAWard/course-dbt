# Week 3 Project

## Part 1

### What is our overall conversion rate?
```
with checked_out_sessions as (
    select
        count(distinct session_id) as converted
    from dev_db.dbt_markmawgmailcom.fct_session_events_agg
    where total_checkout > 0
),
all_sessions as (
    select
        count(distinct session_id) as total
    from dev_db.dbt_markmawgmailcom.fct_session_events_agg
)
select
    converted,
    total,
    converted / total
from checked_out_sessions
outer join all_sessions
```
Answer: `0.6245`

### What is our conversion rate by product?
```
select
    product_id,
    product_name,
    sum(converted) as sessions_converted,
    count(*) as total_sessions,
    sum(converted) / count(*) as conversion_rate
from dev_db.dbt_markmawgmailcom.fct_product_conversion_sessions
group by 1,2
order by conversion_rate desc
;
```
Answer:
```
PRODUCT_ID	PRODUCT_NAME	SESSIONS_CONVERTED	TOTAL_SESSIONS	CONVERSION_RATE
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls	39	64	0.609375
74aeb414-e3dd-4e8a-beef-0fa45225214d	Arrow Head	35	63	0.555556
c17e63f7-0d28-4a95-8248-b01ea354840e	Cactus	30	55	0.545455
b66a7143-c18a-43bb-b5dc-06bb5d1d3160	ZZ Plant	34	63	0.539683
689fb64e-a4a2-45c5-b9f2-480c2155624d	Bamboo	36	67	0.537313
579f4cd0-1f45-49d2-af55-9ab2b72c3b35	Rubber Plant	28	54	0.518519
be49171b-9f72-4fc9-bf7a-9a52e259836b	Monstera	25	49	0.510204
b86ae24b-6f59-47e8-8adc-b17d88cbd367	Calathea Makoyana	27	53	0.509434
e706ab70-b396-4d30-a6b2-a1ccf3625b52	Fiddle Leaf Fig	28	56	0.5
5ceddd13-cf00-481f-9285-8340ab95d06d	Majesty Palm	33	67	0.492537
615695d3-8ffd-4850-bcf7-944cf6d3685b	Aloe Vera	32	65	0.492308
35550082-a52d-4301-8f06-05b30f6f3616	Devil's Ivy	22	45	0.488889
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	Philodendron	30	62	0.483871
a88a23ef-679c-4743-b151-dc7722040d8c	Jade Plant	22	46	0.478261
64d39754-03e4-4fa0-b1ea-5f4293315f67	Spider Plant	28	59	0.474576
5b50b820-1d0a-4231-9422-75e7f6b0cecf	Pilea Peperomioides	28	59	0.474576
37e0062f-bd15-4c3e-b272-558a86d90598	Dragon Tree	29	62	0.467742
d3e228db-8ca5-42ad-bb0a-2148e876cc59	Money Tree	26	56	0.464286
c7050c3b-a898-424d-8d98-ab0aaad7bef4	Orchid	34	75	0.453333
05df0866-1a66-41d8-9ed7-e2bbcddd6a3d	Bird of Paradise	27	60	0.45
843b6553-dc6a-4fc4-bceb-02cd39af0168	Ficus	29	68	0.426471
bb19d194-e1bd-4358-819e-cd1f1b401c0c	Birds Nest Fern	33	78	0.423077
80eda933-749d-4fc6-91d5-613d29eb126f	Pink Anthurium	31	74	0.418919
e2e78dfc-f25c-4fec-a002-8e280d61a2f2	Boston Fern	26	63	0.412698
6f3a3072-a24d-4d11-9cef-25b0b5f8a4af	Alocasia Polly	21	51	0.411765
e5ee99b6-519f-4218-8b41-62f48f59f700	Peace Lily	27	66	0.409091
e18f33a6-b89a-4fbc-82ad-ccba5bb261cc	Ponytail Palm	28	70	0.4
e8b6528e-a830-4d03-a027-473b411c7f02	Snake Plant	29	73	0.39726
58b575f2-2192-4a53-9d21-df9a0c14fc25	Angel Wings Begonia	24	61	0.393443
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos	21	61	0.344262
```

## Part 6
### Which products had their inventory change from week 2 to week 3?
```
select
    product_id,
    name,
    inventory,
    lag(inventory) over(partition by product_id order by dbt_updated_at desc) as prev_inventory
from dev_db.dbt_markmawgmailcom.products_snapshot
qualify prev_inventory != inventory
```
Missed last weeks project so answer is really what changed since week 1
```
PRODUCT_ID	NAME	INVENTORY	PREV_INVENTORY
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	Philodendron	51	15
689fb64e-a4a2-45c5-b9f2-480c2155624d	Bamboo	56	44
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos	40	0
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls	58	0
be49171b-9f72-4fc9-bf7a-9a52e259836b	Monstera	77	50
b66a7143-c18a-43bb-b5dc-06bb5d1d3160	ZZ Plant	89	53
```
