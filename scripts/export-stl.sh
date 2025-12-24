#!/bin/bash
# Export OpenSCAD files to STL for 3D printing
# Usage: ./scripts/export-stl.sh <scad_file> [output_dir]

set -e

SCAD_FILE="$1"
OUTPUT_DIR="${2:-stl-exports}"

if [ -z "$SCAD_FILE" ]; then
    echo "Usage: $0 <scad_file> [output_dir]"
    echo "Example: $0 prints/corner-bracket-plate.scad"
    exit 1
fi

if [ ! -f "$SCAD_FILE" ]; then
    echo "Error: File not found: $SCAD_FILE"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Get base filename without extension
BASENAME=$(basename "$SCAD_FILE" .scad)

# Export to STL
OUTPUT_FILE="$OUTPUT_DIR/$BASENAME.stl"
echo "Exporting $SCAD_FILE to $OUTPUT_FILE..."

openscad -o "$OUTPUT_FILE" "$SCAD_FILE"

if [ $? -eq 0 ]; then
    echo "Successfully exported: $OUTPUT_FILE"
    ls -lh "$OUTPUT_FILE"
else
    echo "Error exporting STL"
    exit 1
fi
