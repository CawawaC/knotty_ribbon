// Formulas for harmonic knots: knots defined by (x, y, z)
// noob definition: a mathematical knot is a closed piece of string twisted on itself.
// Sources :   http://paulbourke.net/geometry/knots/
//             Ideal Knots by Andrzej Stasiak, Vsevolod Katritch, Louis H. Kauffman



// u from 0 to TAU
PVector knot_trefoil(float t) {
  float x = 41*cos(t) - 18*sin(t) - 78*cos(2*t) - 83*sin(2*t) - 11*cos(3*t) + 27*sin(103*t);
  float y = -48*cos(t) + 95*sin(t) - 22*cos(2*t) + 30*sin(2*t) + 11*cos(3*t) - 77*sin(-25*t);
  float z = 45*sin(t) - 30*cos(2*t) + 113*sin(2*t) - 11*cos(3*t) + 27*sin(3*t);

  return new PVector(x, y, z);
}

// where 0 < u < (4*k + 2) * PI;
PVector knot_cinquefoil(float t, float k) {
  float x = cos(t) * (2 - cos(2*t/(2*k + 1)));
  float y = sin(t) * (2 - cos(2*t/(2*k + 1)));
  float z = -sin(2*t/(2*k + 1));

  return new PVector(x, y, z).mult(100);
}

// b from 0 to PI
PVector knot_4(float t) {
  float r = (0.8 + 1.6 * sin(6 * t)) * 100;
  float theta = 2 * t;
  float phi = 0.6 * PI * sin(12 * t);

  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return new PVector(x, y, z);
}


PVector knot_5(float t) {
  float r = 1.2 * 0.6 * sin(0.5 * PI + 6 * t);
  r *= 300;
  float theta = 4 * t;
  float phi = 0.2 * PI * sin(6 * t);
  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return  new PVector(x, y, z);
}

PVector knot_chaos(float t) {
  float r = 2 * sin(0.5 * PI * t);
  float theta = 49 * cos(t * 0.9);
  float phi = 0.2 * PI * sin(6 + t);

  //float r = 2.0 * sin(1.4 * b + 0.1*b) + 1.0 * cos(2.5 * b + 1.9*b + 1.5*pow(b, 2)) + 0.1;
  //float theta = 11.4 * cos(b * 1.2) + 5.0;
  //float phi = 1.7 * sin(-2 + b) + -1.1;

  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return new PVector(x, y, z).mult(300);
}

PVector knot_randomized(float t) {
  println("e: ", e);
  println("f: ", f);
  println("g: ", g);

  float r = e * sin(f * PI * t);
  float theta = f * cos(t * g);
  float phi = g * PI * sin(e + t);

  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return new PVector(x, y, z).mult(300);
}

PVector knotty_boy(float t, float v1, float v2) {
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
PVector torus_knot(float t, int p, int q, float torus_radius, float tube_radius) {
  float R = 200;   // scale

  float x = cos(p*t) * (torus_radius + tube_radius * cos(q*t));
  float y = sin(p*t) * (torus_radius + tube_radius * cos(q*t));
  float z = tube_radius * sin(q*t);

  return new PVector(x, y, z).mult(R);
}

PVector knot_generic(float t) {
  // r, theta and phi are values for spherical coordinates
  // and functions of the angle b
  float r = 2.6 * sin(1.6 * t) * 178;
  float theta = cos(t*0.9) * 2.2;
  float phi = 19 * cos(t) + sin(t*2);

  // There has to be a condition for the path to close
  // (otherwise it's not a knot in the mathematical sense)
  // But I haven't understood it yet
  // Looks nicer with trigonometric functions of b thrown in.

  // Conversion to cartesian coordinates
  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  // Vector is scaled
  return new PVector(x, y, z);
}

// Not functional
PVector knot_lissajous(float t) {
  PVector lissa = new PVector(1, 1, 1.5);
  PVector lissk = new PVector(2, 3, 0.7);
  PVector lissl = new PVector(0, 0.5, 0.8);

  float x = lissa.x * cos(lissk.x*t + lissl.x);
  float y = lissa.y * cos(lissk.y*t + lissl.y);
  float z = lissa.z * cos(lissk.z*t + lissl.z);

  return new PVector(x, y, z).mult(200);
}

// Very pretty one
PVector knot_figure_eight(float t) {
  float x = cos(t) + cos(3*t);
  float y = 0.6*sin(t) + sin(3*t);
  float z = 0.4 * sin(3*t) - sin(6*t);

  return new PVector(x, z, y).mult(200); // flipped coordinates, looks nicer with the ribbon: bends happen... better
}

// f1 and f2 are consecutive values in the fibonacci series
// Series: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ...
PVector fibonacci_knot(float t, float f1, float f2) {
  float f3 = f1 + f2;

  float x = cos(f1*t);
  float y = cos(f2*t + .5);
  float z = 0.5 * cos(f3*t + 0.5) + 0.5*sin(f2*t + 0.5);

  return new PVector(x, z, z).mult(200);
}

PVector knot_toupie(float t) {
  float r = 2.6 * sin(1.6 * t);
  float theta = cos(t*5.9) * 21.2;
  float phi = 1.9 * sin(t);

  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  return new PVector(x, y, z).mult(200);
}

/// 
/// Some nice-looking coordinates I found
///

// Cool spiral
//float r = 2 * sin(0.5 * PI * b);
//float theta = 49 * cos(b * 0.9);
//float phi = 0.2 * PI * sin(6 + b);

// Alex the Great is still solving this one
//float r = 2.6 * sin(1.6 * b) * 100;
//float theta = cos(b*5.9) * 2.2;
//float phi = 19 * cos(b);

// ZARD0Z!
//PVector knot_p = torus_knot(angle, 6, 4, 2, -2.0);
