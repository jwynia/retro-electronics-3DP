// Customizable jar
//
// Author: https://makerworld.com/en/@Fletch16
//
// Copyright (c) 2025
//
// License: 
// Standard Digital File License 
//
// This work is granted under a Standard Digital File License,
// permitting digital files for strict non-commercial, personal
// use only. You are prohibited from sharing, sub-licensing,
// selling, renting, hosting, transferring, or distributing the
// digital file, 3D printed versions, or any other derivative
// works of this object in any digital or physical format,
// including remixes of this object. Hosting these files on
// other digital platforms, web stores, or cloud repositories
// is not allowed. Unauthorized use of the objects in any form
// that involves charging money or collecting fees is strictly
// forbidden.

// Parameters
//Models to create
Models_To_Create = "Jar + Lid";     // [Jar + Lid, Jar Only, Lid Only]
//How many plates to use when downloading 3mf. This will split the jar and lid for multicolor or large prints. NOTE: Second plate ignored if models to create is not Jar + Lid
//3MF_Export_Type = "1 Plate";        // [1 Plate, 2 Plates]
//Color picker based on Bambu PLA. When exporting 3mf, this color will be set.
Jar_Color = "Matte Desert Tan";     // [Bambu Green, Beige, Black, Blue, Blue Gray, Bright Green, Bronze, Brown, Cobalt Blue, Cocoa Brown, Cyan, Dark Gray, Gold, Gray, Jade White, Hot Pink, Indigo Purple, Light Gray, Magenta, Maroon Red, Mistletoe Green, Orange, Pink, Pumpkin Orange, Purple, Red, Silver, Sunflower Yellow, Turquoise, Yellow, Matte Apple Green, Matte Ash Gray, Matte Bone White, Matte Caramel, Matte Charcoal, Matte Dark Blue, Matte Dark Brown, Matte Dark Chocolate, Matte Dark Green, Matte Dark Red, Matte Desert Tan, Matte Grass Green, Matte Ice Blue, Matte Ivory White, Matte Latte Brown, Matte Lemon Yellow, Matte Lilac Purple, Matte Mandarin Orange, Matte Marine Blue, Matte Nardo Gray, Matte Plum, Matte Sakura Pink, Matte Scarlet Red, Matte Sky Blue, Matte Terracotta]
Lid_Color = "Cocoa Brown";          // [Bambu Green, Beige, Black, Blue, Blue Gray, Bright Green, Bronze, Brown, Cobalt Blue, Cocoa Brown, Cyan, Dark Gray, Gold, Gray, Jade White, Hot Pink, Indigo Purple, Light Gray, Magenta, Maroon Red, Mistletoe Green, Orange, Pink, Pumpkin Orange, Purple, Red, Silver, Sunflower Yellow, Turquoise, Yellow, Matte Apple Green, Matte Ash Gray, Matte Bone White, Matte Caramel, Matte Charcoal, Matte Dark Blue, Matte Dark Brown, Matte Dark Chocolate, Matte Dark Green, Matte Dark Red, Matte Desert Tan, Matte Grass Green, Matte Ice Blue, Matte Ivory White, Matte Latte Brown, Matte Lemon Yellow, Matte Lilac Purple, Matte Mandarin Orange, Matte Marine Blue, Matte Nardo Gray, Matte Plum, Matte Sakura Pink, Matte Scarlet Red, Matte Sky Blue, Matte Terracotta]

/* [Jar Settings] */

//The height of the jar
Jar_Height = 80;                    // [25:160]
//The diameter of the jar
Jar_Diameter = 60;                  // [25:160]
//Jar wall thickness
Wall_Thickness = 2.0;               // [1.6:0.4:4]
//The pitch of the jar threads
Thread_Pitch = 2.8;                 // [1:0.1:4]
//Pattern to use on the jar
Pattern = "swirls small";           // [none, arrows, arrows small, bricks, bricks small, checkers, cubes, dash, dash small, diamonds, hexagons, hills, hoops, hoops small, octogons, pills, pyramids, repeat x, ribs, ribs small, slash, squares, swirls, swirls small, triangles, zigzags, zigzags small]

