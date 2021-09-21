import peasy.*; //<>//
import controlP5.*;

/*

 Author: Sacha Holsnyder
 A sketch exploring  generative colorful ribbons twisted into knots and figures.
 - Many different knotty algorithms are provided (see line 81)
 - 2 draw modes: progressive and instant (see line 68)
 
 Press 'b' for screenshot.
 
 Made for sableraph's creative coding Weekly Challenge 
 2021 week 36 (2021-09-06 to 2021-09-12)
 
 Inspiration: Moebius strip by MC Escher: tinyurl.com/atjzhc68
 Maths source: http://paulbourke.net/geometry/knots/
 Coding train tutorial on knots: https://www.youtube.com/embed/r6YMKr1X0VA
 Seriously knotty maths source: Ideal Knots by Andrzej Stasiak, Vsevolod Katritch, Louis H. Kauffman
 
 */


// Fun variables
float ribbon_width = 80; // thicc ribbn
int twistiness = 0;  // How much the ribbon twists on itself. 1 for a simple Moebius strip.
float flutter = 0; // perlin showed up to the party again
//KnotType knot_type = KnotType.values()[int(random(KnotType.values().length))];
KnotType knot_type = KnotType.CINQUEFOIL;
DRAWING_TYPE DRAWING = DRAWING_TYPE.INSTANT;
static TextureType texture_type = TextureType.Bismuth;

// Boring variables
boolean enable_depth_sort = true;  // true: allows proper transparency on transparent ribbon texture
PeasyCam cam;
float angle_resolution = 400; // > 0 pls. Affects draw speed.
ArrayList<PVector> ribbon_points;
boolean closed = false;
float N = TAU * angle_resolution;  // Careful, number of vertices is 2*N.
int startFrame = 0;
BismuthTexture bismuth_texture;
color bg_color_1 = color(50);
color bg_color_2 = color(0);

// arguments for a generative color gradient/palette
// algorithm by https://iquilezles.org/www/articles/palettes/palettes.htm
PVector a = new PVector(random(1), random(1), random(1));
PVector b = new PVector(random(1), random(1), random(1));
PVector c = new PVector(int(random(1, 4))/2.0, int(random(1, 4))/2.0, int(random(1, 4))/2.0); // must be integer number of halves to ensure looping
PVector d = new PVector(random(1), random(1), random(1));

// Chaos knot randomizers
float e, f, g;

// Camera rotation
PVector camrot;
boolean rotate_camera = true;

enum KnotType {
  TREFOIL, CINQUEFOIL, KNOTTY, TORUS, FIGURE_EIGHT, 
    FIBONACCI, GENERIC, LISSAJOUS, GENERIC_RANDOM, 
    KNOT_5, TOUPIE, BANNER
}

enum DRAWING_TYPE { 
  PROGRESSIVE, INSTANT//, BAND
}

enum TextureType { 
  Gradient, Bismuth
}

void setup() {
  size(1000, 1000, P3D);
  surface.setLocation(920, 0);
  surface.setTitle("Ribbon");
  surface.setResizable(false);

  ribbon_width = 80;
  println(ribbon_width);

  cam = new PeasyCam(this, width/2, height/2, 0, 1000);
  cam.setMinimumDistance(5);
  //cam.setMaximumDistance(500);
  //perspective(200, float(width)/float(height), 
  //  5, 500);
  ribbon_points = new ArrayList<PVector>();
  closed = false;

  //println("Colors:");
  //println("a:", a);
  //println("b:", b);
  //println("c:", c);
  //println("d:", d);

  e = random(2);
  f = random(2);
  g = random(2);

  camrot = new PVector();
  camrot.x = random(0, 0.02);
  camrot.y = random(0, 0.02);
  camrot.z = random(0, 0.02);

  println(knot_type);

  ui_setup();
  cp5.setVisible(false);
  bismuth_texture = new BismuthTexture();
}

void draw() {
  //background(25);
  background_2d();


  if (bismuth_texture.draw_style == "progressive")
    bismuth_texture.draw_bismuth();
  //image(bismuth_texture.pg, 0, height-bismuth_texture.pg.height);



  if (enable_depth_sort) 
    hint(ENABLE_DEPTH_SORT);


  hint(ENABLE_DEPTH_TEST);
  translate(width/2, height/2);
  noStroke();
  noFill();

  // Ambient light color slowly changes across time, for crazy color action
  //color l = getColor(a, b, c, d, sin(frameCount/1000.0));
  //ambientLight(red(l), green(l), blue(l));
  // Or not
  ambientLight(200, 200, 200);

  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, 0, 0, -1);
  specular(255, 255, 255);
  shininess(2);

  //rotateX(PI/3);
  //rotateY(TAU * 1.3);
  //rotateZ(TAU * 1.0);

  if (rotate_camera) {
    rotateX(frameCount * camrot.x);
    rotateY(frameCount * camrot.y);
    rotateZ(frameCount * camrot.z);
  }

  switch (DRAWING) {
  case PROGRESSIVE:
    draw_ribbon();
    break;

  case INSTANT:
    instant_draw();  // good for tweaking in search of values
    break;
  }


  //
  //    UI
  //

  cam.beginHUD();
  hint(DISABLE_DEPTH_TEST);
  cp5.draw();
  cam.endHUD();
}

