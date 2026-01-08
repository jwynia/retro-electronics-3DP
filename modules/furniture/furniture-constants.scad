// Furniture Constants
// Scale system, real-world dimensions, and style definitions for mini-furniture domain.

// ========================================
// SCALE SYSTEM
// ========================================

// Global scale factor (1:N). Override in your file before including modules.
// Common scales:
//   1:12 - Standard dollhouse scale (1" = 1')
//   1:24 - Half-inch scale (1/2" = 1')
//   1:48 - Quarter-inch scale (1/4" = 1')
FURNITURE_SCALE = 24;  // Default 1:24

// Scale helper function
// Converts real-world mm to scaled mm
function scale_dim(real_mm, scale=FURNITURE_SCALE) = real_mm / scale;

// Scale a 2D array [x, y]
function scale_dim2(real_mm, scale=FURNITURE_SCALE) = [real_mm[0] / scale, real_mm[1] / scale];

// Scale a 3D array [x, y, z]
function scale_dim3(real_mm, scale=FURNITURE_SCALE) = [real_mm[0] / scale, real_mm[1] / scale, real_mm[2] / scale];

// ========================================
// STYLE DEFINITIONS
// ========================================

// Style constants
STYLE_RETRO = "retro";    // Mid-century modern, atomic age
STYLE_MODERN = "modern";  // Generic contemporary

// ========================================
// BED DIMENSIONS (mattress only, real mm)
// Source: Standard US mattress sizes
// ========================================
_BED_TWIN      = [965, 1905];      // 38" x 75"
_BED_TWIN_XL   = [965, 2032];      // 38" x 80"
_BED_FULL      = [1372, 1905];     // 54" x 75"
_BED_QUEEN     = [1524, 2032];     // 60" x 80"
_BED_KING      = [1930, 2032];     // 76" x 80"
_BED_CAL_KING  = [1829, 2133];     // 72" x 84"

// Bed frame additions
_BED_FRAME_MARGIN = 50;            // Frame extends 50mm beyond mattress each side
_BED_FRAME_HEIGHT = 350;           // Platform/frame height ~14"
_HEADBOARD_HEIGHT = 1000;          // Headboard height ~40"
_HEADBOARD_THICK = 50;             // Headboard thickness

// Function to get bed mattress size by name
function bed_mattress_size(mattress) =
    mattress == "twin" ? _BED_TWIN :
    mattress == "twin_xl" ? _BED_TWIN_XL :
    mattress == "full" ? _BED_FULL :
    mattress == "queen" ? _BED_QUEEN :
    mattress == "king" ? _BED_KING :
    mattress == "cal_king" ? _BED_CAL_KING :
    _BED_QUEEN;  // Default to queen

// ========================================
// SEATING DIMENSIONS (real mm)
// ========================================

// Sofa dimensions
_SOFA_SEAT_WIDTH = 550;            // Per-seat cushion width ~22"
_SOFA_SEAT_DEPTH = 550;            // Seat depth ~22"
_SOFA_SEAT_HEIGHT = 450;           // Seat height from floor ~18"
_SOFA_BACK_HEIGHT = 850;           // Total back height ~34"
_SOFA_ARM_WIDTH = 150;             // Arm width ~6"
_SOFA_ARM_HEIGHT = 600;            // Arm height ~24"

// Function to calculate sofa width based on seats
function sofa_width(seats, arm_width=_SOFA_ARM_WIDTH, seat_width=_SOFA_SEAT_WIDTH) =
    (seats * seat_width) + (arm_width * 2);

// Armchair dimensions (single seat with arms)
_ARMCHAIR_WIDTH = 850;             // Overall width ~34"
_ARMCHAIR_DEPTH = 850;             // Overall depth ~34"
_ARMCHAIR_HEIGHT = 850;            // Overall height ~34"
_ARMCHAIR_SEAT_HEIGHT = 450;       // Seat height ~18"

// Dining chair dimensions
_DINING_CHAIR_WIDTH = 450;         // Width ~18"
_DINING_CHAIR_DEPTH = 500;         // Depth ~20"
_DINING_CHAIR_HEIGHT = 900;        // Total height ~36"
_DINING_CHAIR_SEAT_HEIGHT = 450;   // Seat height ~18"

// Office chair dimensions
_OFFICE_CHAIR_WIDTH = 600;         // Width ~24"
_OFFICE_CHAIR_DEPTH = 600;         // Depth ~24"
_OFFICE_CHAIR_HEIGHT = 1000;       // Max height ~40"
_OFFICE_CHAIR_SEAT_HEIGHT = 450;   // Seat height ~18"

// ========================================
// TABLE DIMENSIONS (real mm)
// ========================================

// Coffee table
_COFFEE_TABLE_WIDTH = 1200;        // Width ~48"
_COFFEE_TABLE_DEPTH = 600;         // Depth ~24"
_COFFEE_TABLE_HEIGHT = 450;        // Height ~18"

// End table / side table
_END_TABLE_WIDTH = 500;            // Width ~20"
_END_TABLE_DEPTH = 500;            // Depth ~20"
_END_TABLE_HEIGHT = 550;           // Height ~22"

// Nightstand
_NIGHTSTAND_WIDTH = 500;           // Width ~20"
_NIGHTSTAND_DEPTH = 400;           // Depth ~16"
_NIGHTSTAND_HEIGHT = 600;          // Height ~24"

