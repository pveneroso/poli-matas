ArrayList<Boids> boids = new ArrayList<Boids>();

void settings() {
  fullScreen();
}

void setup() {
  noStroke();
  smooth();
  for (int i = 0; i < 500; i++) {
    boids.add(new Boids());
  }
}

void draw() {
  fill(255, 15);
  //fill(255);
  rect(0, 0, width, height);

  for (Boids b : boids) {
    b.align(boids);
    b.cohesion(boids);
    b.separation(boids);
    b.move();
    b.display();
  }

  //if (frameCount % 1000 == 0) {
  //  boids = new ArrayList<Boids>();
  //  for (int i = 0; i < 500; i++) {
  //    boids.add(new Boids());
  //  }
  //}
}
