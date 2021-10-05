class Flutter {
  PVector speed = new PVector(0.1, 0.1);  // x: squiggliness. y: change rate
  float scale = 200;
  float[] shifts;  // Gives a magnitude for the normal vector

  Flutter(int N) {
    shifts = new float[N];
  }

  void update() {
    float t = (float)millis() / 1000.0;
    for (int i = 0; i < shifts.length; i++) {
      float x = speed.x * i;
      float y = speed.y * t;
      shifts[i] = noise(x, y) * scale;
    }
  }

  float getShift(int i) {
    return shifts[i];
  }
}

class TransversalFlutter extends Flutter {

  TransversalFlutter(int N) {
    super(N);
  }
}
