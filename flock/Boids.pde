class Boids {
  PVector position, acceleration, velocity;
  color c;
  float radius;
  float sight = 40;
  float separationFactor = 0.3;//random(0.2, 0.6);
  float maxSpeed = 2;//random(0.5, 36);

  Boids() {
    position = new PVector(random(width), random(height));
    acceleration = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector(random(-2, 2), random(-2, 2));

    c = color(random(20, 80), random(20, 80), random(50, 200));
    //radius = random(1, 3);
    radius = 1;
  }

  void move() {
    velocity.add(acceleration);
    velocity.limit(2);
    position.add(velocity);
    acceleration.mult(0);

    if (position.x < 0) {
      position.x = width;
    } else if (position.x > width) {
      position.x = 0;
    }

    if (position.y < 0) {
      position.y = height;
    } else if (position.y > height) {
      position.y = 0;
    }
  }

  void display() {
    fill(c);
    ellipse(position.x, position.y, radius*2, radius*2);
  }

  void align(ArrayList<Boids> _boids) {
    sight = 40;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Boids b : _boids) {
      float distance = dist(b.position.x, b.position.y, position.x, position.y);
      if (b != this && distance < sight) {
        steering.add(b.velocity);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(maxSpeed);
      steering.sub(velocity);
      steering.limit(0.2);
      //steering.mult(0.5);
    }
    acceleration.add(steering);
  }

  void cohesion(ArrayList<Boids> _boids) {
    sight = 100;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Boids b : _boids) {
      float distance = dist(b.position.x, b.position.y, position.x, position.y);
      if (b != this && distance < sight) {
        steering.add(b.position);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.sub(position);
      steering.sub(velocity);
      steering.limit(0.2);
      //steering.mult(0.5);
    }
    acceleration.add(steering);
  }

  void separation(ArrayList<Boids> _boids) {
    sight = 50;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Boids b : _boids) {
      float distance = dist(b.position.x, b.position.y, position.x, position.y);
      if (b != this && distance < sight) {
        PVector diff = PVector.sub(position, b.position);
        if(distance > 0){
          diff.div(distance);
        }
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering.div(total);
      //steering.sub(position);
      steering.setMag(maxSpeed);
      steering.sub(velocity);
      steering.limit(separationFactor);
      //steering.mult(0.5);
    }
    acceleration.add(steering);
  }
}