/* [Lid Settings] */
Lid_Pattern = "ribs";               // [none, arrows right, arrows left, diamonds, hexagons, ribs, ribs small, rectangles, slash, octagons, repeat x, tread, triangles]
//Depth of the pattern, larger values may be more difficult to print. NOTE: When embed is false, a large depth value may create overhangs.
Lid_Pattern_Depth = 0.4;            // [0.4:0.1:0.8]
//The height of the lid
Lid_Height = 10.4;                  // [10:0.2:16]
//The offset between the jar diameter and lid diameter.
Lid_Tolerance = 0.1;                // [0:0.1:1]

/* [Texture Settings] */ 

//Embed the pattern into the jar.
Pattern_Embed = true;
//Depth of the pattern, larger values may be more difficult to print. NOTE: When embed is false, a large depth value may create overhangs.
Pattern_Depth = 0.8;                // [0.6:0.1:1.2]
//The top and bottom taper of the pattern. This will make the top and bottom look better/worse depending on the pattern.
Pattern_Taper = 20;                   // [0:5:40]

include <BOSL2/std.scad>
include <BOSL2/threading.scad>

/* Hidden */
$fn=200;

function computeCustomPattern(pattern) = [
    for(row = pattern) [
        for(el = row)
            el * Pattern_Depth
    ]
];

function computeCustomPatternWithDepth(pattern, depth) = [
    for(row = pattern) [
        for(el = row)
            el * depth
    ]
];

module createStyledPatternedCyl(tex, texSize, texStyle, patternDepth)
    cyl(d=Jar_Diameter, h=Jar_Height, anchor=BOTTOM, texture=tex, tex_size=texSize, tex_depth=patternDepth, tex_taper=Pattern_Taper, style=texStyle, rounding1=Jar_Diameter / 7, teardrop=true);

module createPatternedCyl(tex, texSize, patternDepth)
    cyl(d=Jar_Diameter, h=Jar_Height, anchor=BOTTOM, texture=tex, tex_size=texSize, tex_depth=patternDepth, tex_taper=Pattern_Taper, rounding1=Jar_Diameter / 7, teardrop=true, $fn=200);

module createRotatedPatternedCyl(tex, texSize, patternDepth, rot)
    cyl(d=Jar_Diameter, h=Jar_Height, anchor=BOTTOM, texture=tex, tex_size=texSize, tex_depth=patternDepth, tex_taper=Pattern_Taper, tex_rot=rot, rounding1=Jar_Diameter / 7, teardrop=true);

