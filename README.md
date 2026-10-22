# 2026_git_course

A deliberately imperfect analysis repo, for the **Version control in GitHub** session
of the ICR Reproducible Software Development course.

Copy it, break it, fix it. Your copy is yours to keep.

## What's in here

```
analysis/expression.py   a small differential-expression script, with problems
data/                    synthetic counts + clinical tables (not real data)
tests/                   one test, which currently fails
CHEATSHEET.md            every git command from the session
```

**Slides:** [slides URL] · **Cheat sheet:** [CHEATSHEET.md](CHEATSHEET.md)

## Getting started

Click **Use this template → Create a new repository** (top right on GitHub), name
it `2026_git_course`, keep it **Public**, and create it. Then, from *your* copy:

```bash
git clone git@github.com:YOUR-USERNAME/2026_git_course.git
cd 2026_git_course
pip install -r requirements.txt
python analysis/expression.py
```

It will not work first time. **That is the point** — the first issue on the
[course repo](https://github.com/ICR-RSE-Group/2026_git_course/issues/1) is about exactly that.

## How to take part

Everything happens in **your own copy**: its Issues, its branches, its pull requests.

1. Open an issue in your copy — in the session, "Ignore the outputs/ folder" — and
   assign it to yourself.
2. On the issue page, click **Create a branch**. Fix it, commit, push.
3. Open a pull request with `Closes #N` in the body.
4. Explore the review tools on it: a line comment and a suggested change in
   **Files changed**, and the test results in **Checks**. Then merge it and watch
   the issue close.

Want more? The [course repo's issues](https://github.com/ICR-RSE-Group/2026_git_course/issues) are a list of real bugs in
this script. Copy one into your own Issues and fix it the same way:
`good first issue` if you are new to git, `stretch` if you are not.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the details.

## The rule

Never commit data or credentials. The files in `data/` are synthetic and exist only
so the script has something to read.
