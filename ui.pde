// ui //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
ControlP5 cp5;
float ui_x = 40;
float ui_y = 40;

void ui_setup() {
  pushStyle();
  noStroke();
  cp5 = new ControlP5(this);

  Group group_ui = cp5.addGroup("group_ui")
    .setPosition(100, 100)
    .setBackgroundHeight(500)
    .setWidth(400)
    .setBackgroundColor(color(255, 50));

  int y = 0;

  RadioButton r = cp5.addRadioButton("ui_draw_type")
    .setPosition(0, 0)
    .setSize(20, 19)
    .setItemsPerRow(4)
    .setSpacingColumn(80)
    .addItem("instant", 0)
    .addItem("progressive", 1)
    .addItem("band", 2)
    .setGroup(group_ui);

  y += 22;

  for (Toggle t : r.getItems()) {
    t.getCaptionLabel().setColorBackground(color(255, 80));
    t.getCaptionLabel().getStyle().moveMargin(-7, 0, 0, -3);
    t.getCaptionLabel().getStyle().movePadding(7, 0, 0, 3);
    t.getCaptionLabel().getStyle().backgroundWidth = 80;
    t.getCaptionLabel().getStyle().backgroundHeight = 13;
  }

  RadioButton r2 = cp5.addRadioButton("ui_knot_type")
    .setPosition(0, y)
    .setSize(20, 19)
    .setItemsPerRow(4)
    .setSpacingColumn(80)
    .setGroup(group_ui);

  int i = 0;
  for (KnotType kt : KnotType.values()) {
    r2.addItem(kt.toString(), i);
    i+=1;
  }

  //cp5.addSlider("ui_flutter")
  //  .setPosition(0, ui_y)
  //  .setSize(200, 20)
  //  .setRange(0, 10)
  //  .setValue(flutter)
  //  .setColorCaptionLabel(color(20, 20, 20))
  //  .setGroup(group_ui);

  y += 60;

  cp5.addButton("randomizeColors")
    .setValue(100)
    .setPosition(0, y)
    .setSize(200, 19)
    .setGroup(group_ui);
  y += 20;

  cp5.addButton("reset_progressive")
    .setValue(100)
    .setPosition(0, y)
    .setSize(200, 19)
    .setGroup(group_ui);
  y += 20;

  cp5.addToggle("toggle_camera")
    .setPosition(0, y)
    .setSize(200, 19)
    .setGroup(group_ui)
    .setValue(rotate_camera);
  ;
  y += 20;

  //cp5.addSlider("ui_ribbon_width")
  //  .setPosition(0, y)
  //  .setSize(200, 19)
  //  .setValue(int(ribbon_width))
  //  .setRange(10, 200)
  //  //.setColorCaptionLabel(color(20, 20, 20))
  //  .setGroup(group_ui);
  //y += 20;


  ColorPicker cp = cp5.addColorPicker("picker")
    .setHeight(40)
    .setPosition(0, y)
    .setColorValue(color(255, 128, 0, 128))
    .setGroup(group_ui);


  Textlabel hide_info = cp5.addTextlabel("label")
    .setText("Press 'h' to hide ui")
    .setPosition(100, 50)
    .setColorValue(0xffffff00)
    .setFont(createFont("Georgia", 20));

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

void ui_draw_type(int a) {
  switch(a) {
  case 0: 
    DRAWING = DRAWING_TYPE.INSTANT;
    break;
  case 1: 
    DRAWING = DRAWING_TYPE.PROGRESSIVE;
    reset_progressive();
    break;
    //case 2: 
    //  DRAWING = DRAWING_TYPE.BAND;
    //  break;
  default:
    return;
  }
}

void reset_progressive() {
  startFrame = frameCount;
  ribbon_points = new ArrayList<PVector>();
}

void ui_flutter(float value) {
  flutter = value;
}

void ui_knot_type(int index) {
  knot_type = KnotType.values()[index];
}

void ui_ribbon_width(int value) {
  println("ui_ribbon_width setting: ", ribbon_width, " now: ", value);
  ribbon_width = value;
}

void toggle_camera(boolean flag) {
  rotate_camera = flag;
}
