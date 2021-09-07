class Polar {
  float r, phi, theta;

  Polar(float r, float p, float t) {
    this.r = r;
    this.phi = p;
    this.theta = t;
  }
}

// a from 0 to TAU
PVector knot_trefoil(float u) {
  float x = 41*cos(u) - 18*sin(u) - 83*cos(2*u) - 83*sin(2*u) - 11*cos(3*u) + 27*sin(3*u);
  float y = 36*cos(u) + 27*sin(u) - 113*cos(2*u) + 30*sin(2*u) + 11*cos(3*u) - 27*sin(3*u);
  float z = 45*sin(u) - 30*cos(2*u) + 113*sin(2*u) - 11*cos(3*u) + 27*sin(3*u);

  return new PVector(x, y, z);
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
