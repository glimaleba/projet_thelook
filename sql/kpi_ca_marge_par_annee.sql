--kpi 1: Chiffre d'affaires annuel
SELECT 
    SUM(sale_price) AS `CHIFFRE D'AFFAIRE`,
    EXTRACT(YEAR FROM delivered_at) AS ANNEE
FROM `lookecommerce-502712.thelook_fr_women_2023_2024.sales`
WHERE department = "Women"
  AND country = "France"
  AND item_status = "Complete"
  AND EXTRACT(YEAR FROM delivered_at) IN (2023, 2024)
GROUP BY ANNEE
ORDER BY ANNEE;
--kpi 2: Marge brute
SELECT 
    EXTRACT(YEAR FROM delivered_at) AS ANNEE,
    SUM(sale_price - cost) AS `MARGE BRUTE`
FROM `lookecommerce-502712.thelook_fr_women_2023_2024.sales`
WHERE department = "Women"
  AND country = "France"
  AND item_status = "Complete"
  AND EXTRACT(YEAR FROM delivered_at) IN (2023, 2024)
GROUP BY ANNEE
ORDER BY ANNEE;

