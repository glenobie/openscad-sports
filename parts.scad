/*******************************************************/
// 1  = drawer
// 2  = base
// 3  = exterior front support
// 4  = exterior middle support
// 5  = exterior back support
// 6  = interior front support
// 7  = interior middle support
// 8  = interior back support
// 9  = drawer label
// 10 = side
// 11 = back
// 12 = divider
// value from 1 to 12. Change to make all the necessary models for the storage system
MODEL_TO_MAKE = 1;

// exterior depth of drawer
DRAWER_DEPTH           = 160;
// exterior width of drawer
DRAWER_WIDTH           = 50;
// exterior height of drawer front including label
DRAWER_FRONT_HEIGHT    = 80;
// exterior height of drawer sides and back
DRAWER_SIDES_HEIGHT    = 20;
// thickness of sides, back, and bottom of drawer
DRAWER_THICKNESS       = 2;
// thickness of front of drawer. Needs room for label tabs and magnet. Best not to edit
DRAWER_FRONT_THICKNESS = 5;
// will always add one to back, then at the depths below
DIVIDER_SLOTS = [40,60,80,100, 120, 140];

// thickness of the dividers that can be placed in the drawer, will add tolerance when created
DIVIDER_THICKNESS = 1.2;
// Extra space for divider to slide into slots in drawer
DIVIDER_TOLERANCE = 0.1;
// distance divider slot will extend into sides of drawer, will add tolerance when created
DIVIDER_DEPTH = 1;
// height of the divider
DIVIDER_HEIGHT = 50;

// extra space for the label to slide into the tabs in the front of drawer
LABEL_TAB_EXTRA_SPACE  = 0.1;

// multiplied by DRAWER_FRONT_HEIGHT to determine height of label
LABEL_AS_PCT_OF_DRAWER = 0.8;
// height of the tab that will slide into the front of drawer
LABEL_TAB_HEIGHT       = 10;
// thickness of tab that will slide into front of drawer
LABEL_TAB_THICKNESS    = 2;
// width of the tab that will slide into front of drawer
LABEL_TAB_WIDTH        = 10;
// distance from the side of the label to the start of the tab
LABEL_TAB_SIDE_OFFSET  = 4;
//distance from the front of the label to the start of the tab
LABEL_TAB_FRONT_OFFSET = 1.4;

// total distance between drawer and supports to its sides
DRAWER_HORIZONTAL_TOLERANCE = 1;
// total distance between drawer and the bases above and below
DRAWER_VERTICAL_TOLERANCE   = 1;
// total distance between drawer and front of base below/above and supports behind
DRAWER_DEPTH_TOLERANCE      = 1;

// thickness of the bases
BASE_HEIGHT             = 5;
// thickness of base interior. Support holes will not penetrate this interior section
BASE_INTERIOR_HEIGHT    = 1;
// Number of bases a drawer will span over its depth. Should be at least 2.
BASES_PER_DRAWER        = 2;
// Save some filament by removing an interior rectangle from the base
BASE_REMOVAL_PERCENTAGE = .60;

// Thickness of side and back plates that slide between supports. These parts are solely aesthetic. Value must be less than 3.
SIDE_BACK_THICKNESS = 1.2;

//Provide a way to pull the drawer. Value of 0, 1, 2, 3: 3 = protrusion  2= centered hole for a knob, 1= slot for a magnet, 0=none
PULL_TYPE = 1;

// if PULL_TYPE == 1, make a slot to fit a magnet with this width or diameter
MAGNET_WIDTH  = 6;
// if PULL_TYPE == 1, make a slot to fit a magnet with this thickness
MAGNET_HEIGHT = 2;
// if PULL_TYPE == 1, make a slot that extends down to this distance from bottom of drawer
MAGNET_HEIGHT_OFFSET = 4;

// if PULL_TYPE == 2, make a hole of this diameter
KNOB_HOLE_DIAMETER = 8;
// if PULL_TYPE == 2, the height of center of knob hole from bottom of  drawer
KNOB_HOLE_HEIGHT = 12;
// if PULL_TYPE == 2, add a square inside the drawer of this size
KNOB_SQUARE_SIZE = 10;
// if PULL_TYPE == 2, add a square inside the drawer of this depth
KNOB_SQUARE_DEPTH = 1.2;

