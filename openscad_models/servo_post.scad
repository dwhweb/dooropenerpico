module servo_post(dimensions) {
  hole_diameter = 3.4;

  difference() {
    cube(dimensions); // Main body
    translate([-1, -1, 15.7]) cube([12, 2.2, 2]); // Slot for servo
    translate([4.7, -1, 11.7]) hole();
    translate([4.7, -1, 21.45]) hole();
  }

  module hole() {
    rotate([-90, 0, 0]) {
      cylinder(h=12, d=hole_diameter);
      translate([0, 0, 0.99]) cylinder(h=1, d1=4.6, d2=hole_diameter); // Countersunk portion
    }
  }
}

