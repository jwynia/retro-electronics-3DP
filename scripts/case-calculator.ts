#!/usr/bin/env -S deno run --allow-read --allow-write

/**
 * Plywood Case Calculator with Gridfinity Support
 *
 * Calculates cut lists for plywood cases with 3D-printed corner brackets
 * and optional Gridfinity baseplate sizing.
 *
 * Usage:
 *   deno run scripts/case-calculator.ts --width 400 --depth 300 --height 150
 *   ./scripts/case-calculator.ts -w 400 -d 300 -h 150 --ply 3/8 --gridfinity
 */

import { parse } from "https://deno.land/std@0.208.0/flags/mod.ts";

// ============================================
// Constants
// ============================================

// Gridfinity standard dimensions (from gridfinity-rebuilt-openscad/src/core/standard.scad)
const GRIDFINITY = {
  GRID_PITCH: 42,           // mm per grid unit
  BASE_TOP: 41.5,           // actual base size (0.5mm gap)
  BASE_HEIGHT: 7,           // mm per z-unit
  BASE_PROFILE_HEIGHT: 5.45, // height of interlocking profile
  MIN_WALL: 0.95,           // minimum wall thickness
  MAGNET_HOLE_RADIUS: 3.25, // 6.5mm dia magnets
  MAGNET_HEIGHT: 2,
  SCREW_HOLE_RADIUS: 1.5,   // M3 screws
};

// Plywood actual thicknesses (inches to mm)
const PLYWOOD: Record<string, number> = {
  "1/4": 6.35,    // Actually ~5.5mm (11/64")
  "3/8": 8.73,    // Actually ~8.7mm (11/32")
  "1/2": 11.91,   // Actually ~11.9mm (15/32")
  "5/8": 15.08,   // Actually ~15mm (19/32")
  "3/4": 17.86,   // Actually ~17.9mm (23/32")
};

// Corner bracket defaults
const BRACKET = {
  WALL: 3,          // bracket wall thickness
  TOLERANCE: 0.2,   // clearance for plywood
};

// ============================================
// Types
// ============================================

interface CaseConfig {
  interiorWidth: number;    // Interior X dimension (mm)
  interiorDepth: number;    // Interior Y dimension (mm)
  interiorHeight: number;   // Interior Z dimension (mm)
  plyThickness: number;     // Actual plywood thickness (mm)
  bracketWall: number;      // Bracket wall thickness (mm)
  tolerance: number;        // Fit tolerance (mm)
  useGridfinity: boolean;   // Include Gridfinity calculations
  baseplateStyle: "thin" | "standard" | "weighted";
}

interface CutPiece {
  name: string;
  width: number;
  height: number;
  quantity: number;
  notes?: string;
}

interface GridfinityConfig {
  unitsX: number;
  unitsY: number;
  baseplateWidth: number;
  baseplateDepth: number;
  marginX: number;
  marginY: number;
  maxBinHeight: number;     // max z-units that fit
}

interface CaseCalculation {
  config: CaseConfig;
  cutList: CutPiece[];
  bracketHeight: number;
  armWidth: number;
  exteriorWidth: number;
  exteriorDepth: number;
  exteriorHeight: number;
  gridfinity?: GridfinityConfig;
}

// ============================================
// Calculation Functions
// ============================================

function calculateArmWidth(plyThickness: number, wall: number, tolerance: number): number {
  // arm_width = wall + (ply + tolerance) * 2 + wall
  return wall + (plyThickness + tolerance) * 2 + wall;
}

