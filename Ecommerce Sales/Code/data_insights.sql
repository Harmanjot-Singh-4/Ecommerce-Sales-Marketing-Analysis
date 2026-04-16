-- =============================================
-- TASK: Growth & Engagement Analytics
-- =============================================

--1. Top 10 most sellable Product_Category ?

select 
os."Product_Category" , 
count(os."Quantity")  as Number_of_Sales
from online_sales os 
group by os."Product_Category"
order by Number_of_Sales  desc
limit 10;


--2. Actual Net Revenue(NR) , Total Marketing Spend, Total Return on ad spend (ROAS), Online and Offline RAOS both Separate ?


with discount as (select dc."Month", dc."Discount_pct" , dc."Product_Category"
from discount_coupon dc 
group by 1,2,3) , 

tax as (select ta."Product_Category" , ta."GST"  
from tax_amount ta 
),

spends as (select
sum(ms."Online_Spend") as Online,
sum(ms."Offline_Spend") as Offline
from marketing_spend ms
),

sales as (select
os."Coupon_Status",
d."Discount_pct",
t."GST",
os."Quantity" * os."Avg_Price" as gross_revenue
from online_sales os
left join discount d on os."Product_Category" = d."Product_Category" and to_char(os."Transaction_Date",'Mon') = d."Month"
inner join tax t on os."Product_Category" = t."Product_Category"
left join marketing_spend ms on os."Transaction_Date" = ms."Date"
),

lasts as (select 
round(sum(
(gross_revenue - (case when "Coupon_Status" = 'Used' then (gross_revenue * coalesce("Discount_pct",0)/100) else 0 end ))
- ((gross_revenue - (case when "Coupon_Status" = 'Used' then (gross_revenue * coalesce("Discount_pct",0)/100) else 0 end)) * "GST"/100) )::numeric,2)
as Net_revenue
from sales)

select 
Net_revenue , 
round((Online + Offline)::numeric,2) as total_marketing_spend,
round((Net_revenue/(Online + Offline))::numeric,2) as Total_ROAS,
round((Net_revenue/Online)::numeric,2) as Online_ROAS,
round((Net_revenue/Offline)::numeric,2) as Offline_ROAS
from lasts , spends; 

--3. Which product category has more tax impact ratio ?

with product_table as (select 
os."Quantity" * os."Avg_Price" as gross_revenue ,
ta."GST",
os."Product_Category"
from online_sales os
inner join tax_amount ta on os."Product_Category" = ta."Product_Category"
)
select  
"Product_Category",
"GST" as GST,
round(sum("gross_revenue")::numeric,2) as Total_Sale,
round(("GST" / sum("gross_revenue"))::numeric, 4) as tax_impact_ratio
from product_table
group by "Product_Category" , "GST"
order by "tax_impact_ratio" desc
limit 5;

--4. where are the most customers are from ?

select 
count("CustomerID") as number_of_customers,
"Location" 
from customersdata
group by "Location" 
order by number_of_customers desc;

--5.  Does a loyal customer spend more per transaction than a new one? 

WITH loyalty_buckets AS (
    SELECT 
        c."CustomerID",
        CASE 
            WHEN c."Tenure_Months" > 12 THEN 'Loyal (1yr+)'
            WHEN c."Tenure_Months" BETWEEN 6 AND 12 THEN 'Regular'
            ELSE 'New (<6mo)'
        END AS customer_segment,
        SUM(os."Quantity" * os."Avg_Price") as total_spend,
        COUNT(os."Transaction_ID") as transaction_count
    FROM customersdata c
    INNER JOIN online_sales os ON c."CustomerID" = os."CustomerID"
    GROUP BY 1, 2
)
SELECT
    customer_segment,
    COUNT("CustomerID") as total_customers,
    ROUND((SUM(total_spend) / SUM(transaction_count))::numeric, 2) as avg_spend_per_transaction
FROM loyalty_buckets
GROUP BY 1
ORDER BY avg_spend_per_transaction DESC;

--6. See which Locations uses or not uses how much percentage of coupons for discounts ?

with cus_table as (select 
count(os."Transaction_ID")::numeric as no_transactions ,  
sum(case WHEN os."Coupon_Status" = 'Used' THEN 1 else 0 end) as used,
sum(case WHEN os."Coupon_Status" != 'Used' THEN 1 else 0 end) as not_used,
c."Location" 
from online_sales os 
left join customersdata c on os."CustomerID" = c."CustomerID"
group by "Location")

select 
"Location",
round(("used"/"no_transactions") * 100 ,2) as coupon_used_percentage,
round((1 - ("used"/"no_transactions")) * 100 ,2) as coupon_not_used_percenatge
from cus_table
order by coupon_used_percentage asc , coupon_not_used_percenatge desc;

--7. Which Product Category has Highest Total ROAS (Return On Ad Spend) ?

with discount as (select dc."Month", dc."Discount_pct" , dc."Product_Category"
from discount_coupon dc 
group by 1,2,3) , 

tax as (select ta."Product_Category" , ta."GST"  
from tax_amount ta 
),

spends as (select
sum(ms."Online_Spend") as Online,
sum(ms."Offline_Spend") as Offline
from marketing_spend ms
),

sales as (select
os."Product_Category" ,
os."Coupon_Status",
d."Discount_pct",
t."GST",
os."Quantity" * os."Avg_Price" as gross_revenue
from online_sales os
left join discount d on os."Product_Category" = d."Product_Category" and to_char(os."Transaction_Date",'Mon') = d."Month"
inner join tax t on os."Product_Category" = t."Product_Category"
),

lasts as (select 
"Product_Category" , 
sum(
(gross_revenue - (case when "Coupon_Status" = 'Used' then (gross_revenue * coalesce("Discount_pct",0)/100) else 0 end ))
- ((gross_revenue - (case when "Coupon_Status" = 'Used' then (gross_revenue * coalesce("Discount_pct",0)/100) else 0 end)) * "GST"/100) )
as Net_revenue
from sales
group by 1)

select 
"Product_Category",
round(((Net_revenue/(Online + Offline)))::numeric,2) as Total_ROAS
from lasts , spends
order by 2 desc; 