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

class CrossPair extends TwoPoints {
  
  // Expects:
  // p: reference path point
  // cross: the cross vector to the ribbon in that point (cross being the vector orthogonal to the plane defined by the aim and normal vectors).
  // rw: ribbon width
  CrossPair(PVector p, PVector cross, float rw) {   
    super(null, null);
    
    PVector crossScaled = cross.copy().mult(rw/2);
    l = p.copy().sub(crossScaled);
    r = p.copy().add(crossScaled);
  }
}
