void instant_draw() {
  if (angle_resolution <= 0) {
    print("Keep angle_resolution above 0");
    return;
  }

  float N = TAU * angle_resolution;
  float r = 200;
  float angle = 0;

  rotateX(PI/3);
  beginShape(TRIANGLE_STRIP);
  while (angle < TAU) {
    float twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists
    float moebius_offset = 0;
    if (twistiness % 2 == 1) {
      moebius_offset = 1;
    }  // See if we're moebius twisting (top and bottom of the ribbon end up switching)


    //PVector knot_p = knot_trefoil(angle);
    //PVector knot_p = knot_cinquefoil(5*angle, 2);
    //PVector knot_p = knot_5(angle);
    PVector knot_p = knot_chaos(angle);
    //PVector knot_p = knot_chaos_randomized(angle);
    //PVector knot_p = knotty_boy(angle);
    //PVector knot_p = torus_knot(angle, 2, 3);


    float x1 = knot_p.x;
    float y1 = knot_p.y + ribbon_width * sin(twist)/2;
    float z1 = knot_p.z + ribbon_width * cos(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    float x2 = knot_p.x;
    float y2 = knot_p.y - ribbon_width * sin(twist)/2;
    float z2 = knot_p.z + ribbon_width * sin(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    PVector p1 = new PVector(x1, y1, z1);
    PVector p2 = new PVector(x2, y2, z2);

    //fill(lerpColor(ribbon_gradient[0], ribbon_gradient[1], i/N));
    fill(getColor(a, b, c, d, angle/TAU));
    vertex(p1.x, p1.y + noise(frameCount/118.2, angle/TAU)*50*angle/TAU, p1.z);
    vertex(p2.x, p2.y + noise(frameCount/100.0, angle/TAU)*50*angle/TAU, p2.z);



    angle += 1 / angle_resolution;
  }
  endShape(CLOSE);
}
