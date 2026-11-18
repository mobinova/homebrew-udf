#!/usr/bin/env python3
"""Refresh the Homebrew formula using the latest stable upstream release."""

import json
import re
import urllib.request
from pathlib import Path

API = "https://api.github.com/repos/mobinova/udf/releases/latest"
FORMULA = Path(__file__).resolve().parents[1] / "Formula" / "udf.rb"
PLATFORMS = ("darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64")


def get(url: str) -> bytes:
    request = urllib.request.Request(url, headers={"User-Agent": "mobinova-homebrew-udf-updater"})
    with urllib.request.urlopen(request, timeout=30) as response:
        return response.read()


def main() -> None:
    release = json.loads(get(API))
    tag = release["tag_name"]
    if not tag.startswith("v"):
        raise SystemExit(f"unexpected release tag: {tag!r}")
    version = tag[1:]
    assets = {asset["name"]: asset["browser_download_url"] for asset in release["assets"]}
    if "checksums.txt" not in assets:
        raise SystemExit("release has no checksums.txt asset")
    checksums = {}
    for line in get(assets["checksums.txt"]).decode("utf-8").splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})\s+(.+)", line.strip())
        if match:
            checksums[match.group(2)] = match.group(1)

    formula = FORMULA.read_text(encoding="utf-8")
    formula, version_count = re.subn(r'(?m)^  version "[^"]+"$', f'  version "{version}"', formula)
    if version_count != 1:
        raise SystemExit("could not identify the formula version field")

    for platform in PLATFORMS:
        archive = f"udf_{version}_{platform}.tar.gz"
        checksum = checksums.get(archive)
        if checksum is None:
            raise SystemExit(f"release checksum is missing for {archive}")
        pattern = rf'(?m)^(\s*sha256 ")[0-9a-f]{{64}}(" # udf:{re.escape(platform)}$)'
        formula, count = re.subn(pattern, rf"\g<1>{checksum}\g<2>", formula)
        if count != 1:
            raise SystemExit(f"formula must contain exactly one checksum marker for {platform}")

    FORMULA.write_text(formula, encoding="utf-8")
    print(f"Formula updated to {version}")


if __name__ == "__main__":
    main()
