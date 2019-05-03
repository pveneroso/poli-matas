int resolution = 300;
float wcm = 44;
float hcm = 61.4;
int w, h;
float inch_to_cm = 2.54;
float scale;

PImage path; // imagem de referência para a classe Particles

PGraphics image;

int boids = 1000;
int particles = 1000;
int flow = 1000;

ArrayList<Particles> elements = new ArrayList<Particles>();

void settings(){
  float factor = (resolution/inch_to_cm);
  w = int(wcm * factor);
  h = int(hcm * factor);
  int temph = displayHeight-50;
  int tempw = int(w*temph/h);
  scale = w/tempw;
  size(tempw, temph);
}

void setup() {
  smooth();
  noStroke();
  
  image = createGraphics(w, h);
  int elems = boids + particles + flow;
  for(int i = 0; i < elems; i++){
    if(i < particles){
      elements.add(new Particles("PARTICLE"));
    }
    else if(i < particles + boids){
      elements.add(new Boids("BOIDS"));
    }
    else{
      elements.add(new Flow("FLOW"));
    }
  }
}

void draw() {
  fill(255, 60);
  rect(0, 0, width, height);
  for(Particles p : elements){
    if(p.type == "BOIDS"){
      p.align(elements);
      p.cohesion(elements);
      p.separation(elements);
      p.move();
      p.display();
    }
  }
}

void keyPressed(){
  if(key == 'a'){
    noLoop();
  }
  else if(key == 'b'){
    loop();
  }
  else if(key == 's'){
    // populate pgraphics and save image
  }
}