// if PULL_TYPE == 3, width of drawer base protrusion
PROTRUSION_WIDTH = 20;
// if PULL_TYPE == 3, height of drawer base protrusion
PROTRUSION_HEIGHT = 6;
// if PULL_TYPE == 3, depth of drawer base protrusion
PROTRUSION_DEPTH = 4;
// if PULL_TYPE == 3, percent of protrusion hollowed out
PROTRUSION_HOLLOW_PCT = 0.6;


// List of text to engrave on the drawer label. Each element in list is a list of 4 values:  [text, size of text, font, distance from bottom of label to font base]
TEXTS = [
         ["MLB", 12, "Arial", 40],
         ["1986", 8, "Arial", 14]
        ];
// Depth to engrave the text into the label.
TEXT_DEPTH = 0.6;


/***************************************************************/

//do not edit
SUPPORT_DEPTH = 9.8;
// do not edit
SUPPORT_WIDTH = 6;


// The set 2D profile for all supports
module profile()
{
    square([1.5,SUPPORT_DEPTH]);
    translate([1.5,0,0])
        square([3, 5.8]);
    translate([4.5,0,0])
        square([1.5,SUPPORT_DEPTH]);
}

module support_exterior_front(height)
{
    translate([1,1,0])
        cube([4,4,height+4]);
    translate([0,0,2])
        linear_extrude(height)
            profile();

}

module support_exterior_middle(height)
{
    support_exterior_front(height);
    rotate(180)
        translate([-SUPPORT_WIDTH,0,0])
            support_exterior_front(height);
}

module support_interior_middle(height)
{
    support_exterior_middle(height);
    translate([SUPPORT_WIDTH,0,0])
        support_exterior_middle(height);
}

module support_interior_front(height)
{
    support_exterior_front(height);
    translate([SUPPORT_WIDTH,0,0])
        support_exterior_front(height);
}

module support_exterior_back(height)
{
   support_exterior_front(height);
   rotate(90)
        translate([0,-SUPPORT_WIDTH,0])
            support_exterior_front(height);
}

module support_interior_back(height)
{
    support_exterior_back(height);
    rotate(270)
        translate([-SUPPORT_WIDTH,SUPPORT_WIDTH,0])
            support_exterior_back(height);
}

// Base is two halves with holes and an interior.
module base_half(width, depth, height)
{

    difference(){
        cube([width, depth, height]);
        translate([1,1,0])
            cube([2,2,height]);
        translate([width-3,1,0])
            cube([2,2,height]);
        translate([width-3,depth-3,0])
            cube([2,2,height]);
        translate([1,depth-3,0])
            cube([2,2,height]);
    }
}

module base(width, depth)
{
    h = (BASE_HEIGHT - BASE_INTERIOR_HEIGHT) / 2;
    base_half(width, depth, h);
    difference()
    {
        union(){
            translate([0, 0, h])
                cube([width,depth,BASE_INTERIOR_HEIGHT]);
            translate([0,0,BASE_INTERIOR_HEIGHT + h])
                base_half(width,depth, h );

        }
        // remove a section of base to save filament
        translate([(width - width*BASE_REMOVAL_PERCENTAGE)/2,
                   (depth - depth*BASE_REMOVAL_PERCENTAGE) / 2,
                   0 ])
           cube([width*BASE_REMOVAL_PERCENTAGE,
                depth*BASE_REMOVAL_PERCENTAGE,
                10]);
    }
}

module drawer(width, depth, height, side_height, thickness, front_thickness)
{
    magnet_x = (width - MAGNET_WIDTH) / 2;
    label_z = height - (height*LABEL_AS_PCT_OF_DRAWER);

