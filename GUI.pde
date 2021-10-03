import controlP5.*;


ControlP5 cp5;
boolean selfControl;
int ambientLightColor = color(255);

int y = 0;

void GUISetup() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  Group groupLights = createGroup("Lights");

  cp5.addColorPicker("ambientLightColor")
    .setPosition(0, y)
    .setColorValue(ambientLightColor)
    .setGroup(groupLights)
    ;
}

void GUIDraw() {
  hint(DISABLE_DEPTH_TEST);
  hint(DISABLE_DEPTH_SORT);
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
  ambientLightColor = col;
}
