class BismuthTexture extends PGraphics {
  BismuthTexture() {
    
  }
}

float speed = 10;
PGraphics bismuth_texture;

void setup_bismuth() {
  
}

void randomize_colors() {
  a = new PVector(random(1), random(1), random(1));
  b = new PVector(random(1), random(1), random(1));
  c = new PVector(random(1), random(1), random(1)); // must be integer number of halves to ensure looping
  d = new PVector(random(1), random(1), random(1));
}

void draw_bismuth() {
  PGraphics pg = bismuth_texture;
  pg.beginDraw();
  pg.noStroke();
  //pg.rect(0, 0, pg.width, pg.height);

  switch(DRAWING) {
  case INSTANT:
    int i = 0;
    while (i < bismuth_texture.width) {
      i += speed;
      float bigx = (random(i*speed-50, i*speed));

      if (bigx < bismuth_texture.width) {
        pg.beginDraw();
        draw_bismuth_cluster(pg, bigx);
      }
    }

    break;

  case PROGRESSIVE:
    float bigx = (random(frameCount*speed-50, frameCount*speed));

    if (bigx < bismuth_texture.width) {
      draw_bismuth_cluster(pg, bigx);
    }
    break;
  }

  pg.endDraw();
}

void draw_bismuth_cluster(PGraphics pg, float bigx) {
  float x = bigx % bismuth_texture.width;
  float y = random(-bismuth_texture.height/2, bismuth_texture.height/2);
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
