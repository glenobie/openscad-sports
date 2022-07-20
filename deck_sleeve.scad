
// width of the cards to put inside the sleeve
CARD_WIDTH = 60;

// height of the cards to put inside the sleeve
CARD_HEIGHT = 80;

// width of the deck of cards to put inside the sleeve
DECK_WIDTH = 1;

// height of the tab beyond CARD_HEIGHT
TAB_HEIGHT = 0;

// distance the sides will extend up the sleeve as percent of sleeve height
SIDES_PCT_OF_HEIGHT = 0.55;

// thickness of the sides, bottom, back, and bands
THICKNESS = 1.2;

// radius of the fillet at top of tab, set to zero if tab height is 0
TAB_FILLET = 0;

// where along side the band will start
BAND_HEIGHT = 12;

// the width of the band
BAND_WIDTH = 8;

// the angle with respect to the side at which the band will extend towards bottom
BAND_ANGLE = 25;

// added to band_width for cutout width on back
EXTRA_CUT_WIDTH = 4;

TOP_BANDS = true;

// amount to chamfer off top corner of side
SIDE_CHAMFER = 0;
// radius of the fillet at the top of the back
BACK_FILLET = 0;

//DO NOT EDIT, total width of the sleeve
SLEEVE_WIDTH = CARD_WIDTH + 2*THICKNESS;

//DO NOT EDIT, total width of the sleeve
SLEEVE_DEPTH = DECK_WIDTH + THICKNESS*2;

// where along top the tab will start
TAB_LEFT_START = 20;
// where along top the tab will end
TAB_RIGHT_END = 40;

// diameter of circle to cut out of back to save filament
CUT_OUT_DIAMETER = 30;

/**********************************/

module left_back()
{
    factor = TOP_BANDS ? 2 : 1;
    back_height = (THICKNESS*factor + CARD_HEIGHT) / factor;
    cut_x_1 = (BAND_HEIGHT - EXTRA_CUT_WIDTH) / cos(BAND_ANGLE);
    cut_x_2 = (BAND_HEIGHT + BAND_WIDTH +  EXTRA_CUT_WIDTH) / cos(BAND_ANGLE);
    difference()
    {
        union()
        {
            cube([ SLEEVE_WIDTH/2, back_height - BACK_FILLET, THICKNESS]);
            hull()
            {
                translate([BACK_FILLET, back_height - BACK_FILLET, 0 ] )
                    cylinder(h=THICKNESS, r=BACK_FILLET);
                translate([SLEEVE_WIDTH/2 - BACK_FILLET, back_height - BACK_FILLET, 0 ] )
                    cube([BACK_FILLET, BACK_FILLET, THICKNESS]);
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
  factor = TOP_BANDS ? 2 : 1;
  sleeve_height = CARD_HEIGHT + THICKNESS * factor;
    translate([TAB_LEFT_START, sleeve_height, 0])
        cube([TAB_RIGHT_END - TAB_LEFT_START,
              TAB_HEIGHT - TAB_FILLET,
              THICKNESS]);
    hull()
    {
        translate([TAB_FILLET + TAB_LEFT_START,
                   sleeve_height + TAB_HEIGHT - TAB_FILLET,
                   0])
            cylinder(h=THICKNESS, r=TAB_FILLET);
        translate([TAB_RIGHT_END - TAB_FILLET,
                   sleeve_height + TAB_HEIGHT - TAB_FILLET,
                   0])
            cylinder(h=THICKNESS, r=TAB_FILLET);
    }
}

module bottom()
{
    factor = TOP_BANDS ? 2 : 1;
    cube([SLEEVE_WIDTH, THICKNESS, SLEEVE_DEPTH]);
    if (TOP_BANDS)
    {
      translate([0,CARD_HEIGHT + THICKNESS*factor, 0])
        mirror([0,1,0])
        {
          cube([SLEEVE_WIDTH, THICKNESS, SLEEVE_DEPTH]);
        }
      }
}

module left_side()
{
    factor = TOP_BANDS ? 2 : 1;
    sleeve_height = THICKNESS*factor + CARD_HEIGHT;
    difference()
    {
        cube([THICKNESS, sleeve_height * SIDES_PCT_OF_HEIGHT, SLEEVE_DEPTH]);

        translate([THICKNESS/2, sleeve_height * SIDES_PCT_OF_HEIGHT, SLEEVE_DEPTH])
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

module front_left_parts()
{
  left_back();
  left_side();
  left_band();

  if (TOP_BANDS)
  {
    translate([0,CARD_HEIGHT + THICKNESS*2, 0])
      mirror([0,1,0])
      {
        left_back();
        left_side();
        left_band();
      }
  }
}
/******************************************/

bottom();
tab();

front_left_parts();
translate([SLEEVE_WIDTH,0,0])
    mirror([1,0,0]){
      front_left_parts();
    }
