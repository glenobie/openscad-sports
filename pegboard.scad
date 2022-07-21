digits_9 = ["9", "8", "7", "6", "5", "4", "3", "2", "1","0"];
blanks_9 = ["","","","","","","","","",""];
digits_10 = ["0", "10", "20"];
blanks_10 = ["","",""];

blank = [""];

module row(texts, length, width, height, font_height,
              h_spacing, v_spacing, margin, holes_bottom, hole_radius,
              title_width, title)
{
  difference()
  {
    union()
    {
      cube([width, length, height]);
      translate([margin, v_spacing, height])
        linear_extrude(1)
          text(title, font_height, valign="center", halign="left");
      for (i=[0:len(texts)-1])
      {
        translate([margin+title_width+hole_radius+ i*(h_spacing),
                  v_spacing+hole_radius*2,height])
          linear_extrude(1)
            text(texts[i], font_height, halign="center");
      }
    }
    for (i=[0:len(texts)-1])
    {
      translate([margin+title_width+hole_radius + i*(h_spacing),v_spacing,0])
        cylinder(h=height, r=hole_radius);
      }
  }
}

module column(texts, length, width, height, font_height,
              h_spacing, v_spacing, margin, holes_left, hole_radius, title)
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
      translate([margin+hole_radius, hole_radius+v_spacing + i*(v_spacing+font_height),0])
        cylinder(h=height, r=hole_radius);
      }
  }
}


module PF()
{

  column(digits_9, length=132, width=28, height=4, font_height=8,
         h_spacing=9, v_spacing=4,margin=4, holes_left=true, hole_radius=3, title="P");
  translate([28,0,0])
    column(blanks_9, length=132, width=10, height=4, font_height=8,
      h_spacing=9, v_spacing=4, margin=0, holes_left=true, hole_radius=3, title="F");

  translate([0,132,0])
    column(digits_10, length=44, width=28, height=4, font_height=8,
           h_spacing=9, v_spacing=4, margin=4, holes_left=true, hole_radius=3, title="");
  translate([28,132,0])
             column(blanks_10, length=44, width=10, height=4, font_height=8,
               h_spacing=9, v_spacing=4, margin=0, holes_left=true, hole_radius=3, title="");
}

//PF();
//translate([100,0,0])
//  PF();

row(blank, length=28, width=164, height=4, font_height=8,
       h_spacing=12, v_spacing=8, margin=4, holes_bottom=true, hole_radius=3,
       title_width=40, title="HOME");
