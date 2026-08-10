# Étude et analyse des données e-commerce de TheLook Europe

**Projet de fin de formation — DataGong, Data Analyst**
Auteur : Limaleba Germain

## 🎯 Contexte et objectif

En tant que Data Analyst, ce projet vise à fournir une **étude et une analyse comparative de la performance des activités e-commerce de TheLook Europe**, sur le périmètre suivant :

- **Pays** : France
- **Département produit** : Women
- **Période** : du 01/01/2023 au 31/12/2024

L'objectif est de comprendre les principales tendances de l'activité et de mesurer leur évolution entre 2023 et 2024 à travers les KPIs suivants : **chiffre d'affaires, marge brute, volume de commandes, panier moyen, taux de retour et taux de ré-achat**.

L'analyse cherche également à identifier les tendances mensuelles, les contributions par marque/catégorie/ville, ainsi que les éventuelles ruptures de performance, afin d'éclairer les décisions du management.

## 🧭 Méthodologie du projet

Le projet se déroule en trois étapes, dans un objectif de traçabilité et de validation croisée des résultats :

1. **EDA Python** — Exploration, contrôle qualité et calcul des KPI à partir du fichier CSV fourni.
2. **Validation SQL (BigQuery)** — Recalcul des KPI directement sur la source de vérité (`bigquery-public-data.thelook_ecommerce`) et reconstruction du sous-périmètre.
3. **Restitution Power BI** — Construction d'un tableau de bord permettant de suivre les KPI, comparer 2023 et 2024, et explorer les contributions par marque, catégorie et ville.

### Conventions métier

| Statut | Interprétation analytique | Utilisation |
|---|---|---|
| `Complete` | Vente réalisée / commande complète | CA, marge, panier moyen, ré-achat |
| `Returned` | Article retourné | Taux de retour |
| `Shipped` | Article expédié | Analyse descriptive |
| `Processing` | Article en cours de traitement | Analyse descriptive |
| `Cancelled` | Article / commande annulé(e) | Analyse descriptive |

- **Chiffre d'affaires** : somme de `sale_price` sur les lignes `Complete`.
- **Marge brute** : somme de `sale_price - cost` sur les lignes `Complete`.
- **Panier moyen** : CA / nombre de commandes distinctes ayant généré un revenu positif.
- **Taux de retour** : lignes `Returned` / (`Complete` + `Returned`).
- **Taux de ré-achat** : clients ayant au moins 2 commandes `Complete` / clients ayant au moins 1 commande `Complete`, par année.
- **Date de référence** pour l'analyse de performance : `delivered_at`.

## 📂 Structure du dépôt

```
.
├── data/
│   └── thelook_fr_women_2023_2024.csv     # Extrait fourni pour l'EDA Python
├── notebooks/
│   └── 01_EDA_python.ipynb                # Analyse exploratoire, qualité des données, KPI
├── src/
│   └── utils.py                           # Fonctions utilitaires (ex. top_contributors)
├── sql/
│   ├── extract_sous_perimetre.sql         # Reconstruction du périmètre depuis BigQuery
│   ├── kpi_ca_marge_par_annee.sql         # KPI 1 & 2 : CA et marge brute
│   ├── kpi_aov_par_annee.sql              # KPI 4 : panier moyen
│   ├── kpi_taux_retour_par_annee.sql      # KPI : taux de retour
│   └── kpi_taux_reachat_par_annee.sql     # KPI : taux de ré-achat
├── dashboard/
│   └── E_Commerce_Project_Datagong.pbix   # Tableau de bord Power BI
├── presentation/
│   └── Presentation_Datagong_Ecommerce_LimalebaGermain.pptx
└── README.md
```

> Le notebook charge le CSV via `../data/thelook_fr_women_2023_2024.csv` et `utils.py` via le dossier `src/` — respecter cette arborescence pour l'exécuter sans modification.

## 🗃️ Données

- **Source d'origine** : `bigquery-public-data.thelook_ecommerce` (tables `users`, `orders`, `order_items`, `products`).
- **Fichier CSV fourni** (`thelook_fr_women_2023_2024.csv`) : 1 679 lignes d'articles de commande, une ligne = un `order_item_id`.
- **Écart constaté avec BigQuery** : la requête `extract_sous_perimetre.sql` renvoie 1 294 lignes sur le même périmètre (filtre sur `created_at`), contre 1 679 dans le CSV fourni — cet écart est documenté et peut expliquer certaines différences entre les résultats Python et les résultats SQL directs.
- **Colonnes principales** : identifiants (commande, article, produit, client), dates (`item_created_at`, `order_created_at`, `shipped_at`, `delivered_at`), statuts, prix de vente (`sale_price`) et coût (`cost`), attributs produit (marque, catégorie, département, nom) et attributs client (sexe, pays, région, ville).

