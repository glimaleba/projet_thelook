--kpi 1: Chiffre d'affaires annuel

SELECT EXTRACT(YEAR FROM oi.delivered_at) AS ANNEE,
       SUM(oi.sale_price) AS CA --Chiffre d'affaires
-- Pour les tables suivantes, ordre logique: users,orders,order_items,products
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON u.id = o.user_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON o.order_id = oi.order_id
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON p.id = oi.product_id
--Les lignes suivantes servent à respecter le périmètre
WHERE  oi.delivered_at >= '2023-01-01'AND oi.delivered_at < '2025-01-01' 
  AND p.department = "Women" --afin de respecter le périmètre
  AND u.country = "France" --afin de respecter le périmètre
  AND oi.status = "Complete" -- car ventes
GROUP BY ANNEE -- ou EXTRACT(YEAR FROM oi.delivered_at); cette ligne permet de grouper par année 
ORDER BY ANNEE;

--Resultats: 
--	2023	8349.5400056838989
--	2024	10622.750042915344	


--kpi 2: Marge brute

SELECT EXTRACT(YEAR FROM oi.delivered_at) AS ANNEE,
       SUM(oi.sale_price-p.cost) AS MARGE_BRUTE
-- Pour les tables suivantes, ordre logique: users,orders,order_items,products
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON u.id = o.user_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON o.order_id = oi.order_id
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON p.id = oi.product_id
--Les lignes suivantes servent à respecter le périmètre
WHERE  oi.delivered_at >= '2023-01-01'AND oi.delivered_at < '2025-01-01' 
  AND p.department = "Women" --afin de respecter le périmètre
  AND u.country = "France" --afin de respecter le périmètre
  AND oi.status = "Complete" -- car ventes
GROUP BY ANNEE -- ou EXTRACT(YEAR FROM oi.delivered_at); cette ligne permet de grouper par année 
ORDER BY ANNEE;

-- Résultats: 
--	2023	4282.7899300807712
--	2024	5569.5916364905543	

