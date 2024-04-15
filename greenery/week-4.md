# Week 4 Project

## Part 1

### Which products had their inventory change from week 3 to week 4?
```
select
    product_id,
    name,
    inventory,
    dbt_updated_at as as_of_date,
    lag(inventory) over(partition by product_id order by dbt_updated_at asc) as prev_inventory,
    lag(dbt_updated_at) over(partition by product_id order by dbt_updated_at asc) as prev_as_of_date
from dev_db.dbt_markmawgmailcom.products_snapshot
qualify prev_inventory != inventory and as_of_date = (select max(dbt_updated_at) from dev_db.dbt_markmawgmailcom.products_snapshot)
order by product_id, as_of_date desc
```
Answer:
```
PRODUCT_ID	NAME	INVENTORY	AS_OF_DATE	PREV_INVENTORY	PREV_AS_OF_DATE
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos	20	2024-04-15 00:32:37.655	0	2024-04-07 22:19:21.327
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	Philodendron	30	2024-04-15 00:32:37.655	15	2024-04-07 22:19:21.327
689fb64e-a4a2-45c5-b9f2-480c2155624d	Bamboo	23	2024-04-15 00:32:37.655	44	2024-04-07 22:19:21.327
b66a7143-c18a-43bb-b5dc-06bb5d1d3160	ZZ Plant	41	2024-04-15 00:32:37.655	53	2024-04-07 22:19:21.327
be49171b-9f72-4fc9-bf7a-9a52e259836b	Monstera	31	2024-04-15 00:32:37.655	50	2024-04-07 22:19:21.327
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls	10	2024-04-15 00:32:37.655	0	2024-04-07 22:19:21.327
```

### Determine which products had the most fluctuations in inventory?
```
select
    product_id,
    name,
    count(*) as num_inventory_changes,
    min(inventory) as min_inventory,
    avg(inventory) as mean_inventory,
    median(inventory) as median_inventory,
    max(inventory) as max_inventory,
    coalesce(stddev(inventory), 0) as std_dev_inventory
from dev_db.dbt_markmawgmailcom.products_snapshot
group by 1, 2
order by std_dev_inventory desc
limit 10;
```
Answer: The `String of pearls` had the greatest fluctuations as measured by standard deviation
```
PRODUCT_ID	NAME	NUM_INVENTORY_CHANGES	MIN_INVENTORY	MEAN_INVENTORY	MEDIAN_INVENTORY	MAX_INVENTORY	STD_DEV_INVENTORY
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls	3	0	22.666667	10	58	31.005375873
b66a7143-c18a-43bb-b5dc-06bb5d1d3160	ZZ Plant	3	41	61	53	89	24.979991994
be49171b-9f72-4fc9-bf7a-9a52e259836b	Monstera	3	31	52.666667	50	77	23.115651256
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos	3	0	20	20	40	20
55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3	Philodendron	3	15	32	30	51	18.08314132
689fb64e-a4a2-45c5-b9f2-480c2155624d	Bamboo	3	23	41	44	56	16.703293088
6f3a3072-a24d-4d11-9cef-25b0b5f8a4af	Alocasia Polly	1	83	83	83	83	0
74aeb414-e3dd-4e8a-beef-0fa45225214d	Arrow Head	1	100	100	100	100	0
bb19d194-e1bd-4358-819e-cd1f1b401c0c	Birds Nest Fern	1	49	49	49	49	0
5ceddd13-cf00-481f-9285-8340ab95d06d	Majesty Palm	1	74	74	74	74	0
```

### Did we have any items go out of stock in the last 3 weeks?
```
select
    *
from dev_db.dbt_markmawgmailcom.products_snapshot
where inventory = 0
```
Answer: Yes, `Pothos` and `String of pearls` were out of stock for a period of time
```
PRODUCT_ID	NAME	PRICE	INVENTORY	DBT_SCD_ID	DBT_UPDATED_AT	DBT_VALID_FROM	DBT_VALID_TO
4cda01b9-62e2-46c5-830f-b7f262a58fb1	Pothos	30.5	0	f7928c33c9f7d18a52384d9af1db9158	2024-04-07 22:19:21.327	2024-04-07 22:19:21.327	2024-04-15 00:32:37.655
fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80	String of pearls	80.5	0	c6b8325227cd4b3eb5f8a07e72eeb7ec	2024-04-07 22:19:21.327	2024-04-07 22:19:21.327	2024-04-15 00:32:37.655
```

## Part 2

### Product funnel
Model: `product_funnel_agg`
Data:
```
STAGE	TOTAL	PCT_OF_TOTAL	PCT_OF_PREVIOUS	PCT_DROPOFF
Page View Sessions	578	100	100	0
Add to Cart Sessions	467	80.8	80.8	19.2
Checkout Sessions	361	62.46	77.3	22.7
```

## Part 3

### The dbt pitch

Adopting dbt will help us unlock our company's data's full potential. First off, efficiency. dbt automates the entire process of managing data models within Snowflake. It streamlines development, testing, and deployment of data transformations, saving us a ton of time and effort. With dbt, we can iterate faster, deliver more insights, and unlock more value for ourselves and our customers. But it's not just about speed. dbt also promotes standardization and consistency in our data modeling practices. This means everyone is working with reliable, well-documented data, reducing the risk of errors and discrepancies. Plus, it empowers our teams to be more self-sufficient, reducing our dependency on specialized data engineering resources. Having a shared, structured and modular framework for managing complex data transformations simplifies maintenance and troubleshooting, and reduces the overhead associated with managing data pipelines. Even though we are relaxing a dependency on data specialist, we get more visibility and collaboration. With version-controlled and documented data models, it's easier for everyone to understand and collaborate on data transformations. This transparency fosters better communication and alignment between our product and platform teams, leading to better data-driven decision-making across the board.