## 🐍 Notebook — `01_EDA_python.ipynb`

Structure du notebook :

1. Environnement de travail et chargement du CSV
2. Compréhension du jeu de données (structure, dictionnaire de données)
3. Contrôle qualité des données (valeurs manquantes, doublons, formats de dates, cohérence temporelle)
4. Analyse des statuts (répartition, taux d'annulation et de retour par catégorie/marque/ville)
5. Distributions du prix de vente et du coût (lignes `Complete`)
6. Contributions au chiffre d'affaires — top 15 marques, catégories, villes (via `top_contributors` de `utils.py`)
7. Saisonnalité mensuelle (CA, marge, prix moyen par mois)
8. Calcul des KPI annuels (tableau de synthèse 2023 vs 2024)
9. Comparaison mensuelle et identification des ruptures de tendance
10. Synthèse des enseignements et transition vers l'étape SQL / Power BI

### Principaux enseignements (2023 → 2024)

- Le chiffre d'affaires et la marge brute progressent conjointement, portés par la croissance du nombre de commandes et du panier moyen (81,06 → 85,61 sur la base Python).
- Le taux de retour diminue (38,03 % → 30,5 % sur la base Python), un signal favorable.
- Le taux de ré-achat progresse (0,0 % → 3,41 % sur la base Python).
- L'analyse mensuelle révèle des écarts marqués selon les mois (ex. baisse du CA en novembre liée à une baisse du prix moyen des articles vendus).

> ⚠️ Les valeurs calculées en Python sur le CSV et celles calculées en SQL sur BigQuery peuvent différer légèrement, en raison de l'écart de volumétrie mentionné ci-dessus. Chaque écart doit être expliqué avant validation finale des KPI.

## 🗄️ Requêtes SQL (validation BigQuery)

| Fichier | Objet |
|---|---|
| `extract_sous_perimetre.sql` | Reconstruction du périmètre (France / Women / 2023-2024) depuis les tables BigQuery |
| `kpi_ca_marge_par_annee.sql` | Chiffre d'affaires et marge brute par année |
| `kpi_aov_par_annee.sql` | Panier moyen par année |
| `kpi_taux_retour_par_annee.sql` | Taux de retour par année |
| `kpi_taux_reachat_par_annee.sql` | Taux de ré-achat par année |

Résultats obtenus en SQL (source de vérité BigQuery) :

| KPI | 2023 | 2024 |
|---|---|---|
| Chiffre d'affaires | 8 349,54 | 10 622,75 |
| Marge brute | 4 282,79 | 5 569,59 |
| Panier moyen | 90,76 | 74,81 |
| Taux de retour (%) | 23,68 | 26,32 |
| Taux de ré-achat (%) | 1,1 | 4,41 |

## 📊 Tableau de bord Power BI

`dashboard/E_Commerce_Project_Datagong.pbix` restitue les KPI validés en SQL sous forme de tableau de bord interactif permettant de :
- suivre l'évolution des KPI (CA, marge, panier moyen, taux de retour, taux de ré-achat) entre 2023 et 2024 ;
- comparer les deux années ;
- explorer les contributions par marque, catégorie et ville.

## 📽️ Présentation

`presentation/Presentation_Datagong_Ecommerce_LimalebaGermain.pptx` synthétise la démarche, les enseignements clés et les recommandations à destination du management e-commerce.

## ▶️ Reproduire l'analyse

1. Cloner le dépôt et respecter l'arborescence `data/`, `notebooks/`, `src/`.
2. Installer les dépendances Python nécessaires (`pandas`, `numpy`, `matplotlib`, `seaborn`).
3. Lancer `notebooks/01_EDA_python.ipynb`.
4. Exécuter les requêtes du dossier `sql/` sur BigQuery pour valider les KPI (nécessite un accès au dataset public `bigquery-public-data.thelook_ecommerce`).
5. Ouvrir `dashboard/E_Commerce_Project_Datagong.pbix` avec Power BI Desktop pour explorer le tableau de bord.

## ⚠️ Points de vigilance

- Les anomalies temporelles du CSV sont documentées, non supprimées automatiquement.
- Les KPI financiers reposent exclusivement sur les lignes `Complete`.
- Le taux de retour repose sur `Returned / (Complete + Returned)`.
- Le taux de ré-achat est calculé au niveau client, par année.
- Tout écart entre les résultats Python (CSV) et SQL (BigQuery) doit être expliqué avant restitution finale.
