# Xournal++ Session Manager

A lightweight PowerShell tool to save and restore your Xournal++ workspace. It uses low-level kernel handle scanning to identify exactly which files you have open, allowing you to resume your work even after a system restart.

## Features
- **Kernel-Level Detection**: Uses Sysinternals `handle64.exe` to find open `.pdf` and `.xopp` files.
- **Session Persistence**: Saves your open file list to a simple text file.
- **One-Click Restore**: Reopens all previously active files in Xournal++.
- **Admin Elevation**: Automatically requests necessary privileges to scan system handles.

## Requirements
1. **Xournal++**: Installed and available in your system path (or `xournalpp.exe` must be executable).
2. **Handle64**: Download `handle64.exe` from [Microsoft Sysinternals](https://learn.microsoft.com/en-us/sysinternals/downloads/handle) and place it in the same directory as the script.

## Setup & Usage
1. Clone this repository or download the files.
2. Ensure `handle64.exe` is in the folder.
3. Run `launch.bat` to start the manager.
4. **Save Session**: Choose option `1` before closing your computer or Xournal++.
5. **Restore Session**: Choose option `2` after a restart to pick up where you left off.

## Why this exists?
Xournal++ is incredible, but sometimes it doesn't remember every single PDF you had open across multiple windows after a crash or a reboot. This tool bridges that gap by asking the OS kernel what files the `xournal` process is currently holding.

## Disclaimer
This tool requires Administrator privileges because it scans system-wide file handles. Use at your own risk.

## License
MIT
