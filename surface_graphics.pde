class BismuthTexture {
  PGraphics pg;
  float speed = 50;
  String draw_style = "progressive";
  //String draw_style = "instant";

  BismuthTexture() {
    pg = createGraphics(8000, int(ribbon_width)*2, P3D);
    pg.beginDraw();
    pg.background(0, 0);
    pg.endDraw();
    
    if (draw_style == "instant") {
      draw_bismuth();
    }
  }

  void draw_bismuth() {
    pg.beginDraw();
    pg.noStroke();
    //pg.rect(0, 0, pg.width, pg.height);

    switch(draw_style) {
    case "instant":
      int i = 0;
      while (i < pg.width) {
        i += speed;
        float bigx = (random(i*speed-50, i*speed));

        if (bigx < pg.width) {
          draw_bismuth_cluster(bigx);
        }
      }

      break;

    case "progressive":
      float bigx = (random(frameCount*speed-50, frameCount*speed));

      if (bigx < pg.width) {
        draw_bismuth_cluster(bigx);
      }
      break;
    }

    pg.endDraw();
  }

  void draw_bismuth_cluster(float bigx) {
    float x = bigx % pg.width;
    float y = random(-pg.height/2, pg.height/2);
    float w = random(pg.height/2, pg.height);
    float h = random(pg.height/2, pg.height);

    int thick = 5;
    while (w > 0 && h > 0) {
      pg.fill(getColor(a, b, c, d, random(0, TAU)));
      pg.rect(x, y, w, h);
      x += thick;
      y += thick;
      w -= thick*2;
      h -= thick*2;
    }
  }
}