module getTexturedCyl() {
    patternDepth = Pattern_Embed == true ? -Pattern_Depth : Pattern_Depth;
    if (Pattern == "none" || Pattern == "text") {
        cyl(d=Jar_Diameter, h=Jar_Height, rounding1=Jar_Diameter / 7, anchor=BOTTOM, teardrop=true);
    } else if (Pattern == "hills") {
        texSize = Jar_Height + Jar_Diameter > 150 ? [20,20] : [10,10];
        cyl(d=Jar_Diameter, h=Jar_Height, rounding1=Jar_Diameter / 7, anchor=BOTTOM, teardrop=true, texture=texture(Pattern, n=24), tex_size=texSize, tex_depth=Pattern_Depth, tex_taper=Pattern_Taper);
    } else if (Pattern == "cubes") {
        cyl(d=Jar_Diameter, h=Jar_Height, rounding1=Jar_Diameter / 7, anchor=BOTTOM, teardrop=true, texture=texture(Pattern), tex_size=[10,10], tex_depth=Pattern_Depth, tex_taper=Pattern_Taper, tex_samples=24);
    } else if (Pattern == "ribs") {
        tex = computeCustomPattern(ribPattern);
        createPatternedCyl(tex, [8,8], patternDepth);
    } else if (Pattern == "ribs small") {
        tex = computeCustomPattern(ribSmallPattern);
        createPatternedCyl(tex, [4,8], patternDepth);
    } else if (Pattern == "slash") {
        tex = computeCustomPattern(slashPattern);
        createStyledPatternedCyl(tex, [18,6], "default", patternDepth);
    } else if (Pattern == "octogons") {
        tex = computeCustomPattern(octoPattern);
        createPatternedCyl(tex, [8,10], patternDepth);
    } else if (Pattern == "hoops") {
        tex = computeCustomPattern(ribPattern);
        createRotatedPatternedCyl(tex, [10,10], patternDepth, 90);
    } else if (Pattern == "hoops small") {
        tex = computeCustomPattern(ribPattern);
        createRotatedPatternedCyl(tex, [5,5], patternDepth, 90);
    } else if (Pattern == "pills") {
        tex = computeCustomPattern(pillPattern);
        createPatternedCyl(tex, [10,10], patternDepth);
    } else if (Pattern == "dash") {
        tex = computeCustomPattern(pillPattern);
        createRotatedPatternedCyl(tex, [10,10], patternDepth, 90);
    } else if (Pattern == "dash small") {
        tex = computeCustomPattern(pillPattern);
        createRotatedPatternedCyl(tex, [7,7], patternDepth, 90);
    } else if (Pattern == "hexagons") {
        tex = computeCustomPattern(hexPattern);
        createPatternedCyl(tex, [12,8], patternDepth);
    } else if (Pattern == "diamonds") {
        tex = computeCustomPattern(diamondPattern);
        createPatternedCyl(tex, [10,10], patternDepth);
    } else if (Pattern == "bricks") {
        tex = computeCustomPattern(bricksPattern);
        createStyledPatternedCyl(tex, [10,10], "default", patternDepth);
    } else if (Pattern == "bricks small") {
        tex = computeCustomPattern(bricksPattern);
        createStyledPatternedCyl(tex, [7,7], "default", patternDepth);
    } else if (Pattern == "swirls") {
        tex = computeCustomPattern(swirlPattern);
        createStyledPatternedCyl(tex, [10,10], "default", patternDepth);
    } else if (Pattern == "swirls small") {
        tex = computeCustomPattern(swirlPattern);
        createStyledPatternedCyl(tex, [6,6], "default", patternDepth);
    } else if (Pattern == "zigzags") {
        tex = computeCustomPattern(zigzagPattern);
        createPatternedCyl(tex, [10,10], patternDepth);
    } else if (Pattern == "zigzags small") {
        tex = computeCustomPattern(zigzagPattern);
        createPatternedCyl(tex, [7,7], patternDepth);
    } else if (Pattern == "arrows") {
        tex = computeCustomPattern(arrowsPattern);
        createPatternedCyl(tex, [10,20], patternDepth);
    } else if (Pattern == "arrows small") {
        tex = computeCustomPattern(arrowsPattern);
        createPatternedCyl(tex, [7,14], patternDepth);
    } else if (Pattern == "checkers") {
        cyl(d=Jar_Diameter, h=Jar_Height, rounding1=Jar_Diameter / 7, anchor=BOTTOM, teardrop=true, texture=texture("checkers"), tex_size=[10,10], tex_depth=patternDepth, tex_taper=Pattern_Taper, style="convex");
    } else if (Pattern == "squares") {
        tex = computeCustomPattern(squaresPattern);
        texStyle = Pattern_Embed == true ? "concave" : "convex";
        createStyledPatternedCyl(tex, [10,10], texStyle, patternDepth);
    } else if (Pattern == "triangles") {
        tex = computeCustomPattern(trianglesPattern);
        createPatternedCyl(tex, [14,10], patternDepth);
    } else if (Pattern == "pyramids") {
        tex = computeCustomPatternWithDepth(pyramidsPattern, Pattern_Depth / 3);
        texStyle = Pattern_Embed == true ? "concave" : "convex";
        createStyledPatternedCyl(tex, [10,10], texStyle, patternDepth);
    } else if (Pattern == "repeat x") {
        tex = computeCustomPattern(xPattern);
        createPatternedCyl(tex, [10,10], patternDepth);
    }
}