function calculateCutList(config: CaseConfig): CutPiece[] {
  const { interiorWidth, interiorDepth, interiorHeight, plyThickness } = config;
  const armWidth = calculateArmWidth(plyThickness, config.bracketWall, config.tolerance);

  // Construction order (bottom-up):
  // 1. Bottom: full exterior footprint (all sides sit ON it)
  // 2. Left/Right sides: full depth (front-to-back), sit on bottom
  // 3. Front/Back: shortened width to fit BETWEEN sides, sit on bottom
  // 4. Top: fits between sides, sits on front/back
  //
  // Key relationships:
  // - Interior height is the usable space inside
  // - Exterior height = interior + bottom ply + top ply
  // - Sides run full depth and full exterior height (minus bottom ply they sit on)
  // - Front/back fit between the two side panels

  // Bottom panel: full exterior dimensions
  // Width = interior + both side panel thicknesses
  // Depth = interior + front/back panels extending into bracket arms
  const bottomWidth = interiorWidth + plyThickness * 2;
  const bottomDepth = interiorDepth + armWidth * 2;

  // Side panels (Left/Right): full depth, height from bottom surface to top
  // Depth = same as bottom depth (full front-to-back)
  // Height = interior height + top panel thickness (sits ON bottom, supports top)
  const sidePanelDepth = bottomDepth;
  const sidePanelHeight = interiorHeight + plyThickness;

  // Front/Back panels: fit between sides, same height as sides
  // Width = interior width (sides are on the outside, each side = plyThickness)
  // Height = same as side panels
  const frontBackWidth = interiorWidth;
  const frontBackHeight = sidePanelHeight;

  // Top panel: fits between sides, sits on top of front/back
  // Width = interior width (same as front/back - fits between sides)
  // Depth = interior depth + bracket arms - front/back panel thicknesses
  //         (front/back panels are under it at the edges)
  const topWidth = interiorWidth;
  const topDepth = interiorDepth + armWidth * 2 - plyThickness * 2;

  return [
    {
      name: "Bottom Panel",
      width: bottomWidth,
      height: bottomDepth,
      quantity: 1,
      notes: "Full exterior footprint - all sides sit on this"
    },
    {
      name: "Side Panel (Left)",
      width: sidePanelDepth,
      height: sidePanelHeight,
      quantity: 1,
      notes: `Full depth, sits on bottom, height includes top ply (${plyThickness.toFixed(1)}mm)`
    },
    {
      name: "Side Panel (Right)",
      width: sidePanelDepth,
      height: sidePanelHeight,
      quantity: 1,
      notes: `Full depth, sits on bottom, height includes top ply (${plyThickness.toFixed(1)}mm)`
    },
    {
      name: "Front Panel",
      width: frontBackWidth,
      height: frontBackHeight,
      quantity: 1,
      notes: "Fits between sides, sits on bottom"
    },
    {
      name: "Back Panel",
      width: frontBackWidth,
      height: frontBackHeight,
      quantity: 1,
      notes: "Fits between sides, sits on bottom"
    },
    {
      name: "Top Panel (optional)",
      width: topWidth,
      height: topDepth,
      quantity: 1,
      notes: "Fits between sides, sits on front/back"
    }
  ];
}

function calculateGridfinity(config: CaseConfig): GridfinityConfig {
  const { interiorWidth, interiorDepth, interiorHeight } = config;

  // Calculate how many grid units fit
  const unitsX = Math.floor(interiorWidth / GRIDFINITY.GRID_PITCH);
  const unitsY = Math.floor(interiorDepth / GRIDFINITY.GRID_PITCH);

  // Actual baseplate size
  const baseplateWidth = unitsX * GRIDFINITY.GRID_PITCH;
  const baseplateDepth = unitsY * GRIDFINITY.GRID_PITCH;

  // Remaining margin (can be used for centering or cable routing)
  const marginX = interiorWidth - baseplateWidth;
  const marginY = interiorDepth - baseplateDepth;

  // Calculate max bin height (z-units)
  // Account for baseplate height and some clearance for grabbing bins
  const baseplateHeight = config.baseplateStyle === "thin" ? 5 :
                          config.baseplateStyle === "weighted" ? 13.4 : 7;
  const clearance = 20; // mm above bins for removal
  const availableHeight = interiorHeight - baseplateHeight - clearance;
  const maxBinHeight = Math.floor(availableHeight / GRIDFINITY.BASE_HEIGHT);

  return {
    unitsX,
    unitsY,
    baseplateWidth,
    baseplateDepth,
    marginX,
    marginY,
    maxBinHeight
  };
}

function calculateCase(config: CaseConfig): CaseCalculation {
  const armWidth = calculateArmWidth(config.plyThickness, config.bracketWall, config.tolerance);
  const bracketHeight = config.interiorHeight + config.bracketWall;

  // Exterior dimensions (including bracket overhang)
  const exteriorWidth = config.interiorWidth + armWidth * 2;
  const exteriorDepth = config.interiorDepth + armWidth * 2;
  const exteriorHeight = config.interiorHeight;

  const cutList = calculateCutList(config);

  const result: CaseCalculation = {
    config,
    cutList,
    bracketHeight,
    armWidth,
    exteriorWidth,
    exteriorDepth,
    exteriorHeight
  };

  if (config.useGridfinity) {
    result.gridfinity = calculateGridfinity(config);
  }

  return result;
}

