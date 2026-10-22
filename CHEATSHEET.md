# Git cheat sheet

Everything from the 11:30 session, in the order you will need it.
Print it, or keep the tab open.

## Setup (once per machine)

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@icr.ac.uk"
git config --global init.defaultBranch main
git config --global pull.rebase false      # merge on pull; least surprising
```

## Start

```bash
git clone git@github.com:USER/REPO.git    # copy an existing repo
cd REPO

git init                                  # or: put an existing folder under git
```

## Put an existing folder on GitHub

Write the `.gitignore` **before** the first commit, then:

```bash
git init
git status                                # check data/ is NOT listed
git add .
git commit -m "Initial commit"

# on GitHub: + → New repository, leave it completely empty, then:
git remote add origin git@github.com:USER/REPO.git
git branch -M main
git push -u origin main
```

## The loop you will use every day

```bash
git status                  # what has changed — run this constantly
git diff                    # what exactly changed, line by line
git add path/to/file        # choose what goes in the next snapshot
git add -p                  # ...or choose hunk by hunk
git commit -m "message"     # take the snapshot
git push                    # send it to GitHub
git pull                    # get other people's work
```

## Branches

```bash
git switch -c my-feature          # create a branch and move onto it
git switch main                   # move back
git branch                        # list branches, * marks current
git push -u origin my-feature     # first push of a new branch
git branch -d my-feature          # delete it once merged
```

## Merging and conflicts

```bash
git switch main
git pull
git merge my-feature
```

Conflict? The file now contains:

```
<<<<<<< HEAD
their version
=======
your version
>>>>>>> my-feature
```

Edit the file so it says what you want, delete all three markers, then:

```bash
git add the-file
git commit
```

Panicking? `git merge --abort` puts you back exactly where you started.

## Undo

```bash
git restore FILE                  # discard uncommitted changes to a file
git restore --staged FILE         # unstage, keep the changes
git commit --amend                # fix the last commit (only if unpushed)
git revert COMMIT                 # a new commit undoing an old one — always safe
git reflog                        # you almost certainly have not lost it
```

`git reflog` is the "I have destroyed everything" button. It lists every state
your repo has been in for the last 90 days. You can nearly always get back.

## History

```bash
git log --oneline --graph --all   # the shape of the project
git log -p FILE                   # every change to one file, with diffs
git log -S "some_function"        # which commit introduced this string?
git blame FILE                    # who last touched each line, and in which commit
```

## Versioning and releases

```bash
pip install bump-my-version

bump-my-version bump patch        # 1.2.0 -> 1.2.1   fixes, nothing breaks
bump-my-version bump minor        # 1.2.1 -> 1.3.0   additions, nothing breaks
bump-my-version bump major        # 1.3.0 -> 2.0.0   you broke something

git push && git push --tags
```

Then on GitHub: **Releases → Draft a new release → choose your tag →
Generate release notes**.

Manual tagging, if you are not using the tool:

```bash
git tag -a v1.2.0 -m "Add batch-effect correction"
git push origin v1.2.0
```

## On GitHub, not the command line

| Task | Where |
|---|---|
| Claim work | Issues → assign yourself |
| Branch from an issue | Issue page → **Create a branch** (right sidebar) |
| Propose a change | Pull requests → New pull request |
| Link them | Put `Closes #12` in the PR body |
| Review | Files changed → `+` on a line → **Add a suggestion** |
| Batch your comments | **Start a review**, then **Submit review** |
| Protect `main` | Settings → Branches → Add rule |

## The rules worth remembering

1. **Never commit data or credentials.** History is permanent.
2. Write `.gitignore` on day one, before the mess exists.
3. `git status` before anything you are unsure about.
4. One commit = one idea. If the message needs "and", split it.
5. The commit message explains **why**. The code already says what.
6. `main` always works. Everything else happens on a branch.
7. You have not lost your work. Try `git reflog`.
