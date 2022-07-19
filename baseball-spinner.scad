card_width = 40;
card_height = 70;
card_thickness = .6;

wall_thickness = 1.6;
base_thickness = 1.6;

bottom_offset = card_height / 4;

overhang = 2;

padding_width = .2;
padding_per_card = .05;

side_width = wall_thickness*2+padding_width*2 + card_width;
tray_depth = wall_thickness*3  + (padding_per_card + card_thickness)*10;
tray_height = wall_thickness + card_height;

tray_core_width = tray_depth;
shaft_offset = 3;
shaft_length = 200;
shaft_width = tray_core_width - shaft_offset;
shaft_tolerance = [0.24, 0.2, 0];

angle = 15;
M = [ [ 1  , 0  , 0  , 0   ],
[ 0  , 1  , sin(angle)  , 0   ],  // The skew value; pushed along the y axis as z changes.
[ 0  , 0  , 1  , 0   ],
[ 0  , 0  , 0  , 1   ] ] ;


module left_edge(height)
{
   // left edge
   cube([wall_thickness, tray_depth, height]);
   // left overhang front
   cube([wall_thickness+overhang, wall_thickness, height]);
   // left overhang back
   translate([0,tray_depth-wall_thickness, 0])
   cube([wall_thickness+overhang, wall_thickness, height]);
}


module tray_side()
{
   // bottom
   cube([side_width, tray_depth, base_thickness]);
   // front lip
   cube([side_width, wall_thickness, overhang+wall_thickness]);
   left_edge(tray_height);
   translate([side_width, 0, 0])
   mirror([1, 0, 0]) left_edge(card_height * 2 / 3);
   //middle wall
   translate([0, wall_thickness + card_thickness+padding_per_card, 0])
   cube([side_width, wall_thickness, tray_height]);
   // base offset
   translate([0, wall_thickness+padding_per_card+card_thickness,0])
   cube([side_width, tray_depth - (wall_thickness+padding_per_card+card_thickness), bottom_offset]);
   //back wall
   translate([0, tray_depth - wall_thickness, 0])
   cube([side_width, wall_thickness, bottom_offset + overhang]);

}

module tray()
{
   union(){
      rotate([0,0,180])
      translate([0,-tray_depth, 0])
      tray_side();
      translate([tray_core_width, 0, 0])
      tray_side();
      cube([tray_core_width, tray_depth, tray_height]);
   }
}

module shaft(c)
{
   cube(c,center=true);
}


module knob(height, d1, d2, gaps=5, fillet=2)
{
   linear_extrude(height)
   {
      offset(r = fillet)
      {
         difference()
         {
            circle(d=d1);
            for (i=[0:gaps-1])
            {
               rotate([0,0,(360/gaps)*i])
               translate([d1/2, 0, -1])
               circle(d=d2);
            }
         }
      }
   }
}

// this cylinder version imports into Freecad but lacks the radius effect of above
module knob2(height, d1, d2, gaps=5, fillet=2)
{
      //offset(r = fillet)
      //{
         difference()
         {
            cylinder(h=height, d=d1);
            for (i=[0:gaps-1])
            {
               rotate([0,0,(360/gaps)*i])
                  translate([d1/2, 0, 0])
                     cylinder(h=height,d=d2);
            }
         }
      //}
}



module base()
{
   hull()
   {
      multmatrix(M)
      {
         cube(size=[60,2,100],center=false);
      }
      translate([0,60,0])
      cube([60,2,100]);
   }
}

//
// d1 = overall diameter
// d2 = inner circle diameter
// d3 = diameter of end points
module clicker(height, d1, d2, d3, spokes)
{
   linear_extrude(height)
   {
      circle(d=d2);
      for (i=[0:spokes-1])
      {
         rotate([0,0,(360/spokes)*i])
            translate([(d1 - d3)/2, 0, 0])
               circle(d=d3);

      }
      for (i=[0:spokes-1])
      {
         rotate([0,0,(360/spokes)*i + 360 / (spokes*.8)])
            square([d1/2 - d3, 2]);
      }
   }

   for (i=[0:spokes-1])
   {
         rotate([0,0, (360/spokes)*i + 360 / (spokes*.8)])
            rotate_extrude(angle=360/spokes - 360 *.2 / spokes  , convexity=4)
               translate([d1/2- d3, 0, 0])
                  square([2,height]);
   }
}

module gap(offset, height, d1, d2, angle)
{
   rotate([0,0,offset])
      rotate_extrude(angle=angle-offset, convexity=4)
         translate([d1 / 2 - d2, 0, 0])
            square([4, height]);
   rotate([0, 0, angle ])
      translate([d1/2 - d2, 0, 0])
         cube([8,8,height]);

}

module end_stop(angle, d1, d2, height)
{
   rotate([0, 0, angle])
      translate([d1/2 , 0, 0])
         cylinder(h=height, d=d2);
}

module clicker2(height, d1, d2, stops)
{
   offset = 30;
   angle = 180 - 180 / stops;
   difference()
   {
      linear_extrude(height)
      {
         circle(d=d1);
      }
      gap(offset, height, d1, d2, angle);
      mirror([0,1,0])
      {
         gap(offset, height, d1, d2, angle);
      }
   }
   end_stop(angle, d1, d2, height);
   mirror([0,1,0])
      end_stop(angle, d1, d2, height);
}

module clicker_cutout(height, d1, d2, stops)
{
   cylinder(h=height, d=d1);
   for (i=[0:stops-1])
   {
      rotate([0,0,(360/stops)*i])
         translate([d1/2, 0, 0])
            cylinder(h=height, d=d2);
   }
}

//////////////////////////////////////////////////////////////////
/*
translate([200,-200,0])
   clicker_cutout(height=10, d1=60-.2, d2=6+.2, stops = 4);
*/
//translate([0,200,0])
//   clicker(height=10, d1=60, d2=40, d3=6, spokes=4);
/*
translate([200,200,0])
   clicker2(height=10, d1=60, d2=6, stops=4
   );
*/

translate([-200,0,0])
   base();

/*
translate([200,0,0])
   knob2(height=6, d1=42, d2=16, fillet=2);
   */
/*
shaft_cube = [shaft_width, shaft_width, shaft_length];
translate([(shaft_offset+shaft_width)/2, (shaft_offset+shaft_width)/2, -10])
{
   shaft(shaft_cube);

}
/*
/*
difference()
{
   tray();
   translate([(shaft_offset+shaft_width)/2, (shaft_offset+shaft_width)/2, -10])
   shaft(shaft_cube + shaft_tolerance);
}
*/