// ============================================
// Output Formatting
// ============================================

function formatMM(mm: number): string {
  return `${mm.toFixed(1)}mm`;
}

function formatInches(mm: number): string {
  const inches = mm / 25.4;
  return `${inches.toFixed(2)}"`;
}

function formatDimension(mm: number): string {
  return `${formatMM(mm)} (${formatInches(mm)})`;
}

function printReport(calc: CaseCalculation): void {
  const { config, cutList, bracketHeight, armWidth, exteriorWidth, exteriorDepth, exteriorHeight, gridfinity } = calc;

  console.log("\n" + "=".repeat(60));
  console.log("  PLYWOOD CASE CALCULATOR");
  console.log("=".repeat(60));

  // Configuration summary
  console.log("\nCASE CONFIGURATION:");
  console.log("-".repeat(40));
  console.log(`  Interior Dimensions:`);
  console.log(`    Width (X):  ${formatDimension(config.interiorWidth)}`);
  console.log(`    Depth (Y):  ${formatDimension(config.interiorDepth)}`);
  console.log(`    Height (Z): ${formatDimension(config.interiorHeight)}`);
  console.log(`  Plywood Thickness: ${formatDimension(config.plyThickness)}`);
  console.log(`  Bracket Wall: ${formatMM(config.bracketWall)}`);

  // Exterior dimensions
  console.log("\nEXTERIOR DIMENSIONS:");
  console.log("-".repeat(40));
  console.log(`  Width (X):  ${formatDimension(exteriorWidth)}`);
  console.log(`  Depth (Y):  ${formatDimension(exteriorDepth)}`);
  console.log(`  Height (Z): ${formatDimension(exteriorHeight)}`);

  // Corner bracket specs
  console.log("\nCORNER BRACKETS (3D Print):");
  console.log("-".repeat(40));
  console.log(`  Bracket Height: ${formatMM(bracketHeight)}`);
  console.log(`  Arm Width: ${formatMM(armWidth)}`);
  console.log(`  Quantity: 4 corners`);
  console.log(`  OpenSCAD Parameters:`);
  console.log(`    case_height = ${config.interiorHeight};`);
  console.log(`    ply_thickness = ${config.plyThickness.toFixed(2)};`);
  console.log(`    wall = ${config.bracketWall};`);

  // Cut list
  console.log("\nPLYWOOD CUT LIST:");
  console.log("-".repeat(40));
  console.log(`${"Piece".padEnd(25)} ${"W x H".padEnd(25)} Qty`);
  console.log("-".repeat(60));

  for (const piece of cutList) {
    const dims = `${formatMM(piece.width)} x ${formatMM(piece.height)}`;
    console.log(`${piece.name.padEnd(25)} ${dims.padEnd(25)} ${piece.quantity}`);
    if (piece.notes) {
      console.log(`  ${"".padEnd(23)} ${piece.notes}`);
    }
  }

  // Gridfinity section
  if (gridfinity) {
    console.log("\nGRIDFINITY BASEPLATE:");
    console.log("-".repeat(40));
    console.log(`  Grid Units: ${gridfinity.unitsX} x ${gridfinity.unitsY} (${gridfinity.unitsX * gridfinity.unitsY} total)`);
    console.log(`  Baseplate Size: ${formatMM(gridfinity.baseplateWidth)} x ${formatMM(gridfinity.baseplateDepth)}`);
    console.log(`  Remaining Margin: X=${formatMM(gridfinity.marginX)}, Y=${formatMM(gridfinity.marginY)}`);

    // Show bin height info with common sizes
    const maxHeight = gridfinity.maxBinHeight;
    const maxHeightMM = maxHeight * 7;
    const totalBinHeight = maxHeightMM + 7; // includes 7mm base profile
    console.log(`  Max Bin Height: ${maxHeight}u (${maxHeightMM}mm body + 7mm base = ${totalBinHeight}mm total)`);

    // Show which common bin sizes fit
    // Common heights: 3u (shallow), 6u (standard), 12u (deep), 24u (full height gear)
    const commonSizes = [3, 6, 9, 12, 18, 24];
    const fittingSizes = commonSizes.filter(s => s <= maxHeight);
    if (fittingSizes.length > 0) {
      console.log(`  Common sizes that fit: ${fittingSizes.map(s => `${s}u`).join(", ")}`);
    }

    console.log(`  OpenSCAD Parameters:`);
    console.log(`    gridx = ${gridfinity.unitsX};`);
    console.log(`    gridy = ${gridfinity.unitsY};`);

    if (gridfinity.marginX > 5 || gridfinity.marginY > 5) {
      console.log("\n  TIP: Center the baseplate for even margins:");
      console.log(`    offset_x = ${(gridfinity.marginX / 2).toFixed(1)};`);
      console.log(`    offset_y = ${(gridfinity.marginY / 2).toFixed(1)};`);
    }
  }

  console.log("\n" + "=".repeat(60));
}

