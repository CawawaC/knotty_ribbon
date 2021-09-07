import peasy.*;

// β: Alt + +03b2

PeasyCam cam;
float beta = 0;
float draw_speed = 100.0;

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
  strokeWeight(1);
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

  //draw_ribbon();
}

void draw_knot() {
  if (beta >= PI) {
    return;
  }

  //PVector p = knot_4(beta);
  //PVector p = knot_5(beta);
  PVector p = knot_trefoil(beta*2);

  beta += 0.001 * draw_speed;

  knot_points.add(p);
}

void draw_ribbon() {
  float angle = 0;
  float r = 100;

  beginShape(TRIANGLE_FAN);
  while (angle < TAU) {
    float x = r * cos(angle);
    float y = r * sin(angle);
    vertex(x, y, 0);
    vertex(x, y, 10);

    angle += 0.01;
  }
  endShape();
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    save("screenshots/"+hour()+minute()+second()+".png");
  } else if (key == 'a') {
    draw_knot();
  }
}
