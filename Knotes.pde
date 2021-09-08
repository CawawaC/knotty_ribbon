void draw_knot() {
  if (beta >= PI) {
    return;
  }

  //PVector p = knot_4(beta);
  //PVector p = knot_5(beta);
  PVector p = knot_trefoil(beta*2);

  beta += 0.001 * draw_speed;

  knot_points.add(p);
}

// a from 0 to TAU
PVector knot_trefoil(float u) {
  float x = 41*cos(u) - 18*sin(u) - 83*cos(2*u) - 83*sin(2*u) - 11*cos(3*u) + 27*sin(3*u);
  float y = 36*cos(u) + 27*sin(u) - 113*cos(2*u) + 30*sin(2*u) + 11*cos(3*u) - 27*sin(3*u);
  float z = 45*sin(u) - 30*cos(2*u) + 113*sin(2*u) - 11*cos(3*u) + 27*sin(3*u);

  return new PVector(x, y, z);
}

// where 0 < u < (4*k + 2) * PI;
PVector knot_cinquefoil(float u, float k) {
  float x = cos(u) * (2 - cos(2*u/(2*k + 1)));
  float y = sin(u) * (2 - cos(2*u/(2*k + 1)));
  float z = -sin(2*u/(2*k + 1));

  return new PVector(x, y, z).mult(100);
}

// b from 0 to PI
PVector knot_4(float b) {
  float r = (0.8 + 1.6 * sin(6 * b)) * 100;
  float theta = 2 * b;
  float phi = 0.6 * PI * sin(12 * b);
  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return new PVector(x, y, z);
}


PVector knot_5(float b) {
  float r = 1.2 * 0.6 * sin(0.5 * PI + 6 * b);
  r *= 300;
  float theta = 4 * b;
  float phi = 0.2 * PI * sin(6 * b);
  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return  new PVector(x, y, z);
}

PVector knot_chaos(float b) {
  float r = 0.7 * sin(0.5 * PI * b);
  float theta = 4 * b;
  float phi = 0.2 * PI * sin(6 + b);

  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return new PVector(x, y, z).mult(30);
}

PVector knotty_boy(float t) {
  float v1 = 2;
  float v2 = 3;
  float R0 = 100;
  float R1 = 20;

  float r = R0 + R1 * sin(TAU * v1 * t);
  float x = r * sin(TAU * v2 * t);
  float y = r * cos(TAU * v2 * t);
  float z = r * cos(TAU * v1 * t);

  return new PVector(x, y, z);
}

// p and q must be coprime: no common divisor except 1.
// And 2 <= p < q
// [2, 3], [2, 5], [3, 5]...
PVector torus_knot(float t, int p, int q) {
  float R = 300;   // the radius of the torus (dunno which radius that is)
  float x = cos(p*t) + R * cos(p*t) * cos(q*t);
  float y = sin(p*t) + R * sin(p*t) * cos(q*t);
  float z = R * sin(q*t);

  return new PVector(x, y, z);
}
