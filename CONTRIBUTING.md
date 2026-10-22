# Contributing

This is a teaching repo, but the workflow is the real one.

## The loop

```bash
git switch main
git pull                                  # start from current main
git switch -c short-descriptive-name      # one branch per piece of work
# ...edit...
git status                                # constantly
git add path/to/file.py
git commit -m "Fix sample ID join for re-sequenced batches"
git push -u origin short-descriptive-name
```

Then open a pull request on GitHub.

## Commit messages

Summary line under ~50 characters, imperative mood, then a blank line and the
*why* in as much detail as it deserves.

```
Fix sample ID join for re-sequenced batches

Batch 3 IDs gained a "-R" suffix after re-sequencing, which broke the
join to the clinical table and silently dropped 15 samples.
```

If your summary line needs the word "and", it is probably two commits.

## Pull requests

- Put `Closes #12` in the body so the issue closes itself on merge.
- Open it as a **draft** if you are still working.
- Add one reviewer. Small PRs get reviewed; large ones get ignored.

## Reviewing

Review the things that change the result, not the whitespace:

- hardcoded paths, unset random seeds, magic numbers
- silent failures — dropped rows, empty joins, `NaN`s
- assumptions that happen to be true today
- data or credentials sneaking into a commit

Use **suggested changes** for anything small enough to fix in the browser.
Comment on the code, never on the person.
