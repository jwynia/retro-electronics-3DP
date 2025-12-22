# Context Network Maintenance

## Purpose
Procedures for keeping the RetroCase context network current, organized, and valuable.

## Classification
- **Domain:** Meta
- **Stability:** Stable
- **Abstraction:** Procedural
- **Confidence:** Established

## Update Triggers

Update the context network when:

### Immediate Updates
- Starting a new task or subtask
- Making architectural decisions
- Discovering new relationships between components
- Finding bugs or issues
- Learning how a system works

### Periodic Updates
- Every 10-15 minutes of active development work
- After completing any significant change
- Before committing code

### Discovery-Triggered Updates
- Finding important information in source files
- Understanding a pattern that wasn't documented
- Realizing existing documentation is wrong

## The 3-Line Rule

If you read more than 3 lines of code to understand something, **record it**:

1. What question you were trying to answer
2. Where you found the answer (file:lines)
3. What the answer means in plain language

This prevents repeated investigation of the same code.

## Document Size Limits

### Target Size
- **100-300 lines** per document (atomic note principle)
- **50KB maximum** per file

### When to Split
If a document exceeds limits:
1. Identify logical sections
2. Create separate documents for each section
3. Create index linking to the new documents
4. Update navigation in related documents

## Location Index Maintenance

Every domain has a `locations.md` file. Update it when:

- Adding new code files
- Adding new modules/functions
- Finding important patterns in existing code
- Code moves to different locations

### Format
```markdown
## [Concept Name]
- **File:** `path/to/file.scad`
- **Lines:** XX-YY
- **Purpose:** Brief description
```

## Link Maintenance

### Check for Broken Links
When moving or renaming documents:
1. Search for `[[document-name]]` references
2. Update all references
3. Update navigation sections

### Link Types
- `[[document]]` - Same directory
- `[[../section/document]]` - Different section
- `[text](path.md)` - Markdown links

## Adding New Content

### New Document Checklist
- [ ] Use appropriate template from `meta/templates/`
- [ ] Add to parent index
- [ ] Include navigation section
- [ ] Include metadata section
- [ ] Add cross-references to related documents

### New Section Checklist
- [ ] Create directory
- [ ] Create `index.md`
- [ ] Update parent navigation
- [ ] Update `discovery.md` if major section

## Review Procedures

### Weekly Review (If Active)
- Check for stale content
- Update location indexes if code changed
- Verify links work
- Archive completed task records

### After Major Changes
- Review all affected domain documents
- Update architecture documentation if needed
- Check decision records for relevance
- Update planning documents

## Archiving

### Completed Tasks
Move completed task records to an archive section or delete if no longer valuable.

### Superseded Decisions
Mark old decisions as "Superseded by ADR-XXX" rather than deleting.

### Outdated Content
If content is no longer accurate:
1. Update it if possible
2. Mark as outdated if update not feasible
3. Delete only if completely obsolete

## Quality Standards

### Every Document Should Have
- Clear purpose statement
- Classification metadata
- Navigation section
- Last updated date

### Every Location Index Should Have
- File paths that exist
- Line numbers that are current
- Brief purpose descriptions

### Every Decision Record Should Have
- Clear status (Accepted/Rejected/Superseded)
- Rationale section
- Alternatives considered
- Consequences documented

## Common Maintenance Tasks

### Adding a New Module
1. Create/update domain location index
2. Create pattern documentation if new pattern
3. Update module roadmap (mark as implemented)
4. Update any related domain documents

### Fixing a Bug
1. Document the bug investigation
2. Update affected documentation
3. Note any discovered issues

### Refactoring Code
1. Update all location indexes
2. Check for documentation that references old patterns
3. Update cross-domain interfaces if changed

## Navigation

**Up:** [`index.md`](index.md) - Meta overview

**Related:**
- [`templates/`](templates/) - Templates for new content
- [`updates/`](updates/) - Update history

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Process Documentation
