Ribbon ribbon; //<>//
Background bg;
PVector camrot;

ClusteredBismuth cb;

void setup() {
  size(1000, 1000, P3D);
  surface.setLocation(920, 0);
  surface.setTitle("Ribbon");
  surface.setResizable(false);

  //ribbon = new ProgressiveRibbon(80, 30000);
  //Path path = new Circle();
  //ribbon.setPath(path);

  ribbon = new TexturedRibbon(80);
  cb = new ClusteredBismuth(ribbon.ribbonLength, ribbon.ribbonWidth, ribbon.palette, 100);
  //cb = new AnimatedBismuth(ribbon.ribbonLength, 120, ribbon.palette, 100);
  ((TexturedRibbon)ribbon).setTexture(cb);


  camrot = new PVector(random(0, 0.02), random(0, 0.02), random(0, 0.02));
  bg = new Background(color(50), color(32));
}

void draw() {
  background(51);
  bg.draw();

  translate(width/2, height/2);

  ambientLight(200, 200, 200);
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, 0, 0, -1);
  specular(255, 255, 255);
  shininess(2);

  //rotateX(frameCount * camrot.x);
  //rotateY(frameCount * camrot.y);
  //rotateZ(frameCount * camrot.z);

  rotateX(0.1 * TAU);
  rotateY(0.08 * TAU);
  rotateZ(0.2 * TAU);
  
  hint(ENABLE_DEPTH_SORT);

  if (cb != null) cb.draw();
  ribbon.draw();
}

void keyPressed() {
  if (key == 'b' || key == 'B') {
    save("screenshots/"+hour()+minute()+second()+".png");
  } 
  /*else if (key == 'h') {
   cp5.setVisible(!cp5.isVisible());
   } */  else if (key == 'p') {
    if (ribbon instanceof ProgressiveRibbon) {
      ProgressiveRibbon pr = (ProgressiveRibbon)ribbon;
      pr.reset();
    }
  }
}
