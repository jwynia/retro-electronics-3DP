# External Libraries

This directory contains external library dependencies.

## BOSL2

BOSL2 (Belfry OpenSCAD Library v2) is included as a git submodule.

**Initialize after cloning:**
```bash
git submodule update --init --recursive
```

**Or run the setup script:**
```bash
./scripts/setup.sh
```

**Manual installation:**
If you prefer not to use submodules, download BOSL2 from:
https://github.com/BelfrySCAD/BOSL2

Extract it to `lib/BOSL2/` so that `lib/BOSL2/std.scad` exists.

## Gridfinity Rebuilt

Gridfinity modular storage system generators from kennetek.
https://github.com/kennetek/gridfinity-rebuilt-openscad

**Key files:**
- `gridfinity-rebuilt-baseplate.scad` - Baseplate generator
- `gridfinity-rebuilt-bins.scad` - Bin generator
- `gridfinity-rebuilt-lite.scad` - Simplified variant
- `src/core/standard.scad` - Standard dimensions and constants

**Usage:**
```openscad
include <gridfinity-rebuilt-openscad/src/core/standard.scad>
include <gridfinity-rebuilt-openscad/gridfinity-rebuilt-baseplate.scad>
```

See `context-network/domains/gridfinity/overview.md` for integration details.

## NopSCADlib

Hardware components library including screws, nuts, PCB definitions, and more.
Also includes a simpler Gridfinity implementation.

## Other Libraries

- **PiHoles** - Raspberry Pi mounting hole patterns
- **battery_lib** - Battery dimension references
- **knurled-openscad** - Knurled texture patterns

## Library Path

OpenSCAD needs to find the libraries. Options:

1. **Symlink to OpenSCAD library path:**
   ```bash
   ln -s /path/to/retrocase/lib/BOSL2 ~/.local/share/OpenSCAD/libraries/BOSL2
   ```

2. **Set OPENSCADPATH environment variable:**
   ```bash
   export OPENSCADPATH=/path/to/retrocase/lib
   ```

3. **Use -L flag when running OpenSCAD:**
   ```bash
   openscad -L /path/to/retrocase/lib model.scad
   ```

The example files use `include <BOSL2/std.scad>` which assumes BOSL2 is in the library path.
