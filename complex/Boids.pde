class Boids extends Particles {
  float sight;
  float cohesionMin = 0.01;
  float cohesionMax = 0.1;
  float cohesionFactor = random(cohesionMin, cohesionMax);

  Boids(String _type) {
    super(_type);
    sight = 20;//random(150,250);
    c = color(random(150, 255), random(80), random(80));
    speed = new PVector(random(-2, 2), random(-2, 2));
    w = random(1, 2);
    h = w;
  }

  void align(ArrayList<Particles> _p) {
    //acceleration = new PVector(0, 0);
    sight = 10;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Particles p : _p) {
      float distance = dist(p.position.x, p.position.y, position.x, position.y);
      if (p.type == "BOIDS" && distance < sight) {
        steering.add(p.speed);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.sub(speed);
      //steering.limit(2);
      steering.mult(0.2);
    }
    acceleration.add(steering);
  }

  void cohesion(ArrayList<Particles> _p) {
    sight = 20;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Particles p : _p) {
      float distance = dist(p.position.x, p.position.y, position.x, position.y);
      if (p.type == "BOIDS" && distance < sight) {
        steering.add(p.position);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.sub(speed);
      steering.sub(position);
      steering.mult(0.001);
    }
    acceleration.add(steering);
  }

  void separation(ArrayList<Particles> _p) {
    sight = 5;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Particles p : _p) {
      float distance = dist(p.position.x, p.position.y, position.x, position.y);
      if (p.type == "BOIDS" && distance < sight) {
        PVector diff = PVector.sub(position, p.position);
        if(distance > 0) diff.mult(1/distance);
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.sub(speed);
      steering.mult(0.01);
      //steering.limit(2);
    }
    acceleration.add(steering);
  }
}
