--TODO: Для каждого продукта, у которого цена больше 7000, найти все заказы, в которых скидка равна минимально для этого конкретного продукта или максимальной для этого конкретного продукта

SELECT p.product_id,
       p.product_name,
       oi.list_price,
       o.order_date,
       oi.discount
FROM [sales].[orders] o
    INNER JOIN [sales].[order_items] oi
        ON o.order_id = oi.order_id
    INNER JOIN [production].[products] p
        ON p.product_id = oi.product_id
        AND oi.list_price > 7000
ORDER BY p.product_id,
         p.product_name

        
--TODO: Для каждого года выпуска продукта найдите топ 5 продуктов с самыми большими продажами
--- Can't get how to make TOP 5 working.. below all mytrial and errors, would be great if you could help to understnd where is teh issue.. thank you in advance!
SELECT
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
GROUP BY p.model_year,
         p.product_id,
         p.product_name

---- Union All 
Select p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
  FROM (SELECT TOP (5)
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
    FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
        WHERE p.model_year = '2016'
        GROUP BY p.model_year,
         p.product_id,
         p.product_name
         Order by SUM(oi.list_price - oi.list_price * oi.discount)desc) AS a 
Union all 
Select p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
  FROM (SELECT TOP (5)
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
    FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
        WHERE p.model_year = '2017'
        GROUP BY p.model_year,
         p.product_id,
         p.product_name
         Order by SUM(oi.list_price - oi.list_price * oi.discount)desc) AS b;
         GO 


 -- working ranking 
 SELECT
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales,
RANK()OVER (partition by p.model_year Order by SUM(oi.list_price - oi.list_price * oi.discount)desc) as sales_rank
FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
GROUP BY p.model_year,
         p.product_id,
         p.product_name
---- 

Select TOP 5 *
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
FROM 
( SELECT
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales,
RANK()OVER (partition by p.model_year Order by SUM(oi.list_price - oi.list_price * oi.discount)desc) as sales_rank
FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
GROUP BY p.model_year,
         p.product_id,
         p.product_name )

--- CTE trial
WITH CTE_Sales as
(SELECT
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
GROUP BY p.model_year,
         p.product_id,
         p.product_name 

-------------GO

SELECT * FROM [production].[products] p

Select TOP 5 
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
GROUP BY p.model_year,
         p.product_id,
         p.product_name
Order by p.model_year


--- TOP + CTE

WITH sum_sales
AS (Select 
        SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
FROM sales.order_items )
        
WITH max_sales
AS (SELECT p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
GROUP BY p.model_year,
         p.product_id,
         p.product_name
Order by p.model_year) 
SELECT p.product_id,
       p.product_name,
       SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales
FROM [production].[products] p
    INNER JOIN max_sales md
        ON p.product_id = md.product_id
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
           AND oi.discount = md.max_discount
ORDER BY p.product_id


-- working ranking + filter
 SELECT
      p.model_year,
      p.product_id,
      p.product_name,
      SUM(oi.list_price - oi.list_price * oi.discount) AS sum_sales,
RANK()OVER (partition by p.model_year Order by SUM(oi.list_price - oi.list_price * oi.discount)desc) as sales_rank
FROM [production].[products] p
    INNER JOIN sales.order_items oi
        ON oi.product_id = p.product_id
    WHERE (RANK()OVER (partition by p.model_year Order by SUM(oi.list_price - oi.list_price * oi.discount)desc) >=5)
GROUP BY p.model_year,
         p.product_id,
         p.product_name
