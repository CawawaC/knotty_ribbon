import controlP5.*;


ControlP5 cp5;
boolean selfControl;

void GUISetup() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  Group groupLights = createGroup("Lights");

  cp5.addColorPicker("ambientLightColor")
    .setPosition(60, 100)
    .setColorValue(color(255, 128, 0, 128))
    .setGroup(groupLights)
    ;

  cp5.addToggle("selfControl")
    .setLabel("S. Control")
    .setPosition(100, 100)
    .setSize(50, 20)
    ;
}

void GUIDraw() {
  hint(DISABLE_DEPTH_TEST);
  cp5.draw();
  hint(ENABLE_DEPTH_TEST);
}

Group createGroup(String s) {
  Group g = cp5.addGroup(s)
    .setPosition(100, 100)
    .setBackgroundHeight(500)
    .setWidth(400)
    .setBackgroundColor(color(255, 50));
  return g;
}

void ambientLightColor(int col) {
  println("picker\talpha:"+alpha(col)+"\tred:"+red(col)+"\tgreen:"+green(col)+"\tblue:"+blue(col)+"\tcol"+col);
}
