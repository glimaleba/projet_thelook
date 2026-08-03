
def top_contributors(data, dimension, n=15):
    return (
        data.groupby(dimension, dropna=False)["sale_price"]
            .sum()
            .sort_values(ascending=False)
            .head(n)
            .sort_values()
    )