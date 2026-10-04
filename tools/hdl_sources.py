"""Discover Verilog and SystemVerilog sources shared by the quality workflows."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]


@dataclass(frozen=True)
class HdlSource:
    path: Path
    relative_path: str
    file_type: str


def discover_sources(
    source_root: Path, *, project_root: Path = PROJECT_ROOT
) -> tuple[HdlSource, ...]:
    """Return packages first, then other sources, each in stable path order.

    An existing empty RTL directory is valid while this project is being scaffolded.
    """
    project_root = project_root.resolve()
    source_root = source_root.resolve()
    if not source_root.is_dir():
        raise FileNotFoundError(f"HDL source root is missing: {source_root}")
    try:
        source_root.relative_to(project_root)
    except ValueError as exc:
        raise ValueError(f"HDL source root is outside the project: {source_root}") from exc

    paths = sorted(
        (
            path
            for path in source_root.rglob("*")
            if path.is_file() and path.suffix in {".v", ".sv"}
        ),
        key=lambda path: (not path.name.endswith("_pkg.sv"), path.relative_to(project_root)),
    )
    return tuple(
        HdlSource(
            path=path.resolve(),
            relative_path=path.relative_to(project_root).as_posix(),
            file_type="systemVerilogSource" if path.suffix == ".sv" else "verilogSource",
        )
        for path in paths
    )
