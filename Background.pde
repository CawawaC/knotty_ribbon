class Background {
  PShape ps;
  color c1 = color(255);
  color c2 = color(0);

  Background(color c1, color c2) {
    this.c1 = c1;
    this.c2 = c2;
    ps = createShape();
    drawGradient();
  }

  void drawGradient() {
    ps.beginShape();

    //fill(getColor(a, b, c, d, 0.0));
    ps.fill(c1);
    ps.vertex(0, 0);
    ps.vertex(width, 0);

    //fill(getColor(a, b, c, d, 0.5));
    ps.fill(c2);
    ps.vertex(width, height);
    ps.vertex(0, height);

    ps.endShape();
  }

  void draw() {
    hint(DISABLE_DEPTH_TEST);
    noLights();
    ortho();
    shape(ps);
    hint(ENABLE_DEPTH_TEST);
  }
}
