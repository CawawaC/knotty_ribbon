class RibbonVertexPair {
  PVector l;
  PVector r;
  
  RibbonVertexPair(PVector p, float ribbon_width) {
    l = new PVector(p.x, p.y - ribbon_width/2, p.z);
    r = new PVector(p.x, p.y + ribbon_width/2, p.z);
  }
  
  String toString() {
    return "p1: " + l + " p2: " + r;
  }
}
