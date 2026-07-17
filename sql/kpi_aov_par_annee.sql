--kpi 3: Nombre de commandes
SELECT 
    EXTRACT(YEAR FROM delivered_at) AS ANNEE,
    COUNT(DISTINCT order_id) AS `NOMBRE DE COMMANDES`
FROM `lookecommerce-502712.thelook_fr_women_2023_2024.sales`
WHERE department = "Women"
  AND country = "France"
  AND item_status = "Complete"
  AND EXTRACT(YEAR FROM delivered_at) IN (2023, 2024)
GROUP BY ANNEE
ORDER BY ANNEE;
--kpi 4: Panier moyen
SELECT 
    EXTRACT(YEAR FROM delivered_at) AS ANNEE,
    ROUND(SUM(sale_price) / COUNT(DISTINCT order_id), 2) AS `PANIER MOYEN`
FROM `lookecommerce-502712.thelook_fr_women_2023_2024.sales`
WHERE department = "Women"
  AND country = "France"
  AND item_status = "Complete"
  AND EXTRACT(YEAR FROM delivered_at) IN (2023, 2024)
GROUP BY ANNEE
ORDER BY ANNEE;