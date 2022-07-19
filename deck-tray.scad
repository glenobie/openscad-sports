//Part to make: 1=back, 2=side, 3=bottom
PART_TO_MAKE = 3;

// Total height of the tray, must be greater than 40
TRAY_HEIGHT = 50; 

// width of the card tray, total width will be greater due to TAB_EXCESS_WIDTH
TRAY_WIDTH = 68;

// depth of the card tray, total depth will be greater due to SIDE_OFFSET
TRAY_DEPTH = 70;

// thickness (z direction when printed) of all parts
PARTS_THICKNESS = 3;

// amount of the parts that will overhand the slots.
TAB_EXCESS_WIDTH = 3;

// extra width added to PARTS_THICKNESS for slots 
SIDE_SLOT_TOLERANCE = 0.1;
// extra width add to horizontal slot in back part
BACK_SLOT_TOLERANCE = 0.2;
// save filament by cutting out some of back piece
BACK_CUT_DIAMETER = 26;
// save filament by cutting out some of bottom piece
BOTTOM_CUT_DIAMETER = 36;

// distance from back part to back edge of side part
SIDE_OFFSET = 4;

// Angle of bottom part with respect to ground
BOTTOM_ANGLE = 5;

// DO NOT EDIT, height of top third of back
BACK_TOP_HEIGHT = 20;
// DO NOT EDIT, height of bottom third of back
BACK_BOTTOM_HEIGHT = 20;

// DO NOT EDIT, extent of lower slot on back
BACK_LOWER_SLOT_HEIGHT = 10;
// DO NOT EDIT, extent of upper slot on back
BACK_UPPER_SLOT_HEIGHT = 14;

// DO NOT EDIT, height of horizontal slot on back part
BACK_SLOT_FOR_BOTTOM_HEIGHT = 5;
// DO NOT EDIT, height of horizontal slot on back part
BACK_SLOT_FOR_BOTTOM_LENGTH = TRAY_WIDTH / 2;


// DO NOT EDIT, height of slot on bottom part
BOTTOM_SLOT_HEIGHT = 20;

// DO NOT EDIT, height of tab on bottom part
BOTTOM_TAB_HEIGHT = 6;



/**********************************/


module profile_back_right_half()
{
    middle_height = TRAY_HEIGHT - BACK_TOP_HEIGHT - BACK_BOTTOM_HEIGHT;
    slot_width = SIDE_SLOT_TOLERANCE + PARTS_THICKNESS;

    //bottom third
    square([TRAY_WIDTH/2, BACK_BOTTOM_HEIGHT]);

    //Middle part 
    translate([0,BACK_BOTTOM_HEIGHT,0])
        square([TRAY_WIDTH/2, middle_height]);

    //top third
    translate([0,BACK_BOTTOM_HEIGHT+middle_height,0])
        square([TRAY_WIDTH/2, BACK_TOP_HEIGHT]);
    //bottom hooks
    translate([TRAY_WIDTH/2, BACK_LOWER_SLOT_HEIGHT, 0])
        square([slot_width+TAB_EXCESS_WIDTH,
                BACK_BOTTOM_HEIGHT - BACK_LOWER_SLOT_HEIGHT]);
    translate([TRAY_WIDTH/2 + slot_width, BACK_LOWER_SLOT_HEIGHT-slot_width, 0])
        square([TAB_EXCESS_WIDTH,
                BACK_LOWER_SLOT_HEIGHT - BACK_SLOT_FOR_BOTTOM_HEIGHT]);
    //top hooks
    translate([TRAY_WIDTH/2, TRAY_HEIGHT - BACK_UPPER_SLOT_HEIGHT, 0])
        square([slot_width+TAB_EXCESS_WIDTH,
                 BACK_UPPER_SLOT_HEIGHT]);
    translate([TRAY_WIDTH/2 + slot_width, TRAY_HEIGHT - BACK_TOP_HEIGHT, 0])
        square([TAB_EXCESS_WIDTH,
                BACK_TOP_HEIGHT - BACK_UPPER_SLOT_HEIGHT]);
   
}


