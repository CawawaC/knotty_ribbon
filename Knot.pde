class Path {
  private PVector[] points;
  private int points_n;

  Path() {
  }

  void generate_points(int N) {
    points_n = N;
    points = new PVector[N+1];
    for (int i = 0; i < N; i+=1) {
      PVector p = getPoint((float)i/points_n*TAU);
      points[i] = p;
    }
    points[N] = points[0];
  }

  PVector getPoint(float angle) {
    return new PVector(0, 0, 0);
  }

  float getLength() {
    float l = 0;
    PVector prev = null;
    for (PVector p : points) {
      if (prev != null)
        l += p.copy().sub(prev).mag();
      prev = p;
    }
    return l;
  }

  void randomize() {
  }
}

class Strip extends Path {
  PVector getPoint(float angle) {
    return new PVector((angle-PI) * 200, angle*20, 0);
  }
}

class Squiggle extends Path {
  PVector getPoint(float angle) {
    return new PVector((angle-PI) * 100, sin(angle) * 50, cos(angle*2) * 100);
  }
}

class RandomSquiggle extends Path {
  float ya, yb, za, zb, zc;

  RandomSquiggle() {
    ya = random(0.5, 5);
    yb = random(5, 150);
    za = random(0.5, 5);
    zb = random(5, 150);
    zc = random(10, 50);

    // param set for a 800x80
    ya = random(0.5, 5);
    yb = random(5, 20);
    za = random(0.5, 5);
    zb = random(5, 20);
    zc = random(10, 20);
  }

  PVector getPoint(float angle) {
    return (new PVector((angle-PI) /TAU * 800, sin(ya*angle) * yb, cos(za*angle) * zb + zc)).mult(1);
  }
}


class Knot extends Path {
  PVector sphericalToCartesian(float r, float phi, float theta) {
    float x = r * cos(phi) * cos(theta);
    float y = r * cos(phi) * sin(theta);
    float z = r * sin(phi);
    return new PVector(x, y, z);
  }
}

Knot getKnotFromEnum(Knots k) {
  switch(k) {
  case Circle: 
    return new Circle();

  case  Trefoil: 
    return new Trefoil();

  case Cinquefoil:
    return new Cinquefoil(2);

  case Torus:
    return new Torus(11, 15, 200, 50);

  case RandomKnot:
    return new RandomKnot();

  default: 
    return null;
  }
}

enum Knots { 
  Circle, Trefoil, Cinquefoil, Torus, RandomKnot
};

class Circle extends Knot {
  PVector getPoint(float angle) {
    return new PVector(cos(angle) * 200, 0, sin(angle) * 200).mult(2);
  }
}


class Trefoil extends Knot {
  PVector getPoint(float t) {
    float x = 41*cos(t) - 18*sin(t) - 83*cos(2*t) - 83*sin(2*t) - 11*cos(3*t) + 27*sin(3*t);
    float y = 36*cos(t) + 27*sin(t) - 113*cos(2*t) + 30*sin(2*t) + 11*cos(3*t) - 27*sin(3*t);
    float z = 45*sin(t) - 30*cos(2*t) + 113*sin(2*t) - 11*cos(3*t) + 27*sin(3*t);

    return new PVector(x, y, z);
  }
}

class Cinquefoil extends Knot {
  int k;

  Cinquefoil(int k) {
    this.k = k;
  }

  // (t, k) where t ranges from 0 to (2*k+1)*TAU, k int
  // Examples: (5*angle, 2), (7*angle, 3)
  PVector getPoint(float t) {
    t *= 2*k+1;

    float x = cos(t) * (2 - cos(2*t/(2*k + 1)));
    float y = sin(t) * (2 - cos(2*t/(2*k + 1)));
    float z = -sin(2*t/(2*k + 1));

    return new PVector(x, z, y).mult(119);
  }
}

class CinquefoilXYZ extends Knot {
  int k;

  CinquefoilXYZ(int k) {
    this.k = k;
  }

  // (t, k) where t ranges from 0 to (2*k+1)*TAU, k int
  // Examples: (5*angle, 2), (7*angle, 3)
  PVector getPoint(float t) {
    t *= 2*k+1;

    float x = cos(t) * (2 - cos(2*t/(2*k + 1)));
    float y = sin(t) * (2 - cos(2*t/(2*k + 1)));
    float z = -sin(2*t/(2*k + 1));

    return new PVector(x, y, z).mult(119);
  }
}

class Knot4 extends Knot {
  PVector getPoint(float t) {
    float r = (0.8 + 1.6 * sin(6 * t)) * 100;
    float theta = 2 * t;
    float phi = 0.6 * PI * sin(12 * t);

    return sphericalToCartesian(r, phi, theta);
  }
}

class Knot5 extends Knot {
  PVector getPoint(float t) {
    float r = 1.2 * 0.6 * sin(0.5 * PI + 6 * t);
    r *= 300;
    float theta = 4 * t;
    float phi = 0.2 * PI * sin(6 * t);

    return sphericalToCartesian(r, phi, theta);
  }
}

class Torus extends Knot {
  float p, q;
  float torusRadius, tubeRadius;

  // p and q must be coprime: no common divisor except 1.
  // And 2 <= p < q
  // [2, 3], [2, 5], [3, 5]...
  Torus(int p, int q, float to, float tu) {
    this.p = p;
    this.q = q;
    torusRadius = to;
    tubeRadius = tu;
  }


  PVector getPoint(float t) {
    float R = 200;   // scale

    float x = cos(p*t) * (torusRadius + tubeRadius * cos(q*t));
    float y = sin(p*t) * (torusRadius + tubeRadius * cos(q*t));
    float z = tubeRadius * sin(q*t);

    return new PVector(x, y, z);
  }
}

class RandomKnot extends Knot {
  float[] rr;
  float[] thetar;
  float[] phir;
  int N = 3;

  RandomKnot() {
    rr = thetar = phir = new float[N];
    randomize();
  }

  PVector getPoint(float t) {
    //t = t/2.5;
    float r = rr[0] * sin(rr[1] * t) + rr[2];
    float theta = thetar[0] * cos(thetar[1] * t) + thetar[2];
    float phi = phir[0] * sin(phir[1] * t) + phir[2];

    float x = r * cos(phi) * cos(theta);
    float y = r * cos(phi) * sin(theta);
    float z = r * sin(phi);

    return sphericalToCartesian(r, phi, theta).mult(80);
  }

  void randomize() {
    for (int i = 0; i < N; i++) {
      rr[i] = random(0, 10);
      thetar[i] = random(0, 10);
      phir[i] = random(0, 10);
    }
  }
}
