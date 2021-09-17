// ui
ControlP5 cp5;

void ui_setup() {
  pushStyle();
  noStroke();
  cp5 = new ControlP5(this);
  cp5.addSlider("v1")
    .setPosition(40, 40)
    .setSize(200, 20)
    .setRange(100, 300)
    .setValue(250)
    .setColorCaptionLabel(color(20, 20, 20));

  cp5.addButton("randomizeColors")
    .setValue(100)
    .setPosition(100, 120)
    .setSize(200, 19)
    .setValueLabel("test");

  cp5.setAutoDraw(false);
}


// function colorB will receive changes from 
// controller with name colorB
void randomizeColors(int theValue) {
  a = new PVector(random(1), random(1), random(1));
  b = new PVector(random(1), random(1), random(1));
  c = new PVector(int(random(1, 4))/2.0, int(random(1, 4))/2.0, int(random(1, 4))/2.0); // must be integer number of halves to ensure looping
  d = new PVector(random(1), random(1), random(1));
}
