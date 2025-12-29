#!/bin/sh
# RetroCase render script
# Renders OpenSCAD files to PNG for visual verification
# Compatible with sh, bash, and zsh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_ROOT/test-renders"

# Default settings
IMGSIZE="800,600"
COLORSCHEME="Tomorrow"
DISTANCE="450"

# Camera preset lookup (returns: translateX,Y,Z,rotX,Y,Z - distance added separately)
get_camera() {
    case "$1" in
        front)  echo "0,0,0,90,0,0" ;;
        top)    echo "0,0,0,0,0,0" ;;
        iso)    echo "0,0,0,55,0,45" ;;
        right)  echo "0,0,0,90,0,90" ;;
        back)   echo "0,0,0,90,0,180" ;;
        *)      echo "0,0,30,55,0,25" ;;  # default (slightly raised)
    esac
}

usage() {
    echo "Usage: $0 [options] <file.scad> [camera-preset]"
    echo ""
    echo "Options:"
    echo "  --all           Render all files in examples/"
    echo "  --size WxH      Image size (default: 800,600)"
    echo "  --distance N    Camera distance (default: 450, use 600-800 for large scenes)"
    echo "  --stl           Also export STL"
    echo "  --help          Show this help"
    echo ""
    echo "Camera presets: default, front, top, iso, right, back"
    echo ""
    echo "Examples:"
    echo "  $0 examples/01-basic-rounded-box.scad"
    echo "  $0 examples/02-wedge-shell.scad front"
    echo "  $0 --distance 700 examples/19-font-sampler.scad top"
    echo "  $0 --all"
}

render_file() {
    INPUT_FILE="$1"
    PRESET="${2:-default}"
    EXPORT_STL="${3:-false}"

    if [ ! -f "$INPUT_FILE" ]; then
        echo "Error: File not found: $INPUT_FILE"
        return 1
    fi

    # Get camera for preset (add distance)
    CAM="$(get_camera "$PRESET"),$DISTANCE"

    # Generate output filename
    BASENAME=$(basename "$INPUT_FILE" .scad)
    PNG_OUTPUT="$OUTPUT_DIR/${BASENAME}.png"
    STL_OUTPUT="$OUTPUT_DIR/${BASENAME}.stl"

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
        -D '$fn=32' \
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
            -D '$fn=64' \
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
    EXPORT_STL_FLAG="$1"
    COUNT=0
    FAILED=0

    echo "=== Rendering all examples ==="
    echo ""

    for FILE in "$PROJECT_ROOT"/examples/*.scad; do
        if [ -f "$FILE" ]; then
            echo "---"
            if render_file "$FILE" "default" "$EXPORT_STL_FLAG"; then
                COUNT=$((COUNT + 1))
            else
                FAILED=$((FAILED + 1))
            fi
            echo ""
        fi
    done

    echo "=== Complete ==="
    echo "Rendered: $COUNT files"
    if [ "$FAILED" -gt 0 ]; then
        echo "Failed: $FAILED files"
    fi
}

# Parse arguments
EXPORT_STL="false"
RENDER_ALL="false"
FILES=""
PRESET=""

while [ $# -gt 0 ]; do
    case "$1" in
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
        --distance|-d)
            DISTANCE="$2"
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
            if [ -z "$FILES" ]; then
                FILES="$1"
            else
                PRESET="$1"
            fi
            shift
            ;;
    esac
done

# Execute
if [ "$RENDER_ALL" = "true" ]; then
    render_all "$EXPORT_STL"
elif [ -n "$FILES" ]; then
    INPUT_FILE="$FILES"
    PRESET="${PRESET:-default}"

    # Handle relative paths
    case "$INPUT_FILE" in
        /*)
            # Absolute path, use as-is
            ;;
        *)
            # Relative path - check current dir first, then project root
            if [ -f "$INPUT_FILE" ]; then
                INPUT_FILE="$(pwd)/$INPUT_FILE"
            elif [ -f "$PROJECT_ROOT/$INPUT_FILE" ]; then
                INPUT_FILE="$PROJECT_ROOT/$INPUT_FILE"
            fi
            ;;
    esac

    render_file "$INPUT_FILE" "$PRESET" "$EXPORT_STL"
else
    usage
    exit 1
fi