module createJar() {
    lipHeight = 5;
    lipOffset = 2;
    threadHeight = Lid_Height - 2;
    wallOffset = 0.8 + Pattern_Depth;
    innerDiameter = Jar_Diameter - (Wall_Thickness * 2) - wallOffset;

    getBambuColor(Jar_Color) {
        difference() {
            getTexturedCyl();

            translate([0,0,Wall_Thickness])
                cyl(d=innerDiameter, h=Jar_Height, rounding1=Jar_Diameter / 7, anchor=BOTTOM);

        }

        translate([0, 0, Jar_Height - lipOffset]) {
            difference() {
                cyl(h=lipHeight, d=Jar_Diameter + 4, rounding1=3, rounding2=2, anchor=BOTTOM, teardrop=true);
                cyl(h=lipHeight, d=innerDiameter, anchor=BOTTOM);
            }
        }

        translate([0,0, Jar_Height + lipHeight - lipOffset]) {
            difference() {
                threaded_rod(d=Jar_Diameter, l=threadHeight, pitch=Thread_Pitch, internal=false, end_len1=0.6, anchor=BOTTOM);

                cyl(h=threadHeight, d=innerDiameter, anchor=BOTTOM);
            }
        }
    }
}

module createLidCyl(tex) {
    createLidCyl(tex, "min_edge");
}

// d=Jar_Diameter + 5
module createLidCyl(tex, texStyle) {
    cyl(h=Lid_Height, d=Jar_Diameter + 3, rounding1=2.4, texture=tex, tex_size=[10, Lid_Height], tex_depth=Lid_Pattern_Depth, tex_taper=10, anchor=BOTTOM, teardrop=true, tex_style=texStyle);
}

module getLidCyl() {
    if (Lid_Pattern == "none") {
        createLidCyl(undef);
    } else if (Lid_Pattern == "arrows right") {
        createLidCyl(lidArrowsRightPattern);
    } else if (Lid_Pattern == "arrows left") {
        createLidCyl(lidArrowsLeftPattern);
    } else if (Lid_Pattern == "diamonds") {
        createLidCyl(lidDiamondsPattern);
    } else if (Lid_Pattern == "ribs") {
        createLidCyl(lidRibPattern, "convex");
    } else if (Lid_Pattern == "ribs small") {
        cyl(h=Lid_Height, d=Jar_Diameter + 3, rounding1=2.4, texture=lidRibPattern, tex_size=[5, Lid_Height], tex_depth=0.4, tex_taper=10, anchor=BOTTOM, teardrop=true, tex_style="convex");
    } else if (Lid_Pattern == "octagons") {
        createLidCyl(lidOctoPattern);
    } else if (Lid_Pattern == "rectangles") {
        createLidCyl(lidRectPattern, "convex");
    } else if (Lid_Pattern == "slash") {
        createLidCyl(lidSlashPattern, "default");
    } else if (Lid_Pattern == "triangles") {
        createLidCyl(lidTrianglesPattern);
    } else if (Lid_Pattern == "tread") {
        createLidCyl(lidTreadPattern);
    } else if (Lid_Pattern == "repeat x") {
        createLidCyl(lidXPattern);
    } else if (Lid_Pattern == "hexagons") {
        createLidCyl(lidHexPattern);
    }
}

module createLid() {
    getBambuColor(Lid_Color) {
        difference() {
            getLidCyl();

            // d=Jar_Diameter + Lid_Tolerance + 3
            translate([0,0,2.4])
                threaded_rod(d=Jar_Diameter + Lid_Tolerance + 1, l=Lid_Height - 2.4, pitch=Thread_Pitch, internal=true, anchor=BOTTOM, end_len2=0.2);
        }
    }
}

