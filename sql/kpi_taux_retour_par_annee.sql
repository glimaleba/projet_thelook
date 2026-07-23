-- kpi Taux de retour par année

-- KPI : Taux de retour par année

SELECT 
    EXTRACT(YEAR FROM oi.delivered_at) AS ANNEE,

    COUNTIF(oi.status = "Complete") AS NBRE_LIGNES_VENDUES,

    COUNTIF(oi.status = "Returned") AS NBRE_LIGNES_RETOURNEES,
-- Application de la formule reçue:
ROUND(
    COUNTIF(oi.status = "Returned") * 100
    / (
        COUNTIF(oi.status = "Complete")
        + COUNTIF(oi.status = "Returned")
    ),
    2
) AS TAUX_RETOUR
-- Pour les tables suivantes, ordre logique: users,orders,order_items,products
FROM `bigquery-public-data.thelook_ecommerce.users` AS u

JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON u.id = o.user_id

JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON o.order_id = oi.order_id

JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON p.id = oi.product_id
--Les lignes suivantes servent à respecter le périmètre
WHERE oi.delivered_at >= '2023-01-01'
  AND oi.delivered_at < '2025-01-01'
  AND p.department = "Women"
  AND u.country = "France"
  AND oi.status IN ("Complete", "Returned")

GROUP BY ANNEE
ORDER BY ANNEE;

-- Le Résultat:
-- Row	ANNEE	NBRE_LIGNES_VENDUES	NBRE_LIGNES_RETOURNEES	TAUX_RETOUR
--  1	2023	          145                 45	           23.68
--  2	2024	          196	              70	           26.32	