function generateScadFile(calc: CaseCalculation): string {
  const { config, gridfinity } = calc;

  let scad = `// Generated Case Configuration
// Created by case-calculator.ts

$parent_modules = true;

include <../modules/hardware/corner-bracket.scad>

// === CASE PARAMETERS ===
CASE_WIDTH = ${config.interiorWidth};   // Interior width (X)
CASE_DEPTH = ${config.interiorDepth};   // Interior depth (Y)
CASE_HEIGHT = ${config.interiorHeight}; // Side panel height (Z)

PLY = ${config.plyThickness.toFixed(2)};        // Plywood thickness
WALL = ${config.bracketWall};                   // Bracket wall
TOLERANCE = ${config.tolerance};                // Fit tolerance
`;

  if (gridfinity) {
    scad += `
// === GRIDFINITY PARAMETERS ===
GRID_X = ${gridfinity.unitsX};           // Grid units in X
GRID_Y = ${gridfinity.unitsY};           // Grid units in Y
BASEPLATE_OFFSET_X = ${(gridfinity.marginX / 2).toFixed(1)}; // Center offset
BASEPLATE_OFFSET_Y = ${(gridfinity.marginY / 2).toFixed(1)}; // Center offset
`;
  }

  scad += `
// === DERIVED VALUES ===
ARM = WALL + (PLY + TOLERANCE) * 2 + WALL;

// === ASSEMBLY ===
// See examples/08-corner-brackets.scad for full assembly
`;

  return scad;
}

// ============================================
// Gridfinity-First Calculation
// ============================================

interface GridfinitySpec {
  gridX: number;
  gridY: number;
  gridZ: number;  // bin height in units
  marginX?: number;  // extra margin around baseplate (default: 10mm each side)
  marginY?: number;
}

function calculateFromGridfinity(
  spec: GridfinitySpec,
  plyThickness: number,
  bracketWall: number,
  tolerance: number,
  baseplateStyle: "thin" | "standard" | "weighted"
): CaseConfig {
  const { gridX, gridY, gridZ, marginX = 10, marginY = 10 } = spec;

  // Baseplate dimensions
  const baseplateWidth = gridX * GRIDFINITY.GRID_PITCH;
  const baseplateDepth = gridY * GRIDFINITY.GRID_PITCH;

  // Interior must fit baseplate + margins
  const interiorWidth = baseplateWidth + marginX * 2;
  const interiorDepth = baseplateDepth + marginY * 2;

  // Height calculation:
  // - Baseplate height (depends on style)
  // - Bin height: (gridZ * 7) + 7 for base profile
  // - Clearance above bins for removal (~20mm)
  const baseplateHeight = baseplateStyle === "thin" ? 5 :
                          baseplateStyle === "weighted" ? 13.4 : 7;
  const binHeight = gridZ * GRIDFINITY.BASE_HEIGHT + GRIDFINITY.BASE_HEIGHT;
  const clearance = 20;
  const interiorHeight = baseplateHeight + binHeight + clearance;

  return {
    interiorWidth,
    interiorDepth,
    interiorHeight,
    plyThickness,
    bracketWall,
    tolerance,
    useGridfinity: true,
    baseplateStyle
  };
}

// ============================================
// Size-First Gridfinity Calculation
// ============================================

// Common Gridfinity bin heights (multiples of 3)
const COMMON_BIN_HEIGHTS = [3, 6, 9, 12, 18, 24];

