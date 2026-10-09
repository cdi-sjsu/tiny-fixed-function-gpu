.DEFAULT_GOAL := help

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

SIM ?= verilator
UV ?= uv
UV_RUN ?= $(UV) run --frozen
UV_SYNC ?= $(UV) sync --frozen
PYTEST ?= $(UV_RUN) pytest

.PHONY: help setup format check test waves ci

help: ## List available workflows
	@awk 'BEGIN { FS = ":.*## "; print "Available commands:" } /^[A-Za-z0-9_-]+:.*## / { printf "  make %-16s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

setup: ## Install locked Python development dependencies
	$(UV_SYNC)

format: ## Format Python and HDL sources
	$(UV_RUN) ruff format .
	$(UV_RUN) python -m tools.hdl_workflow format

check: ## Check formatting, lint, project metadata, and tests
	$(UV_RUN) ruff check .
	$(UV_RUN) ruff format --check .
	$(UV_RUN) python -m tools.hdl_workflow lint
	$(UV_RUN) python -m tools.hdl_workflow verify
	SIM=$(SIM) $(PYTEST)

TARGET ?= tests

test: ## Run simulation suites (e.g. make test or make test TARGET=tests/rasterizer)
	SIM=$(SIM) $(PYTEST) $(TARGET)

waves: ## Run simulation suites with waveform output (e.g. make waves TARGET=tests/top)
	WAVES=1 SIM=$(SIM) $(PYTEST) $(TARGET)

ci: ## Validate the lockfile and run the complete quality gate
	$(UV) lock --check
	$(MAKE) setup
	$(MAKE) check
