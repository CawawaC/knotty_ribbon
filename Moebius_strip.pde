import peasy.*; //<>// //<>// //<>//
import processing.svg.PGraphicsSVG;
import processing.pdf.*;

// β: Alt + +03b2

color[] palette = {#3fb8af, #7fc7af, #dad8a7, #ff9e9d, #ff3d7f};
color[] ribbon_gradient = { palette[0], palette[4] };
PGraphics pg;
PeasyCam cam;
float beta = 0;
float draw_speed = 100.0;

float ribbon_width = 20;
int twistiness = 0;  // How much the ribbon twists on itself. 1 for a simple Moebius strip.
float angle_resolution = 200; // > 0

ArrayList<PVector> knot_points;
ArrayList<PVector> ribbon_points;

PVector a = new PVector(random(1), random(1), random(1));
PVector b = new PVector(random(1), random(1), random(1));
PVector c = new PVector(int(random(1, 4))/2.0, int(random(1, 4))/2.0, int(random(1, 4))/2.0); // must be integer number of halves to ensure looping
PVector d = new PVector(random(1), random(1), random(1));


// Chaos knot randomizers
float e, f, g;



void setup() {
  size(1000, 1000, P3D);

  cam = new PeasyCam(this, width/2, height/2, 0, 1000);
  cam.setMinimumDistance(5);
  knot_points = new ArrayList<PVector>();
  ribbon_points = new ArrayList<PVector>();

  pg = create_background();

  e = random(2);
  f = random(2);
  g = random(2);

  //noLoop();
}

void draw() {
  translate(width/2, height/2);
  stroke(255);
  strokeWeight(1);
  noFill();
  
  background(25);
  
  //beginShape();
  //fill(255, 123, 85);
  //vertex(0, 0);
  //vertex(width, 0);
  
  //fill(65, 23, 246);
  //vertex(width, height);
  //vertex(0, height);
  //endShape();
  
  ambientLight(102, 102, 102);
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, 0, 0, -1);
  specular(255, 255, 255);

  fill(palette[0]);
  noStroke();
  shininess(2);

  draw_chaosknotty_ribbon_progressive();
}

void draw_chaosknotty_ribbon_progressive() {
  if (angle_resolution <= 0) {
    print("Keep angle_resolution above 0");
    return;
  }

  float N = TAU * angle_resolution;
  float r = 200;
  float angle = frameCount/angle_resolution;

  if (angle < TAU) {
    float twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists
    float moebius_offset = 0;
    if (twistiness % 2 == 1) {
      moebius_offset = 1;
    }  // See if we're moebius twisting (top and bottom of the ribbon end up switching)


    //PVector knot_p = knot_trefoil(angle);
    //PVector knot_p = knot_cinquefoil(5*angle, 2);
    //PVector knot_p = knot_5(angle);
    PVector knot_p = knot_chaos(angle);
    //PVector knot_p = knot_chaos_randomized(angle);
    //PVector knot_p = knotty_boy(angle);
    //PVector knot_p = torus_knot(angle, 2, 3);


    float x1 = knot_p.x;
    float y1 = knot_p.y + ribbon_width * sin(twist)/2;
    float z1 = knot_p.z + ribbon_width * cos(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    float x2 = knot_p.x;
    float y2 = knot_p.y - ribbon_width * sin(twist)/2;
    float z2 = knot_p.z + ribbon_width * sin(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    ribbon_points.add(new PVector(x1, y1, z1));
    ribbon_points.add(new PVector(x2, y2, z2));
  }


  beginShape(TRIANGLE_STRIP);
  fill(ribbon_gradient[0]);
  for (int i = 0; i < ribbon_points.size(); i += 2) {
    PVector p1 = ribbon_points.get(i);
    PVector p2 = ribbon_points.get(i+1);

    //fill(lerpColor(ribbon_gradient[0], ribbon_gradient[1], i/N));
    fill(crazyInigo(a, b, c, d, i/N));
    vertex(p1.x, p1.y + noise(frameCount/118.2, i/100.0)*23, p1.z);
    vertex(p2.x, p2.y + noise(frameCount/100.0, i/108.6)*20, p2.z);
  }

  endShape(CLOSE);
}

color crazyInigo(PVector a, PVector b, PVector c, PVector d, float t) {
  float col_r = (a.x + b.x * cos(TAU * (c.x * t + d.x)))*255;
  float col_g = (a.y + b.y * cos(TAU * (c.y * t + d.y)))*255;
  float col_b = (a.z + b.z * cos(TAU * (c.z * t + d.z)))*255;

  return color(col_r, col_g, col_b);
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    save("screenshots/"+hour()+minute()+second()+".png");
  } else if (key == 'a') {
    draw_knot();
  } else if (key == 's') {
    saveHighRes(4);
  } else if (key == 'u') {
    bufferSave();
  }
}

PGraphics create_background() {
  PGraphics bg = createGraphics(width, height, P3D); // make your buffered image size equal to sketch size

  bg.beginDraw();
  // do your gradient stuff here
  bg.background(102);  // you can do background statements in the background
  for (int i = 0; i < width; i++) {
    bg.stroke(i/width * 125, 126, 13);
    bg.line(i, 0, i, height);
  }

  // after your gradient, close out the pg image and finalize it with pg.endDraw
  bg.endDraw();

  return bg;
}

void saveHighRes(int scaleFactor) {
  PGraphics hires = createGraphics(
    width * scaleFactor, 
    height * scaleFactor, 
    P3D);
  println("Generating high-resolution image...");

  beginRecord(hires);
  hires.scale(scaleFactor);
  draw();
  hires.save("screenshots/"+hour()+minute()+second()+".png");

  endRecord();

  println("Finished");
}

PGraphics bufferSave() {
  PGraphics pg = createGraphics(width*2, height*2, P3D);

  pg.beginDraw();
  pg.lights();
  pg.background(0);
  pg.noStroke();
  pg.translate(pg.width/2, pg.height/2);
  pg.rotateX(frameCount/100.0);
  pg.rotateY(frameCount/200.0);
  pg.box(400);
  pg.save("test.png");
  pg.endDraw();

  return pg;
}
