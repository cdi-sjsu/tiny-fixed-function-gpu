import yaml

from tools.hdl_sources import PROJECT_ROOT, discover_sources


def test_project_metadata_matches_rtl() -> None:
    metadata = yaml.safe_load((PROJECT_ROOT / "edam.yml").read_text())
    sources = discover_sources(PROJECT_ROOT / "rtl")
    assert metadata["name"] == "tiny_fixed_function_gpu"
    assert metadata["files"] == [
        {"name": source.relative_path, "file_type": source.file_type} for source in sources
    ]
    if sources:
        assert isinstance(metadata.get("toplevel"), str) and metadata["toplevel"].strip(), (
            "Set edam.yml toplevel to the actual top module when adding RTL."
        )
    else:
        assert "toplevel" not in metadata, "Do not select a nonexistent top module."
