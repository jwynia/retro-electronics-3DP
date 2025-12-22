# Cross-Domain - Standards and Connections

## Purpose
This section documents standards, conventions, and connections that span multiple domains. These are the shared interfaces and common patterns that enable different parts of RetroCase to work together.

## Classification
- **Domain:** Cross-cutting concerns and interfaces
- **Stability:** Semi-stable (changes affect multiple domains)
- **Abstraction:** Structural and detailed
- **Confidence:** Established

## Cross-Domain Documents

### [`parameter-conventions.md`](parameter-conventions.md)
**Naming Standards Across Modules**

Standardized parameter names and conventions used throughout RetroCase.

**Contains:**
- Standard dimension parameters (`width`, `height`, `depth`)
- Standard material parameters (`wall`, `corner_radius`)
- Standard hardware parameters (`magnet_dia`, `magnet_depth`)
- Naming patterns and conventions

**Why this matters:** Consistent parameter names make modules composable and predictable.

### [`module-dependencies.md`](module-dependencies.md)
**How Modules Interact**

Map of dependencies and relationships between modules.

**Contains:**
- Which modules depend on which
- Shared utility functions
- Common parameter passing patterns
- Attachment point contracts

**Why this matters:** Understanding dependencies prevents circular references and guides refactoring.

### [`interface-contracts.md`](interface-contracts.md)
**Attachment Point Standards**

Standardized attachment points and anchoring conventions.

**Contains:**
- Standard anchor names and positions
- Attachment point specifications for shells
- Attachment point specifications for faceplates
- How to create new attachment points

**Why this matters:** Consistent attachment points make modules interchangeable.

## Cross-Domain Patterns

### Parameter Inheritance
Modules often pass parameters through to child modules. The conventions document standardizes this pattern.

### Attachment Contracts
Shells expose certain attachment points that faceplates expect. The interface contracts document formalizes these expectations.

### Naming Consistency
Across all domains, we use consistent naming patterns. This reduces cognitive load and makes the API learnable.

## Impact of Changes

Changes to cross-domain standards affect multiple areas:

| Change Type | Impact Scope |
|-------------|--------------|
| Parameter naming | All modules using that parameter |
| Attachment contracts | Shells and faceplates |
| Module dependencies | Affected modules and their dependents |

## Navigation Patterns

### When Creating New Modules
1. Review [`parameter-conventions.md`](parameter-conventions.md) for standard names
2. Check [`module-dependencies.md`](module-dependencies.md) for reusable utilities
3. Follow [`interface-contracts.md`](interface-contracts.md) for attachment points

### When Refactoring
1. Check impact in [`module-dependencies.md`](module-dependencies.md)
2. Verify conventions still followed per [`parameter-conventions.md`](parameter-conventions.md)
3. Update contracts in [`interface-contracts.md`](interface-contracts.md) if needed

### When Debugging Integration Issues
1. Verify parameter names match [`parameter-conventions.md`](parameter-conventions.md)
2. Check attachment points match [`interface-contracts.md`](interface-contracts.md)
3. Review dependencies in [`module-dependencies.md`](module-dependencies.md)

## Navigation

**Up:** [`../discovery.md`](../discovery.md) - Main context network navigation

**Related Sections:**
- [`../domains/`](../domains/index.md) - Domain-specific implementation details
- [`../foundation/architecture.md`](../foundation/architecture.md) - Overall architecture
- [`../processes/module-creation.md`](../processes/module-creation.md) - How to create modules following these standards

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Section Type:** Cross-domain standards collection
