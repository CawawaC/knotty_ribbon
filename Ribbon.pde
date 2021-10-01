class Ribbon { //<>//
  int ribbonWidth = 20;
  int ribbonLength;
  TwoPoints[] points;
  float angle_resolution = 200;

  Path path;
  RibbonBuilder builder;
  InigoPalette palette;
  ClusteredBismuth tex;


  Ribbon(int w) {
    ribbonWidth = w;
    path = new Circle();

    //int N = ceil(TAU * angle_resolution);
    //path.generate_points(N); 
    //builder = new RibbonBuilder(path, ribbonWidth);
    setPath(path);
    palette = new InigoPalette();  

    println("length:", ribbonLength);
    println("points N:", points.length);
  }

  Ribbon(int w, Path path) {
    ribbonWidth = w;
    setPath(path);
    palette = new InigoPalette();  

    println("length:", ribbonLength);
    println("points N:", points.length);
  }

  //void build_points() {
  //  int N = path.points_n;
  //  points = new RibbonVertexPair[N];
  //  for (int i = 0; i < N; i++) {
  //    PVector p = path.points[i];
  //    points[i] = new RibbonVertexPair(p, ribbonWidth);
  //  }
  //}

  void draw() {
    beginShape(TRIANGLE_STRIP);
    if (tex != null) texture(tex.pg);
    for (int i = 0; i < points.length-1; i++) {
      color c = palette.getColor((float)i/points.length);
      //stroke(c);
      noStroke();
      if (tex == null) fill(c);


      TwoPoints vp = points[i];
      paintVertex(vp.l, vp.r, (float)i/points.length);
    }
    endShape();
  }

  void paintVertex(PVector p1, PVector p2) {
    vertex(p1.x, p1.y, p1.z);
    vertex(p2.x, p2.y, p2.z);
  }

  //use this one for texture UV
  void paintVertex(PVector p1, PVector p2, float t) {
    if (tex != null) {
      vertex(p1.x, p1.y, p1.z, t*tex.pg.width, 0);
      vertex(p2.x, p2.y, p2.z, t*tex.pg.width, tex.pg.height);
    } else {
      paintVertex(p1, p2);
    }
  }

  void setTexture(ClusteredBismuth t) {
    tex = t;
  }

  void setPath(Path p) {
    int N = ceil(TAU * angle_resolution);
    path = p;

    path.generate_points(N); 

    ribbonLength = (int)path.getLength();
    builder = new ParallelTransportFrame(path, ribbonWidth);
    points = builder.build_points();
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

      TwoPoints vp = points[i];
      paintVertex(vp.l, vp.r);
    }
    endShape(CLOSE);
  }

  void reset() {
    startTime = millis()/1000;
  }
}

class BandRibbon extends ProgressiveRibbon {
  float bandLengthRatio = 0;
  
  BandRibbon(int w, float s, float l) {
    super(w, s);
    bandLengthRatio = max(0, min(1, l));
  }
  
  void draw() {
    float time = millis()/1000.0;
    float currentLength = (time-startTime) * speed;
    float t = currentLength / ribbonLength;
    //t = min(t, 1);

    beginShape(TRIANGLE_STRIP);
    if (tex != null) texture(tex.pg);
    int start_i = floor(t * points.length);
    int end_i = floor((t+bandLengthRatio) * points.length);

    for (int i = start_i; i < end_i; i++) {
      noStroke();
      color c = palette.getColor((float)(i%points.length)/points.length);
      if (tex == null) fill(c);

      TwoPoints vp = points[i%points.length];
      paintVertex(vp.l, vp.r, (float)(i%points.length)/points.length);
    }
    endShape(CLOSE);
  }
}