// module dmw_plate_1() {
//     if (3MF_Export_Type == "2 Plates") {
//         createJar();
//     } else if (Models_To_Create == "Jar Only") {
//         createJar();
//     } else {
//         if (Models_To_Create == "Jar + Lid") {
//             createJar();

//             translate([0,Jar_Diameter + 10, 0])
//                 createLid();
//         } else if (Models_To_Create == "Lid Only") {
//             createLid();
//         }
//     }
// }

// module dmw_plate_2() {
//     if (Models_To_Create == "Jar + Lid" && 3MF_Export_Type == "2 Plates") {
//         createLid();
//     }
// }

// module dmw_assembly_view() {
//     mw_plate_1();
//     translate([0,Jar_Diameter + 10, 0]) mw_plate_2();
// }

// For STL, coment out and prepend a char to the 3 modules directly above (dmw_plate_1, dmw_plate_2, dmw_assembly_view). Uncomment below.
if (Models_To_Create == "Jar Only") {
    createJar();
} else if (Models_To_Create == "Lid Only") {
    createLid();
} else {
    posOffset = (Jar_Diameter + 10) / 2;
    translate([0,posOffset, 0])
        createJar();

    translate([0,-posOffset, 0])
        createLid();
}

// ----------------------------
//      Bambu PLA Colors
// ----------------------------

module getBambuColor(c) {
    if (c == "Jade White") {
        color("#FFFFFF")
            children();
    } else if (c == "Beige") {
        color("#F7E6DE")
            children();
    } else if (c == "Gold") {
        color("#E4BD68")
            children();
    } else if (c == "Silver") {
        color("#A6A9AA")
            children();
    } else if (c == "Gray") {
        color("#8E9089")
            children();
    } else if (c == "Brown") {
        color("#9D432C")
            children();
    } else if (c == "Cocoa Brown") {
        color("#6F5034")
            children();
    } else if (c == "Red") {
        color("#C12E1F")
            children();
    } else if (c == "Orange") {
        color("#FF6A13")
            children();
    } else if (c == "Sunflower Yellow") {
        color("#FEC600")
            children();
    } else if (c == "Bambu Green") {
        color("#00AE42")
            children();
    } else if (c == "Mistletoe Green") {
        color("#3F8E43")
            children();
    } else if (c == "Cyan") {
        color("#0086D6")
            children();
    } else if (c == "Blue") {
        color("#0A2989")
            children();
    } else if (c == "Purple") {
        color("#5E43B7")
            children();
    } else if (c == "Blue Gray") {
        color("#5B6579")
            children();
    } else if (c == "Light Gray") {
        color("#D1D3D5")
            children();
    } else if (c == "Dark Gray") {
        color("#545454")
            children();
    } else if (c == "Black") {
        color("#000000")
            children();
    } else if (c == "Yellow") {
        color("#F4EE2A")
            children();
    } else if (c == "Pink") {
        color("#F55A74")
            children();
    } else if (c == "Bright Green") {
        color("#BECF00")
            children();
    } else if (c == "Bronze") {
        color("#847D48")
            children();
    } else if (c == "Pumpkin Orange") {
        color("#FF9016")
            children();
    } else if (c == "Magenta") {
        color("#EC008C")
            children();
    } else if (c == "Indigo Purple") {
        color("#482960")
            children();
    }  else if (c == "Maroon Red") {
        color("#9D2235")
            children();
    }  else if (c == "Hot Pink") {
        color("#F5547C")
            children();
    }  else if (c == "Turquoise") {
        color("#00B1B7")
            children();
    }  else if (c == "Cobalt Blue") {
        color("#0056B8")
            children();
    } else if (c == "Matte Latte Brown") {
        color("#D3B7A7")
            children();
    } else if (c == "Matte Bone White") {
        color("#CBC6B8")
            children();
    } else if (c == "Matte Ice Blue") {
        color("#A3D8E1")
            children();
    } else if (c == "Matte Grass Green") {
        color("#61C680")
            children();
    } else if (c == "Matte Ash Gray") {
        color("#9B9EA0")
            children();
    } else if (c == "Matte Mandarin Orange") {
        color("#F99963")
            children();
    } else if (c == "Matte Desert Tan") {
        color("#E8DBB7")
            children();
    } else if (c == "Matte Ivory White") {
        color("#FFFFFF")
            children();
    } else if (c == "Matte Caramel") {
        color("#AE835B")
            children();
    } else if (c == "Matte Terracotta") {
        color("#B15533")
            children();
    } else if (c == "Matte Nardo Gray") {
        color("#757575")
            children();
    } else if (c == "Matte Lilac Purple") {
        color("#AE96D4")
            children();
    } else if (c == "Matte Sakura Pink") {
        color("#E8AFCF")
            children();
    } else if (c == "Matte Plum") {
        color("#950051")
            children();
    } else if (c == "Matte Lemon Yellow") {
        color("#F7D959")
            children();
    } else if (c == "Matte Scarlet Red") {
        color("#DE4343")
            children();
    } else if (c == "Matte Dark Red") {
        color("#BB3D43")
            children();
    } else if (c == "Matte Dark Brown") {
        color("#7D6556")
            children();
    } else if (c == "Matte Dark Chocolate") {
        color("#4D3324")
            children();
    } else if (c == "Matte Dark Green") {
        color("#68724D")
            children();
    } else if (c == "Matte Apple Green") {
        color("#C2E189")
            children();
    } else if (c == "Matte Sky Blue") {
        color("#56B7E6")
            children();
    } else if (c == "Matte Marine Blue") {
        color("#0078BF")
            children();
    } else if (c == "Matte Dark Blue") {
        color("#042F56")
            children();
    } else if (c == "Matte Charcoal") {
        color("#000000")
            children();
    }
}

