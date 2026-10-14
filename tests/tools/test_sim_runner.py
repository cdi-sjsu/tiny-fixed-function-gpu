"""Check package loading for independently compiled subsystem suites."""

from pathlib import Path

import pytest

from tb.common import sim_runner
from tools.hdl_sources import discover_sources


@pytest.fixture
def source_tree(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> Path:
    (tmp_path / "rtl/pkg").mkdir(parents=True)
    (tmp_path / "rtl/geometry").mkdir()
    (tmp_path / "rtl/pkg/gpu_pkg.sv").write_text("package gpu_pkg; endpackage\n")
    (tmp_path / "rtl/geometry/dot_product.sv").write_text("module dot_product; endmodule\n")
    monkeypatch.setattr(sim_runner, "PROJECT_ROOT", tmp_path)
    monkeypatch.setattr(
        sim_runner,
        "discover_sources",
        lambda root: discover_sources(root, project_root=tmp_path),
    )
    return tmp_path


def test_explicit_suite_loads_shared_package_once_before_consumers(source_tree: Path) -> None:
    paths = sim_runner._resolve_sources(("rtl/geometry/dot_product.sv", "rtl/pkg/gpu_pkg.sv"), None)
    assert paths == [
        source_tree / "rtl/pkg/gpu_pkg.sv",
        source_tree / "rtl/geometry/dot_product.sv",
    ]


def test_discovered_subsystem_loads_shared_package(source_tree: Path) -> None:
    paths = sim_runner._resolve_sources(
        (), discover_sources(source_tree / "rtl/geometry", project_root=source_tree)
    )
    assert paths == [
        source_tree / "rtl/pkg/gpu_pkg.sv",
        source_tree / "rtl/geometry/dot_product.sv",
    ]


def test_package_opt_out_preserves_explicit_suite_order(source_tree: Path) -> None:
    paths = sim_runner._resolve_sources(
        ("rtl/geometry/dot_product.sv", "rtl/pkg/gpu_pkg.sv"),
        None,
        include_packages=False,
    )
    assert paths == [
        source_tree / "rtl/geometry/dot_product.sv",
        source_tree / "rtl/pkg/gpu_pkg.sv",
    ]
