digits_9 = ["9", "8", "7", "6", "5", "4", "3", "2", "1","0"];
blanks_9 = ["","","","","","","","","",""];
digits_10 = ["0", "10", "20"];
blanks_10 = ["","",""];
blank = [""];

HEIGHT = 7;
space_between = 150;

visitor_width = 74;
home_width = 52;

module row(texts, length, width, height, font_height,
              h_spacing, v_spacing, margin, holes_bottom, hole_radius, hole_depth,
              title_width, title, right_justified=false)
{
  title_x = right_justified ? margin + (hole_radius*2 + h_spacing)*len(texts) : margin;
  start_hole = right_justified ? margin : margin+title_width+h_spacing;
  difference()
  {
    union()
    {
      cube([width, length, height]);
      translate([title_x, v_spacing, height])
        linear_extrude(1)
          text(title, font_height, valign="center", halign="left");
      for (i=[0:len(texts)-1])
      {
        translate([start_hole + hole_radius + i*(h_spacing),
                  v_spacing+hole_radius*2,height])
          linear_extrude(1)
            text(texts[i], font_height, halign="center");
      }
    }
    for (i=[0:len(texts)-1])
    {
      translate([start_hole+hole_radius + i*(h_spacing),v_spacing, height-hole_depth])
        cylinder(h=height, r=hole_radius);
      }
  }
}

module column(texts, length, width, height, font_height,
              h_spacing, v_spacing, margin,
              holes_left, hole_radius, hole_depth, title)
{
  difference()
  {
    union()
    {
      cube([width, length, height]);
      for (i=[0:len(texts)-1])
      {
        translate([margin+hole_radius*2+h_spacing, v_spacing + i*(v_spacing+font_height),height])
          linear_extrude(1)
            text(texts[i], font_height, halign="center");
      }
      translate([margin+hole_radius, v_spacing + len(texts)*(v_spacing+font_height),height])
        linear_extrude(1)
          text(title, font_height, halign="center");
    }
    for (i=[0:len(texts)-1])
    {
      translate([margin+hole_radius, hole_radius+v_spacing + i*(v_spacing+font_height),height-hole_depth])
        cylinder(h=height, r=hole_radius);
      }
  }
}


module PF()
{

  column(digits_9, length=142, width=28, height=HEIGHT , font_height=8,
         h_spacing=9, v_spacing=5, margin=4, holes_left=true, hole_radius=3, hole_depth=6,title="P");
  translate([28,0,0])
    column(blanks_9, length=142, width=10, height=HEIGHT , font_height=8,
      h_spacing=9, v_spacing=5, margin=0, holes_left=true, hole_radius=3, hole_depth=6,title="F");

  translate([0,142,0])
    column(digits_10, length=44, width=28, height=HEIGHT , font_height=8,
           h_spacing=9, v_spacing=5, margin=4, holes_left=true, hole_radius=3, hole_depth=6,title="");
  translate([28,142,0])
             column(blanks_10, length=44, width=10, height=HEIGHT , font_height=8,
               h_spacing=9, v_spacing=5, margin=0, holes_left=true, hole_radius=3, hole_depth=6,title="");
}

card_width = 40;
card_height = 70;
card_thickness = .6;

wall_thickness = 1.6;
base_thickness = 1.6;

short_side_height = card_height *2/3;

overhang = 2;

padding_width = .2;
padding_per_card = .05;

side_width = wall_thickness*2+padding_width*2 + card_width;
tray_depth = wall_thickness*3  + (padding_per_card + card_thickness)*10;
tray_height = wall_thickness + card_height;

tray_core_width = 4;


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
      mirror([1, 0, 0]) left_edge(short_side_height);
   //back wall
   translate([0, tray_depth - wall_thickness, 0])
      cube([side_width, wall_thickness, short_side_height]);

}

module tray()
{
   union(){
      mirror([1,0,0])
         translate([0,0, 0])
            tray_side();
      translate([tray_core_width, 0, 0])
         tray_side();
      cube([tray_core_width, tray_depth, tray_height]);
   }
}


PF_width = 38;
PF();
translate([PF_width+space_between, 0, 0])
  PF();

m = 4; // margin
r = 3; // radius
h = 2; // horizontal space

translate([PF_width,0,0])
   row(blank, length=18, width=visitor_width, height=HEIGHT , font_height=8,
         h_spacing=h, v_spacing=8, margin=m, holes_bottom=true, hole_radius=r, hole_depth=6,
         title_width=54, title="VISITORS", right_justified=true);
translate([PF_width + space_between - home_width , 0, 0])
   row(blank, length=18, width=home_width, height=HEIGHT , font_height=8,
         h_spacing=h, v_spacing=8, margin=m, holes_bottom=true, hole_radius=r, hole_depth=6,
         title_width=34, title="HOME", right_justified=false);

leftover_space = space_between - visitor_width - home_width ;

translate([PF_width + visitor_width, 0 , 0])
   cube([leftover_space, 18, HEIGHT]);

translate([PF_width, 142, 0])
   cube([space_between, 44,HEIGHT]);

translate([-60,0,0])
   tray();
