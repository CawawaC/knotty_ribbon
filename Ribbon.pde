class Ribbon {
  int ribbonWidth = 80;
  int ribbonLength;
  RibbonVertexPair[] points;
  float angle_resolution = 200;

  Path path;

  InigoPalette palette;

  Ribbon(int w) {
    ribbonWidth = w;
    setPath(new Cinquefoil(4));
    palette = new InigoPalette();  

    println("length:", ribbonLength);
    println("points N:", points.length);
  }

  void build_points() {
    int N = path.points_n;
    points = new RibbonVertexPair[N];
    for (int i = 0; i < N; i++) {
      PVector p = path.points[i];
      points[i] = new RibbonVertexPair(p, ribbonWidth);
    }
  }

  void draw() {
    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < points.length; i++) {
      noStroke();
      color c = palette.getColor((float)i/points.length);
      fill(c);

      RibbonVertexPair vp = points[i];
      paintVertex(vp.l, vp.r);
    }
    endShape(CLOSE);
  }

  void paintVertex(PVector p1, PVector p2) {
    vertex(p1.x, p1.y, p1.z);
    vertex(p2.x, p2.y, p2.z);
  }
  
  void setPath(Path p) {
    int N = ceil(TAU * angle_resolution);
    path = p;
    path.generate_points(N); 
    build_points();
    ribbonLength = (int)path.getLength();
  }
}

class ProgressiveRibbon extends Ribbon {
  float t = 0;  // goes from 0 to 1 to represent ribbon drawing percentage
  float speed; // length per second
  float startTime;  // seconds

  ProgressiveRibbon(int w, float s) {
    super(w);
    speed = s;
    startTime = millis()/1000;
  }

  void draw() {
    float time = millis()/1000.0;
    float currentLength = (time-startTime) * speed;
    float t = currentLength / ribbonLength;
    t = min(t, 1);

    beginShape(TRIANGLE_STRIP);
    for (int i = 0; i < floor(t * points.length); i++) {
      noStroke();
      color c = palette.getColor((float)i/points.length);
      fill(c);

      RibbonVertexPair vp = points[i];
      paintVertex(vp.l, vp.r);
    }
    endShape(CLOSE);
  }

  void reset() {
    startTime = millis()/1000;
  }
}

class TexturedRibbon extends Ribbon {
  ClusteredBismuth tex;

  TexturedRibbon(int w) {
    super(w);
  }

  void setTexture(ClusteredBismuth t) {
    tex = t;
  }

  void draw() {
    beginShape(TRIANGLE_STRIP);
    texture(tex.pg);

    for (int i = 0; i < points.length; i++) {
      noStroke();
      color c = palette.getColor((float)i/points.length);
      //fill(c);

      RibbonVertexPair vp = points[i];
      paintVertex(vp.l, vp.r, (float)i/points.length);
    }
    endShape(CLOSE);
  }

  void paintVertex(PVector p1, PVector p2, float t) {
    vertex(p1.x, p1.y, p1.z, t*tex.pg.width, 0);
    vertex(p2.x, p2.y, p2.z, t*tex.pg.width, tex.pg.height);
  }
}
