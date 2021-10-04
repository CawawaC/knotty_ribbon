class BaseCluster {
  InigoPalette palette;
  int x, y, w, h;
  int thickness = 5;
  color[] colors;
  int N;
  float outgrow = 1.0;  //Funny shapes at outgrow 2. Normal concentric rectangles at outgrow 1.
  PVector shift;
  color strokeColor = color(0);
  float strokeWeight = 2;
  int parentLength;

  BaseCluster(int bigx, int parentLength, int parentHeight, InigoPalette ip, float og, PVector s) {
    x = bigx % parentLength;
    this.parentLength = parentLength;
    y = (int)random(-parentHeight/2, parentHeight/2);
    w = (int)random(parentHeight/2, parentHeight);
    h = (int)random(parentHeight/2, parentHeight);
    palette = ip;
    outgrow = og;
    shift = s;

    int ref = min(w, h);
    N = ref / (2*thickness) + 1;

    colors = new color[N];

    for (int i = 0; i < N; i++) {
      colors[i] = palette.getColor(random(0, TAU));
    }
  }

  BaseCluster(int bigx, int parentLength, int parentHeight, InigoPalette ip) {
    this(bigx, parentLength, parentHeight, ip, 1.0, new PVector(0, 0));
  }

  String toString() {
    return "cluster: " + " x: " + x;
  }
}

class Cluster extends BaseCluster {
  Cluster(int bigx, int parentLength, int parentHeight, InigoPalette ip) {
    super(bigx, parentLength, parentHeight, ip);
  }

  Cluster(int bigx, int parentLength, int parentHeight, InigoPalette ip, float og, PVector s) {
    super(bigx, parentLength, parentHeight, ip, og, s);
    //outgrow = og;
    //shift = s;
  }

  void draw(PGraphics graphics) {
    graphics.beginDraw();
    graphics.pushMatrix();
    graphics.translate(x, y);
    //graphics.background(0, 0);
    graphics.stroke(strokeColor);
    graphics.strokeWeight(strokeWeight);
    for (int i = 0; i < N; i++) {
      graphics.fill(colors[i]);
      graphics.shininess(2);
      //graphics.rect((i+shift.x)*thickness, (i+shift.y)*thickness, w-i*thickness*2, h-i*thickness*2);
      // Attempt at skewed cystals
      graphics.rect(0, 0, w-i*thickness*2+shift.x, h-i*thickness*2+shift.y);
      graphics.translate(thickness, thickness);
    }
    graphics.popMatrix();

    graphics.endDraw();
  }

  void update() {
  }
}

class AnimatedCluster extends Cluster {
  float xspeed = 1;

  AnimatedCluster(int bigx, int parentLength, int parentHeight, InigoPalette ip) {
    super(bigx, parentLength, parentHeight, ip);
    xspeed = random(0.5, 3);
  }

  void update() {
    //x += sin((float)frameCount/30) * 10;
    x += xspeed;
  }
}

class SineCluster extends AnimatedCluster {
  SineCluster(int bigx, int parentLength, int parentHeight, InigoPalette ip) {
    super(bigx, parentLength, parentHeight, ip);
  }

  void update() {
    x += sin((float)frameCount/100) * 10 * xspeed;
    x %= parentLength;
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
