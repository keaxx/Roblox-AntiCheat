# 🛡️ Roblox Anti-Cheat Hub

A comprehensive collection of **production-ready anti-cheat solutions** for Roblox games, combining server-side detection, client-side monitoring, and active exploit prevention. Designed to protect against SaveInstance, decompilers, backdoors, and executor abuse. All Comments were made with AI.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Roblox](https://img.shields.io/badge/Roblox-Studio-red.svg)](https://www.roblox.com/create)
[![Contributions Welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## 📑 Table of Contents

- [Features](#-features)
- [Quick Start](#-quick-start)
- [Detection Capabilities](#-detection-capabilities)
- [Architecture](#-architecture)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Contributing](#-contributing)
- [FAQ](#-faq)
- [Disclaimer](#-disclaimer)
- [License](#-license)

---

## ✨ Features

### 🎯 Core Protection
- **Server-side log scanning** – Catches exploit outputs before they succeed
- **Client-side monitoring** – Detects malicious GUIs and injected scripts
- **Self-healing scripts** – Auto-recreates deleted anti-cheat components
- **Pattern matching** – 150+ compiled patterns from open-source exploits
- **Instant response** – Immediate kicks, no remote round-trips

### 🔍 Detection Sources
- **Infinity Yield** – SaveInstance and decompiler patterns
- **Universal SynSaveInstance** – All major saveinstance variants
- **Dark Dex / Dex Explorer** – Explorer-based saveinstance tools
- **Synapse X / Krnl / Fluxus / Solara / Wave** – Popular executors
- **Common backdoors** – Remote spy, server lua injection, FE bypasses

### ⚡ Performance
- **Single compiled Lua pattern** – O(n) complexity, not 150 separate checks
- **Throttled client scanning** – GUI checks every 5 seconds
- **Minimal server overhead** – Reactive LogService events only
- **No external dependencies** – Pure Lua, zero third-party modules

---

## 🚀 Quick Start

### Minimum Setup (30 seconds)

1. **Download** `ServerAntiCheat.lua` from the `/scripts` folder
2. **Insert** it into `ServerScriptService` in Roblox Studio
3. **Publish** your game

That's it. The script auto-configures everything.

### Full Setup (Recommended)

1. **Download both files:**
   - `ServerAntiCheat.lua` → `ServerScriptService`
   - (Optional) `ClientAntiCheat.lua` → `StarterPlayerScripts`

2. **Configure whitelist** (see [Configuration](#-configuration))

3. **Test in Studio** before publishing

---

## 🎯 Detection Capabilities

### SaveInstance / Game Copying
| Tool Detected | Detection Method |
|---------------|------------------|
| Universal SynSaveInstance | Server logs + GUI scan |
| EasySaveInstance | Output pattern matching |
| RoSaver | Output pattern matching |
| Synapse SaveInstance | Output pattern matching |
| Infinity Yield SaveInstance | Output pattern matching |
| Dark Dex SaveInstance | GUI detection + logs |

### Decompilers
| Tool Detected | Detection Method |
|---------------|------------------|
| Unluac | Output pattern matching |
| LuaDec | Output pattern matching |
| Bytecode Converters | Output pattern matching |
| Script Dumpers | `getscriptbytecode` detection |

### Executors
| Executor | Detection Method |
|----------|------------------|
| Synapse X | Name + function detection |
| Krnl | Name + function detection |
| Fluxus | Name + function detection |
| Solara | Name + function detection |
| Wave | Name + function detection |
| Script-Ware | Name detection |
| Vega X | Name detection |
| Arceus X | Name detection |
| Hydrogen | Name detection |
| JJSploit | Name detection |
| Nihon | Name detection |
| Furk Ultra | Name detection |
| Codex | Name detection |
| Electron | Name detection |

### Backdoors / Exploits
| Threat | Protection |
|--------|------------|
| Remote Spies | Log pattern matching |
| Server Lua Execution | Identity function detection |
| FE Bypasses | FilteringEnabled checks |
| Injected Scripts | `loadstring` / `getgc` detection |
| Function Hooks | `hookfunction` / `hookmetamethod` detection |

---

## 🏗️ Architecture
