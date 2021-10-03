import controlP5.*;


ControlP5 cp5;

ColorPicker ambientLightColorPicker;

boolean selfControl;
int ambientLightColor = color(255);

int y = 0;

void GUISetup() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  Group groupLights = createGroup("Lights", 10, 10);
  Group groupRibbon = createGroup("Ribbon", 500, 10);

  ambientLightColorPicker = cp5.addColorPicker("ambientLightColor")
    .setPosition(0, y)
    .setColorValue(ambientLightColor)
    .setGroup(groupLights)
    ;

  cp5.addButton("getambientLightColorFromPalette")
    .setLabel("get from palette")
    .setPosition(300, 0)
    .setGroup(groupLights)
    ;

  buildGroupRibbon(groupRibbon);
}

void buildGroupRibbon(Group g) {
  //cp5.addSlider("setRibbonWidth")
  //  .setRange(1, 200)
  //  .setValue(float(ribbon.ribbonWidth))
  //  .setPosition(0, 0)
  //  .setLabel("ribbon width")
  //  .setGroup(g);
}

void GUIDraw() {
  hint(DISABLE_DEPTH_TEST);
  hint(DISABLE_DEPTH_SORT);
  cp5.draw();
  hint(ENABLE_DEPTH_TEST);
}

Group createGroup(String s, int x, int y) {
  Group g = cp5.addGroup(s)
    .setPosition(x, y)
    .setBackgroundHeight(500)
    .setWidth(400)
    .setBackgroundColor(color(255, 50));
  return g;
}

void ambientLightColor(int col) {
  ambientLightColor = col;
}

void getambientLightColorFromPalette() {
  ambientLightColor = ribbon.palette.getColor(random(1));
  ambientLightColorPicker.setColorValue(ambientLightColor);
}

void setRibbonWidth(int v) {
  ribbon.ribbonWidth = v;
}
