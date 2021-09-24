class InigoPalette {
  // arguments for a generative color gradient/palette
  // algorithm by https://iquilezles.org/www/articles/palettes/palettes.htm
  PVector a, b, c, d;

  InigoPalette() {
    a = new PVector(random(1), random(1), random(1));
    b = new PVector(random(1), random(1), random(1));
    // c must be integer number of halves to ensure looping
    //c = new PVector(int(random(1, 4))/2.0, int(random(1, 4))/2.0, int(random(1, 4))/2.0); 
    c = new PVector(1, 1, 1); 
    d = new PVector(random(1), random(1), random(1));
  }
  
  // t is in [0; 1[
  color getColor(float t) {
    float col_r = (a.x + b.x * cos(TAU * (c.x * t + d.x)))*255;
    float col_g = (a.y + b.y * cos(TAU * (c.y * t + d.y)))*255;
    float col_b = (a.z + b.z * cos(TAU * (c.z * t + d.z)))*255;

    return color(col_r, col_g, col_b);
  }
  
  String toString() {
    return "a: " + a +
      "b: " + b + 
      "c: " + c + 
      "d: " + d; 
  }
}