void draw_ribbon() {
  if (angle_resolution <= 0) {
    print("Keep angle_resolution above 0");
    return;
  }


  float angle = (frameCount-startFrame)/angle_resolution;

  if (angle < TAU) {
    float twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists
    float moebius_offset = check_for_moebius(twistiness);

    PVector knot_p = get_knot_p(knot_type, angle);


    if (knot_p == null) {
      print("Unhandled knot type: " + knot_type);
    }

    // Generate next pair of vertices
    create_ribbon_vertices(knot_p, twist, angle, moebius_offset);
  } else if (!closed) {
    ribbon_points.add(ribbon_points.get(0));
    ribbon_points.add(ribbon_points.get(1));
    closed = true;
  }




  beginShape(TRIANGLE_STRIP);
  switch(texture_type) {
  case Bismuth:
    texture(bismuth_texture.pg);
    noFill();
    break;

  default:
    break;
  }

  for (int i = 0; i < ribbon_points.size(); i += 2) {
    PVector p1 = ribbon_points.get(i);
    PVector p2 = ribbon_points.get(i+1);

    switch(texture_type) {
    case Gradient:
      fill(getColor(a, b, c, d, i/N));
      break;

    default:
      break;
    }
    paintVertex(p1, p2, i/N);
  }

  endShape(CLOSE);
}

void paintVertex(PVector p1, PVector p2, float t) {
  vertex(p1.x, p1.y + noise(frameCount/118.2, t, 0)*23*flutter, p1.z, 
    t*bismuth_texture.pg.width, 0);  // UV
  vertex(p2.x, p2.y + noise(frameCount/100.0, t*0.01, 1)*20*flutter, p2.z, 
    t*bismuth_texture.pg.width, bismuth_texture.pg.height);  // UV
}

//// Many possible knot algorithms
//// Some come with conditions on the arguments.
//// Check Knots.pde for details and tweaking
PVector get_knot_p(KnotType kt, float angle) {
  PVector knot_p = null;

  switch(kt) {
  case TREFOIL:
    knot_p = knot_trefoil(angle);
    // Trefoil. Yee basic knot.
    break;

  case CINQUEFOIL:
    knot_p = knot_cinquefoil(7*angle, 3);
    // (t, k) where t ranges from 0 to (2*k+1)*TAU, k int
    // Examples: (5*angle, 2), (7*angle, 3)
    break;

  case KNOTTY:
    knot_p = knotty_boy(angle/6, 9, 4);  // not sure about the rules here
    // Dunno what it is. Looks like lissajous curves?
    break;

  case TORUS:
    knot_p = torus_knot(angle, 10, 19, 2, 0.4); 
    // (t, p, q, R, r). For a proper knot: 2 <= p < q. p and q coprime. Defines winding amount. 
    // For art which is not a knot: do whatever
    // R is torus radius. r is radius of the tube.
    break;

  case FIGURE_EIGHT:
    knot_p = knot_figure_eight(angle);
    // Figure eight. looks gud.
    break;

  case FIBONACCI:
    knot_p = fibonacci_knot(angle, 8, 13);
    // Fibonacci knot. 
    // (t, f1, f2), f1 and f2 consecutive values in the fibonacci sequence.
    // Series: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, ...
    break;

  case GENERIC:
    knot_p = knot_generic(angle);
    // Somewhat generic formula to be tweaked and abundantly DECONSTRUCTED
    break;

  case GENERIC_RANDOM:
    knot_p = knot_randomized(angle);
    break;

  case LISSAJOUS:
    knot_p = knot_lissajous(angle);
    break;

  case KNOT_5:
    knot_p = knot_5(angle);
    break;

  case TOUPIE:
    knot_p = knot_toupie(angle);
    break;

  case BANNER:
    knot_p = knot_banner(5*angle, 2);
    break;
  } 

  return knot_p;
}

// Generate 2 Vertices, on each side of the width of ribbon
void create_ribbon_vertices(PVector knot_p, float twist, float angle, float mo) {
  float x1 = knot_p.x;
  float y1 = knot_p.y + ribbon_width * sin(twist)/2;
  float z1 = knot_p.z + ribbon_width * cos(twist) 
    + ribbon_width*angle/TAU * mo;

  float x2 = knot_p.x;
  float y2 = knot_p.y - ribbon_width * sin(twist)/2;
  float z2 = knot_p.z + ribbon_width * sin(twist) 
    + ribbon_width*angle/TAU * mo;

  ribbon_points.add(new PVector(x1, y1, z1));
  ribbon_points.add(new PVector(x2, y2, z2));
}

color getColor(PVector a, PVector b, PVector c, PVector d, float t) {
  float col_r = (a.x + b.x * cos(TAU * (c.x * t + d.x)))*255;
  float col_g = (a.y + b.y * cos(TAU * (c.y * t + d.y)))*255;
  float col_b = (a.z + b.z * cos(TAU * (c.z * t + d.z)))*255;

  return color(col_r, col_g, col_b);
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    save("screenshots/"+hour()+minute()+second()+".png");
  } else if (key == 'h') {
    cp5.setVisible(!cp5.isVisible());
  } else if (key == 'p') {
    reset_progressive();
  }
}

int check_for_moebius(float t) {
  // See if we're moebius twisting (top and bottom of the ribbon end up switching at the end of 1 loop)
  if (twistiness % 2 == 1) {
    return 1;
  } else {
    return 0;
  }
}

void background_2d() {
  cam.beginHUD();
  hint(DISABLE_DEPTH_TEST);
  noLights();
  ortho();
  pushMatrix();
  translate(-width/2, -height/2);

  beginShape();

  //fill(getColor(a, b, c, d, 0.0));
  fill(bg_color_1);
  vertex(0, 0);
  vertex(width, 0);

  //fill(getColor(a, b, c, d, 0.5));
  fill(bg_color_2);
  vertex(width, height);
  vertex(0, height);
  endShape();

  popMatrix();
  cam.endHUD();
}
