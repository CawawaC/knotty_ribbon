class RibbonBuilder {
  Path path;
  float ribbonWidth;
  
  RibbonBuilder(Path p, float rw) {
    path = p;
    ribbonWidth = rw;
  }
  
  RibbonVertexPair[] build_points() {
    int N = path.points_n;
    RibbonVertexPair[] points = new RibbonVertexPair[N];
    for (int i = 0; i < N; i++) {
      PVector p = path.points[i];
      points[i] = new RibbonVertexPair(p, ribbonWidth);
    }
    
    return points;
  }
}
