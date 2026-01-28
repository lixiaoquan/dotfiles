---
name: Disk Space
description: This skill should be used when the user asks to "check disk space", "show disk usage", "see available space", "how much disk space is left", "df", or "view disk availability".
version: 0.1.0
---

# Disk Space Checker

This skill displays current disk usage and available space on the system.

## Usage

When the user asks about disk space, run the disk space check script to show:
- Total disk space
- Used space
- Available space
- Usage percentage
- Mount points

The script provides human-readable output using the `-h` flag for df command.

## Reference

- **`scripts/check-disk-space.sh`** - Script to check disk space
