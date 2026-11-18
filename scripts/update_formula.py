#!/usr/bin/env python3
"""Refresh the Homebrew formula using the latest stable upstream release."""

import re
import urllib.request
from pathlib import Path

LATEST_CHECKSUMS = "https://github.com/mobinova/udf/releases/latest/download/checksums.txt"
FORMULA = Path(__file__).resolve().parents[1] / "Formula" / "udf.rb"
PLATFORMS = ("darwin_arm64", "darwin_amd64", "linux_arm64", "linux_amd64")


def get(url: str) -> tuple[bytes, str]:
    request = urllib.request.Request(url, headers={"User-Agent": "mobinova-homebrew-udf-updater"})
    with urllib.request.urlopen(request, timeout=30) as response:
        return response.read(), response.geturl()


def main() -> None:
    checksum_data, _ = get(LATEST_CHECKSUMS)
    checksums = {}
    for line in checksum_data.decode("utf-8").splitlines():
        match = re.fullmatch(r"([0-9a-f]{64})\s+(.+)", line.strip())
        if match:
            checksums[match.group(2)] = match.group(1)

    versions = {
        match.group(1)
        for filename in checksums
        if (match := re.fullmatch(r"udf_(.+)_darwin_arm64\.tar\.gz", filename))
    }
    if len(versions) != 1:
        raise SystemExit("could not determine a single version from release checksums")
    version = versions.pop()

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
