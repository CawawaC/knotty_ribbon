class TwoPoints {
  PVector l;
  PVector r;

  TwoPoints(PVector p1, PVector p2) {
    l = p1;
    r = p2;
  }

  String toString() {
    return "p1: " + l + " p2: " + r;
  }
}


class RibbonVertexPair extends TwoPoints {
  RibbonVertexPair(PVector p, float ribbon_width) {
    super(
      new PVector(p.x, p.y - ribbon_width/2, p.z), 
      new PVector(p.x, p.y + ribbon_width/2, p.z)
      );
  }
}
