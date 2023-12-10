h_tube = 20;
d_tube = 9.0;
r_round = 2;
wall_thickness = 1.3;
r_round_wall = wall_thickness/2;
h_cyl = h_tube - r_round_wall;

r_tor = d_tube/2 - r_round_wall;

d_screw_hole = 3.5;
len_srew = d_tube + 4;
d_groove = d_tube/2 + 2.2;
r_round_groove = 3;
width_screw = 3;
h_base = 1.8;

translate([0, 0, -20])
set_tube();
// washer_base();

module set_tube() {
  color("lime")
  spiral_quadro1();
  tube();
  translate([0, 0, -h_base/2])
  washer_base();
}

module washer_base() {
  difference() {
    cylinder(d=18, h=h_base, center=true, $fn=64);
    cylinder(d=d_tube-2*wall_thickness, h=5, center=true, $fn=64);
  }
}

// cube(7-0.5, true);
module tor() {
  translate([0, 0, r_round_wall])
  rotate_extrude($fn = 64)
  translate([r_tor, 0, 0])
  circle(r = r_round_wall, $fn = 32);
}

module tor_groove() {
  
  rotate_extrude($fn = 64)
  translate([d_groove, 0, 0])
  circle(r = r_round_groove, $fn = 32);
}


module base() {
    //translate([0, 0, r_round])
    cylinder(d = d_tube, h = h_cyl, $fn = 64 );    
}


module section() {
    difference() {
        square(r_round);
        translate([r_round, r_round, 0])
        circle(r = r_round, $fn = 32);
    }
}

module base2() {
    base();
    rotate_extrude($fn = 64)
    translate([d_tube/2, 0, 0])
    section();
}

module tube_inner() {
        translate([0, 0, -2])
        cylinder(d = d_tube - 2*wall_thickness, h = h_tube + 4, $fn = 64 );
}

module tube() {
    translate([0, 0, h_cyl - r_round_wall])
    tor();
    difference() {
        base2();
        tube_inner();
    }
}

module set_screw_holes() {
    rotate([90, 0, 0])
    cylinder(d = d_screw_hole, h = len_srew, center = true, $fn = 32);
    rotate([0, 90, 0])
    cylinder(d = d_screw_hole, h = len_srew, center = true, $fn = 32);
}

module tube_holed() {
    difference() {
        tube();
        translate([0, 0, h_cyl - d_screw_hole])
        set_screw_holes();
    }
}

module tube_grooved() {
    difference() {
        tube_holed();
        translate([0, 0, h_cyl - d_screw_hole])
        tor_groove();
    }
}


module rect_screw(){
  width_screw = 1;
  //rotate_extrude(angle=360)
  linear_extrude(h_tube-r_round_wall, center=false, twist = 2880, slices=400, scale=[1.0, 1.0], $fn=3)
//  linear_extrude(h_tube, center=false, twist = 360, slices=0, scale=1.0, $fn=30)
  //tanslate([0, -(width_screw/2 + d_tube/2 - 0.1)])
  translate([3, 0])
  square([3, 3], center=true);
}

module spiral_quadro1() {
  
  linear_extrude(height=h_tube-5*r_round_wall, twist=720, $fn=100, slices=300)
  section_spiral();
}

module section_spiral() {
  sqrt2 = sqrt(2);
  echo(sqrt2);
  delta = 0.7;
  d_screw = d_tube/2/sqrt2 - 0.0-delta;

  intersection() {  
    union() {
      translate([-d_screw, -d_screw])
      square(width_screw, true);
      mirror([1, 0])
      translate([-d_screw, -d_screw])
      square(width_screw, true);
      mirror([0, 1])
      translate([-d_screw, -d_screw])
      square(width_screw, true);
      mirror([1, 1])
      translate([-d_screw, -d_screw])
      square(width_screw, true);
    }
    difference() {   
      circle(d=d_tube+0.5*width_screw*sqrt2-delta*sqrt2, $fn=32);
      circle(d=d_tube-2*wall_thickness*sqrt2+0.4+delta*sqrt2, $fn=32);
    }
  }
}


//section_spiral();
//translate([0, 0, -25])
//color("lime")
//spiral_quadro1();
//base2();
//rect_screw();
//translate([0, 0, -25])
//tube();
//translate([0, 0, -2.5/2])
//washer_base();
//tube_grooved();
//tube_holed();
//translate([0, 0, 0])
//color("red")
//cylinder(d = d_tube, h = h_tube);
//base();

//translate([0, 0, h_tube])
//tor_groove();
//base();