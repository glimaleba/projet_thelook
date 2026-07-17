-- kpi taux réachat par année
WITH commandes_clients AS (

    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS NB_COMMANDES
    FROM `lookecommerce-502712.thelook_fr_women_2023_2024.sales`
    WHERE
          department = "Women"
      AND country = "France"
      AND item_status = "Complete"
      AND EXTRACT(YEAR FROM delivered_at) = 2024
    GROUP BY user_id

),

kpi_reachat AS (

    SELECT
        COUNT(*) AS NOMBRE_CLIENTS_TOTAL,
        COUNTIF(NB_COMMANDES >= 2) AS CLIENTS_REACHAT
    FROM commandes_clients

)

SELECT
    ROUND(
        CLIENTS_REACHAT * 100.0 / NOMBRE_CLIENTS_TOTAL
    ,2) AS TAUX_REACHAT
FROM kpi_reachat;