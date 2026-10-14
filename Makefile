.DEFAULT_GOAL := help

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

SIM ?= verilator
UV ?= uv
UV_RUN ?= $(UV) run --frozen
UV_SYNC ?= $(UV) sync --frozen
PYTEST ?= $(UV_RUN) pytest

.PHONY: help setup edam format check test tb waves ci

help: ## Show this help message
	@awk 'BEGIN { FS = ":.*## "; print "Available commands:" } /^[A-Za-z0-9_-]+:.*## / { printf "  make %-10s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

setup:
	$(UV_SYNC)
	$(MAKE) edam

edam: ## Refresh the RTL project source list
	$(UV_RUN) python -m tools.generate_edam

format check test tb waves: edam

format: ## Format Python and HDL code
	$(UV_RUN) ruff format .
	$(UV_RUN) python -m tools.hdl_workflow format

check: ## Run full lint, format check, and all tests
	$(UV_RUN) ruff check .
	$(UV_RUN) ruff format --check .
	$(UV_RUN) python -m tools.hdl_workflow lint
	$(UV_RUN) python -m tools.hdl_workflow verify
	SIM=$(SIM) $(PYTEST) tests tb

TARGET ?=

test: ## Run software and tooling tests
	$(PYTEST) $(if $(TARGET),$(if $(filter tests/%,$(TARGET)),$(TARGET),tests/$(TARGET)),tests)

tb: ## Run hardware simulation testbenches
	SIM=$(SIM) $(PYTEST) $(if $(TARGET),$(if $(filter tb/%,$(TARGET)),$(TARGET),tb/$(TARGET)),tb)

waves: ## Run testbenches and record VCD waveforms
	WAVES=1 SIM=$(SIM) $(PYTEST) $(if $(TARGET),$(if $(filter tb/%,$(TARGET)),$(TARGET),tb/$(TARGET)),tb)

ci:
	$(UV) lock --check
	$(MAKE) setup
	$(MAKE) check
