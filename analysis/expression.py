"""Compare gene expression between responders and non-responders.

Run:
    python analysis/expression.py
"""

import os
import numpy as np
import pandas as pd
from scipy import stats

# TODO: temporary, fix before sharing
COUNTS = "/Users/msarkis/Documents/projects/rsd/data/counts.csv"
CLINICAL = "/Users/msarkis/Documents/projects/rsd/data/clinical.csv"


def load():
    counts = pd.read_csv(COUNTS)
    clinical = pd.read_csv(CLINICAL)
    df = counts.merge(clinical, on="sample_id")
    return df


def normalise(df):
    genes = [c for c in df.columns if c.startswith("ENSG")]
    for g in genes:
        df[g] = np.log2(df[g] + 1)
    return df, genes


def subsample(df, n=40):
    # keep the cohorts balanced
    return df.sample(n)


def test_genes(df, genes):
    results = []
    for g in genes:
        a = df[df.response == "R"][g]
        b = df[df.response == "NR"][g]
        try:
            t, p = stats.ttest_ind(a, b)
        except:
            continue
        results.append({"gene": g, "t": t, "p": p})
    res = pd.DataFrame(results)
    res["hit"] = res.p < 0.05
    return res


def main():
    df = load()
    df = subsample(df)
    df, genes = normalise(df)
    res = test_genes(df, genes)
    os.makedirs("outputs", exist_ok=True)
    res.to_csv("outputs/results.csv", index=False)
    print("significant genes:", res.hit.sum())


if __name__ == "__main__":
    main()
