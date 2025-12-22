# Foundation - Core Project Knowledge

## Purpose
This section contains the fundamental knowledge about RetroCase - what it is, how it's structured, and how we develop it. Start here to understand the project's purpose, architecture, and core principles.

## Classification
- **Domain:** Meta-knowledge about the project
- **Stability:** Semi-stable (evolves with major architectural changes)
- **Abstraction:** Conceptual and structural
- **Confidence:** Established

## Documents in Foundation

### [`project-definition.md`](project-definition.md)
**What is RetroCase?**

Defines the project's purpose, design philosophy, target use cases, and aesthetic inspiration. Essential reading for understanding the "why" behind RetroCase.

**Key topics:**
- Project goals and vision
- Design language (Braun/Rams, 1970s Japanese electronics, Space Age)
- Target use cases (screen-centric, control panels, internal mounting)
- Audience and intended users

### [`architecture.md`](architecture.md)
**How is RetroCase structured?**

Documents the technical architecture, module organization, BOSL2 integration strategy, and overall system design.

**Key topics:**
- Module organization (profiles, shells, faces, hardware)
- BOSL2 library integration
- Directory structure and naming conventions
- External library dependencies
- Build and rendering infrastructure

### [`development-principles.md`](development-principles.md)
**How do we develop RetroCase?**

The critical workflow and principles that guide development. **Read this before writing any code.**

**Key topics:**
- The Read → Write → Render → Verify workflow
- BOSL2-specific development practices
- Testing and validation requirements
- Code review principles
- Common mistakes to avoid

## Navigation

**Up:** [`../discovery.md`](../discovery.md) - Main context network navigation

**Related Sections:**
- [`../domains/`](../domains/index.md) - Domain-specific technical knowledge
- [`../processes/`](../processes/index.md) - Detailed workflow documentation
- [`../decisions/`](../decisions/index.md) - Why we made these architectural choices

## When to Read Foundation

- **New to the project:** Read all foundation documents in order
- **Before first contribution:** At minimum, read `development-principles.md`
- **Making architectural changes:** Review all three documents
- **Onboarding others:** Direct them here first

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Section Type:** Foundation knowledge
