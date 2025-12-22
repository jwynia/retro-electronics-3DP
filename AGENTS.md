# RetroCase Development Guide

This project uses a **Context Network** for all planning, architecture, and coordination information.

## Quick Start

1. **Read the context network first**: See [`.context-network.md`](.context-network.md)
2. **Before coding**: Review [`context-network/foundation/development-principles.md`](context-network/foundation/development-principles.md)
3. **When creating modules**: Follow [`context-network/processes/module-creation.md`](context-network/processes/module-creation.md)
4. **For BOSL2 help**: See [`context-network/domains/bosl2-integration/`](context-network/domains/bosl2-integration/)

## Critical Rules

- **ALWAYS** read relevant BOSL2 docs in `docs/bosl2/` before writing new modules
- **ALWAYS** render and verify output before proceeding
- **ALWAYS** update the context network as you work
- **NEVER** create planning documents outside the context network

## Environment Setup

```bash
./scripts/setup.sh
```

This initializes BOSL2 and creates required directories.

## Key Workflow

```
READ → WRITE → RENDER → VERIFY
```

1. Read BOSL2 docs and examples first
2. Write code following established patterns
3. Render with `./scripts/render.sh`
4. Verify the PNG output matches intent

## Context Network Location

All detailed documentation lives in `context-network/`:

| Topic | Location |
|-------|----------|
| Project overview | `foundation/project-definition.md` |
| Architecture | `foundation/architecture.md` |
| BOSL2 patterns | `domains/bosl2-integration/` |
| Shell patterns | `domains/shells/` |
| Faceplate patterns | `domains/faceplates/` |
| Development workflow | `processes/development-workflow.md` |
| Module creation | `processes/module-creation.md` |
| Decision records | `decisions/` |
| Roadmap | `planning/module-roadmap.md` |

## Navigation

Start at: [`.context-network.md`](.context-network.md) → [`context-network/discovery.md`](context-network/discovery.md)
