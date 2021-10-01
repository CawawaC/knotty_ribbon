class BismuthTexture { //<>//
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
    ribbonLength = 16384;

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

class ClusteredBismuth {
  PGraphics pg;
  int ribbonLength;
  int ribbonWidth;
  InigoPalette palette;
  float speed = 20;
  ArrayList<Cluster> clusters;

  ClusteredBismuth(int l, int rw, InigoPalette p, int s) {
    ribbonWidth = rw;
    palette = p;
    //length = (int)l;
    ribbonLength = l;
    speed = s;

    pg = createGraphics(ribbonLength, (int)ribbonWidth, P3D);
    clusters = new ArrayList<Cluster>();
    generateClusters();
  }

  void generateClusters() {
    int i = 0;
    while (i < pg.width) {
      int bigx = int(random(i*speed-50, i*speed));

      Cluster c = new Cluster(bigx, ribbonLength, ribbonWidth, palette);
      c.draw();
      clusters.add(c);

      i += speed;
    }
  }

  void draw() {
    pg.beginDraw();
    pg.noStroke();

    pg.clear();
    
    for (Cluster c : clusters) {
      c.update();
      pg.image(c.graphics, c.x, c.y);
    }

    pg.endDraw();
  }
}

class AnimatedBismuth extends ClusteredBismuth {
  AnimatedBismuth(int l, int rw, InigoPalette p, int s) {
    super(l, rw, p, s);
  }

  void generateClusters() {
    int i = 0;
    while (i < pg.width) {
      int bigx = int(random(i*speed-50, i*speed));

      //Cluster c = new SineCluster(bigx, ribbonLength, ribbonWidth, palette);
      //Cluster c = new NoiseCluster(bigx, ribbonLength, ribbonWidth, palette);
      Cluster c = new AnimatedCluster(bigx, ribbonLength, ribbonWidth, palette);
      c.draw();
      clusters.add(c);

      i += speed;
    }
  }
}

class AnimatedCluster extends Cluster {
  float xspeed = 1;

  AnimatedCluster(int bigx, int parentWidth, int parentHeight, InigoPalette ip) {
    super(bigx, parentWidth, parentHeight, ip);
    xspeed = random(0.5, 3);
  }

  void update() {
    //x += sin((float)frameCount/30) * 10;
    x += xspeed;
  }
}

class SineCluster extends AnimatedCluster {
  SineCluster(int bigx, int parentWidth, int parentHeight, InigoPalette ip) {
    super(bigx, parentWidth, parentHeight, ip);
  }

  void update() {
    x += sin((float)frameCount/100) * 10 * xspeed;
  }
}

class NoiseCluster extends AnimatedCluster {
  float noiseOffset = 0;
  int initX;

  NoiseCluster(int bigx, int parentWidth, int parentHeight, InigoPalette ip) {
    super(bigx, parentWidth, parentHeight, ip);
    initX = x;
    noiseOffset = random(0, 20);
    noiseDetail(2);
  }
  void update() {
    x = initX + (int)(min(0.2, pow(noise(frameCount * xspeed/500, noiseOffset), 2)) * 500);
  }
}

class BaseCluster {
  PGraphics graphics;
  InigoPalette palette;
  int x, y, w, h;
  int thickness = 5;
  color[] colors;
  int N;
  float outgrow = 1.0;  //Funny shapes at outgrow 2. Normal concentric rectangles at outgrow 1.
  PVector shift;

  BaseCluster(int bigx, int parentWidth, int parentHeight, InigoPalette ip) {
    x = bigx % parentWidth;
    y = (int)random(-parentHeight/2, parentHeight/2);
    w = (int)random(parentHeight/2, parentHeight);
    h = (int)random(parentHeight/2, parentHeight);
    palette = ip;

    graphics = createGraphics(w, h);
    shift = new PVector(0, 0);

    N = int(min(w/thickness*outgrow/2, h/thickness*outgrow/2));
    colors = new color[N];

    for (int i = 0; i < N; i++) {
      colors[i] = palette.getColor(random(0, TAU));
    }
  }
}

class Cluster extends BaseCluster {
  Cluster(int bigx, int parentWidth, int parentHeight, InigoPalette ip) {
    super(bigx, parentWidth, parentHeight, ip);
  }

  Cluster(int bigx, int parentWidth, int parentHeight, InigoPalette ip, float og, PVector s) {
    super(bigx, parentWidth, parentHeight, ip);
    outgrow = og;
    shift = s;
  }

  void draw() {
    graphics.beginDraw();
    graphics.clear();
    graphics.background(0, 0);
    for (int i = 0; i < N; i++) {    
      //graphics.noStroke();
      graphics.fill(colors[i]);
      graphics.rect((i+shift.x)*thickness, (i+shift.y)*thickness, w-i*thickness*2, h-i*thickness*2);
    }
    graphics.endDraw();
  }

  void update() {
  }
}
