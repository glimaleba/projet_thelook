-- kpi taux réachat par année

--Rappelons le périmètre utilisé : 
--France
--Département: Women
--Année basée sur oi.delivered_at
--Commandes Complete
--Taux de ré-achat = nombre de clients ayant au moins 2 commandes Complete / nombre de clients ayant au moins 1 commande Complete × 100

--Trouvons Table de calcul du nombre de clients ayant effectué au moins 1 commande complète (car taux de ré-achat est basé sur les commandes Complete) pour chaque année 2023 - 2024
WITH TABLE1 AS
(
SELECT EXTRACT(YEAR FROM oi.delivered_at) AS ANNEE,
       COUNT(DISTINCT o.user_id) AS NBR_CL --Nombre de clients ayant effectué au moins 1 commande
-- Pour les tables suivantes, ordre logique: users,orders,order_items,products
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON u.id = o.user_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON o.order_id = oi.order_id
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON p.id = oi.product_id
--afin de respecter le périmètre
WHERE  oi.delivered_at >= '2023-01-01'AND oi.delivered_at < '2025-01-01' 
  AND p.department = "Women" 
  AND u.country = "France" 
  AND o.status = "Complete" --car on veut clients ayant au moins une commande Complete
GROUP BY ANNEE
),

--Table de calcul du nombre de clients ayant au moins 2 commandes Complete dans chaque année 2023 - 2024
TABLE2 AS
(
SELECT ANNEE,
       COUNT(*) AS NB_CLIENTS_REACHAT--nombre de clients ayant au moins 2 commandes Complete 
FROM
(

SELECT EXTRACT(YEAR FROM oi.delivered_at) AS ANNEE,
       COUNT(DISTINCT o.order_id) AS NB_COMMANDES_COMPLETE_SUP_2,--On affiche les lignes ayant au moins 2 commandes complètes
       o.user_id 
-- Pour les tables suivantes, ordre logique: users,orders,order_items,products
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON u.id = o.user_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON o.order_id = oi.order_id
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON p.id = oi.product_id
--afin de respecter le périmètre
WHERE  oi.delivered_at >= '2023-01-01'AND oi.delivered_at < '2025-01-01' 
  AND p.department = "Women" 
  AND u.country = "France" 
  AND o.status="Complete" --Car nous voulons clients ayant ≥ 2 commandes "complètes"
GROUP BY o.user_id, ANNEE
HAVING NB_COMMANDES_COMPLETE_SUP_2>=2

) AS clients_reacheteurs
GROUP BY ANNEE
)
--Afficher taux de re-achat par année 2023 - 2024
SELECT t2.ANNEE,
       ROUND(t2.NB_CLIENTS_REACHAT*100/t1.NBR_CL,2) AS TAUX_REACHAT--Taux de re-achat
FROM TABLE1 AS t1
JOIN TABLE2 AS t2
  ON t1.ANNEE=t2.ANNEE

-- Le résultat :
-- 2023:	1.1	
-- 2024:	4.41
