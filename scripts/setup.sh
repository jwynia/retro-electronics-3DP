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

# Initialize BOSL2 submodule
echo ""
echo "=== Initializing BOSL2 ==="

if [ -d "$PROJECT_ROOT/lib/BOSL2/.git" ] || [ -f "$PROJECT_ROOT/lib/BOSL2/std.scad" ]; then
    echo "✓ BOSL2 already initialized"
else
    if [ -f "$PROJECT_ROOT/.gitmodules" ]; then
        echo "Initializing git submodule..."
        cd "$PROJECT_ROOT"
        git submodule update --init --recursive
    else
        echo "Cloning BOSL2 directly..."
        mkdir -p "$PROJECT_ROOT/lib"
        git clone https://github.com/BelfrySCAD/BOSL2.git "$PROJECT_ROOT/lib/BOSL2"
    fi
    echo "✓ BOSL2 installed"
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

if [ -f "$PROJECT_ROOT/lib/BOSL2/std.scad" ]; then
    echo "✓ BOSL2 std.scad found"
else
    echo "✗ BOSL2 std.scad not found - check lib/BOSL2/"
    exit 1
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
