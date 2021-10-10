SELECT model_year,
       AVG([list_price]) AS AVG_Price
FROM [production].[products]
WHERE [list_price] >= 832.99
GROUP BY model_year
HAVING MIN([list_price]) > 850
ORDER BY model_year

Not sure why 2019 has diffrent value from key in PPT. 