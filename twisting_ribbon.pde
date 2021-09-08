void draw_twisting_ribbon() {
  if (angle_resolution <= 0) {
    print("Keep angle_resolution above 0");
    return;
  }

  float angle = 0;
  float r = 200;
  float twist = 0;
  float moebius_offset = 0;

  if (twistiness % 2 == 1) {
    moebius_offset = 1;
  }  // See if we're moebius twisting (top and bottom of the ribbon end up switching)

  beginShape(TRIANGLE_STRIP);
  while (angle < TAU) {
    float x1 = r * cos(angle);
    float y1 = r * sin(angle) + ribbon_width * sin(twist)/2;
    float z1 = ribbon_width * cos(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    float x2 = r * cos(angle);
    float y2 = r * sin(angle) - ribbon_width * sin(twist)/2;
    float z2 = ribbon_width * sin(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists

    stroke(255, sin(angle)*255, 123);

    vertex(x1, y1, z1);
    vertex(x2, y2, z2);

    angle += 1/angle_resolution;
  }

  endShape(CLOSE);
}
