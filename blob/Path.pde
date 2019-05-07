class Path {
  PVector position, acceleration, speed;
  float r = 0.5;
  float max_speed = 1; // 2
  float limit_target = 0.2;
  float limit_separation = 0.4; // 0.3
  Blobs current_target = null;
  int general_sight = 3; // 3
  
  ArrayList<PVector> history = new ArrayList<PVector>();

  Path() {
    //position = new PVector(random(width), random(height));
    //position = new PVector(width/2, height/2);
    position = new PVector(random(width/2-180, width/2+180), random(height/2-100, height/2+100));
    acceleration = new PVector(random(-1, 1), random(-1, 1));
    speed = new PVector(random(-2, 2), random(-2, 2));
    
    //if(random(1)>0.85){
    //  general_sight = int(random(3, 10));
    //}
  }
  
  Path(float _x, float _y) {
    position = new PVector(_x, _y);
    acceleration = new PVector(random(-1, 1), random(-1, 1));
    speed = new PVector(random(-2, 2), random(-2, 2));
  }

  void move() {
    speed.add(acceleration);
    speed.limit(max_speed);
    position.add(speed);
    acceleration.mult(0);
    
    history.add(new PVector(position.x, position.y));
    if(history.size() > 30){
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
    noStroke();
    //fill(255, 0, 0);
    fill(0);
    ellipse(position.x, position.y, r*2, r*2);
  }
  
  void displayTrail(){
    int counter = 0;
    
    for(PVector p : history){
      float cc = (255/history.size())*counter;
      fill(0, cc);
      ellipse(p.x, p.y, r*2, r*2);
      counter++;
    }
  }

  void seek(ArrayList<Blobs> _b) {
    float distance = 30000;
    for (Blobs b : _b) {
      if (dist(b.x+(b.w/2), b.y+(b.h/2), position.x, position.y) < distance) {
        distance = dist(b.x+(b.w/2), b.y+(b.h/2), position.x, position.y);
        current_target = b;
      }
    }
  }

  void target() {
    if (current_target != null) {
      int sight = 1500;
      PVector steering = new PVector(0, 0);
      PVector current = new PVector(current_target.x+(current_target.w/2), current_target.y+(current_target.h/2));
      if (dist(current.x, current.y, position.x, position.y) < sight) {
        steering.add(current);
        steering.sub(position);
        steering.sub(speed);
        steering.setMag(max_speed);
        steering.limit(limit_target); //0.2
      }
      acceleration.add(steering);
    }
  }

  void separation(ArrayList<Path> f) {
    int sight = general_sight;
    PVector steering = new PVector(0, 0);
    int total = 0;
    int neighbors = 0;
    for (Path b : f) {
      float distance = dist(b.position.x, b.position.y, position.x, position.y);
      if (b != this && distance < sight) {
        PVector diff = PVector.sub(position, b.position);
        if (distance > 0) {
          diff.div(distance);
        }
        steering.add(diff);
        total++;
      }
      else if(b != this && distance < 40){
        neighbors++;
      }
    }
    if (total > 0) {
      steering.div(total);
      steering.setMag(1);
      steering.sub(speed);
      steering.limit(limit_separation); // 0.4
    }
    if (total > 1) { // 20
      current_target = null;
      //general_sight = 10;
      //limit_separation = 0.2;
    }
    else{
      //general_sight = 4;
      //limit_separation = 0.4;
    }
    //limit_target = map(total, 0, f.size(), 0.2, 1);
    acceleration.add(steering);
  }
}
