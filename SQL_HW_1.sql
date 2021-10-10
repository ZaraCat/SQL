SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price]
FROM [production].[products]
WHERE [list_price] <= 1000
AND [category_id] IN (3,6)
AND product_name LIKE 'Sun%'
OR product_name LIKE '%Girl%'