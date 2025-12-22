# RetroCase

A parametric OpenSCAD library for generating retro-styled electronics enclosures.

## Design Language

This library produces enclosures inspired by:
- **Braun/Dieter Rams** - Clean geometry, consistent radii, functional minimalism
- **1970s Japanese electronics** - JVC, Sanyo, Panasonic flip clocks and radios
- **Space Age/Atomic design** - Tapered forms, bold colors, organic curves

## Quick Start

```openscad
include <retrocase/modules/shells/monolithic.scad>
include <retrocase/modules/faces/bezel.scad>

// Generate a wedge-shaped shell
shell_wedge(
    width = 150,
    height = 100,
    depth = 80,
    wall = 3,
    corner_radius = 8,
    rake_angle = 15,
    opening_width = 120,
    opening_height = 70
);

// Generate a matching face plate with screen bezel
faceplate_bezel(
    width = 120,
    height = 70,
    screen_width = 100,
    screen_height = 60,
    thickness = 4
);
```

## Installation

```bash
git clone --recurse-submodules https://github.com/yourname/retrocase.git
cd retrocase
./scripts/setup.sh
```

If you already cloned without `--recurse-submodules`:
```bash
git submodule update --init --recursive
./scripts/setup.sh
```

The setup script will:
1. Initialize all library submodules (BOSL2, NopSCADlib, PiHoles)
2. Verify each library is present
3. Run a test render to confirm everything works

## Shell Types

### Monolithic (`shell_monolithic`)
Single-piece shell with front opening. Face plate drops into rebated lip.

### Wedge (`shell_wedge`)
Trapezoidal profile with raked front face. Classic retro electronics shape.

### Sleeve (`shell_sleeve`)
Open-ended U-channel (like Braun RT 20). Face plate and back panel attach separately.

### Compound (`shell_compound`)
Organic curves with different front/back profiles. Think 1970s flip clocks.

## Face Plate Types

### Bezel (`faceplate_bezel`)
Frame for mounting screens/displays. Configurable screen dimensions and mounting depth.

### Control Panel (`faceplate_controls`)
Panel with holes for knobs, switches, LEDs. Specify control positions as list.

### Grille (`faceplate_grille`)
Speaker grille patterns: perforated grid, slots, hexagonal.

## Hardware Mounting

### Attachment System
Shell and face plate connect via magnets:
- **Shell side**: Magnet pockets (disc magnets glued in)
- **Face plate side**: Steel disc pockets (steel washers/discs glued in)

No polarity matching needed. Face plates freely swap between any compatible shell.

### Board Mounting
Internal standoffs for common boards:
- Raspberry Pi (Zero, 3, 4, 5)
- ESP32 dev boards
- Arduino Uno/Nano
- Audio amplifier boards

Uses mounting hole data from NopSCADlib/PiHoles when available.

## Examples

See the `examples/` directory for complete working designs:

- `01-basic-rounded-box.scad` - Simplest possible shell
- `02-wedge-shell.scad` - Raked front, Braun-style
- `03-hollow-shell-with-lip.scad` - Ready for face plate
- `04-shell-with-cutout.scad` - Screen opening example

## Rendering

```bash
# Render example to PNG
./scripts/render.sh examples/02-wedge-shell.scad

# Export to STL
openscad -o output.stl examples/02-wedge-shell.scad
```

## Dependencies

- **OpenSCAD 2021.x** or later

All libraries are included as git submodules in `lib/`:
- **BOSL2** - Core geometry library (required)
- **NopSCADlib** - PCB definitions, connectors, switches, batteries
- **PiHoles** - Raspberry Pi mounting hole patterns
- **knurled-openscad** - Knurled surface textures for knobs
- **battery_lib** - Battery dimensions for compartment design

## License

MIT License. See LICENSE file.

## Contributing

1. Read `CLAUDE.md` for workflow and coding conventions
2. Add tests for new modules
3. Render and verify before submitting
