import pandas as pd
from typing import Any

# Le but est d'enrichir le tableau de description des colonnes du dataset avec un exemple de valeur pour chaque colonne.
def exemple_valeurs_dataset(df: pd.DataFrame) -> list[Any]:
    """
    Retourne une liste contenant un exemple de valeur non nulle pour chaque colonne du DataFrame.

    Pour chaque colonne, la fonction parcourt les lignes jusqu'à trouver
    la première valeur non nulle, puis l'ajoute à la liste des exemples.

    Si une colonne ne contient que des valeurs nulles, aucun exemple n'est ajouté pour cette colonne.
     
    """
    exemples: list[Any] = []

    for colonne in df.columns:
            for i in range(len(df)):
                  if pd.notna(df.loc[i, colonne]):
                        exemples.append(df.loc[i, colonne])
                        break
    return exemples

# Le but est de mieux comprendre les valeurs manquantes dans la colonne shipped_at en les regroupant par statut de commande (order_status).
# Fonction (suivante) présentant le nombre de valeurs manquantes dans la colonne shipped_at pour chaque statut de commande (order_status)
def valeurs_manquantes_shipped_at_par_statut(df: pd.DataFrame) -> pd.DataFrame:

    """
    Retourne un DataFrame contenant le nombre de valeurs manquantes dans la colonne shipped_at pour chaque statut de commande.

    On parcours les index de la colonne shipped_at; pour chaque valeur manquante, on incrémente le compteur correspondant au statut de commande.
     
    """

    compteurs = {
        "Processing": 0,
        "Shipped": 0,
        "Completed": 0,
        "Cancelled": 0,
        "Returned": 0,
        "Statut Manquant": 0
    }

    for i in range(len(df)):
        if pd.isnull(df.loc[i, "shipped_at"]):
            statut = df.loc[i, "order_status"]

            if statut in compteurs:
                compteurs[statut] += 1
            else:
                compteurs["Statut Manquant"] += 1

    resultat = pd.DataFrame({
        "Order_Status": compteurs.keys(),
        "Nbre_valeurs_manquantes_shipped_at": compteurs.values()
    })

    return resultat


# Le but est de mieux comprendre les valeurs manquantes dans la colonne delivered_at en les regroupant par statut de commande (order_status).
# Fonction (suivante) présentant le nombre de valeurs manquantes dans la colonne delivered_at pour chaque statut de commande (order_status)
def valeurs_manquantes_delivered_at_par_statut(df: pd.DataFrame) -> pd.DataFrame:

    """
    Retourne un DataFrame contenant le nombre de valeurs manquantes dans la colonne delivered_at pour chaque statut de commande.

    On parcours les index de la colonne delivered_at; pour chaque valeur manquante, on incrémente le compteur correspondant au statut de commande.
     
    """

    compteurs = {
        "Processing": 0,
        "Shipped": 0,
        "Completed": 0,
        "Cancelled": 0,
        "Returned": 0,
        "Statut Manquant": 0
    }

    for i in range(len(df)):
        if pd.isnull(df.loc[i, "delivered_at"]):
            statut = df.loc[i, "order_status"]

            if statut in compteurs:
                compteurs[statut] += 1
            else:
                compteurs["Statut Manquant"] += 1

    resultat = pd.DataFrame({
        "Order_Status": compteurs.keys(),
        "Nbre_valeurs_manquantes_delivered_at": compteurs.values()
    })

    return resultat