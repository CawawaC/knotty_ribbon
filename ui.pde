// ui //<>// //<>//
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
    .setBackgroundColor(color(150, 50));

  Group ui_bg = cp5.addGroup("ui_bg")
    .setPosition(500, 100)
    .setBackgroundHeight(500)
    .setWidth(400)
    .setBackgroundColor(color(150, 50));

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
  y += 60;

  RadioButton r3 = cp5.addRadioButton("ui_texture_type")
    .setPosition(0, y)
    .setSize(20, 19)
    .setItemsPerRow(4)
    .setSpacingColumn(130)
    .setGroup(group_ui);

  i = 0;
  for (TextureType tt : TextureType.values()) {
    r3.addItem(tt.toString(), i);
    if (tt == texture_type)
      r3.activate(tt.toString());
    i+=1;
  }

  y += 50;

  cp5.addButton("ui_redraw_texture")
    .setPosition(0, y)
    .setSize(200, 19)
    .setGroup(group_ui);
  y += 20;

  //cp5.addSlider("ui_flutter")
  //  .setPosition(0, ui_y)
  //  .setSize(200, 20)
  //  .setRange(0, 10)
  //  .setValue(flutter)
  //  .setColorCaptionLabel(color(20, 20, 20))
  //  .setGroup(group_ui);


  cp5.addButton("randomizeColors")
    .setPosition(0, y)
    .setSize(200, 19)
    .setGroup(group_ui);
  y += 20;

  cp5.addButton("reset_progressive")
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

  cp5.addToggle("ui_enable_depth_sort")
    .setValue(enable_depth_sort)
    .setPosition(0, y)
    .setSize(200, 19)
    .setGroup(group_ui)
    .setLabel("test")
    .setCaptionLabel("caption")
    .setValueLabel("value")
    .setMode(ControlP5.SWITCH)
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


  Textlabel hide_info = cp5.addTextlabel("label")
    .setText("Press 'h' to hide ui")
    .setPosition(100, 50)
    .setColorValue(0xffffff00)
    .setFont(createFont("Georgia", 20));

  cp5.setAutoDraw(false);


  // 
  // ui bg
  //

  y = 0;
  cp5.addColorWheel("ui_bg_col_1")
    .setHeight(200)
    .setPosition(0, y)
    .setColorValue(bg_color_1)
    .setGroup(ui_bg);
  cp5.addButton("ui_bg_col_1_inigo")
    .setValue(100)
    .setPosition(200, y)
    .setSize(100, 100)
    .setGroup(ui_bg);
  y += 200;

  cp5.addColorWheel("ui_bg_col_2")
    .setHeight(200)
    .setPosition(0, y)
    .setColorValue(bg_color_2)
    .setGroup(ui_bg);
  cp5.addButton("ui_bg_col_2_inigo")
    .setValue(100)
    .setPosition(200, y)
    .setSize(100, 100)
    .setGroup(ui_bg);
  y += 200;
}

// function colorB will receive changes from 
// controller with name colorB
void randomizeColors() {
  a = new PVector(random(1), random(1), random(1));
  b = new PVector(random(1), random(1), random(1));
  c = new PVector(int(random(1, 4))/2.0, int(random(1, 4))/2.0, int(random(1, 4))/2.0); // must be integer number of halves to ensure looping
  d = new PVector(random(1), random(1), random(1));

  ui_redraw_texture();
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

void ui_texture_type(int a) {
  switch(a) {
  case 0: 
    texture_type = TextureType.Gradient;
    break;
  case 1: 
    texture_type = TextureType.Bismuth;
    break;

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

void ui_enable_depth_sort(boolean flag) {
  enable_depth_sort = flag;
}

void ui_bg_col_1(color col) {
  bg_color_1 = col;
}

void ui_bg_col_2(color col) {
  bg_color_2 = col;
}

void ui_bg_col_1_inigo() {
  bg_color_1 = getColor(a, b, c, d, random(TAU));
}

void ui_bg_col_2_inigo() {
  bg_color_2 = getColor(a, b, c, d, random(TAU));
}

void ui_redraw_texture() {
  bismuth_texture.redraw();
}
