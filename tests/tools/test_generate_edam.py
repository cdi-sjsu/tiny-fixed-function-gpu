import os
from pathlib import Path

import pytest
import yaml

from tools.generate_edam import generate_edam


@pytest.fixture
def project(tmp_path: Path) -> Path:
    (tmp_path / "rtl").mkdir()
    (tmp_path / "edam.yml").write_text(
        yaml.safe_dump(
            {
                "name": "example_gpu",
                "toplevel": "selected_top",
                "tool_options": {"verilator": {"mode": "lint-only"}},
                "files": [{"name": "rtl/stale.sv", "file_type": "systemVerilogSource"}],
            },
            sort_keys=False,
        )
    )
    return tmp_path


def write_source(project: Path, name: str) -> Path:
    path = project / name
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("module example; endmodule\n")
    return path


def read_metadata(project: Path) -> dict:
    return yaml.safe_load((project / "edam.yml").read_text())


def test_generate_sources_and_preserve_project_metadata(project: Path) -> None:
    original = read_metadata(project)
    write_source(project, "rtl/top.sv")
    write_source(project, "rtl/geometry/child.v")
    write_source(project, "rtl/pkg/gpu_pkg.sv")
    write_source(project, "rtl/notes.md")
    write_source(project, "tb/helper.sv")

    assert generate_edam(project)

    assert read_metadata(project) == {
        **original,
        "files": [
            {"name": "rtl/pkg/gpu_pkg.sv", "file_type": "systemVerilogSource"},
            {"name": "rtl/geometry/child.v", "file_type": "verilogSource"},
            {"name": "rtl/top.sv", "file_type": "systemVerilogSource"},
        ],
    }


def test_added_renamed_and_removed_sources(project: Path) -> None:
    source = write_source(project, "rtl/geometry/old.sv")
    generate_edam(project)
    assert read_metadata(project)["files"] == [
        {"name": "rtl/geometry/old.sv", "file_type": "systemVerilogSource"}
    ]

    child = write_source(project, "rtl/blocks/child.v")
    generate_edam(project)
    assert [entry["name"] for entry in read_metadata(project)["files"]] == [
        "rtl/blocks/child.v",
        "rtl/geometry/old.sv",
    ]

    source = source.rename(source.with_name("renamed.sv"))
    generate_edam(project)
    assert [entry["name"] for entry in read_metadata(project)["files"]] == [
        "rtl/blocks/child.v",
        "rtl/geometry/renamed.sv",
    ]

    child.unlink()
    source.unlink()
    generate_edam(project)
    assert read_metadata(project)["files"] == []


def test_empty_rtl_retains_configured_metadata(project: Path) -> None:
    original = read_metadata(project)
    generate_edam(project)
    assert read_metadata(project) == {**original, "files": []}


def test_unchanged_generation_does_not_rewrite_file(project: Path) -> None:
    write_source(project, "rtl/top.sv")
    generate_edam(project)
    path = project / "edam.yml"
    contents = path.read_bytes()
    os.utime(path, ns=(1_000_000_000, 1_000_000_000))
    modified_at = path.stat().st_mtime_ns

    assert not generate_edam(project)
    assert path.read_bytes() == contents
    assert path.stat().st_mtime_ns == modified_at


@pytest.mark.parametrize("contents", ["[not, a, mapping]\n", "name: [unterminated\n"])
def test_invalid_metadata_is_not_overwritten(project: Path, contents: str) -> None:
    path = project / "edam.yml"
    path.write_text(contents)
    with pytest.raises((ValueError, yaml.YAMLError)):
        generate_edam(project)
    assert path.read_text() == contents
