from pathlib import Path

import pytest

from tools.hdl_sources import discover_sources


def write(path: Path) -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("module example; endmodule\n")
    return path.resolve()


def test_mixed_nested_sources_and_package_order(tmp_path: Path) -> None:
    rtl = tmp_path / "rtl"
    child = write(rtl / "blocks" / "child.v")
    top = write(rtl / "top.sv")
    package = write(rtl / "types" / "gpu_pkg.sv")
    write(rtl / "notes.md")

    sources = discover_sources(rtl, project_root=tmp_path)

    assert [source.path for source in sources] == [package, child, top]
    assert [source.relative_path for source in sources] == [
        "rtl/types/gpu_pkg.sv",
        "rtl/blocks/child.v",
        "rtl/top.sv",
    ]
    assert [source.file_type for source in sources] == [
        "systemVerilogSource",
        "verilogSource",
        "systemVerilogSource",
    ]


def test_empty_directory_is_valid(tmp_path: Path) -> None:
    rtl = tmp_path / "rtl"
    rtl.mkdir()
    assert discover_sources(rtl, project_root=tmp_path) == ()


def test_rejects_missing_or_external_roots(tmp_path: Path) -> None:
    with pytest.raises(FileNotFoundError, match="source root is missing"):
        discover_sources(tmp_path / "missing", project_root=tmp_path)
    with pytest.raises(ValueError, match="outside the project"):
        discover_sources(tmp_path.parent, project_root=tmp_path)
