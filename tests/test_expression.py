"""One test, which currently fails. See issue #4."""

import pandas as pd

from analysis.expression import normalise


def test_normalise_is_log2_of_count_plus_one():
    df = pd.DataFrame({"sample_id": ["a", "b"], "ENSG00000000001": [0, 3]})
    out, genes = normalise(df)
    assert genes == ["ENSG00000000001"]
    assert out["ENSG00000000001"].tolist() == [0.0, 2.0]


def test_every_sample_survives_the_join():
    """All 60 samples in counts.csv should reach the analysis."""
    counts = pd.read_csv("data/counts.csv")
    clinical = pd.read_csv("data/clinical.csv")
    merged = counts.merge(clinical, on="sample_id")
    # Compare plain numbers so a failure prints "45 == 60", not two whole tables.
    n_counts, n_merged = len(counts), len(merged)
    assert n_merged == n_counts, f"{n_counts - n_merged} samples were dropped by the join"
