use <gear_generator.scad>

module servo_gear(mm_per_tooth=5, gear_teeth=18, gear_thickness=10, gear_hole_diameter=2, servo_horn_height=3.7) {
  gear_hollow_bottom = gear_thickness / 2 - servo_horn_height - 2; // Extra 2mm so screw engages properly with servo

  translate([0, 0, gear_thickness / 2]) {
    difference() {
      gear(mm_per_tooth, gear_teeth, gear_thickness, gear_hole_diameter);
      translate([0, 0, gear_hollow_bottom]) cylinder(h=servo_horn_height + 3, d=20); // Extra 2mm so screw engages properly with servo, 1mm above the top of gear
    }
  }
}

servo_gear();
