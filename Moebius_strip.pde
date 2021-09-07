import peasy.*;

// β: Alt + +03b2

PeasyCam cam;
float beta = 0;

ArrayList<PVector> knot_points;

void setup() {
  size(707, 1000, P3D);

  cam = new PeasyCam(this, width/2, height/2, 0, 1000);
  knot_points = new ArrayList<PVector>();

  //noLoop();
}

void draw() {
  translate(width/2, height/2);
  stroke(255);
  strokeWeight(8);
  noFill();

  background(25);

  ambientLight(255, 123, 85);
  ambient(51, 26, 0);

  draw_knot();

  beginShape();
  for (PVector p : knot_points) {
    stroke(255, p.mag(), 255);
    vertex(p.x, p.y, p.z);
  }
  endShape();
}

void draw_knot() {
  float r = (0.8 + 1.6 * sin(6 * beta)) * 100;
  float theta = 2 * beta;
  float phi = 0.6 * PI * sin(12 * beta);

  float x = r * cos(phi) * cos(theta);
  float y = r * cos(phi) * sin(theta);
  float z = r * sin(phi);

  beta += 0.001;

  knot_points.add(new PVector(x, y, z));
}


void keyPressed() {
  if (key == 'b' || key == 'B') {
    save("screenshots/"+hour()+minute()+second()+".png");
  } else if (key == 'a') {
    draw_knot();
  }
}
