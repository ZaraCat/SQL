--CASE TODO: Для всех продуктов, у которых последние 4 символа в названии 
---продукта равны 2018 и название бренда равно 'Surly' посчитайте сумму продаж. 
--На основе суммы продаж категоризируйте продукты. 
--Если сумма продаж = 0,то категория равна 'No sales'. 
--Если сумма продаж строго меньше 2000, то категория равна 'Bad'. 
--Если сумма продаж от 2000 до 5000 включительно с обеих сторон, то категория равна 'Good'.
--Если сумма продаж строго больше 5000, то категория равна 'Excellent'.


SELECT p.product_id,
       p.product_name,
       RIGHT(p.product_name,4) as name_filter,
       SUM(oi.list_price - oi.list_price * oi.discount) AS total_sales,
       CASE
           WHEN SUM(oi.list_price - oi.list_price * oi.discount)
                BETWEEN 2000 AND 5000 THEN
               'Good'
           WHEN SUM(oi.list_price - oi.list_price * oi.discount) < 2000 THEN
               'Bad'
           WHEN SUM(oi.list_price - oi.list_price * oi.discount)
                = 0 THEN
               'No Sales'
           WHEN SUM(oi.list_price - oi.list_price * oi.discount)
                > 5000 THEN
               'Excellent'
           ELSE
               'NA'
       END AS Product_category
       FROM [production].[products] p
INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
        WHERE p.product_name LIKE '%Surly%' AND (RIGHT(p.product_name,4)) LIKE '%2018%'
GROUP BY p.product_id,
         p.product_name
ORDER BY total_sales DESC


--Функции TODO: Посчитайте сумму продаж велосипедов для каждого месяца (учитывая года).
--месяц и год берем из даты заказа. 
--Продажи берем из деталей заказа, как разницу между list price и discount * list price.

SELECT
   cast(YEAR(o.order_date) as varchar) + '-' + cast(MONTH(o.order_date) as varchar) as sales_period,
    SUM(oi.list_price - oi.list_price * oi.discount) AS sales_per_month
FROM [sales].[orders] o
INNER JOIN [sales].[order_items] oi
        ON oi.order_id = o.order_id
GROUP BY 
YEAR(o.order_date), 
MONTH(o.order_date) 
Order by 
YEAR(o.order_date), 
MONTH(o.order_date)

--- vs YA??? Can't get how to keep years aggregated to make it YA... 
SELECT
YEAR(o.order_date) as Sales_year,
MONTH(o.order_date) as sales_m,
SUM(oi.list_price - oi.list_price * oi.discount) AS sales_per_month,
Dateadd(y, -1, o.order_date) as last_year,
MONTH(o.order_date) as sales_m,
SUM(oi.list_price - oi.list_price * oi.discount) AS sales_per_month
FROM [sales].[orders] o
INNER JOIN [sales].[order_items] oi
        ON oi.order_id = o.order_id
GROUP BY 
YEAR(o.order_date), 
MONTH(o.order_date),
o.order_date
Order by 
YEAR(o.order_date), 
MONTH(o.order_date) 