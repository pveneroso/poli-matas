class Followers {
  PVector position, acceleration, velocity;
  float r;
  color c;
  int currentTarget = -1;
  float distance = 3000000;
  boolean[] targets;

  Followers(boolean[] _targets) {
    position = new PVector(random(width), random(height));
    acceleration = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector(random(-2, 2), random(-2, 2));
    r = 1;
    c = color(255, 0, 0);
    targets = _targets;
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

  void target() {

    if (currentTarget == -1) {
      setTarget(0);
    } else if (currentTarget > -1) {
      //PVector reference = getVisionCoordinate(currentTarget);
      //float dist = dist(reference.x, reference.y, position.x, position.y);
      //if (dist < 10) {
      //  currentTarget = -1;
      //  distance = 300000;
      //} 
      //println(getCoordinate(currentTarget));

      //PVector steering = PVector.sub(getCoordinate(currentTarget), position);
      //steering.sub(velocity);
      //steering.setMag(4);
      //steering.limit(2);
      //acceleration.add(steering);
      int sight = 1500;
      PVector steering = new PVector(0, 0);
      PVector current = getCoordinate(currentTarget);
      if (dist(current.x, current.y, position.x, position.y) < sight) {
        steering.add(current);
        steering.sub(position);
        steering.sub(velocity);
        steering.setMag(2);
        steering.limit(0.2);
        //steering.mult(0.5);
      }

      acceleration.add(steering);
    }
  }

  void setTarget(float d) {
    for (int i = 0; i < targets.length; i++) {
      PVector reference = getVisionCoordinate(i);
      float dist = dist(reference.x, reference.y, position.x, position.y);
      if (targets[i] && dist < distance && distance > d) {
        distance = dist;
        currentTarget = getIndex(i);
      }
    }
  }

  PVector getCoordinate(int i) {
    int x = i%width;
    int y = floor(i/width);
    PVector temp = new PVector(x, y);
    return temp;
  }

  PVector getVisionCoordinate(int i) {
    int x = ((i%col)*cell_size)+(cell_size/2);
    int y = (floor(i/col)*cell_size)+(cell_size/2);
    PVector temp = new PVector(x, y);
    return temp;
  }

  int getIndex(int i) {
    int temp = ((floor(i/col)*cell_size)*width)+((i%col)*cell_size);
    return temp;
  }

  void display() {
    //fill(255, 255, 0);
    //PVector temp = getCoordinate(currentTarget);
    //ellipse(temp.x, temp.y, 5, 5);

    fill(c);
    ellipse(position.x, position.y, r*2, r*2);

    //currentTarget = -1;
    //distance = 3000000;
  }

  void separation(ArrayList<Followers> f) {
    int sight = 6;
    PVector steering = new PVector(0, 0);
    int total = 0;
    for (Followers b : f) {
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
      steering.setMag(1);
      steering.sub(velocity);
      steering.limit(0.2);
      //currentTarget = -1;
      //distance = 300000;
      //steering.mult(0.5);
    }
    if (total > 5) {
      //currentTarget = -1;
      //distance = 3000000;
      //setTarget(0);
    }
    acceleration.add(steering);
  }
}