    difference(){
        union(){

            cube([width, depth, side_height]);
            cube([width, front_thickness, label_z]);

            // protrusion
            if (PULL_TYPE == 3)
            {
                translate([(width - PROTRUSION_WIDTH)/2, -PROTRUSION_DEPTH, 0])
                    cube([PROTRUSION_WIDTH, PROTRUSION_DEPTH, PROTRUSION_HEIGHT]);
            }
        }
        // hollow it out
        translate([thickness, front_thickness, thickness])
            cube([width - (2 * thickness),
                  depth - thickness - front_thickness,
                  side_height]);
        // remove excess from where label will go
        translate([0, 0, label_z])
            cube([width, front_thickness, height]);
        // magnet slot
        if (PULL_TYPE == 1)
            translate([magnet_x, 1, MAGNET_HEIGHT_OFFSET ])
                cube([MAGNET_WIDTH, MAGNET_HEIGHT, label_z]);
        // knob hole
        if (PULL_TYPE == 2)
        {
            translate([width/2, 0, KNOB_HOLE_HEIGHT])
                rotate([270,0,0])
                    cylinder(h=front_thickness+1, d=KNOB_HOLE_DIAMETER);
            translate([width/2, front_thickness - KNOB_SQUARE_DEPTH/2, KNOB_HOLE_HEIGHT])
                rotate([0,45,0])
                      cube([KNOB_SQUARE_SIZE, KNOB_SQUARE_DEPTH, KNOB_SQUARE_SIZE], true);
        }
        // protrusion
        if (PULL_TYPE == 3)
        {
            translate([(width - PROTRUSION_WIDTH*PROTRUSION_HOLLOW_PCT)/2,
                        -PROTRUSION_DEPTH*PROTRUSION_HOLLOW_PCT,
                        PROTRUSION_HEIGHT -PROTRUSION_HEIGHT*PROTRUSION_HOLLOW_PCT])
                cube([PROTRUSION_WIDTH*PROTRUSION_HOLLOW_PCT,
                      PROTRUSION_DEPTH*PROTRUSION_HOLLOW_PCT,
                      PROTRUSION_HEIGHT*PROTRUSION_HOLLOW_PCT]);
        }
        // label tab left slot
        translate([(LABEL_TAB_SIDE_OFFSET - LABEL_TAB_EXTRA_SPACE),
                   (LABEL_TAB_FRONT_OFFSET - LABEL_TAB_EXTRA_SPACE),
                   label_z - LABEL_TAB_HEIGHT - LABEL_TAB_EXTRA_SPACE])
            cube([LABEL_TAB_WIDTH + LABEL_TAB_EXTRA_SPACE,
                  LABEL_TAB_THICKNESS + LABEL_TAB_EXTRA_SPACE,
                  height]);
        //label tab right slot
        translate([width - LABEL_TAB_SIDE_OFFSET - LABEL_TAB_WIDTH + LABEL_TAB_EXTRA_SPACE,
                   LABEL_TAB_FRONT_OFFSET - LABEL_TAB_EXTRA_SPACE,
                   label_z - LABEL_TAB_HEIGHT - LABEL_TAB_EXTRA_SPACE])
            cube([LABEL_TAB_WIDTH + LABEL_TAB_EXTRA_SPACE,
                  LABEL_TAB_THICKNESS + LABEL_TAB_EXTRA_SPACE,
                  height]);
        // back divider slot left
        translate([thickness - DIVIDER_DEPTH - DIVIDER_TOLERANCE,
                   depth - thickness - DIVIDER_THICKNESS - DIVIDER_TOLERANCE,
                   thickness])
            cube([DIVIDER_DEPTH + DIVIDER_TOLERANCE,
                  DIVIDER_THICKNESS + DIVIDER_TOLERANCE,
                  side_height]);
        // back divider slot right
        translate([width - thickness,
                   depth-thickness - DIVIDER_THICKNESS - DIVIDER_TOLERANCE,
                   thickness])
            cube([DIVIDER_DEPTH + DIVIDER_TOLERANCE,
                  DIVIDER_THICKNESS + DIVIDER_TOLERANCE,
                  side_height]);
        // other divider slots
        for (d = DIVIDER_SLOTS)
        {
            // left side
            translate([thickness - DIVIDER_DEPTH - DIVIDER_TOLERANCE, d, thickness])
                cube([DIVIDER_DEPTH + DIVIDER_TOLERANCE,
                     DIVIDER_THICKNESS + DIVIDER_TOLERANCE,
                     side_height]);
            // right side
            translate([width - thickness, d, thickness])
                cube([DIVIDER_DEPTH + DIVIDER_TOLERANCE,
                     DIVIDER_THICKNESS + DIVIDER_TOLERANCE,
                     side_height]);

        }


    }
}

