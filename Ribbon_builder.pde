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
      PVector p = path.points[i];
      points[i] = new RibbonVertexPair(p, ribbonWidth);
    }

    return points;
  }
}

class ParallelTransportFrame extends RibbonBuilder {

  PVector initialVector = new PVector(1, 0, 0);

  PVector[] points;
  PMatrix[] frames;

  float twistStep;
  float twistAmount = 50;

  float x_delta = 5, y_delta = 3;

  ParallelTransportFrame(Path p, float rw) {
    super(p, rw);

    points = path.points;
    int N = points.length;
    frames = new PMatrix[N];
    twistStep = twistAmount / (N-1);
  }

  TwoPoints[] build_points() {
    println("building points...");
    
    PVector up = initialVector;
    float[] floatMatrix = new float[16];
    TwoPoints[] pps = new TwoPoints[points.length];
    
    for (int i = 0; i < points.length-1; i++) {
      //computing the orthonormal frame
      frames[i] = computeFrame(points[i], points[i+1], up, points[i]);
      floatMatrix = frames[i].get(floatMatrix);

      //applying twist
      PVector aim = new PVector(floatMatrix[0], floatMatrix[1], floatMatrix[2]);
      PMatrix3D rot = getRotationMatrix(aim, twistStep*i);
      frames[i].apply(rot);

      // Extracting the twisted cross vector to build the ribbon
      floatMatrix = frames[i].get(floatMatrix);
      PVector cross = new PVector(floatMatrix[8], floatMatrix[9], floatMatrix[10]);
      cross.mult(ribbonWidth);
      pps[i] = new TwoPoints(points[i], points[i].add(cross));

      //critical part of parallel transport, the up vector gets updated at every step
      up = new PVector(floatMatrix[4], floatMatrix[5], floatMatrix[6]);
    }
    
    println("points built");
    return pps;
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
}
