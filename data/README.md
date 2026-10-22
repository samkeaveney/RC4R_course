# data/

`counts.csv` and `clinical.csv` here are **small synthetic files**, generated for
the workshop. There is no real or patient-derived data anywhere in this repo, and
there never should be.

In a real project this directory would hold nothing at all — data lives on the
RDS/scratch storage and is referenced by a path in a config file, or is tracked
with DVC (Thursday's session). The rule from the slides holds:

> Never commit data or credentials.
