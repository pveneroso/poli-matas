import processing.pdf.*;

Manager manager;
String path;
String file_name = "exp/01_";
String file_extension = ".jpg";
String current_counter;
int counter = 0;

PImage ref;
boolean[] target;
int cell_size = 5;
int col, lin;

ArrayList<Blobs> blobs = new ArrayList<Blobs>();
ArrayList<Path> particles = new ArrayList<Path>();
int threshold = 127;

boolean mp = false;

boolean disable_tracking = false;

SaveImage svimg;
PGraphics img;

ArrayList<Boids> boids = new ArrayList<Boids>();

void settings() {
  svimg = new SaveImage();
  size(svimg.tempw, svimg.temph);
  //size(1920, 1080);
}

void setup() {
  path = sketchPath();
  manager = new Manager(path, file_name, file_extension);
  current_counter = manager.currentCounter();
  String save_path = file_name + current_counter + file_extension;

  ref = loadImage("path-4.jpg");
  ref.resize(width, height);
  noStroke();
  smooth();
  img = createGraphics(svimg.w, svimg.h);

  ref.loadPixels();

  for (int i = 0; i < ref.pixels.length; i++) {
    if (meanColor(ref.pixels[i]) < threshold) {
      boolean match = false;
      PVector coord = getCoordinates(i);
      for (Blobs b : blobs) {
        if (b.isNear(coord)) {
          match = true;
          b.add(coord);
          break;
        }
      }

      if (!match) {
        Blobs blob = new Blobs(coord);
        blobs.add(blob);
      }
    }
  }

  //ArrayList<Blobs> ignore = new ArrayList<Blobs>();
  //for (Blobs b : blobs) {
  //  for (Blobs c : blobs) {
  //    boolean ignore_blob = false;
  //    for (int i = 0; i < ignore.size(); i++) {
  //      Blobs ig = ignore.get(i);
  //      if (ig == b || ig == c) {
  //        ignore_blob = true;
  //      }
  //    }
  //    if (!ignore_blob) {
  //      if (b != c) {
  //        if (b.intersect(c.coordinates)) {
  //          b.join(c.coordinates, c.x, c.y, c.w, c.h);
  //          ignore.add(c);
  //          break;
  //        }
  //      }
  //    }
  //  }
  //}
  //for (int i = 0; i < ignore.size(); i++) {
  //  blobs.remove(ignore.get(i));
  //}

  // PATH

  for (int i = 0; i < 600; i++) {
    float x = random(width/2-140, width/2+140);
    float y = random(height/2-75, height/2-15);
    particles.add(new Path(x, y));
  }
  for (int i = 0; i < 1200; i++) {
    float x = random(width/2-200, width/2+200);
    float y = random(height/2-10, height/2+70);
    particles.add(new Path(x, y));
  }

  // BOIDS

  //for (int i = 0; i < 800; i++) {
  //  boids.add(new Boids());
  //}
}

void draw() {
  fill(255, 25);
  fill(255);
  noStroke();
  rect(0, 0, width, height);

  if (mp) {
    particles.add(new Path(mouseX, mouseY));
  }

  //stroke(0);
  //rectMode(CORNER);
  //rect(width/2-200, height/2-30, 400, 80);

  //image(ref, 0, 0);
  //stroke(0);
  //noFill();
  //rect(width/2-140, height/2-75, 280, 60);
  //rect(width/2-200, height/2-10, 400, 80);

  //for (Blobs b : blobs) {
  //b.display();
  //b.displayPixels();
  //}

  for (Path p : particles) {
    if (!disable_tracking) {
      p.seek(blobs);
      p.target();
    }
    p.align(particles);
    p.cohesion(particles);
    p.separation(particles);
    p.move();
    //p.displayTrail();
    p.display();
  }

  for (Boids b : boids) {
    b.align(boids);
    b.cohesion(boids);
    b.separation(boids);
    b.move();
    b.display();
  }

  //SAVE
  //current_counter = nf(counter, 5);
  //String save_path = file_name + current_counter + file_extension;
  //svimg.setPath(save_path);
  //println(save_path);
  //svimg.save(particles, boids, img);
  //img = createGraphics(svimg.w, svimg.h);
  //counter++;
}

int meanColor(color c) {
  int mean = int((red(c)+green(c)+blue(c))/3);
  return mean;
}

PVector getCoordinates(int index) {
  int x = index%ref.width;
  int y = floor(index/ref.width);
  PVector coordinate = new PVector(x, y);
  return coordinate;
}

void mousePressed() {
  mp = true;
}

void mouseReleased() {
  mp = false;
}

void keyPressed() {
  if (key == 'p') {
    for (Path p : particles) {
      if (p.general_sight <= 20 && p.general_sight > 1) {
        p.general_sight++;
      }
    }
  } else if (key == 'o') {
    for (Path p : particles) {
      if (p.general_sight <= 20 && p.general_sight > 1) {
        p.general_sight--;
      }
    }
  } else if (key == 'd') {
    // disable tracking
    disable_tracking = !disable_tracking;
  }
}

void createParticles() {
  int counter = int(random(1, 6));
  for (int i = 0; i < counter; i++) {
    float x = random(0, width);
    float y = random(0, height);
    particles.add(new Path(x, y));
  }
}
