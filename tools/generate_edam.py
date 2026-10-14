"""Refresh the EDAM source list from the repository's RTL directory."""

from __future__ import annotations

from pathlib import Path

import yaml

from tools.hdl_sources import PROJECT_ROOT, discover_sources

GENERATED_NOTICE = "# RTL file list generated from rtl/; run make edam to refresh.\n"


def generate_edam(project_root: Path = PROJECT_ROOT) -> bool:
    """Update only the source-list metadata, returning whether the file changed."""
    metadata_path = project_root / "edam.yml"
    original = metadata_path.read_text()
    metadata = yaml.safe_load(original)
    if not isinstance(metadata, dict):
        raise ValueError("edam.yml must contain a YAML mapping of project metadata.")

    metadata["files"] = [
        {"name": source.relative_path, "file_type": source.file_type}
        for source in discover_sources(project_root / "rtl", project_root=project_root)
    ]
    generated = GENERATED_NOTICE + yaml.safe_dump(metadata, sort_keys=False)
    if generated == original:
        return False
    metadata_path.write_text(generated)
    return True


def main() -> None:
    changed = generate_edam()
    print("Updated edam.yml." if changed else "edam.yml is up to date.")


if __name__ == "__main__":
    main()
