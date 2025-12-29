// 19-font-sampler.scad
// Font sampler for Googie sign text
// Shows installed fonts that work well for retro signage

$parent_modules = true;

// === CONFIGURATION ===
SAMPLE_TEXT = "CAFE";
TEXT_SIZE = 20;
TEXT_DEPTH = 4;
ROW_SPACING = 35;

// Fonts to sample (installed on system)
FONTS = [
    // Google Fonts - Googie/Retro style
    ["Atomic Age", "Atomic Age"],
    ["Bungee", "Bungee"],
    ["Pacifico", "Pacifico"],
    ["Fascinate", "Fascinate"],
    // System fonts
    ["Futura", "Futura Medium"],
    ["Futura Bold", "Futura Bold"],
    ["Arial Black", "Arial Black"],
    ["Impact", "Impact"],
    ["SignPainter", "SignPainter-HouseScript"],
    ["Arial Rounded", "Arial Rounded MT Bold"],
];

// === LAYOUT ===
COLS = 2;
COL_WIDTH = 140;
ROWS = ceil(len(FONTS) / COLS);

// Center the layout
SCENE_WIDTH = (COLS - 1) * COL_WIDTH;
SCENE_HEIGHT = (ROWS - 1) * ROW_SPACING;
CENTER_X = -SCENE_WIDTH / 2;
CENTER_Y = SCENE_HEIGHT / 2;  // Start from top

// === RENDER FONT SAMPLES ===
translate([CENTER_X, CENTER_Y, 0]) {
    for (i = [0 : len(FONTS) - 1]) {
        col = i % COLS;
        row = floor(i / COLS);

        font_label = FONTS[i][0];
        font_name = FONTS[i][1];

        translate([col * COL_WIDTH, -row * ROW_SPACING, 0]) {
            // Font label (small)
            color("Gray")
            translate([0, 12, 0])
            linear_extrude(height = 1)
            text(font_label, size = 6, font = "Helvetica");

            // Sample text in the font
            color("Coral")
            linear_extrude(height = TEXT_DEPTH)
            text(SAMPLE_TEXT, size = TEXT_SIZE, font = font_name, halign = "left");
        }
    }
}

// === ADDITIONAL SAMPLES WITH DIFFERENT WORDS ===
// Show how the new Googie fonts look with sign words

translate([0, -ROWS * ROW_SPACING - 50, 0]) {
    // Centered title
    color("DimGray")
    translate([0, 35, 0])
    linear_extrude(height = 1)
    text("Sample Sign Words in Atomic Age", size = 7, font = "Helvetica", halign = "center");

    // Row of different words in Atomic Age
    words = ["DINER", "MOTEL", "EAT", "OPEN"];
    word_spacing = 75;

    translate([-(len(words) - 1) * word_spacing / 2, 0, 0])
    for (i = [0 : len(words) - 1]) {
        translate([i * word_spacing, 0, 0])
        color("Gold")
        linear_extrude(height = TEXT_DEPTH)
        text(words[i], size = 14, font = "Atomic Age", halign = "center");
    }

    // Second row in Bungee
    translate([0, -35, 0]) {
        color("DimGray")
        translate([0, 35, 0])
        linear_extrude(height = 1)
        text("Sample Sign Words in Bungee", size = 7, font = "Helvetica", halign = "center");

        translate([-(len(words) - 1) * word_spacing / 2, 0, 0])
        for (i = [0 : len(words) - 1]) {
            translate([i * word_spacing, 0, 0])
            color("Coral")
            linear_extrude(height = TEXT_DEPTH)
            text(words[i], size = 14, font = "Bungee", halign = "center");
        }
    }
}