// ----------------------------
//        Jar Patterns
// ----------------------------

ribPattern = [
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,1,1,1,1]
];

ribSmallPattern = [
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1]
];

slashPattern = [
    [1,0,0,0,1,1,1,1,0,0,0,1,1,1],
    [1,1,0,0,0,1,1,1,1,0,0,0,1,1],
    [1,1,1,0,0,0,1,1,1,1,0,0,0,1],
    [1,1,1,1,0,0,0,1,1,1,1,0,0,0]
];

swirlPattern = [
    [0,0,1,1,1,1,0,0],
    [0,0,0,1,1,1,1,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,1,1,1,1,0,0,0],
];

octoPattern = [
    [0,0,0,1,1,1,1,0,0,0],
    [0,0,1,1,1,1,1,1,0,0],
    [0,1,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,1,0],
    [0,0,1,1,1,1,1,1,0,0],
    [0,0,0,1,1,1,1,0,0,0],
    [1,1,0,0,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1,1,1],
    [1,1,1,1,0,0,1,1,1,1],
    [1,1,1,1,0,0,1,1,1,1],
    [1,1,1,1,0,0,1,1,1,1],
    [1,1,1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,0,0,1,1]
];

hexPattern = [
    [1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,1],
    [1,1,0,0,0,1,1,1,1,1,1,0,0,0,1,1],
    [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
    [0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
    [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
    [1,1,0,0,0,1,1,1,1,1,1,0,0,0,1,1],
    [1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,1],
    [1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1],
    [1,1,1,1,1,0,0,0,0,0,0,1,1,1,1,1],
    [1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1]
];

pillPattern = [
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,0,0],
    [0,0,1,1,0,0,0,0],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,0,0,0,0,1,1],
    [0,0,0,0,0,0,1,1]
];

diamondPattern = [
    [1,1,0,0,1,0,0,1],
    [1,0,0,1,1,1,0,0],
    [0,0,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1],
    [0,0,1,1,1,1,1,0],
    [1,0,0,1,1,1,0,0],
    [1,1,0,0,1,0,0,1],
    [1,1,1,0,0,0,1,1],
    [1,1,1,1,0,1,1,1],
    [1,1,1,0,0,0,1,1]
];

bricksPattern = [
    [0,0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [1,1,1,1,0,0,1,1,1],
    [1,1,1,1,0,0,1,1,1],
    [1,1,1,1,0,0,1,1,1],
    [0,0,0,0,0,0,0,0,0]
];

zigzagPattern = [
    [0,0,0,1,1,1,1,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,1,1,1,1,0,0,0],
    [1,1,1,1,0,0,0,0],
    [1,1,1,0,0,0,0,1],
    [1,1,0,0,0,0,1,1],
    [1,0,0,0,0,1,1,1],
    [0,0,0,0,1,1,1,1]
];

arrowsPattern = [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,1,1,1,1,0,0,0],
    [1,1,1,1,0,0,0,0],
    [1,1,1,0,0,0,0,1],
    [1,1,0,0,0,0,1,1],
    [1,0,0,0,0,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [1,1,1,1,0,0,0,0],
    [1,1,1,0,0,0,0,1],
    [1,1,0,0,0,0,1,1],
    [1,0,0,0,0,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,1,1,1,1,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
];

squaresPattern = [
    [0,0,0,0,0,0],
    [0,1,1,1,1,1],
    [0,1,1,1,1,1],
    [0,1,1,1,1,1],
    [0,1,1,1,1,1],
    [0,1,1,1,1,1]
];

trianglesPattern = [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,0,0,0,0,0,1,1,1,1,1,1,1],
    [1,0,0,0,1,0,0,0,1,1,1,1,1,1],
    [0,0,0,1,1,1,0,0,0,1,1,1,1,1],
    [0,0,1,1,1,1,1,0,0,0,1,1,1,0],
    [0,1,1,1,1,1,1,1,0,0,0,1,0,0],
    [1,1,1,1,1,1,1,1,1,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
];

pyramidsPattern = [
    [0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,1],
    [0,1,2,2,2,2,2,1],
    [0,1,2,3,3,3,2,1],
    [0,1,2,3,4,3,2,1],
    [0,1,2,3,3,3,2,1],
    [0,1,2,2,2,2,2,1],
    [0,1,1,1,1,1,1,1]
];

xPattern = [
    [0,0,0,0,0,0,0,0,0,0,0],
    [0,1,1,0,0,0,0,0,1,1,0],
    [0,0,1,1,0,0,0,1,1,0,0],
    [0,0,0,1,1,0,1,1,0,0,0],
    [0,0,0,0,1,1,1,0,0,0,0],
    [0,0,0,0,0,1,0,0,0,0,0],
    [0,0,0,0,1,1,1,0,0,0,0],
    [0,0,0,1,1,0,1,1,0,0,0],
    [0,0,1,1,0,0,0,1,1,0,0],
    [0,1,1,0,0,0,0,0,1,1,0],
    [0,0,0,0,0,0,0,0,0,0,0]
];

// ----------------------------
//        Lid Patterns
// ----------------------------

lidRibPattern = [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,1,1,0,0,1,1],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
];

lidRibSmallPattern = [
    [0,0,0,0],
    [0,0,0,0],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,1,1],
    [0,0,0,0],
    [0,0,0,0],
    [0,0,0,0]
];

lidRectPattern = [
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,1,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,1,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0]
];