module back()
{
    difference()
    {
        linear_extrude(PARTS_THICKNESS)
        {
                profile_back_right_half();
                mirror([1,0,0])
                    profile_back_right_half();
        }
        translate([-(BACK_SLOT_FOR_BOTTOM_LENGTH + BACK_SLOT_TOLERANCE)/2,
                   BACK_SLOT_FOR_BOTTOM_HEIGHT,0])
            cube([BACK_SLOT_FOR_BOTTOM_LENGTH + BACK_SLOT_TOLERANCE , 
                  PARTS_THICKNESS + BACK_SLOT_TOLERANCE, 
                   PARTS_THICKNESS]);
        translate([0,TRAY_HEIGHT/2,0])
            cylinder(h=PARTS_THICKNESS, d=BACK_CUT_DIAMETER);
        
        
    }
}

module side()
{
    slot_width = SIDE_SLOT_TOLERANCE + PARTS_THICKNESS;
    side_depth = TRAY_DEPTH + slot_width + SIDE_OFFSET;
    difference()
    {
        // TRAY_DEPTH will be in x, TRAY_HEIGHT in y
        if (side_depth > TRAY_HEIGHT)
        {
            scale([1, TRAY_HEIGHT/side_depth])
                cylinder(h=PARTS_THICKNESS, d=side_depth*2);
        }
        else
        {
            scale([side_depth/ TRAY_HEIGHT, 1])
                cylinder(h=PARTS_THICKNESS, d=TRAY_HEIGHT*2);
        }
        
        translate([-side_depth,-TRAY_HEIGHT,  0])
            cube([side_depth, TRAY_HEIGHT*2, PARTS_THICKNESS]);
        translate([0,-TRAY_HEIGHT, 0])
            cube([side_depth, TRAY_HEIGHT, PARTS_THICKNESS]);
        // bottom slot
        translate([SIDE_OFFSET, BACK_LOWER_SLOT_HEIGHT, 0])
            cube([slot_width, 
                  BACK_BOTTOM_HEIGHT - BACK_SLOT_FOR_BOTTOM_HEIGHT, 
                  PARTS_THICKNESS]);
        // top slot
        translate([SIDE_OFFSET, 
                   TRAY_HEIGHT-BACK_UPPER_SLOT_HEIGHT, 
                   0])
            cube([slot_width, 
                  TRAY_HEIGHT - BACK_UPPER_SLOT_HEIGHT, 
                  PARTS_THICKNESS]);
        rotate(BOTTOM_ANGLE,[0,0,1])
        {
            //front slot
            translate([side_depth - BOTTOM_SLOT_HEIGHT, 
                       BACK_SLOT_FOR_BOTTOM_HEIGHT, 
                       0])
                cube([BOTTOM_SLOT_HEIGHT, slot_width, PARTS_THICKNESS ]);
            //front tab
            translate([side_depth - BOTTOM_SLOT_HEIGHT - BOTTOM_TAB_HEIGHT,
                       BACK_SLOT_FOR_BOTTOM_HEIGHT, 
                       0])
                cube([3, slot_width, PARTS_THICKNESS ]);
        }
        
    }
}

module profile_bottom_right_half()
{
    slot_width = SIDE_SLOT_TOLERANCE + PARTS_THICKNESS;
    square([TRAY_WIDTH/2, TRAY_DEPTH]);
    translate([0,TRAY_DEPTH, 0])
        square([BACK_SLOT_FOR_BOTTOM_LENGTH/2, PARTS_THICKNESS]);
    translate([TRAY_WIDTH/2, 0, 0])
        square([slot_width, BOTTOM_SLOT_HEIGHT]);
    translate([TRAY_WIDTH/2 + slot_width, 0, 0])
        square([TAB_EXCESS_WIDTH, BOTTOM_SLOT_HEIGHT+BOTTOM_TAB_HEIGHT]);
    translate([TRAY_WIDTH/2 + slot_width, BOTTOM_SLOT_HEIGHT+BOTTOM_TAB_HEIGHT, 0])
        polygon([[0, 0],[-0.8, 0],[0, -2]] );
}

module bottom()
{
    difference()
    {
        linear_extrude(PARTS_THICKNESS)
        {
            profile_bottom_right_half();
            mirror([1,0,0])
                profile_bottom_right_half();
        }
        
        translate([0, TRAY_DEPTH / 2, 0])
            cylinder(h=PARTS_THICKNESS, d=BOTTOM_CUT_DIAMETER);
        
    }
}



/************************************/

if (PART_TO_MAKE == 1)
{
    back();
} 
else if (PART_TO_MAKE == 2)
{
    side();
}
else if (PART_TO_MAKE == 3)
{
    bottom();
}
