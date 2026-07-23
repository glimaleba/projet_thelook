--kpi 4: Panier moyen
WITH TABLE AS
(
SELECT EXTRACT(YEAR FROM oi.delivered_at) AS ANNEE,
       SUM(oi.sale_price) AS CA,--Chiffre d'affaire
       COUNT(DISTINCT o.order_id) AS NBRE_COMMANDE_POS --Nombre de commandes vendues
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
GROUP BY ANNEE
)

SELECT ROUND(CA/NBRE_COMMANDE_POS,2) AS PANIER_MOYEN,--panier moyen
       ANNEE
FROM TABLE
ORDER BY ANNEE;

-- Le Résultat:
-- 2023: 90.76 
-- 2024: 74.81