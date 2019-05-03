class Particles{
  PVector position, acceleration, speed;
  float w, h;
  color c;
  PVector[] positions;
  String type;
  
  Particles(String _type){
    type = _type;
    acceleration = new PVector(random(-1, 1), random(-1, 1));
    speed = new PVector(random(-2, 2), random(-2, 2));
    position = new PVector(random(0, width), random(0, height));
    w = random(1, 4);
    h = w;
    c = color(random(20,100), random(20,100), random(120,255));
    //c = color(random(0,255), random(0,255), random(0,255));
  }
  
  void move(){
    speed.add(acceleration);
    speed.limit(2);
    position.add(speed);
    
    if(position.x < 0){
      position.x = width;
    }
    else if(position.x > width){
      position.x = 0;
    }
    
    if(position.y < 0){
      position.y = height;
    }
    else if(position.y > height){
      position.y = 0;
    }
  }
  
  void display(){
    fill(c);
    ellipse(position.x, position.y, w, h);
  }
  
  void align(ArrayList<Particles> _p){
    
  }
  
  void cohesion(ArrayList<Particles> _p) {
    
  }
  
  void separation(ArrayList<Particles> _p) {
    
  }
}
