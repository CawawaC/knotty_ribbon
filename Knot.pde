class Path {
  PVector[] points;
  int points_n;

  Path() {
  }

  void generate_points(int N) {
    points_n = N+1;
    points = new PVector[points_n];
    for (int i = 0; i < points_n; i++) {
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
        l += p.sub(prev).mag();
      prev = p;
    }
    return l;
  }
}

class Strip extends Path {
  PVector getPoint(float angle) {
    return new PVector((angle-PI) * 200, angle*20, 0);
  }
}


class Knot extends Path {
}

class Circle extends Knot {
  PVector getPoint(float angle) {
    return new PVector(cos(angle) * 200, 0, sin(angle) * 200);
  }
}


class Trefoil extends Knot {
  PVector getPoint(float t) {
    float x = 41*cos(t) - 18*sin(t) - 78*cos(2*t) - 83*sin(2*t) - 11*cos(3*t) + 27*sin(103*t);
    float y = -48*cos(t) + 95*sin(t) - 22*cos(2*t) + 30*sin(2*t) + 11*cos(3*t) - 77*sin(-25*t);
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
