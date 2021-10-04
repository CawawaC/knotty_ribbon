import com.hamoid.*; //<>// //<>//
//import peasy.*;

//PeasyCam cam;
Ribbon ribbon;
Background bg;
PVector camrot;

ClusteredBismuth cb;

VideoExport videoExport;


void setup() {
  size(1000, 1000, P3D);
  //size(800, 80, P3D);
  surface.setLocation(920, 0);
  surface.setTitle("Ribbon");
  surface.setResizable(false);

  //cam = new PeasyCam(this, 500);

  ribbon = new Ribbon(100);
  Path path = new Circle();
  ribbon.setPath(path);
  //cb = new AnimatedBismuth(ribbon.ribbonLength, ribbon.ribbonWidth, ribbon.palette, 2);
  cb = new ClusteredBismuth(ribbon.ribbonLength, ribbon.ribbonWidth, ribbon.palette, 2);
  //cb = new MarchingBismuth(ribbon.ribbonLength, ribbon.ribbonWidth, ribbon.palette, 2, 2000);
  ribbon.setTexture(cb);

  //ribbon = new BandRibbon(80, 300, 0.8);
  //Path path = new Cinquefoil(4);
  //ribbon.setPath(path);

  //ribbon = new Ribbon(100);
  //Path path = new Cinquefoil(3);
  //ribbon.setPath(path);
  ////cb = new ClusteredBismuth(ribbon.ribbonLength, ribbon.ribbonWidth, ribbon.palette, 50);
  //cb = new AnimatedBismuth(ribbon.ribbonLength, ribbon.ribbonWidth, ribbon.palette, 50);
  //ribbon.setTexture(cb);

  if (cb != null) cb.draw();

  camrot = new PVector(random(0, 0.02), random(0, 0.02), random(0, 0.02));
  bg = new Background(color(50), color(32));
  GUISetup();

  //videoExport = new VideoExport(this, "screenshots/"+hour()+minute()+second()+".mp4");
  //videoExport.startMovie();
}

void draw() {
  background(51);
  bg.draw();

  float fov = PI/3.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
    cameraZ/10.0, cameraZ*10.0);

  pushMatrix();
  translate(width/2, height/2);

  ambientLight(red(ambientLightColor), green(ambientLightColor), blue(ambientLightColor));
  directionalLight(102, 102, 102, 0, 0, -1);
  //spotLight(51, 102, 126, 320, 80, 160, -1, 0, 0, PI/2, 2);
  //pointLight()  

  lightSpecular(204, 204, 204);
  //lightFalloff();

  specular(255, 255, 255);
  shininess(2);

  //rotateX(frameCount * camrot.x);
  //rotateY(frameCount * camrot.y);
  //rotateZ(frameCount * camrot.z);

  
  rotateX(0.1 * TAU);
  rotateY(0.08 * TAU);
  rotateZ(0.2 * TAU);

  //rotateX(frameCount * camrot.x);

  hint(ENABLE_DEPTH_SORT);
  hint(ENABLE_DEPTH_TEST);

  if (cb != null && cb.animate) {
    cb.update();
    cb.draw();
  }
  ribbon.draw();



  //
  //  EXPORT
  //

  //if (videoExport != null) {
  //  if (frameCount * camrot.x < TAU) {
  //    videoExport.saveFrame();
  //  } else {
  //    videoExport.endMovie();
  //    exit();
  //  }
  //}

  if (videoExport != null)
    videoExport.saveFrame();

  popMatrix();

  //
  //  GUI
  //
  GUIDraw();


  //
  //  DEBUG
  //

  //image(cb.pg, 0, 0);


  //RibbonBuilder b = ribbon.builder;
  //ParallelTransportFrame ptf = (ParallelTransportFrame) b;
  //ptf.drawDebug();
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
  } else if (key == 'o') {
    Path path = new RandomSquiggle(); 
    ribbon.setPath(path);
  } else if (key == 'r') {
    ribbon.path.randomize();
    ribbon.setPath(ribbon.path);
  }
}
