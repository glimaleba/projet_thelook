-- Requête de reconstruction du périmètre (requête d'extraction)
-- users,orders,order_items,products
SELECT 
      oi.created_at AS DATE_ARTICLE,
      o.created_at AS DATE_COMMANDE,
      oi.status AS STATUT_ARTICLE,
      oi.sale_price AS PRIX_VENTE,
      p.cost AS COUT,
      p.brand AS MARQUE,
      p.category AS CATEGORIE,
      p.department AS DEPARTEMENT,
      p.name AS NOM_PRODUIT,
      o.order_id AS ID_COMMANDE,
      oi.id AS ID_ARTICLE,
      u.id AS ID_CLIENT,
      u.gender AS SEXE,
      u.country AS PAYS_CLIENT,
      u.state AS ETAT_PROVINCE_CLIENT,
      u.city AS VILLE_CLIENT

FROM `bigquery-public-data.thelook_ecommerce.users` AS u

JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o
    ON u.id = o.user_id

JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi
    ON o.order_id = oi.order_id
    
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
    ON p.id = oi.product_id

WHERE 
      u.country = 'France'
  AND p.department = 'Women'
  AND oi.created_at >= '2023-01-01' AND oi.created_at < '2025-01-01' -- Nous utilisons created_at car instruction metier 
ORDER BY 
      oi.created_at,
      o.order_id,
      oi.id;

