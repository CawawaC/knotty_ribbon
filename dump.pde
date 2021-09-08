
void draw_ribbon() {
  float angle = 0;
  float r = 100;

  beginShape(TRIANGLE_STRIP);

  while (angle < TAU) {
    float x = r * cos(angle);
    float y = r * sin(angle);

    vertex(x + noise(frameCount/10), y, 0);
    vertex(x, y, ribbon_width);

    angle += 0.01;
  }
  endShape(CLOSE);
}

void draw_knotty_ribbon() {
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

    PVector knot_p = knot_4(angle);

    float x1 = knot_p.x;
    float y1 = knot_p.y + ribbon_width * sin(twist)/2;
    float z1 = knot_p.z + ribbon_width * cos(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    float x2 = knot_p.x;
    float y2 = knot_p.y - ribbon_width * sin(twist)/2;
    float z2 = knot_p.z + ribbon_width * sin(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists

    //stroke(255, sin(angle)*255, 123);

    vertex(x1, y1, z1);
    vertex(x2, y2, z2);

    angle += 1/angle_resolution;
  }

  endShape(CLOSE);
}
