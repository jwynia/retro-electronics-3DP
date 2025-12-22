#!/bin/bash
# RetroCase render script
# Renders OpenSCAD files to PNG for visual verification

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_ROOT/test-renders"
LIB_PATH="$PROJECT_ROOT/lib"

# Camera presets (x,y,z,rx,ry,rz,dist)
declare -A CAMERAS
CAMERAS[default]="0,0,0,55,0,25,300"
CAMERAS[front]="0,0,0,90,0,0,300"
CAMERAS[top]="0,0,0,0,0,0,300"
CAMERAS[iso]="0,0,0,55,0,45,300"
CAMERAS[right]="0,0,0,90,0,90,300"
CAMERAS[back]="0,0,0,90,0,180,300"

# Default settings
IMGSIZE="800,600"
COLORSCHEME="Tomorrow"
CAMERA="${CAMERAS[default]}"

usage() {
    echo "Usage: $0 [options] <file.scad> [camera-preset]"
    echo ""
    echo "Options:"
    echo "  --all         Render all files in examples/"
    echo "  --size WxH    Image size (default: 800,600)"
    echo "  --stl         Also export STL"
    echo "  --help        Show this help"
    echo ""
    echo "Camera presets: default, front, top, iso, right, back"
    echo ""
    echo "Examples:"
    echo "  $0 examples/01-basic-rounded-box.scad"
    echo "  $0 examples/02-wedge-shell.scad front"
    echo "  $0 --all"
    echo "  $0 --stl modules/shells/monolithic.scad"
}

render_file() {
    local INPUT_FILE="$1"
    local PRESET="${2:-default}"
    local EXPORT_STL="${3:-false}"
    
    if [ ! -f "$INPUT_FILE" ]; then
        echo "Error: File not found: $INPUT_FILE"
        return 1
    fi
    
    # Get camera for preset
    local CAM="${CAMERAS[$PRESET]}"
    if [ -z "$CAM" ]; then
        echo "Warning: Unknown camera preset '$PRESET', using default"
        CAM="${CAMERAS[default]}"
    fi
    
    # Generate output filename
    local BASENAME=$(basename "$INPUT_FILE" .scad)
    local PNG_OUTPUT="$OUTPUT_DIR/${BASENAME}.png"
    local STL_OUTPUT="$OUTPUT_DIR/${BASENAME}.stl"
    
    echo "Rendering: $INPUT_FILE"
    echo "  Camera: $PRESET"
    echo "  Output: $PNG_OUTPUT"
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # Render PNG
    openscad -o "$PNG_OUTPUT" \
        --camera="$CAM" \
        --imgsize="$IMGSIZE" \
        --colorscheme="$COLORSCHEME" \
        -D "\$fn=32" \
        "$INPUT_FILE" 2>&1 | grep -v "^DEPRECATED" | head -30
    
    if [ -f "$PNG_OUTPUT" ]; then
        echo "  ✓ PNG created"
    else
        echo "  ✗ PNG creation failed"
        return 1
    fi
    
    # Export STL if requested
    if [ "$EXPORT_STL" = "true" ]; then
        echo "  Exporting STL..."
        openscad -o "$STL_OUTPUT" \
            -D "\$fn=64" \
            "$INPUT_FILE" 2>&1 | grep -v "^DEPRECATED" | head -10
        
        if [ -f "$STL_OUTPUT" ]; then
            echo "  ✓ STL created: $STL_OUTPUT"
        else
            echo "  ✗ STL creation failed"
        fi
    fi
    
    return 0
}

render_all() {
    local EXPORT_STL="$1"
    local COUNT=0
    local FAILED=0
    
    echo "=== Rendering all examples ==="
    echo ""
    
    for FILE in "$PROJECT_ROOT"/examples/*.scad; do
        if [ -f "$FILE" ]; then
            echo "---"
            if render_file "$FILE" "default" "$EXPORT_STL"; then
                ((COUNT++))
            else
                ((FAILED++))
            fi
            echo ""
        fi
    done
    
    echo "=== Complete ==="
    echo "Rendered: $COUNT files"
    if [ $FAILED -gt 0 ]; then
        echo "Failed: $FAILED files"
    fi
}

# Parse arguments
EXPORT_STL="false"
RENDER_ALL="false"
POSITIONAL=()

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            RENDER_ALL="true"
            shift
            ;;
        --stl)
            EXPORT_STL="true"
            shift
            ;;
        --size)
            IMGSIZE="$2"
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            POSITIONAL+=("$1")
            shift
            ;;
    esac
done

# Restore positional parameters
set -- "${POSITIONAL[@]}"

# Execute
if [ "$RENDER_ALL" = "true" ]; then
    render_all "$EXPORT_STL"
elif [ $# -ge 1 ]; then
    INPUT_FILE="$1"
    PRESET="${2:-default}"
    
    # Handle relative paths
    if [[ ! "$INPUT_FILE" = /* ]]; then
        # Check if file exists relative to current dir
        if [ -f "$INPUT_FILE" ]; then
            INPUT_FILE="$(pwd)/$INPUT_FILE"
        # Check if file exists relative to project root
        elif [ -f "$PROJECT_ROOT/$INPUT_FILE" ]; then
            INPUT_FILE="$PROJECT_ROOT/$INPUT_FILE"
        fi
    fi
    
    render_file "$INPUT_FILE" "$PRESET" "$EXPORT_STL"
else
    usage
    exit 1
fi
