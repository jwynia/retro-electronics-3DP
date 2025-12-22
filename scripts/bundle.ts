#!/usr/bin/env -S deno run --allow-read --allow-write
/**
 * OpenSCAD Bundler for Makerworld/Customizer Export
 *
 * Bundles a module into a standalone .scad file with:
 * - Customizer-ready parameter annotations
 * - All local dependencies inlined
 * - BOSL2 includes preserved (external dependency)
 *
 * Usage:
 *   deno run --allow-read --allow-write scripts/bundle.ts <input.scad> <module_name> [output.scad]
 *   ./scripts/bundle.ts <input.scad> <module_name> [output.scad]
 *
 * Example:
 *   ./scripts/bundle.ts modules/faces/grille.scad faceplate_grille
 */

import { join, dirname, resolve } from "https://deno.land/std@0.208.0/path/mod.ts";
import { ensureDir } from "https://deno.land/std@0.208.0/fs/mod.ts";

// Patterns for external dependencies (available on Makerworld)
const EXTERNAL_PATTERNS = [/BOSL2\//, /NopSCADlib\//];

function isExternal(path: string): boolean {
  return EXTERNAL_PATTERNS.some((pattern) => pattern.test(path));
}

function extractIncludes(content: string): Array<{ type: string; path: string; line: string }> {
  const pattern = /^(include|use)\s*<([^>]+)>/gm;
  const matches: Array<{ type: string; path: string; line: string }> = [];

  for (const match of content.matchAll(pattern)) {
    matches.push({
      type: match[1],
      path: match[2],
      line: match[0],
    });
  }

  return matches;
}

async function inlineFile(
  filepath: string,
  processed: Set<string> = new Set()
): Promise<{ content: string; externalIncludes: string[] }> {
  const resolvedPath = resolve(filepath);

  if (processed.has(resolvedPath)) {
    return { content: "", externalIncludes: [] };
  }
  processed.add(resolvedPath);

  let content: string;
  try {
    content = await Deno.readTextFile(resolvedPath);
  } catch {
    console.error(`Warning: File not found: ${filepath}`);
    return { content: "", externalIncludes: [] };
  }

  const externalIncludes: string[] = [];
  const includes = extractIncludes(content);

  for (const inc of includes) {
    if (isExternal(inc.path)) {
      externalIncludes.push(inc.line);
      content = content.replace(inc.line, `// [external] ${inc.line}`);
    } else {
      const incPath = join(dirname(resolvedPath), inc.path);
      const inlined = await inlineFile(incPath, processed);
      externalIncludes.push(...inlined.externalIncludes);

      const marker = `\n// === Inlined from: ${inc.path} ===\n`;
      content = content.replace(inc.line, marker + inlined.content + "\n// === End inlined ===\n");
    }
  }

  return { content, externalIncludes };
}

// Customizer templates for each module
const CUSTOMIZER_TEMPLATES: Record<string, string> = {
  faceplate_grille: `
/* [Faceplate Size] */
// Width of faceplate (mm)
width = 100; // [60:200]
// Height of faceplate (mm)
height = 80; // [40:150]
// Thickness (mm)
thickness = 4; // [2:0.5:8]
// Corner radius (mm)
corner_r = 8; // [0:20]

/* [Grille Pattern] */
// Pattern style
pattern = "perf"; // [perf:Circular Holes, slots:Horizontal Slots, vslots:Vertical Slots, hex:Honeycomb, circles:Concentric Circles, diamond:Diamond Grid, sunburst:Sunburst]
// Margin from edges (mm)
grille_margin = 10; // [5:20]

/* [Pattern Settings - Perf/Diamond] */
// Hole diameter (mm)
hole_dia = 4; // [2:0.5:10]
// Hole spacing (mm)
spacing = 6; // [4:15]

/* [Pattern Settings - Slots] */
// Slot width (mm)
slot_width = 40; // [20:80]
// Slot height (mm)
slot_height = 2; // [1:0.5:5]

/* [Pattern Settings - Hex] */
// Hex cell size (mm)
cell_size = 8; // [4:15]
// Hex wall thickness (mm)
hex_wall = 1.5; // [1:0.5:4]

/* [Pattern Settings - Circles] */
// Number of rings
ring_count = 5; // [2:10]
// Ring width (mm)
ring_width = 2; // [1:0.5:5]
// Gap between rings (mm)
ring_gap = 4; // [2:8]

/* [Pattern Settings - Sunburst] */
// Number of rays
ray_count = 12; // [6:24]
// Ray width (mm)
ray_width = 3; // [1:0.5:6]
// Center hole diameter (mm)
center_dia = 10; // [5:20]

/* [Mounting] */
// Include steel disc pockets for magnetic mounting
steel_pockets = true;
// Pocket inset from corners (mm)
steel_inset = 12; // [8:20]

/* [Hidden] */
$fn = 32;

// Render the grille
faceplate_grille(
    size = [width, height],
    thickness = thickness,
    corner_r = corner_r,
    grille_margin = grille_margin,
    pattern = pattern,
    hole_dia = hole_dia,
    spacing = spacing,
    slot_width = slot_width,
    slot_height = slot_height,
    cell_size = cell_size,
    hex_wall = hex_wall,
    ring_count = ring_count,
    ring_width = ring_width,
    ring_gap = ring_gap,
    ray_count = ray_count,
    ray_width = ray_width,
    center_dia = center_dia,
    steel_pockets = steel_pockets,
    steel_inset = steel_inset
);
`,

  shell_wedge: `
/* [Shell Size] */
// Width (mm)
width = 120; // [60:200]
// Height (mm)
height = 80; // [40:150]
// Depth (mm)
depth = 60; // [30:120]

/* [Wedge Style] */
// Taper style
taper_style = "top"; // [top:Narrower at Top, front:Raked Front Face]
// Taper ratio (1.0 = no taper)
taper = 0.7; // [0.4:0.05:1.0]

/* [Shell Properties] */
// Wall thickness (mm)
wall = 3; // [2:0.5:6]
// Corner radius (mm)
corner_r = 10; // [0:20]

/* [Opening] */
// Include front opening
has_opening = true;
// Opening width (mm)
opening_width = 80; // [40:150]
// Opening height (mm)
opening_height = 50; // [30:100]
// Opening corner radius (mm)
opening_r = 5; // [0:15]
// Lip depth for faceplate (mm)
lip_depth = 3; // [0:6]

/* [Hidden] */
$fn = 32;

// Render the shell
shell_wedge(
    size = [width, height, depth],
    taper = taper,
    taper_style = taper_style,
    wall = wall,
    corner_r = corner_r,
    opening = has_opening ? [opening_width, opening_height] : undef,
    opening_r = opening_r,
    lip_depth = lip_depth
);
`,

  shell_monolithic: `
/* [Shell Size] */
// Width (mm)
width = 150; // [60:250]
// Height (mm)
height = 100; // [40:180]
// Depth (mm)
depth = 80; // [30:150]

/* [Shell Properties] */
// Wall thickness (mm)
wall = 3; // [2:0.5:6]
// Corner radius (mm)
corner_r = 12; // [0:25]

/* [Opening] */
// Include front opening
has_opening = true;
// Opening width (mm)
opening_width = 120; // [40:200]
// Opening height (mm)
opening_height = 70; // [30:150]
// Opening corner radius (mm)
opening_r = 5; // [0:15]
// Lip depth for faceplate (mm)
lip_depth = 3; // [0:6]
// Lip inset from edge (mm)
lip_inset = 1.5; // [0:0.5:4]

/* [Hidden] */
$fn = 32;

// Render the shell
shell_monolithic(
    size = [width, height, depth],
    wall = wall,
    corner_r = corner_r,
    opening = has_opening ? [opening_width, opening_height] : undef,
    opening_r = opening_r,
    lip_depth = lip_depth,
    lip_inset = lip_inset
);
`,
};

async function bundleWithTemplate(
  inputFile: string,
  moduleName: string,
  outputFile?: string
): Promise<string> {
  const output = outputFile ?? `exports/${moduleName}_customizer.scad`;

  await ensureDir(dirname(output) || "exports");

  // Inline the module code
  const { content, externalIncludes } = await inlineFile(inputFile);

  // Remove preview blocks
  const cleanedContent = content.replace(/if\s*\(\$preview\)\s*\{[^}]*\}/gs, "");

  // Get template
  const template = CUSTOMIZER_TEMPLATES[moduleName];
  if (!template) {
    console.error(`Warning: No Customizer template for '${moduleName}'. Creating basic export.`);
    const basicOutput = [
      `// ${moduleName} - Exported`,
      "// External dependencies",
      ...new Set(externalIncludes),
      "",
      cleanedContent,
    ].join("\n");

    await Deno.writeTextFile(output, basicOutput);
    console.log(`Created basic export: ${output}`);
    return output;
  }

  // Build output
  const lines = [
    `// ${moduleName.replace(/_/g, " ").replace(/\b\w/g, (c) => c.toUpperCase())} - Customizer Ready`,
    "// Generated by RetroCase bundler",
    "// Parametric retro electronics enclosure",
    "",
    "// External dependencies",
    ...new Set(externalIncludes),
    "",
    template,
    "",
    "// === Module Code ===",
    cleanedContent,
  ];

  await Deno.writeTextFile(output, lines.join("\n"));
  console.log(`Created Customizer-ready export: ${output}`);
  return output;
}

function printUsage(): void {
  console.log(`
OpenSCAD Bundler for Makerworld/Customizer Export

Usage:
  ./scripts/bundle.ts <input.scad> <module_name> [output.scad]

Example:
  ./scripts/bundle.ts modules/faces/grille.scad faceplate_grille

Available module templates:
${Object.keys(CUSTOMIZER_TEMPLATES).map((name) => `  - ${name}`).join("\n")}
`);
}

// Main
if (import.meta.main) {
  const args = Deno.args;

  if (args.length < 2) {
    printUsage();
    Deno.exit(1);
  }

  const [inputFile, moduleName, outputFile] = args;

  try {
    await Deno.stat(inputFile);
  } catch {
    console.error(`Error: Input file not found: ${inputFile}`);
    Deno.exit(1);
  }

  await bundleWithTemplate(inputFile, moduleName, outputFile);
}
