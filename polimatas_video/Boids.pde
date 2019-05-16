class Boids {
  PVector position, acceleration, velocity;
  color c;
  float radius;
  float sight = 20;
  float separationFactor = 0.25;//random(0.2, 0.6);
  float maxSpeed = 2;//random(0.5, 36);

  ArrayList<PVector> history = new ArrayList<PVector>();

  Boids() {
    position = new PVector(random(width), random(height));
    acceleration = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector(random(-2, 2), random(-2, 2));

    c = color(random(40, 80), random(40, 80), random(100, 200));
    //c = color(random(100, 180), random(100, 180), random(100, 180));
    //radius = random(0.3, 0.7);
    radius = 0.5;
  }

  void move() {
    velocity.add(acceleration);
    velocity.limit(2);
    position.add(velocity);
    acceleration.mult(0);

    history.add(new PVector(position.x, position.y));
    if (history.size() > 30) {
      history.remove(0);
    }

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
    sight = 15;
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
      steering.limit(0.15);
      //steering.mult(0.5);
    }
    acceleration.add(steering);
  }

  void cohesion(ArrayList<Boids> _boids) {
    sight = 20;
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
      steering.limit(0.1);// 0.1 funciona bem
      //steering.mult(0.5);
    }
    acceleration.add(steering);
  }

  void separation(ArrayList<Boids> _boids) {
    sight = 12;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Boids b : _boids) {
      float distance = dist(b.position.x, b.position.y, position.x, position.y);
      if (b != this && distance < sight) {
        PVector diff = PVector.sub(position, b.position);
        if (distance > 0) {
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
