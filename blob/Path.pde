class Path {
  PVector position, acceleration, speed;
  float r = 1;
  float max_speed = 2;

  Path() {
  }

  void move() {
    speed.add(acceleration);
    speed.limit(max_speed);
    position.add(speed);
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
    ellipse(position.x, position.y, r*2, r*2);
  }
  
  void seek(){
    
  }
  
  void target(){
    
  }
}
