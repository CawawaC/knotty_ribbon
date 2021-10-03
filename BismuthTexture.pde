class ClusteredBismuth { //<>//
  PGraphics pg;
  int ribbonLength;
  int ribbonWidth;
  InigoPalette palette;
  ArrayList<Cluster> clusters;
  int N; // Number of clusters
  boolean animate = false;

  ClusteredBismuth(int l, int rw, InigoPalette p) {
    this(l, rw, p, 10.0);
  }

  ClusteredBismuth(int l, int rw, InigoPalette p, float density) {
    ribbonWidth = rw;
    palette = p;
    ribbonLength = min((int)l, 16384);

    pg = createGraphics(ribbonLength+200, (int)ribbonWidth, P3D);
    clusters = new ArrayList<Cluster>();

    N = int(ribbonLength * density * 0.01);
    generateClusters(N);
  }

  void generateClusters(int N) {
    for (int i = 0; i < N; i++) {
      int x = int(float(ribbonLength) / N * i);
      println("generating cluster at:", x);
      Cluster c = generateCluster(x);
      clusters.add(c);
    }
  }

  Cluster generateCluster(int x) {
    return new Cluster(x, ribbonLength, ribbonWidth, palette, 1, new PVector(0, 0));
  }

  void draw() {
    pg.beginDraw();
    pg.noStroke();
    pg.clear();
    for (Cluster c : clusters) {
      c.update();
      c.draw(pg);
    }
    pg.endDraw();

    pg.copy(
      ribbonLength, 0, 200, ribbonWidth, 
      0, 0, 200, ribbonWidth);
  }


  void update() {
  }
}

class AnimatedBismuth extends ClusteredBismuth {
  AnimatedBismuth(int l, int rw, InigoPalette p, int d) {
    super(l, rw, p, d);
    animate = true;
  }

  void generateClusters(int N) {
    for (int i = 0; i < N; i++) {
      int x = ribbonLength / N * i;

      Cluster c = new SineCluster(x, ribbonLength, ribbonWidth, palette);
      //Cluster c = new NoiseCluster(bigx, ribbonLength, ribbonWidth, palette);
      //Cluster c = new AnimatedCluster(bigx, ribbonLength, ribbonWidth, palette);      clusters.add(c);

      clusters.add(c);
    }
  }
}

class MarchingBismuth extends ClusteredBismuth {
  float speed = 10.0;
  float bismuthLength;
  float startTime;

  MarchingBismuth(int l, int rw, InigoPalette p, float s) {
    super(l, rw, p);
    speed = s;

    bismuthLength = 0;
    startTime = millis()/1000.0;
    clusters.clear();
    animate = true;
  }

  void generateClusters(int N) {
    for (int i = 0; i < N; i++) {
      int x = ribbonLength / N * i;

      Cluster c = new SineCluster(x, ribbonLength, ribbonWidth, palette);
      //Cluster c = new NoiseCluster(bigx, ribbonLength, ribbonWidth, palette);
      //Cluster c = new AnimatedCluster(bigx, ribbonLength, ribbonWidth, palette);      clusters.add(c);

      clusters.add(c);
    }
  }

  void update() {
    int n = clusters.size();
    if (n >= (N+5)) 
      return;

    float time = millis()/1000.0;
    bismuthLength = (time-startTime) * speed;

    if (bismuthLength > ribbonLength / N * n) {
      int x = ribbonLength / N * (n+1);
      Cluster c = generateCluster(x);
      clusters.add(c);
    }
  }
}

/* //<>//
 class BismuthTexture {
 PGraphics pg;
 int ribbonLength;
 int ribbonWidth;
 InigoPalette palette;
 float speed = 20;
 
 BismuthTexture() {
 }
 
 BismuthTexture(float rw, InigoPalette p, float l) {
 ribbonWidth = (int)rw;
 palette = p;
 //length = (int)l;
 ribbonLength = min((int)l, 16384);
 
 pg = createGraphics(ribbonLength, (int)ribbonWidth, P3D);
 
 draw_bismuth();
 }
 
 void draw_bismuth() {
 pg.beginDraw();
 pg.noStroke();
 //pg.rect(0, 0, pg.width, pg.height);
 
 int i = 0;
 while (i < pg.width) {
 
 float bigx = (random(i*speed-50, i*speed));
 float y = random(-pg.height/2, pg.height/2);
 
 
 if (bigx < pg.width) {
 createBismuth(bigx, y);
 }
 i += speed;
 }
 
 pg.endDraw();
 }
 
 void createBismuth(float bigx, float y) {
 draw_bismuth_cluster(bigx, y);
 }
 
 void draw_bismuth_cluster(float bigx, float y) {
 float x = bigx % pg.width;
 float w = random(pg.height/2, pg.height);
 float h = random(pg.height/2, pg.height);
 
 int thick = 5;
 while (w > 0 && h > 0) {
 pg.fill(palette.getColor(random(0, TAU)));
 pg.rect(x, y, w, h);
 x += thick;
 y += thick;
 w -= thick*2;
 h -= thick*2;
 }
 }
 
 void redraw() {
 pg = createGraphics(ribbonLength, ribbonWidth, P3D);
 pg.beginDraw();
 pg.background(0, 0);
 pg.endDraw();
 draw_bismuth();
 }
 
 void draw() { }
 }
 */