/**
 * Calculate what bin height (in units) would fit in the given interior height.
 * Returns the largest common bin height that fits.
 */
function calcMaxBinHeight(heightMM: number, baseplateHeight: number, clearance: number): number {
  // Available height for bins = interior - baseplate - clearance
  // Bin total height = (units * 7) + 7 for base profile
  // So: availableHeight >= (units * 7) + 7
  // units <= (availableHeight - 7) / 7
  const availableForBins = heightMM - baseplateHeight - clearance;
  const maxUnits = Math.floor((availableForBins - GRIDFINITY.BASE_HEIGHT) / GRIDFINITY.BASE_HEIGHT);

  // Find the largest common height that fits
  for (let i = COMMON_BIN_HEIGHTS.length - 1; i >= 0; i--) {
    if (COMMON_BIN_HEIGHTS[i] <= maxUnits) {
      return COMMON_BIN_HEIGHTS[i];
    }
  }
  // If smaller than all common sizes, return the smallest
  return COMMON_BIN_HEIGHTS[0];
}

/**
 * Round a bin height UP to the nearest common Gridfinity bin height.
 * Used when we want to ensure a certain bin height fits.
 */
function roundUpToCommonHeight(units: number): number {
  for (const common of COMMON_BIN_HEIGHTS) {
    if (common >= units) {
      return common;
    }
  }
  // If larger than all common sizes, round up to nearest multiple of 3
  return Math.ceil(units / 3) * 3;
}

interface SizeSpec {
  targetWidth: number;   // desired minimum interior width (mm)
  targetDepth: number;   // desired minimum interior depth (mm)
  targetHeight: number;  // desired minimum interior height (mm)
  minMargin: number;     // minimum margin around baseplate (each side)
  roundDown: boolean;    // round grid units DOWN (smaller case) - default is UP
}

interface SizeResult {
  config: CaseConfig;
  gridX: number;
  gridY: number;
  gridZ: number;         // bin height in units
  actualMarginX: number;
  actualMarginY: number;
}

function calculateFromSize(
  spec: SizeSpec,
  plyThickness: number,
  bracketWall: number,
  tolerance: number,
  baseplateStyle: "thin" | "standard" | "weighted"
): SizeResult {
  const { targetWidth, targetDepth, targetHeight, minMargin, roundDown } = spec;

  // Baseplate height depends on style
  const baseplateHeight = baseplateStyle === "thin" ? 5 :
                          baseplateStyle === "weighted" ? 13.4 : 7;
  const clearance = 20;

  // Available space for baseplate (target interior minus minimum margins)
  const availableWidth = targetWidth - minMargin * 2;
  const availableDepth = targetDepth - minMargin * 2;

  // Calculate grid units that fit
  const rawGridX = availableWidth / GRIDFINITY.GRID_PITCH;
  const rawGridY = availableDepth / GRIDFINITY.GRID_PITCH;

  // Round based on preference (default is UP)
  const gridX = roundDown ? Math.floor(rawGridX) : Math.ceil(rawGridX);
  const gridY = roundDown ? Math.floor(rawGridY) : Math.ceil(rawGridY);

  // Calculate bin height from target interior height
  // Find the largest common bin height that fits the target height
  const gridZ = calcMaxBinHeight(targetHeight, baseplateHeight, clearance);

  // Actual baseplate size
  const baseplateWidth = gridX * GRIDFINITY.GRID_PITCH;
  const baseplateDepth = gridY * GRIDFINITY.GRID_PITCH;

  // Calculate actual interior size (always rounds UP, so case grows)
  const interiorWidth = baseplateWidth + minMargin * 2;
  const interiorDepth = baseplateDepth + minMargin * 2;
  const actualMarginX = minMargin;
  const actualMarginY = minMargin;

  // Height calculation from grid units
  const binHeightMM = gridZ * GRIDFINITY.BASE_HEIGHT + GRIDFINITY.BASE_HEIGHT;
  const interiorHeight = baseplateHeight + binHeightMM + clearance;

  return {
    config: {
      interiorWidth,
      interiorDepth,
      interiorHeight,
      plyThickness,
      bracketWall,
      tolerance,
      useGridfinity: true,
      baseplateStyle
    },
    gridX,
    gridY,
    gridZ,
    actualMarginX,
    actualMarginY
  };
}

