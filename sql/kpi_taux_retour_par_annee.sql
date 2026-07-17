-- kpi Taux de retour par année
SELECT
     EXTRACT (YEAR FROM delivered_at) AS ANNEE,
     ROUND(COUNTIF(item_status='Returned')*100/COUNTIF(item_status IN ('Returned','Complete')),2) AS TAUX_RETOUR
FROM `lookecommerce-502712.thelook_fr_women_2023_2024.sales`
WHERE 
        department='Women'
    AND country='France'
    AND EXTRACT(YEAR FROM delivered_at) IN (2023,2024)
GROUP BY ANNEE
ORDER BY ANNEE;