lidOctoPattern = [
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [1,1,1,1,0,0,1,1,1],
    [1,1,1,1,0,0,1,1,1],
    [1,1,1,0,0,0,0,1,1],
    [1,1,0,0,0,0,0,0,1],
    [0,0,0,1,1,1,0,0,0],
    [0,0,1,1,1,1,1,0,0],
    [0,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1,0],
    [0,0,1,1,1,1,1,0,0],
    [0,0,0,1,1,1,0,0,0],
    [1,1,0,0,0,0,0,0,1],
    [1,1,1,0,0,0,0,1,1],
    [1,1,1,1,0,0,1,1,1],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0]
];

lidDiamondsPattern = [
    [0,0,0,0,0,0,0,0],
    [1,1,1,1,0,1,1,1],
    [1,1,1,0,0,0,1,1],
    [1,1,0,0,1,0,0,1],
    [1,0,0,1,1,1,0,0],
    [0,0,1,1,1,1,1,0],
    [0,1,1,1,1,1,1,1],
    [0,0,1,1,1,1,1,0],
    [1,0,0,1,1,1,0,0],
    [1,1,0,0,1,0,0,1],
    [1,1,1,0,0,0,1,1],
    [1,1,1,1,0,1,1,1],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
];

lidSlashPattern = [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,1,1,1,1,0,0],
    [0,0,0,1,1,1,1,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,1,1,1,1,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
];

