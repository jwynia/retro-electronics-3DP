# Parameter Conventions

## Purpose
Standardized parameter names and conventions used throughout RetroCase modules.

## Classification
- **Domain:** Cross-domain standards
- **Stability:** Stable (changes affect all modules)
- **Abstraction:** Naming standards
- **Confidence:** Established

## Core Dimensional Parameters

### Size Parameters
| Name | Type | Description | Example |
|------|------|-------------|---------|
| `size` | `[x, y, z]` | Overall dimensions as array | `[100, 80, 60]` |
| `width` | number | X dimension | `100` |
| `height` | number | Y dimension | `80` |
| `depth` | number | Z dimension | `60` |

**Convention:** When both `size` array and individual dimensions are valid, prefer `size` for API simplicity.

### Wall Parameters
| Name | Type | Description | Default |
|------|------|-------------|---------|
| `wall` | number | Wall thickness | `3` |

### Rounding Parameters
| Name | Type | Description | Default |
|------|------|-------------|---------|
| `corner_r` | number | Corner radius | `10` |
| `corner_radius` | number | Alias for corner_r | - |
| `rounding` | number | BOSL2 native parameter | - |

**Convention:** Use `corner_r` in RetroCase modules; `rounding` is BOSL2's native name.

## Opening Parameters

| Name | Type | Description |
|------|------|-------------|
| `opening` | `[w, h]` | Opening dimensions |
| `opening_width` | number | Opening width |
| `opening_height` | number | Opening height |
| `opening_r` | number | Opening corner radius |
| `opening_inset` | number | Distance from edge |

## Lip/Rebate Parameters

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `lip_depth` | number | Depth of rebate | `3` |
| `lip_width` | number | Width of lip edge | `1.5` |
| `lip_inset` | number | Inset from outer edge | `1.5` |

## Hardware Parameters

### Magnetic Attachment
| Name | Type | Description | Default |
|------|------|-------------|---------|
| `magnet_dia` | number | Magnet diameter | `8` |
| `magnet_depth` | number | Magnet pocket depth | `3` |
| `steel_dia` | number | Steel disc diameter | `8` |
| `steel_depth` | number | Steel pocket depth | `1` |
| `steel_inset` | number | Inset from corner | `12` |
| `steel_pockets` | bool | Include pockets | `true` |

### Mounting
| Name | Type | Description | Default |
|------|------|-------------|---------|
| `standoff_height` | number | Standoff height | varies |
| `standoff_dia` | number | Standoff diameter | `6` |
| `screw_dia` | number | Screw hole diameter | `2.5` |
| `mounting_inset` | number | Distance from corners | `12` |

## BOSL2 Attachment Parameters

All attachable modules accept:

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `anchor` | constant | BOSL2 anchor point | `CENTER` or `BOT` |
| `spin` | number | Z-axis rotation | `0` |
| `orient` | constant | Up direction | `UP` |

**Convention:** Shells default to `anchor=BOT`; faceplates to `anchor=CENTER`.

## Screen/Display Parameters

| Name | Type | Description |
|------|------|-------------|
| `screen_size` | `[w, h]` | Screen visible area |
| `screen_width` | number | Screen width |
| `screen_height` | number | Screen height |
| `screen_depth` | number | Screen mounting depth |
| `screen_corner_r` | number | Screen opening radius |
| `screen_lip` | number | Lip holding screen |

## Parameter Naming Rules

### General Rules
1. Use `snake_case` for all parameters
2. Use clear, descriptive names
3. Abbreviate common terms consistently:
   - `r` for radius
   - `dia` for diameter
   - `w` for width (in arrays only)
   - `h` for height (in arrays only)

### Suffix Conventions
| Suffix | Meaning | Example |
|--------|---------|---------|
| `_r` | radius | `corner_r` |
| `_dia` | diameter | `magnet_dia` |
| `_depth` | Z-direction depth | `lip_depth` |
| `_width` | X-direction width | `opening_width` |
| `_height` | Y-direction height | `opening_height` |
| `_inset` | distance from edge | `steel_inset` |

### Boolean Parameters
- Use positive names (`steel_pockets` not `no_pockets`)
- Default to most common usage

### Array Parameters
- Document expected order: `[width, height]` or `[x, y, z]`
- Be consistent within a module

## Default Value Constants

Module-level defaults use underscore prefix:

```openscad
_SHELL_WALL = 3;
_SHELL_CORNER_R = 10;
_FACEPLATE_THICKNESS = 4;
```

## Navigation

**Up:** [`index.md`](index.md) - Cross-domain overview

**Related:**
- [`interface-contracts.md`](interface-contracts.md) - How modules connect
- [`../processes/module-creation.md`](../processes/module-creation.md) - Using conventions

## Metadata
- **Created:** 2025-12-21
- **Last Updated:** 2025-12-21
- **Document Type:** Standards
