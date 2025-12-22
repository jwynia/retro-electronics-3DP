# Development Principles - How We Develop RetroCase

## Purpose
This document describes the critical workflow and principles for developing RetroCase. **Read this before writing any code.**

## Classification
- **Domain:** Development process
- **Stability:** Stable (core workflow)
- **Abstraction:** Procedural
- **Confidence:** Established

## The Core Workflow

### Read → Write → Render → Verify

Every code change follows this cycle:

```
1. READ  - Understand what exists before changing
2. WRITE - Make your changes
3. RENDER - Generate visual output
4. VERIFY - Confirm output matches intent
```

### 1. READ - Before Writing Any New Module

**Always do these steps first:**

1. **Read the relevant BOSL2 documentation** in `docs/bosl2/`
   - Check the function signatures
   - Understand parameter meanings
   - Note any edge cases

2. **Check `examples/` for similar patterns**
   - Find working code that does something similar
   - Understand how it uses BOSL2
   - Copy patterns, not just code

3. **Understand the module's responsibility**
   - Is it a profile (2D), shell (3D), face plate, or hardware?
   - Where does it fit in the module hierarchy?
   - What interfaces must it satisfy?

### 2. WRITE - Code Guidelines

**Follow established patterns:**
- Use BOSL2's attachment system (not raw `translate`/`rotate`)
- Use `diff()` with `tag("remove")` (not raw `difference()`)
- Make modules `attachable()` when they're reusable shapes
- Follow naming conventions in [`../cross-domain/parameter-conventions.md`](../cross-domain/parameter-conventions.md)

**Avoid common mistakes:**
- See [`../domains/bosl2-integration/common-mistakes.md`](../domains/bosl2-integration/common-mistakes.md)

### 3. RENDER - Generate Output

```bash
./scripts/render.sh modules/shells/myshell.scad
```

This generates a PNG in `test-renders/` for visual verification.

**Camera presets:**
- `default` - Isometric view
- `front` - Front face
- `top` - Top-down
- `iso` - Alternative isometric
- `right` - Right side

### 4. VERIFY - Check the Output

**Look at the PNG:**
- Does the shape match your intent?
- Are corners rounded correctly?
- Is the hollowing correct?
- Do attachment points look right?

**If wrong:**
1. Check BOSL2 errors in console output
2. Simplify - comment out parts until issue is found
3. Use `show_anchors()` to visualize attachment points
4. Check edge specifications - most common mistake
5. Verify `diff()` tag usage - missing tags cause geometry issues

## Context Network Discipline

### Before Starting Work
1. Read `.context-network.md` to locate the context network
2. Navigate to relevant sections based on your task
3. Review existing documentation

### During Work
**Update the context network:**
- Every 3-5 significant changes or discoveries
- When you find yourself re-reading the same files
- When discovering important code patterns

### The 3-Line Rule
If you read more than 3 lines of code to understand something, **record it**:
1. What question you were trying to answer
2. Where you found the answer (file:lines)
3. What the answer means in plain language

### After Completing Work
1. Update all modified nodes in the context network
2. Create/update location indexes if you found important code
3. Document any follow-up items

## Debugging Render Failures

When a render produces unexpected results:

1. **Check for BOSL2 errors** in the console output
   - These often indicate the exact problem

2. **Simplify**
   - Comment out parts until you find the issue
   - Binary search through the code

3. **Use `show_anchors()`**
   - Visualize where attachment points actually are
   - Compare to your expectations

4. **Check edge specifications**
   - This is the most common mistake
   - `edges=TOP` vs `edges="Z"` vs `edges=[TOP,BOT]`

5. **Verify diff() tag usage**
   - Missing `tag("remove")` = geometry not subtracted
   - Missing `diff()` wrapper = tags ignored

## Adding New Modules

1. **Create the `.scad` file** in the appropriate `modules/` subdirectory
2. **Add a test case** in `examples/` that exercises the module
3. **Render and verify** the test case
4. **Document parameters** in the module's header comment
5. **Update location indexes** in the context network

## Code Review Checklist

Before committing:
- [ ] Ran render and verified output
- [ ] No BOSL2 errors in console
- [ ] Parameters follow naming conventions
- [ ] Header comment documents all parameters
- [ ] Example or test case exists
- [ ] Context network updated with any discoveries

## Navigation

**Up:** [`index.md`](index.md) - Foundation overview

**Related:**
- [`../processes/development-workflow.md`](../processes/development-workflow.md) - Detailed workflow
- [`../processes/module-creation.md`](../processes/module-creation.md) - Creating new modules
- [`../domains/bosl2-integration/common-mistakes.md`](../domains/bosl2-integration/common-mistakes.md) - Avoid these errors
- [`../domains/bosl2-integration/idioms.md`](../domains/bosl2-integration/idioms.md) - Patterns to use

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Foundation - Development Process
