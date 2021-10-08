class Flutter {
  float noiseR = 5;
  //float noiseScale = 200;
  float[] shifts;  // Gives a magnitude for the normal vector
  boolean animate = false;

  Flutter(int N) {
    this(N, false);
  }
  
  Flutter(int N, boolean a) {
    shifts = new float[N];
    animate = a;
    init();
  }

  void init() {
    update();
  }

  void update() {
    float t = (float)millis() / 1000.0;
    for (int i = 0; i < shifts.length; i++) {
      float a = (float)i/shifts.length * TAU;
      float noisex = map(cos(a), -1, 1, 0, noiseR);
      float noisey = map(sin(a), -1, 1, 0, noiseR);
      shifts[i] = map(noise(noisex, noisey, t), 0, 1, 50, 100);
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