module drawer_label(width, thickness, height)
{

    difference(){
        union(){
            cube([width, height, thickness]);
            translate([LABEL_TAB_SIDE_OFFSET, -LABEL_TAB_HEIGHT, 0 ])
                cube([LABEL_TAB_WIDTH, LABEL_TAB_HEIGHT, LABEL_TAB_THICKNESS ]);
            translate([width - LABEL_TAB_SIDE_OFFSET - LABEL_TAB_WIDTH,
                       -LABEL_TAB_HEIGHT, 0])
            cube([LABEL_TAB_WIDTH, LABEL_TAB_HEIGHT, LABEL_TAB_THICKNESS ]);
        }
        for (t = TEXTS)
            translate([width/2, t[3], thickness-TEXT_DEPTH])
            linear_extrude(TEXT_DEPTH)
                text(t[0], t[1], t[2], halign="center");
    }

}

module side(base_depth, height)
{
    y = base_depth - (SUPPORT_WIDTH * 2) - 1; // 1 = tolerance
    cube([SIDE_BACK_THICKNESS, y, height]);
}

module back(base_width, height)
{
    x = base_width - (SUPPORT_WIDTH * 2) - 1; // 1 = tolerance
    cube([x, SIDE_BACK_THICKNESS, height]);
}

module divider()
{
    width = DRAWER_WIDTH - (2*DRAWER_THICKNESS) + (2*DIVIDER_DEPTH);
    fillet = width/4; //radius of fillet
    union()
    {
        cube([width, DIVIDER_THICKNESS, DIVIDER_HEIGHT-fillet]);
        hull()
        {
            rotate(90, [1,0,0])
            {
                translate([fillet, DIVIDER_HEIGHT-fillet, -DIVIDER_THICKNESS])
                    cylinder(h=DIVIDER_THICKNESS, r=fillet);
                translate([width - fillet, DIVIDER_HEIGHT-fillet, -DIVIDER_THICKNESS])
                    cylinder(h=DIVIDER_THICKNESS, r=fillet);
            }
        }
    }
}

/**************************************************/
// BEGIN

base_depth = (DRAWER_DEPTH + SUPPORT_WIDTH + DRAWER_DEPTH_TOLERANCE) / BASES_PER_DRAWER;
base_width = DRAWER_WIDTH + DRAWER_HORIZONTAL_TOLERANCE + (SUPPORT_WIDTH * 2);

support_height = DRAWER_FRONT_HEIGHT + DRAWER_VERTICAL_TOLERANCE;

if (MODEL_TO_MAKE == 1)
{
    drawer(DRAWER_WIDTH, DRAWER_DEPTH, DRAWER_FRONT_HEIGHT,
        DRAWER_SIDES_HEIGHT, DRAWER_THICKNESS, DRAWER_FRONT_THICKNESS);
}
else if (MODEL_TO_MAKE == 2)
{
    base(base_width, base_depth);
}
else if (MODEL_TO_MAKE == 3)
{
    support_exterior_front(support_height);
}
else if (MODEL_TO_MAKE == 4)
{
    support_exterior_middle(support_height);
}
else if (MODEL_TO_MAKE == 5)
{
    support_exterior_back(support_height);
}
else if (MODEL_TO_MAKE == 6)
{
    support_interior_front(support_height);
}
else if (MODEL_TO_MAKE == 7)
{
    support_interior_middle(support_height);
}
else if (MODEL_TO_MAKE == 8)
{
    support_interior_back(support_height);
}
else if (MODEL_TO_MAKE == 9)
{
    thickness = LABEL_TAB_FRONT_OFFSET + LABEL_TAB_THICKNESS;
    height = DRAWER_FRONT_HEIGHT * LABEL_AS_PCT_OF_DRAWER;
    drawer_label(DRAWER_WIDTH, thickness, height);
}
else if (MODEL_TO_MAKE == 10)
{
    side(base_depth, support_height);
}
else if (MODEL_TO_MAKE == 11)
{
    back(base_width, support_height);
}
else if (MODEL_TO_MAKE == 12)
{
    divider();
}
