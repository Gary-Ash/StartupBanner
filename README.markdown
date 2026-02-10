# StartupBanner



![Screenshot](.github/Screenshot.png)

A fast, native macOS terminal startup banner that displays system information alongside an Apple logo. Written in Swift with concurrent data gathering for maximum performance.

## What It Does

- **Displays system info** — User, OS version, Homebrew packages, shell, machine model, CPU/memory, IP addresses, disk usage, uptime
- **Apple logo** — Renders via Kitty graphics protocol (PNG) or falls back to colorful ASCII art
- **Concurrent gathering** — All system data is collected in parallel using Swift structured concurrency
- **Native APIs** — Replaces slow subprocess calls with direct sysctl, IOPowerSources, getifaddrs, and statfs calls
- **Theme support** — Light and dark terminal background themes

## Requirements

- macOS 14.0 (Sonoma) or later
- Swift 6.0+
- Kitty-compatible terminal for PNG logo display (optional, ASCII fallback provided)

## Installation

### Building from Source

```bash
cd StartupBanner
swift build -c release
cp .build/release/startup-banner /usr/local/bin/
```

### Shell Integration

Add to your `.zshrc` or `.bashrc`:

```bash
startup-banner --dark
```

## Usage

```
startup-banner [OPTIONS]

Options:
  -l, --light    Light terminal background theme (default)
  -d, --dark     Dark terminal background theme
```

## Project Structure

```
Sources/
├── startup-banner/              Library
│   ├── SystemInfo.swift         Data model
│   ├── DataGatherers/           System info collectors
│   ├── Display/                 ANSI themes, logo, renderer
│   └── Utilities/               Sysctl helpers, subprocess runner
└── startup-banner-cli/          Executable entry point
    └── main.swift
```

## License

Copyright © 2026 Gary Ash. All rights reserved.