lidArrowsLeftPattern = [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,1,1,1,1,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,1,1,1,1,0,0,0],
    [1,1,1,1,0,0,0,0],
    [1,1,1,0,0,0,0,1],
    [1,1,0,0,0,0,1,1],
    [1,0,0,0,0,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
];

lidArrowsRightPattern = [
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,1,1,1,1,0,0,0],
    [1,1,1,1,0,0,0,0],
    [1,1,1,0,0,0,0,1],
    [1,1,0,0,0,0,1,1],
    [1,0,0,0,0,1,1,1],
    [0,0,0,0,1,1,1,1],
    [0,0,0,1,1,1,1,0],
    [0,0,0,0,1,1,1,1],
    [1,0,0,0,0,1,1,1],
    [1,1,0,0,0,0,1,1],
    [1,1,1,0,0,0,0,1],
    [1,1,1,1,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0]
];

lidTrianglesPattern = [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,0,0,0,0,0,1,1,1,1,1,1,1],
    [1,0,0,0,1,0,0,0,1,1,1,1,1,1],
    [0,0,0,1,1,1,0,0,0,1,1,1,1,1],
    [0,0,1,1,1,1,1,0,0,0,1,1,1,0],
    [0,1,1,1,1,1,1,1,0,0,0,1,0,0],
    [1,1,1,1,1,1,1,1,1,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0]
];

lidTreadPattern = [
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,1,1,1,0,0,0,0,0],
    [0,0,0,1,1,1,0,0,0,0],
    [0,0,0,0,1,1,1,0,0,0],
    [1,1,1,0,0,1,1,1,0,0],
    [1,1,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,1,1],
    [0,0,0,0,0,0,0,1,1,1],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0]
];

lidXPattern = [
    [0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0],
    [0,1,1,0,0,0,0,0,1,1,0],
    [0,0,1,1,0,0,0,1,1,0,0],
    [0,0,0,1,1,0,1,1,0,0,0],
    [0,0,0,0,1,1,1,0,0,0,0],
    [0,0,0,0,0,1,0,0,0,0,0],
    [0,0,0,0,1,1,1,0,0,0,0],
    [0,0,0,1,1,0,1,1,0,0,0],
    [0,0,1,1,0,0,0,1,1,0,0],
    [0,1,1,0,0,0,0,0,1,1,0],
    [0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0]
];

lidHexPattern = [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1],
    [1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,1],
    [1,1,0,0,0,1,1,1,1,1,1,0,0,0,1,1],
    [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
    [0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0],
    [0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0],
    [1,1,0,0,0,1,1,1,1,1,1,0,0,0,1,1],
    [1,1,1,0,0,0,1,1,1,1,0,0,0,1,1,1],
    [1,1,1,1,0,0,0,0,0,0,0,0,1,1,1,1],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
];


