#!/bin/bash
# RetroCase setup script
# Installs dependencies and initializes the project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "=== RetroCase Setup ==="

# Check for OpenSCAD
if command -v openscad &> /dev/null; then
    OPENSCAD_VERSION=$(openscad --version 2>&1 | head -1)
    echo "✓ OpenSCAD found: $OPENSCAD_VERSION"
else
    echo "✗ OpenSCAD not found"
    echo ""
    echo "Install OpenSCAD:"
    echo "  Ubuntu/Debian: sudo apt install openscad"
    echo "  macOS:         brew install openscad"
    echo "  Windows:       https://openscad.org/downloads.html"
    echo ""
    echo "Or install via snap for latest version:"
    echo "  sudo snap install openscad-nightly"
    echo ""
    
    # Try to install on Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        read -p "Attempt to install OpenSCAD via apt? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sudo apt-get update
            sudo apt-get install -y openscad
        fi
    fi
fi

# Initialize all library submodules
echo ""
echo "=== Initializing Libraries ==="

cd "$PROJECT_ROOT"

if [ -f "$PROJECT_ROOT/.gitmodules" ]; then
    echo "Initializing git submodules..."
    git submodule update --init --recursive
    echo "✓ Submodules initialized"
else
    echo "No .gitmodules found - cloning libraries directly..."
    mkdir -p "$PROJECT_ROOT/lib"
    git clone https://github.com/BelfrySCAD/BOSL2.git "$PROJECT_ROOT/lib/BOSL2"
    git clone https://github.com/nophead/NopSCADlib.git "$PROJECT_ROOT/lib/NopSCADlib"
    git clone https://github.com/daprice/PiHoles.git "$PROJECT_ROOT/lib/PiHoles"
    echo "✓ Libraries cloned"
fi

# Create necessary directories
echo ""
echo "=== Creating directories ==="

mkdir -p "$PROJECT_ROOT/test-renders"
mkdir -p "$PROJECT_ROOT/presets"
mkdir -p "$PROJECT_ROOT/reference"

echo "✓ Directories created"

# Make render script executable
chmod +x "$PROJECT_ROOT/scripts/render.sh" 2>/dev/null || true

# Verify setup
echo ""
echo "=== Verifying setup ==="

# Check BOSL2 (required)
if [ -f "$PROJECT_ROOT/lib/BOSL2/std.scad" ]; then
    echo "✓ BOSL2 std.scad found"
else
    echo "✗ BOSL2 std.scad not found - check lib/BOSL2/"
    exit 1
fi

# Check NopSCADlib (optional but recommended)
if [ -d "$PROJECT_ROOT/lib/NopSCADlib/vitamins" ]; then
    echo "✓ NopSCADlib found (PCB definitions, hardware)"
else
    echo "⚠ NopSCADlib not found - some hardware features unavailable"
fi

# Check PiHoles (optional)
if [ -f "$PROJECT_ROOT/lib/PiHoles/PiHoles.scad" ]; then
    echo "✓ PiHoles found (Raspberry Pi mounting)"
else
    echo "⚠ PiHoles not found - Pi mounting features unavailable"
fi

# Check knurled-openscad (optional)
if [ -f "$PROJECT_ROOT/lib/knurled-openscad/knurled.scad" ]; then
    echo "✓ knurled-openscad found (knob textures)"
else
    echo "⚠ knurled-openscad not found - knurling features unavailable"
fi

# Check battery_lib (optional)
if [ -f "$PROJECT_ROOT/lib/battery_lib/battery_lib.scad" ]; then
    echo "✓ battery_lib found (battery dimensions)"
else
    echo "⚠ battery_lib not found - battery compartment features unavailable"
fi

# Test render if OpenSCAD is available
if command -v openscad &> /dev/null; then
    echo ""
    echo "=== Testing render ==="
    
    TEST_FILE="$PROJECT_ROOT/examples/01-basic-rounded-box.scad"
    if [ -f "$TEST_FILE" ]; then
        echo "Rendering test file..."
        openscad -o "$PROJECT_ROOT/test-renders/setup-test.png" \
            --camera=0,0,0,55,0,25,300 \
            --imgsize=800,600 \
            --colorscheme=Tomorrow \
            "$TEST_FILE" 2>&1 | head -20
        
        if [ -f "$PROJECT_ROOT/test-renders/setup-test.png" ]; then
            echo "✓ Test render successful"
            echo "  Output: test-renders/setup-test.png"
        else
            echo "✗ Test render failed"
        fi
    else
        echo "No test file yet - skipping render test"
    fi
fi

echo ""
echo "=== Setup complete ==="
echo ""
echo "Next steps:"
echo "  1. Review CLAUDE.md for workflow instructions"
echo "  2. Check examples/ for working designs"
echo "  3. Run ./scripts/render.sh <file.scad> to test"
