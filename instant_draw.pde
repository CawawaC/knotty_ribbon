void instant_draw() {
  if (angle_resolution <= 0) {
    print("Keep angle_resolution above 0");
    return;
  }

  float N = TAU * angle_resolution;
  float r = 200;
  float angle = 0;

  float ribbon_length = 0;
  PVector prev_p1 = null;

  

  //rotateX(PI/3);
  beginShape(TRIANGLE_STRIP);
  switch(texture_type) {
  case Bismuth:
    texture(bismuth_texture.pg);
    noFill();
    break;

  default:
    break;
  }
  
  while (angle < TAU) {
    float twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists
    float mo = check_for_moebius(twistiness);

    PVector knot_p = get_knot_p(knot_type, angle);
    if (knot_p == null) {
      print("Unhandled knot type: " + knot_type);
      return;
    }


    // Generate next pair of vertices
    float x1 = knot_p.x;
    float y1 = knot_p.y + ribbon_width * sin(twist)/2;
    float z1 = knot_p.z + ribbon_width * cos(twist) 
      + ribbon_width*angle/TAU * mo;

    float x2 = knot_p.x;
    float y2 = knot_p.y - ribbon_width * sin(twist)/2;
    float z2 = knot_p.z + ribbon_width * sin(twist) 
      + ribbon_width*angle/TAU * mo;


    PVector p1 = new PVector(x1, y1, z1);
    PVector p2 = new PVector(x2, y2, z2);

    //fill(lerpColor(ribbon_gradient[0], ribbon_gradient[1], i/N));
    if (texture_type == TextureType.Gradient) 
      fill(getColor(a, b, c, d, angle/TAU*2));
      
    paintVertex(p1, p2, angle/TAU);

    angle += 1 / angle_resolution;

    if (prev_p1 != null) ribbon_length += p1.dist(prev_p1);
    prev_p1 = p1;
  }
  //println("ribbon length: " + ribbon_length);

  endShape(CLOSE);
}
