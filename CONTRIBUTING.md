# Contributing

Use GitHub issues and the [project board](https://github.com/orgs/cdi-sjsu/projects/1)
to choose and track work. The [team table](README.md#project-and-teams) lists each
subsystem's responsibility, lead, source directory, and issue label. Ask your
team lead if you need help choosing a task.

## Setup

Clone the project repository:

```sh
git clone https://github.com/cdi-sjsu/tiny-fixed-function-gpu.git
cd tiny-fixed-function-gpu
```

This sets `origin` to the project repository. Create and push work branches there,
then open a PR targeting its `main` branch.

Follow [Getting Started](README.md#getting-started) to open the repo in its Dev
Container. From the repository directory, run this once for your checkout:

```sh
git config --local user.name "YOUR_NAME"
git config --local user.email "YOUR_GITHUB_EMAIL"
git config --local commit.gpgsign false
```

## Start a task

1. Choose an issue with your team lead and keep its project-board status current.
   Agree on the expected result and any interfaces shared with other subsystems.
2. Save any existing work before switching branches. Update `main` and create a
   focused branch:

   ```sh
   git switch main
   git pull --ff-only origin main
   git switch -c feat/describe-your-change
   ```

   Use a descriptive name such as `feat/sine-lut` or `docs/geometry-interface`.

## Check your changes

Run `make format` after code changes and `make ci` before requesting review.

## Committing

On your work branch, review the diff and stage only the files for your change:

```sh
git diff
git add path/to/changed-file
git diff --cached
```

Once your changes are staged:

```sh
git commit -m "Describe your change"
```

## Open and merge a pull request

1. Push your work branch to the project repository:

   ```sh
   git push -u origin HEAD
   ```

2. Open a PR from your work branch to the project repository's `main` branch.
   Explain what changed, why, and how you checked it.
   Link the issue using `Refs #N` for partial work; use `Closes #N` only when the
   PR completes the issue's deliverable.
3. Request review from `@cdi-sjsu/gpu-leads`. Every PR needs one eligible GPU lead's
   approval. Regular members may review and give feedback, but their
   approvals do not satisfy the merging requirements.
4. Address feedback and push follow-up commits to the same branch. Rerun checks
   after changes and resolve conversations once the feedback is addressed.
5. If `main` has advanced, update your work branch and rerun checks:

   ```sh
   git fetch origin
   git merge origin/main
   ```

   Resolve any merge conflicts before committing and pushing the update.
6. Once all merge requirements below are met, open the PR on GitHub and confirm
   that its target branch is `main`. Click **Squash and merge**, selecting it
   from the merge dropdown if needed.
7. Review the commit title and message, then click **Confirm squash and merge**.
   GitHub creates one commit on `main` containing the PR's changes.
8. Update the linked issue and project board to reflect the work.
9. Save any uncommitted work by committing it on its work branch or stashing it
   before switching branches. Update your local checkout:

   ```sh
   git switch main
   git pull --ff-only origin main
   ```

## Merge requirements

- The GitHub Actions job named `check` must pass for the current PR commit.
- The branch must be up to date with `main`.
- All review conversations must be resolved.
- One eligible member of `@cdi-sjsu/gpu-leads` must approve. Reviewable pushes
  dismiss stale approvals, and someone other than the latest pusher must approve
  the latest reviewable push.
- Use squash merging through a PR. Direct pushes, force pushes, and deletion of
  `main` are protected.
