import peasy.*;

// β: Alt + +03b2

PeasyCam cam;
float beta = 0;
float draw_speed = 100.0;

float ribbon_width = 20;
int twistiness = 5;  // How much the ribbon twists on itself. 1 for a simple Moebius strip.


float angle_resolution = 200; // > 0

ArrayList<PVector> knot_points;

void setup() {
  size(500, 500, P3D);

  cam = new PeasyCam(this, width/2, height/2, 0, 1000);
  knot_points = new ArrayList<PVector>();

  //noLoop();
}

void draw() {
  translate(width/2, height/2);
  stroke(255);
  strokeWeight(1);
  noFill();

  background(25);

  //draw_knot();

  //beginShape();
  //for (PVector p : knot_points) {
  //  stroke(255, p.mag(), 255);
  //  vertex(p.x, p.y, p.z);
  //}
  //endShape();

  ambientLight(102, 102, 102);
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, 0, 0, -1);
  specular(255, 255, 255);

  fill(250, 165, 120);
  noStroke();
  shininess(2);

  draw_ribbon();
}

void draw_ribbon() {
  float angle = 0;
  float r = 100;

  beginShape(TRIANGLE_STRIP);

  while (angle < TAU) {
    float x = r * cos(angle);
    float y = r * sin(angle);

    vertex(x + noise(frameCount/10), y, 0);
    vertex(x, y, ribbon_width);

    angle += 0.01;
  }
  endShape(CLOSE);
}

void draw_knotty_ribbon() {
  if (angle_resolution <= 0) {
    print("Keep angle_resolution above 0");
    return;
  }

  float angle = 0;
  float r = 200;
  float twist = 0;
  float moebius_offset = 0;

  if (twistiness % 2 == 1) {
    moebius_offset = 1;
  }  // See if we're moebius twisting (top and bottom of the ribbon end up switching)

  beginShape(TRIANGLE_STRIP);
  while (angle < TAU) {

    PVector knot_p = knot_trefoil(angle);

    float x1 = knot_p.x;
    float y1 = knot_p.y + ribbon_width * sin(twist)/2;
    float z1 = knot_p.z + ribbon_width * cos(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    float x2 = knot_p.x;
    float y2 = knot_p.y - ribbon_width * sin(twist)/2;
    float z2 = knot_p.z + ribbon_width * sin(twist) 
      + ribbon_width*angle/TAU * moebius_offset;

    twist = angle * twistiness/2;  // Divided by 2 to allow for moebius twists

    stroke(255, sin(angle)*255, 123);

    vertex(x1, y1, z1);
    vertex(x2, y2, z2);

    angle += 1/angle_resolution;
  }

  endShape(CLOSE);
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    save("screenshots/"+hour()+minute()+second()+".png");
  } else if (key == 'a') {
    draw_knot();
  }
}