// ============================================
// CLI
// ============================================

function printUsage(): void {
  console.log(`
Plywood Case Calculator with Gridfinity Support

Usage:
  ./scripts/case-calculator.ts [options]

MODES:

  1. Plain case (no Gridfinity):
     ./scripts/case-calculator.ts -w 300 -d 200 -h 150

  2. Size-first Gridfinity (auto-calculate grid from dimensions):
     ./scripts/case-calculator.ts -w 400 -d 300 -h 120 --gridfinity
     (Rounds UP to nearest grid units and common bin height)

  3. Exact Gridfinity grid:
     ./scripts/case-calculator.ts --grid 9x7x6
     (Exactly 9x7 grid units, fits 6u tall bins)

Options:
  -w, --width <mm>      Interior width in mm
  -d, --depth <mm>      Interior depth in mm
  -h, --height <mm>     Interior height in mm
  --grid <XxYxZ>        Exact Gridfinity grid: units X x Y x bin height Z
                        Example: --grid 6x4x6 (6x4 base, fits 6u tall bins)
  --margin <mm>         Minimum margin around baseplate (default: 5mm each side)
  --round-down          Round grid units DOWN (smaller case) - default is UP
  -p, --ply <size>      Plywood size: 1/4, 3/8, 1/2, 5/8, 3/4 (default: 3/8)
  --wall <mm>           Bracket wall thickness (default: 3)
  --tolerance <mm>      Fit tolerance (default: 0.2)
  -g, --gridfinity      Enable Gridfinity mode (auto-calculate grid from size)
  --baseplate <style>   Baseplate style: thin, standard, weighted (default: standard)
  -o, --output <file>   Write OpenSCAD config to file
  --help                Show this help

Gridfinity dimensions: 42mm per grid unit, 7mm per height unit
Common bin heights: 3u, 6u, 9u, 12u, 18u, 24u (multiples of 3)

Examples:
  # Size-first: "I need ~400x300x120mm interior, fit Gridfinity"
  # (Rounds UP to 10x8 grid, 12u bins)
  ./scripts/case-calculator.ts -w 400 -d 300 -h 120 --gridfinity

  # Same but round DOWN (smaller case, fewer grid units)
  ./scripts/case-calculator.ts -w 400 -d 300 -h 120 --gridfinity --round-down

  # Exact grid: "I want exactly 10x8 grid with 24u bins"
  ./scripts/case-calculator.ts --grid 10x8x24

  # Plain case without Gridfinity
  ./scripts/case-calculator.ts -w 300 -d 200 -h 150

  # Custom margin (10mm each side) and plywood
  ./scripts/case-calculator.ts -w 400 -d 300 -h 150 --gridfinity --margin 10 --ply 1/2
`);
}

// Parse grid spec like "6x4x3" into {gridX: 6, gridY: 4, gridZ: 3}
function parseGridSpec(spec: string): GridfinitySpec | null {
  const match = spec.match(/^(\d+)x(\d+)x(\d+)$/i);
  if (!match) return null;
  return {
    gridX: parseInt(match[1], 10),
    gridY: parseInt(match[2], 10),
    gridZ: parseInt(match[3], 10)
  };
}

