import pandas as pd
from typing import Any

def exemple_valeurs_dataset(df: pd.DataFrame) -> list[Any]:
    """
    Retourne une liste contenant un exemple de valeur non nulle pour chaque
    colonne du DataFrame.

    Pour chaque colonne, la fonction parcourt les lignes jusqu'à trouver
    la première valeur non nulle, puis l'ajoute à la liste des exemples.

    Si une colonne ne contient que des valeurs nulles, aucun exemple n'est
    ajouté pour cette colonne.
    
    """

    exemples: list[Any] = []

    for colonne in df.columns:
        for i in range(len(df)):
            if pd.notna(df[colonne][i]):
                exemples.append(df[colonne][i])
                break

    return exemples