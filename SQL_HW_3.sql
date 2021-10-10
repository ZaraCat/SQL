SELECT p.product_id,
       p.product_name,
       p.model_year,
       AVG(ISNULL(CAST(oi.discount AS decimal(38,6)), 0.000000)) AS avg_disc
FROM [production].[products] p
    LEFT JOIN [sales].[order_items] oi
        ON p.product_id = oi.product_id
             WHERE [model_year] IN (2016)
GROUP BY p.product_id,
         p.product_name,
        p.model_year
HAVING AVG(ISNULL(CAST(oi.discount AS decimal(38,6)), 0.000000)) >= 0
    AND AVG(ISNULL(CAST(oi.discount AS decimal(38,6)), 0.000000)) <= 0.105581
