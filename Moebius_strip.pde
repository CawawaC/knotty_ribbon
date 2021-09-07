import peasy.*;

// β: Alt + +03b2

PeasyCam cam;

void setup() {
  size(707, 1000, P3D);
  
  cam = new PeasyCam(this, width/2, height/2, 0, 1000);
  //cam.setMinimumDistance(50);
  //cam.setMaximumDistance(500);
  
  background(25);

  //noLoop();
}

void draw() {
  translate(width/2, height/2);
  stroke(255);
  noFill();

  draw_knot();
}

void draw_knot() {
  float beta = 0;
  beginShape();
  while (beta < PI) {
    float r = (0.8 + 1.6 * sin(6 * beta)) * 100;
    float theta = 2 * beta;
    float phi = 0.6 * PI * sin(12 * beta);

    float x = r * cos(phi) * cos(theta);
    float y = r * cos(phi) * sin(theta);
    float z = r * sin(phi);

    vertex(x, y, z);

    beta += 0.01;
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