// Main
if (import.meta.main) {
  const args = parse(Deno.args, {
    string: ["width", "depth", "height", "ply", "wall", "tolerance", "output", "baseplate", "grid", "margin"],
    boolean: ["gridfinity", "help", "round-down"],
    alias: {
      w: "width",
      d: "depth",
      h: "height",
      p: "ply",
      g: "gridfinity",
      o: "output"
    },
    default: {
      ply: "3/8",
      wall: "3",
      tolerance: "0.2",
      baseplate: "standard",
      margin: "5"
    }
  });

  // Check for help or valid mode
  const hasDirectDimensions = args.width && args.depth && args.height;
  const hasSizeFirstGridfinity = hasDirectDimensions && args.gridfinity;
  const hasGridSpec = args.grid;

  if (args.help || (!hasDirectDimensions && !hasGridSpec)) {
    printUsage();
    Deno.exit(args.help ? 0 : 1);
  }

  const plyKey = args.ply as string;
  const plyThickness = PLYWOOD[plyKey];
  if (!plyThickness) {
    console.error(`Error: Unknown plywood size '${plyKey}'. Valid: ${Object.keys(PLYWOOD).join(", ")}`);
    Deno.exit(1);
  }

  const baseplateStyle = args.baseplate as "thin" | "standard" | "weighted";
  if (!["thin", "standard", "weighted"].includes(baseplateStyle)) {
    console.error(`Error: Unknown baseplate style '${baseplateStyle}'. Valid: thin, standard, weighted`);
    Deno.exit(1);
  }

  const bracketWall = parseFloat(args.wall as string);
  const tolerance = parseFloat(args.tolerance as string);
  const margin = parseFloat(args.margin as string);

  let config: CaseConfig;
  let sizeFirstResult: SizeResult | null = null;

  if (hasGridSpec) {
    // Gridfinity-first mode: specify exact grid dimensions
    const gridSpec = parseGridSpec(args.grid as string);
    if (!gridSpec) {
      console.error(`Error: Invalid grid format '${args.grid}'. Use XxYxZ format, e.g., 6x4x3`);
      Deno.exit(1);
    }
    gridSpec.marginX = margin;
    gridSpec.marginY = margin;

    const binHeightMM = gridSpec.gridZ * GRIDFINITY.BASE_HEIGHT;
    console.log(`\nGridfinity-first mode: ${gridSpec.gridX}x${gridSpec.gridY} grid, fits ${gridSpec.gridZ}u bins (${binHeightMM}mm + 7mm base)`);

    config = calculateFromGridfinity(gridSpec, plyThickness, bracketWall, tolerance, baseplateStyle);
  } else if (hasSizeFirstGridfinity) {
    // Size-first Gridfinity mode: specify interior dimensions, auto-calculate grid
    const targetWidth = parseFloat(args.width as string);
    const targetDepth = parseFloat(args.depth as string);
    const targetHeight = parseFloat(args.height as string);
    const roundDown = args["round-down"] as boolean;

    const sizeSpec: SizeSpec = {
      targetWidth,
      targetDepth,
      targetHeight,
      minMargin: margin,
      roundDown
    };

    sizeFirstResult = calculateFromSize(sizeSpec, plyThickness, bracketWall, tolerance, baseplateStyle);
    config = sizeFirstResult.config;

    const binHeightMM = sizeFirstResult.gridZ * GRIDFINITY.BASE_HEIGHT;
    const rounding = roundDown ? "down" : "up";
    console.log(`\nSize-first Gridfinity mode: ${targetWidth}x${targetDepth}x${targetHeight}mm target`);
    console.log(`  → ${sizeFirstResult.gridX}x${sizeFirstResult.gridY} grid, ${sizeFirstResult.gridZ}u bins (rounded ${rounding})`);
    console.log(`  Bin height: ${binHeightMM}mm + 7mm base = ${binHeightMM + 7}mm total`);
    console.log(`  Margin: ${sizeFirstResult.actualMarginX.toFixed(1)}mm per side`);
  } else {
    // Direct dimensions mode (no Gridfinity)
    config = {
      interiorWidth: parseFloat(args.width as string),
      interiorDepth: parseFloat(args.depth as string),
      interiorHeight: parseFloat(args.height as string),
      plyThickness,
      bracketWall,
      tolerance,
      useGridfinity: false,
      baseplateStyle
    };
  }

  const calculation = calculateCase(config);

  // If size-first mode, override the gridfinity calculation with our pre-calculated values
  if (sizeFirstResult && calculation.gridfinity) {
    calculation.gridfinity.unitsX = sizeFirstResult.gridX;
    calculation.gridfinity.unitsY = sizeFirstResult.gridY;
    calculation.gridfinity.baseplateWidth = sizeFirstResult.gridX * GRIDFINITY.GRID_PITCH;
    calculation.gridfinity.baseplateDepth = sizeFirstResult.gridY * GRIDFINITY.GRID_PITCH;
    calculation.gridfinity.marginX = sizeFirstResult.actualMarginX * 2;
    calculation.gridfinity.marginY = sizeFirstResult.actualMarginY * 2;
  }

  printReport(calculation);

  if (args.output) {
    const scadContent = generateScadFile(calculation);
    await Deno.writeTextFile(args.output as string, scadContent);
    console.log(`\nOpenSCAD config written to: ${args.output}`);
  }
}
