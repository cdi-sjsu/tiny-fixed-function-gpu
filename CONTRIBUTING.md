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

1. Update local `main` from the remote, then create a focused branch such as
   `docs/geometry-interface` or `feat/sine-lut`. Fork first if you lack write access.
2. Link the relevant issue in the PR description and explain the resulting behavior
   and validation. Use `Refs #N` for partial work; use a closing keyword only when
   the PR fulfills that issue's deliverable.
3. Run `make format` after code changes and `make ci` before requesting review.
   Review documentation links and paths too. With no RTL, HDL checks and the hardware
   simulation explicitly skip; passing infrastructure checks is not hardware coverage.
4. Open a PR targeting `main` and request review from the relevant subsystem team:

   | Area | Review team | Issue label |
   | --- | --- | --- |
   | Rasterization | `@cdi-sjsu/gpu-rasterizer` | Rasterizer Team |
   | Geometry | `@cdi-sjsu/gpu-geometry` | Geometry Team |
   | Python preprocessing and LUTs | `@cdi-sjsu/gpu-python-preprocessing` | Python Preprocessing Team |
   | Framebuffer and VGA | `@cdi-sjsu/gpu-vga` | VGA Team |

   For shared infrastructure or cross-subsystem changes, involve
   `@cdi-sjsu/gpu` and the affected subsystem teams. If a team has no available
   reviewers, ask a GPU maintainer to review.

## Merge requirements

- The GitHub Actions job named `check` must pass for the current PR commit.
- The branch must be up to date with `main`; rerun CI after updating it.
- Resolve all review conversations.
- Obtain one approval. Reviewable pushes dismiss stale approvals, and someone other
  than the latest pusher must approve the latest reviewable push.
- Squash and merge through a PR. Direct pushes, force pushes, and deletion of `main`
  are protected. Use a clear PR title and description for the resulting commit.

**Existing review exception:** Nativity8904 has a PR-only approval exception through
the `gpu-review-bypass` team. It applies to the review requirement only; required CI,
an up-to-date branch, resolved conversations, and the other protections still apply.
No other contributor has a configured review exception.

When adding hardware, follow [Adding the first RTL and simulation](README.md#adding-the-first-rtl-and-simulation)
to update `edam.yml` and register a Cocotb suite. Keep subsystem design and interface
notes beside their sources and link completed deliverables from their issues.
