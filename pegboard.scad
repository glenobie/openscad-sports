texts = ["a", "b", "c"];
blanks = ["","",""];


module column(length, width, height, font_height,
              spacing, margin, holes_left, hole_radius)
{

  difference()
  {
    union()
    {
      cube([width, length, height]);
      for (i=[0:len(texts)-1])
      {
        translate([margin+hole_radius*2+spacing, spacing + i*(spacing+font_height),height])
          linear_extrude(1)
            text(texts[i], font_height);
      }
    }
    for (i=[0:len(texts)-1])
    {
      translate([margin+hole_radius, hole_radius+spacing + i*(spacing+font_height),0])
        cylinder(h=height, r=hole_radius);
      }
  }
}

column(80, 40, 4, 8, 12, 4, true, 3);
