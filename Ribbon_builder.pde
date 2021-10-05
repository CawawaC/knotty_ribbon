class RibbonBuilder {
  Path path;
  float ribbonWidth;

  RibbonBuilder(Path p, float rw) {
    path = p;
    ribbonWidth = rw;
  }

  TwoPoints[] build_points() {
    int N = path.points_n;
    RibbonVertexPair[] points = new RibbonVertexPair[N];
    for (int i = 0; i < N; i++) {
      PVector p = path.points[i].copy();
      points[i] = new RibbonVertexPair(p, ribbonWidth);
    }

    return points;
  }
}

class ParallelTransportFrame extends RibbonBuilder {

  PVector initialVector = new PVector(1, 0, 0);

  private PVector[] path_points;
  PMatrix3D[] frames;

  float twistStep;
  float twistAmount = 0;

  float x_delta = 5, y_delta = 3;

  ParallelTransportFrame(Path p, float rw) {
    super(p, rw);

    path_points = path.points;

    int N = path_points.length;
    frames = new PMatrix3D[N];
    twistStep = twistAmount / (N-1);
  }

  TwoPoints[] build_points() {
    println("build points", twistStep);
    PVector up = initialVector;
    float[] floatMatrix = new float[16];
    TwoPoints[] pps = new TwoPoints[path_points.length];

    for (int i = 0; i < path_points.length; i++) {
      //computing the orthonormal frame
      int next_i = i+1;
      if (i>0) next_i = next_i%i;
      frames[i] = computeFrame(path_points[i], path_points[next_i], up, path_points[i]);
      floatMatrix = frames[i].get(floatMatrix);

      //applying twist
      PVector aim = new PVector(floatMatrix[0], floatMatrix[1], floatMatrix[2]);
      PMatrix3D rot = getRotationMatrix(aim, twistStep*i);
      frames[i].apply(rot);

      // Extracting the twisted cross vector to build the ribbon
      floatMatrix = frames[i].get(floatMatrix);
      PVector cross = new PVector(floatMatrix[8], floatMatrix[9], floatMatrix[10]);
      //cross.mult(ribbonWidth);
      //PVector p2 = path_points[i].copy();
      //p2.add(cross);
      pps[i] = new CrossPair(path_points[i], cross, ribbonWidth);

      //critical part of parallel transport, the up vector gets updated at every step
      up = new PVector(floatMatrix[4], floatMatrix[5], floatMatrix[6]);
    }

    return pps;
  }

  PVector getNormal(int i) {
    float[] floatMatrix = new float[16];
    floatMatrix = frames[i].get(floatMatrix);
    PVector up = new PVector(floatMatrix[4], floatMatrix[5], floatMatrix[6]);
    
    return up;
  }

  PMatrix3D computeFrame(PVector start, PVector end, PVector up, PVector pos) {
    //compute an orthonormal frame from two points and an up vector
    PVector aim = end.copy().sub(start).normalize();
    PVector cross = aim.copy().cross(up).normalize();
    up = cross.copy().cross(aim).normalize();

    //PVector aim = new PVector(0, 0, 0);
    //PVector cross = new PVector(0, 0, 0);

    //generating the matrix
    return new PMatrix3D(
      aim.x, aim.y, aim.z, 0.0, 
      up.x, up.y, up.z, 0.0, 
      cross.x, cross.y, cross.z, 0.0, 
      pos.x, pos.y, pos.z, 1.0);
  }

  //creating a rotation matrix from a given axis and angle
  //https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
  PMatrix3D getRotationMatrix(PVector axis, float angle)
  {
    float rad = angle;
    float cosA = cos(rad);
    float sinA = sin(rad);

    PMatrix3D t = new PMatrix3D(
      cosA + axis.x * axis.x * (1.0f - cosA), axis.x * axis.y * (1.0f - cosA) - axis.z * sinA, 
      axis.x * axis.z * (1.0f - cosA) + axis.y * sinA, 0, 
      axis.y * axis.x * (1.0f - cosA) + axis.z * sinA, cosA + axis.y * axis.y * (1.0f - cosA), 
      axis.y * axis.z * (1.0f - cosA) - axis.x * sinA, 0, 
      axis.z * axis.x * (1.0f - cosA) - axis.y * sinA, axis.z * axis.y * (1.0f - cosA) + axis.z * sinA, 
      cosA + axis.z * axis.z * (1.0f - cosA), 0, 
      0, 0, 0, 1
      );

    t.transpose();
    return t;
  }

  void drawDebug() {
    int N = path_points.length;
    for (int i  = 0; i < N-1; i++) {
      PVector p = ribbon.path.points[i];
      PMatrix3D f = frames[i];
      float[] floatMatrix = new float[N];
      floatMatrix = f.get(floatMatrix); 
      PVector aim = new PVector(floatMatrix[0], floatMatrix[1], floatMatrix[2]); 
      PVector up = new PVector(floatMatrix[4], floatMatrix[5], floatMatrix[6]); 
      PVector cross = new PVector(floatMatrix[8], floatMatrix[9], floatMatrix[10]); 

      aim.mult(50);
      up.mult(50);
      cross.mult(50);

      stroke(255, 0, 0); 
      line(p.x, p.y, p.z, p.x+aim.x, p.y+aim.y, p.z+aim.z); 

      stroke(0, 255, 0); 
      line(p.x, p.y, p.z, p.x+up.x, p.y+up.y, p.z+up.z); 

      stroke(0, 0, 255); 
      line(p.x, p.y, p.z, p.x+cross.x, p.y+cross.y, p.z+cross.z);
    }
  }

  void setTwistAmount(float v) {
    twistAmount = v;
    int N = path_points.length;
    twistStep = twistAmount / (N-1);
  }
}
