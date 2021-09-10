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

void draw_knotty_ribbon_progressive() {
  if (angle_resolution <= 0) {
    print("Keep angle_resolution above 0");
    return;
  }

  float N = TAU * angle_resolution;
  float r = 200;
  float angle = frameCount/angle_resolution;

  if (angle < TAU) {
    float   twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists
    float moebius_offset = 0;
    if (twistiness % 2 == 1) {
      moebius_offset = 1;
    }  // See if we're moebius twisting (top and bottom of the ribbon end up switching)


    PVector knot_p = knot_trefoil(angle);

    float x1 = knot_p.x;
    float y1 = knot_p.y + ribbon_width * sin(twist)/2;
    float z1 = knot_p.z + ribbon_width * cos(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    float x2 = knot_p.x;
    float y2 = knot_p.y - ribbon_width * sin(twist)/2;
    float z2 = knot_p.z + ribbon_width * sin(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    ribbon_points.add(new PVector(x1, y1, z1));
    ribbon_points.add(new PVector(x2, y2, z2));
  }


  beginShape(TRIANGLE_STRIP);
  for (int i = 0; i < ribbon_points.size(); i += 2) {
    PVector p1 = ribbon_points.get(i);
    PVector p2 = ribbon_points.get(i+1);

    //fill(lerpColor(ribbon_gradient[0], ribbon_gradient[1], i/N));
    fill(crazyInigo(a, b, c, d, i/N));
    vertex(p1.x, p1.y, p1.z);
    vertex(p2.x, p2.y, p2.z);
  }

  endShape(CLOSE);
}
