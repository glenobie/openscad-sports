CARD = [60, 1, 90];

TOLERANCE = [.2, .2, .2];

BASE = [80,20, 1];
BASE_HEIGHT = 14;

slot =  CARD + TOLERANCE;

FRAME_OVERHANG = [2, 0, 2];
WALL = [2, 2, 2];


module window()
{
    cube(slot - FRAME_OVERHANG*2 +[0,WALL[1]*2, 0]);
}

module sleeve()
{
    difference()
    {
        cube(slot+WALL*2);
        translate([WALL[0], WALL[1], WALL[2]])
            cube(slot + [0, 0, WALL[2]]);
        translate([WALL[0] + FRAME_OVERHANG[0], 0, WALL[2]*2 + FRAME_OVERHANG[2]*2])
                window();
    }
}

hull()
{
    translate([ -(BASE[0] - (CARD[0] + TOLERANCE[0] + WALL[0]*2)) / 2 ,
                -(BASE[1] - (CARD[1] + TOLERANCE[1] + WALL[1]*2)) / 2 ,
                -BASE_HEIGHT])
        cube(BASE);
    translate([0,0,-1])
        cube([CARD[0] + TOLERANCE[0] + WALL[0]*2, CARD[1]+TOLERANCE[1]+WALL[1]*2, 1]);

}

sleeve();


