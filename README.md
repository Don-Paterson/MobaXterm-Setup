# MobaXterm-Setup

Installs MobaXterm and injects pre-configured SSH sessions for Check Point lab VMs. One command, no interaction required.

## Quick start

Open any PowerShell session:

```
irm https://raw.githubusercontent.com/Don-Paterson/MobaXterm-Setup/main/run-mobaxterm-setup.ps1 | iex
```

MobaXterm installs silently, launches briefly to generate its config file, then the lab SSH bookmarks are injected automatically.

## What it does

1. Installs MobaXterm via `winget` using the community source (`--source winget` to bypass Microsoft Store certificate issues when HTTPS Inspection is active from Lab 8A onwards)
2. Launches MobaXterm briefly to generate `MobaXterm.ini` in `%APPDATA%\MobaXterm\`, then closes it
3. Downloads `MobaXterm-Sessions.mxtsessions` from this repo
4. Strips any existing `[Bookmarks]` sections from the ini file and injects the lab sessions

After running, open MobaXterm and all lab SSH sessions appear in the bookmarks sidebar ready to use.

## Files

| File | Purpose |
|------|---------|
| `run-mobaxterm-setup.ps1` | Entry point — install + session injection |
| `MobaXterm-Sessions.mxtsessions` | Pre-configured SSH bookmarks for the lab topology |

## Notes

- Uses `--source winget` rather than the default source list. The Microsoft Store source (`msstore`) fails certificate validation when Check Point HTTPS Inspection is performing MiTM on outbound traffic (CCSA Lab 8A onwards, CCSE, CCTA, CCTE courses).
- Winget installs to `C:\Program Files (x86)\Mobatek\MobaXterm\` — this path is not added to PATH by winget.
- The ini injection uses a regex to strip all existing `[Bookmarks*]` sections before writing, so the script is safe to re-run.
- If MobaXterm is already installed, winget reports a non-zero exit code which the script handles gracefully.

## Requirements

* PowerShell 5.1 or later (PowerShell 7 recommended — avoids module loading issues on unpatched Windows 10 1809 Skillable VMs)
* Internet access to GitHub raw content and the winget community source
* No elevation required — winget handles per-user install

## Related

* [LabLauncher](https://github.com/Don-Paterson/LabLauncher) — master launcher menu for all lab automation scripts
* [SkillableMods](https://github.com/Don-Paterson/SkillableMods) — UK locale/timezone patching for Skillable lab VMs
* [SmartConsoleCleanup](https://github.com/Don-Paterson/SmartConsoleCleanup) — removes legacy SmartConsole versions
* [chkp-monitor](https://github.com/Don-Paterson/chkp-monitor) — Check Point health-monitoring dashboard
* [Plink-Automation](https://github.com/Don-Paterson/Plink-Automation) — GUI runner for clish commands via plink
