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
  int w = ribbon.ribbonWidth;
  cp5.addSlider("setRibbonWidth", 1, 200).setValue(w).setGroup(g).linebreak();

  cp5.addButton("addClusters").setGroup(g);
  cp5.addButton("clearClusters").setGroup(g);
  cp5.addToggle("toggleTexture").setGroup(g).setValue(cb == null).linebreak();


  DropdownList knotsddl = cp5.addDropdownList("setKnot").setGroup(g).linebreak();

  Knots[] knots = Knots.values();
  for (int i = 0; i < knots.length; i++) {
    knotsddl.addItem(knots[i].name(), i);
  }

  //cp5.addSlider("setPTFTwistAmount", 0, 1).setValue(ribbon.getPTF().twistAmount).plugTo(ribbon).setGroup(g);
  //cp5.addButton("recalculateBuilder").plugTo(ribbon).setGroup(g);
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
  ribbon.setRibbonWidth(v);
}

void setKnot(int i) {
  ribbon.setPath(getKnotFromEnum(Knots.values()[i]));
}

void addClusters() {
  if (cb != null) cb.addClusters();
}

void clearClusters() {
  if (cb != null) cb.clearClusters();
}

void toggleTexture() {
  if (cb != null) {
    cb = null;
    ribbon.setTexture(null);
  } else {
    cb = new ClusteredBismuth(ribbon.ribbonLength, ribbon.ribbonWidth, ribbon.palette, 2);
    ribbon.setTexture(cb);

    cb.draw();
  }
}

void setPTFTwistAmount(float v) {
  ribbon.getPTF().setTwistAmount(v);
  ribbon.builder.build_points();
  ribbon.points = ribbon.builder.build_points();
}
