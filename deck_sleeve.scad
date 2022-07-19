
// width of the cards to put inside the sleeve
CARD_WIDTH = 60;

// height of the cards to put inside the sleeve
CARD_HEIGHT = 80;

// width of the deck of cards to put inside the sleeve
DECK_WIDTH = 10;

// height of the tab beyond CARD_HEIGHT
TAB_HEIGHT = 14;

// distance the sides will extend up the sleeve as percent of sleeve height
SIDES_PCT_OF_HEIGHT = 0.5;

// thickness of the sides, bottom, back, and bands
THICKNESS = 1.2;

// diameter of the fillet at top of tab
TAB_FILLET = 6;

// where along side the band will start
BAND_HEIGHT = 12;

// the width of the band
BAND_WIDTH = 8;

// the angle with respect to the side at which the band will extend towards bottom
BAND_ANGLE = 25;

// added to band_width for cutout width on back
EXTRA_CUT_WIDTH = 4;

// amount to chamfer off top corner of side
SIDE_CHAMFER = 14;
// diameter of the fillet at the top of the back
BACK_FILLET = 24; 

//DO NOT EDIT, total width of the sleeve
SLEEVE_WIDTH = CARD_WIDTH + 2*THICKNESS;
//DO NOT EDIT, total height of the sleeve
SLEEVE_HEIGHT = CARD_HEIGHT + THICKNESS + TAB_HEIGHT;
//DO NOT EDIT, total width of the sleeve
SLEEVE_DEPTH = DECK_WIDTH + THICKNESS*2;

// where along top the tab will start
TAB_LEFT_START = 0;
// where along top the tab will end
TAB_RIGHT_END = 40;

// diameter of circle to cut out of back to save filament
CUT_OUT_DIAMETER = 30;

/**********************************/

module left_back()
{
    cut_x_1 = (BAND_HEIGHT - EXTRA_CUT_WIDTH) / cos(BAND_ANGLE);
    cut_x_2 = (BAND_HEIGHT + BAND_WIDTH +  EXTRA_CUT_WIDTH) / cos(BAND_ANGLE);
    difference()
    {
        union()
        {
            cube([ SLEEVE_WIDTH/2, CARD_HEIGHT - BACK_FILLET/2, THICKNESS]);
            hull()
            {
                translate([BACK_FILLET/2, CARD_HEIGHT - BACK_FILLET/2, 0 ] )
                    cylinder(h=THICKNESS, d=BACK_FILLET);
                translate([SLEEVE_WIDTH/2 - BACK_FILLET/2, CARD_HEIGHT - BACK_FILLET/2, 0 ] )
                    cube([BACK_FILLET/2, BACK_FILLET/2, THICKNESS]);
                
            
            }
        }
        // cut around bands
        linear_extrude(THICKNESS)
        {
            polygon([ [0,BAND_HEIGHT + BAND_WIDTH + EXTRA_CUT_WIDTH], 
                      [0, BAND_HEIGHT - EXTRA_CUT_WIDTH],
                      [cut_x_1, 0], 
                      [cut_x_2 ,0]   ]);
        }
        //cut out
        translate([SLEEVE_WIDTH/2, CARD_HEIGHT/2, 0])
            cylinder(h=THICKNESS, d=CUT_OUT_DIAMETER);
    }
}

module tab()
{
    translate([TAB_LEFT_START, CARD_HEIGHT - BACK_FILLET/2, 0])
        cube([TAB_RIGHT_END - TAB_LEFT_START, 
              SLEEVE_HEIGHT - CARD_HEIGHT - TAB_FILLET/2 + BACK_FILLET/2, 
              THICKNESS]);
    hull()
    {
        translate([TAB_FILLET/2 + TAB_LEFT_START , SLEEVE_HEIGHT - TAB_FILLET/2,  0])
            cylinder(h=THICKNESS, d=TAB_FILLET);
        translate([TAB_RIGHT_END - TAB_FILLET/2, 
                   SLEEVE_HEIGHT - TAB_FILLET/2, 
                   0])
            cylinder(h=THICKNESS, d=TAB_FILLET);
    }
}

module bottom()
{
    cube([SLEEVE_WIDTH, THICKNESS, SLEEVE_DEPTH]);
}

module left_side()
{
    difference()
    { 
        cube([THICKNESS, SLEEVE_HEIGHT * SIDES_PCT_OF_HEIGHT, SLEEVE_DEPTH]);

        translate([THICKNESS/2, SLEEVE_HEIGHT * SIDES_PCT_OF_HEIGHT, SLEEVE_DEPTH])
            rotate(45, [1,0,0])
                cube([THICKNESS, SIDE_CHAMFER, SIDE_CHAMFER], center=true);
    }
}

module left_band()
{
    band_x_1 = BAND_HEIGHT / cos(BAND_ANGLE);
    band_x_2 = (BAND_HEIGHT+BAND_WIDTH) / cos(BAND_ANGLE);
    
    translate([0,0,SLEEVE_DEPTH-THICKNESS])
    linear_extrude(THICKNESS)
    {
        polygon( [[0, BAND_HEIGHT+BAND_WIDTH], 
                  [0, BAND_HEIGHT],
                  [band_x_1, 0], 
                  [band_x_2, 0] ]);
    }
}

/******************************************/

left_back();
bottom();
left_side();
left_band();
tab();

translate([SLEEVE_WIDTH,0,0])
    mirror([1,0,0]){
        left_back();
        left_side();
        left_band();
    }
