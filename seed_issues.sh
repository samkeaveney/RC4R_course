#!/usr/bin/env bash
# Seed the sandbox repo with labels and workshop issues.
#
#   gh auth login
#   ./seed_issues.sh ICR-RSE-Group/2026_git_course
#
# Safe to re-run: label creation failures are ignored, but issues WILL be
# duplicated, so only run this once per repo.

set -euo pipefail
REPO="${1:?usage: ./seed_issues.sh OWNER/REPO}"

echo "Seeding $REPO"

# --- labels ----------------------------------------------------------------
gh label create "good first issue" -R "$REPO" -c 7057ff -d "Start here if git is new to you" 2>/dev/null || true
gh label create "stretch"          -R "$REPO" -c d93f0b -d "For people who finish early"     2>/dev/null || true
gh label create "bug"              -R "$REPO" -c d73a4a -d "Something is wrong"              2>/dev/null || true
gh label create "enhancement"      -R "$REPO" -c a2eeef -d "Something to add"                2>/dev/null || true
gh label create "reproducibility"  -R "$REPO" -c 0e8a16 -d "Affects whether results can be reproduced" 2>/dev/null || true

issue () {  # issue <labels> <title> <body>
  gh issue create -R "$REPO" -l "$1" -t "$2" -b "$3" >/dev/null
  echo "  + $2"
}

# --- good first issues -----------------------------------------------------
issue "good first issue,bug" \
"Script fails immediately: file paths are hardcoded to someone's laptop" \
"\`analysis/expression.py\` starts with:

\`\`\`python
COUNTS = \"/Users/msarkis/Documents/projects/rsd/data/counts.csv\"
\`\`\`

That path exists on exactly one computer in the world, so the script fails with
\`FileNotFoundError\` for everyone else.

**Fix:** make the paths relative to the repo, so \`python analysis/expression.py\`
works after a fresh clone.

Hardcoded absolute paths are the single most common reason a colleague cannot run
your analysis. Worth learning to spot in review."

issue "good first issue,reproducibility" \
"Repo has no .gitignore" \
"Run the script and then \`git status\`. You will see \`outputs/\` and
\`__pycache__/\` offered up as things to commit. Neither belongs in the repo.

**Fix:** add a \`.gitignore\` covering generated outputs, Python cruft, notebook
checkpoints, OS files (\`.DS_Store\`), and — most importantly — data and
credentials (\`*.csv\` outside \`data/\`, \`.env\`, \`*.key\`).

Note that \`.gitignore\` only affects files git is not already tracking, which is
why it should be the first file in any new project."

issue "good first issue" \
"README does not say how to install the dependencies" \
"A new person clones the repo and runs the script. It fails on
\`import pandas\`, and nothing tells them what to do next.

**Fix:** add the install step to the README, and check the rest of the
instructions actually work on a fresh clone.

Documentation that has never been followed by a stranger is usually wrong."

# --- bugs ------------------------------------------------------------------
issue "bug,reproducibility" \
"15 samples are silently dropped by the join" \
"\`tests/test_expression.py::test_every_sample_survives_the_join\` fails.

\`counts.csv\` has 60 samples. After \`counts.merge(clinical, on=\"sample_id\")\`
only 45 survive. Re-sequenced samples gained an \`-R\` suffix in the counts table
that the clinical table does not have, so pandas' default inner join quietly
discards them.

Nothing warns you. The script runs, produces a results file, and is wrong.

**Fix:** reconcile the IDs, and make the code fail loudly if samples go missing.

This is the kind of bug that survives peer review, because the output looks fine."

issue "bug,reproducibility" \
"subsample() is not seeded, so every run gives a different answer" \
"\`\`\`python
def subsample(df, n=40):
    # keep the cohorts balanced
    return df.sample(n)
\`\`\`

Two problems:

1. \`df.sample()\` has no \`random_state\`, so the results change on every run.
   Run the script twice and compare \`outputs/results.csv\`.
2. The comment claims it balances the cohorts. It does not — it takes 40 rows at
   random, and can easily return 32 responders and 8 non-responders.

**Fix:** seed it, and either make it do what the comment says or fix the comment.

A comment that lies is worse than no comment."

issue "bug" \
"Bare except: swallows every error in test_genes()" \
"\`\`\`python
try:
    t, p = stats.ttest_ind(a, b)
except:
    continue
\`\`\`

A bare \`except:\` catches everything — including typos, missing columns, and
Ctrl-C. Genes silently vanish from the results with no record of how many or why.

**Fix:** catch the specific thing you expect, and log when you skip a gene."

# --- stretch ---------------------------------------------------------------
issue "stretch,reproducibility" \
"No multiple-testing correction on 12 simultaneous t-tests" \
"\`res[\"hit\"] = res.p < 0.05\` is applied across every gene tested. With 12
genes you expect false positives by chance alone; with a real panel of thousands,
the 'hits' are mostly noise.

**Fix:** apply an appropriate correction (Benjamini–Hochberg,
\`statsmodels.stats.multitest.multipletests\`), and make the threshold a named
parameter rather than a number buried in a comparison.

While you are there: 0.05 appears with no justification anywhere. Magic numbers
that determine your conclusions deserve a name and a comment."

issue "stretch" \
"Subsampling happens before normalisation" \
"In \`main()\`:

\`\`\`python
df = load()
df = subsample(df)      # <- throws away 20 samples
df, genes = normalise(df)
\`\`\`

The normalisation is computed on the subsample rather than the full cohort, so
the numbers depend on which rows happened to be drawn. Combined with the missing
seed, results are not reproducible between runs.

**Fix:** decide what the right order is, justify it in the commit message, and
make \`n\` a parameter instead of a hardcoded 40."

issue "stretch,enhancement" \
"Replace print() with proper logging" \
"The script's only output is \`print(\"significant genes:\", ...)\`. When it runs
on the cluster at 3am, nobody knows what it loaded, how many samples survived, or
which genes were skipped.

**Fix:** use the \`logging\` module — record input paths, sample counts before and
after the join, the seed, and the parameters used.

This one connects directly to the log files session at 13:30. A run you cannot
reconstruct from its log is a run you cannot reproduce."

echo
echo "Done. Now, in the repo settings:"
echo "  - Settings > General > check 'Template repository'"
echo "  - Settings > General > Features > enable Issues"
