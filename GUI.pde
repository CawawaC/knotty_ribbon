import controlP5.*;


ControlP5 cp5;

ColorWheel ambientLightColorPicker;

boolean selfControl = false;
int ambientLightColor = color(255);

int y = 0;

// Accordion groups control groups!

void GUISetup() {
  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  //
  //  TABS
  //

  cp5.addTab("composition")
    .setColorBackground(color(0, 160, 100))
    .setColorLabel(color(255))
    .setColorActive(color(255, 128, 0))
    ;

  Accordion defaultAccordion = new Accordion(cp5, "ac");

  //Group groupComposition = createGroup("groupComposition", 0, 50).setWidth(200).moveTo("composition");
  Group groupRibbon = createGroup("groupRibbon", 0, 50);
  //
  //  CONTROLS
  //



  ambientLightColorPicker = cp5.addColorWheel("ambientLightColor")
    .setPosition(0, 50)
    .setColorValue(ambientLightColor)
    .moveTo("composition")
    ;

  cp5.begin(groupRibbon, 50, 50);

  cp5.addButton("getambientLightColorFromPalette")
    .setLabel("get from palette")
    .linebreak()
    //.setPosition(300, 0)
    //.setGroup(groupComposition)
    ;

  cp5.addToggle("rotateRibbon")
    //.setLabel("Rotate")
    .linebreak()
    //.setGroup(groupComposition)
    ;



  int w = ribbon.ribbonWidth;
  cp5.addSlider("setRibbonWidth", 1, 200).setValue(w).linebreak();

  cp5.addButton("addClusters");
  cp5.addButton("clearClusters");
  cp5.addToggle("toggleTexture").setValue(cb == null).linebreak();


  DropdownList knotsddl = cp5.addDropdownList("setKnot").setGroup("groupRibbon").linebreak();

  Knots[] knots = Knots.values();
  for (int i = 0; i < knots.length; i++) {
    knotsddl.addItem(knots[i].name(), i);
  }

  cp5.end();
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
