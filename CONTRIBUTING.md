# Contributing to Tiny Fixed Function GPU

Start with the [shared CDI contributor guide](https://github.com/cdi-sjsu/.github/blob/main/CONTRIBUTING.md)
for access, GitHub workflow, and host/container credentials. Its
[Git signatures section](https://github.com/cdi-sjsu/.github/blob/main/CONTRIBUTING.md#git-signatures)
covers PGP verification and SSH signing on macOS, Windows, WSL, and in the Dev
Container. Cryptographic signing is recommended and optional; DCO sign-off is
separate and optional.

## Development and task tracking

Use the required [Dev Container and Make workflows](README.md#required-development-environment).
The [project board](https://github.com/orgs/cdi-sjsu/projects/1) and GitHub issues are
the authoritative sources for task progress and deadlines. Use the
[team table](README.md#project-and-teams) to find the responsible team, issue,
label, and source directory. Keep task status accurate; documentation cleanup
does not complete the engineering deliverables in issues #3–#6.

## Member workflow

1. Update local `main` from the remote, then create a focused branch such as
   `docs/geometry-interface` or `feat/sine-lut`. Fork first if you lack write access.
2. Link the relevant issue in the PR description and explain the resulting behavior
   and validation. Use `Refs #N` for partial work; use a closing keyword only when
   the PR fulfills that issue's deliverable.
3. Run `make format` after code changes and `make ci` before requesting review.
   Review documentation links and paths too. With no RTL, HDL checks and the hardware
   simulation explicitly skip; passing infrastructure checks is not hardware coverage.
4. Open a PR targeting `main` and request review from `@cdi-sjsu/gpu-leads`.
   Every PR requires approval from one eligible GPU lead, including code,
   documentation, infrastructure, and changes to `.github/CODEOWNERS`.
   Regular members' approvals do not satisfy the code-owner requirement.
5. Address feedback, rerun checks after changes, and resolve review conversations
   before squash-merging.

## Lead workflow

Review the linked issue, changes, and validation, then approve when ready. One
eligible lead's approval is sufficient; both leads do not need to approve.
For a lead-authored PR, another lead reviews and approves it. The latest reviewable
push must be approved by someone other than its pusher.

The visible `@cdi-sjsu/gpu-leads` team contains `Nativity8904` and `nicojeda189` and
has explicit write access to this repository. Add future leads to this team when
appointed so they can satisfy the ownership requirement for every path.

## Merge requirements

- The GitHub Actions job named `check` must pass for the current PR commit.
- The branch must be up to date with `main`; rerun CI after updating it.
- Resolve all review conversations.
- Obtain one approval from an eligible member of `@cdi-sjsu/gpu-leads`. Reviewable
  pushes dismiss stale approvals, and someone other than the latest pusher must
  approve the latest reviewable push.
- Squash and merge through a PR. Direct pushes, force pushes, and deletion of `main`
  are protected. Use a clear PR title and description for the resulting commit.

**Existing review exception:** Nativity8904 has a PR-only approval exception through
the `gpu-review-bypass` team. It applies to the review requirement only; required CI,
an up-to-date branch, resolved conversations, and the other protections still apply.
No other contributor has a configured review exception.

When adding hardware, follow [Adding the first RTL and simulation](README.md#adding-the-first-rtl-and-simulation)
to update `edam.yml` and register a Cocotb suite. Keep subsystem design and interface
notes beside their sources and link completed deliverables from their issues.