// Dining table (rectangular, seats 6)
_DINING_TABLE_WIDTH = 1800;        // Width ~72" (seats 6)
_DINING_TABLE_DEPTH = 900;         // Depth ~36"
_DINING_TABLE_HEIGHT = 750;        // Height ~30"

// Dining table (round, seats 4)
_DINING_TABLE_ROUND_DIA = 1200;    // Diameter ~48"

// Desk
_DESK_WIDTH = 1500;                // Width ~60"
_DESK_DEPTH = 750;                 // Depth ~30"
_DESK_HEIGHT = 750;                // Height ~30"

// ========================================
// STORAGE DIMENSIONS (real mm)
// ========================================

// Dresser (6-drawer)
_DRESSER_WIDTH = 1500;             // Width ~60"
_DRESSER_DEPTH = 500;              // Depth ~20"
_DRESSER_HEIGHT = 900;             // Height ~36"
_DRAWER_HEIGHT = 150;              // Per drawer ~6"

// Bookcase (standard 5-shelf)
_BOOKCASE_WIDTH = 900;             // Width ~36"
_BOOKCASE_DEPTH = 300;             // Depth ~12"
_BOOKCASE_HEIGHT = 1800;           // Height ~72"
_SHELF_HEIGHT = 300;               // Per shelf spacing ~12"

// Wardrobe / armoire
_WARDROBE_WIDTH = 1200;            // Width ~48"
_WARDROBE_DEPTH = 600;             // Depth ~24"
_WARDROBE_HEIGHT = 2000;           // Height ~80"

// TV stand
_TV_STAND_WIDTH = 1500;            // Width ~60"
_TV_STAND_DEPTH = 450;             // Depth ~18"
_TV_STAND_HEIGHT = 500;            // Height ~20"

// ========================================
// APPLIANCE DIMENSIONS (real mm)
// ========================================

// Refrigerator (standard)
_FRIDGE_WIDTH = 900;               // Width ~36"
_FRIDGE_DEPTH = 750;               // Depth ~30"
_FRIDGE_HEIGHT = 1750;             // Height ~69"

// Stove/Range
_STOVE_WIDTH = 750;                // Width ~30"
_STOVE_DEPTH = 650;                // Depth ~26"
_STOVE_HEIGHT = 900;               // Height ~36"

// Dishwasher
_DISHWASHER_WIDTH = 600;           // Width ~24"
_DISHWASHER_DEPTH = 600;           // Depth ~24"
_DISHWASHER_HEIGHT = 850;          // Height ~34"

// Counter section
_COUNTER_DEPTH = 600;              // Standard depth ~24"
_COUNTER_HEIGHT = 900;             // Standard height ~36"
_COUNTER_SECTION_WIDTH = 600;      // Per section ~24"

// ========================================
// BATHROOM DIMENSIONS (real mm)
// ========================================

// Bathtub (standard)
_BATHTUB_WIDTH = 750;              // Width ~30"
_BATHTUB_LENGTH = 1500;            // Length ~60"
_BATHTUB_HEIGHT = 400;             // Height ~16"

// Toilet
_TOILET_WIDTH = 400;               // Width ~16"
_TOILET_DEPTH = 700;               // Depth ~28"
_TOILET_HEIGHT = 400;              // Bowl height ~16"
_TOILET_TANK_HEIGHT = 750;         // Total with tank ~30"

// Vanity (single sink)
_VANITY_WIDTH = 900;               // Width ~36"
_VANITY_DEPTH = 550;               // Depth ~22"
_VANITY_HEIGHT = 850;              // Height ~34"

// ========================================
// LEG DIMENSIONS (real mm)
// ========================================

// Tapered leg (retro style)
_LEG_TAPERED_TOP_DIA = 50;         // Top diameter
_LEG_TAPERED_BOT_DIA = 25;         // Bottom diameter
_LEG_TAPERED_HEIGHT = 150;         // Standard height ~6"

// Block leg (modern style)
_LEG_BLOCK_SIZE = 50;              // Square leg size
_LEG_BLOCK_HEIGHT = 100;           // Height ~4"

// Hairpin leg
_LEG_HAIRPIN_DIA = 10;             // Rod diameter
_LEG_HAIRPIN_HEIGHT = 400;         // Height ~16"

// ========================================
// MATERIAL THICKNESSES (real mm)
// ========================================
_PANEL_THICK = 20;                 // Standard panel ~3/4"
_CUSHION_THICK = 100;              // Cushion thickness ~4"
_TABLETOP_THICK = 25;              // Tabletop ~1"

// ========================================
// PREVIEW COLORS
// ========================================
_COLOR_WOOD_LIGHT = "BurlyWood";
_COLOR_WOOD_DARK = "SaddleBrown";
_COLOR_WOOD_WALNUT = "Sienna";
_COLOR_FABRIC_GRAY = "SlateGray";
_COLOR_FABRIC_BLUE = "SteelBlue";
_COLOR_FABRIC_GREEN = "DarkOliveGreen";
_COLOR_METAL = "Silver";
_COLOR_APPLIANCE_WHITE = "WhiteSmoke";
_COLOR_APPLIANCE_STEEL = "LightSlateGray";
