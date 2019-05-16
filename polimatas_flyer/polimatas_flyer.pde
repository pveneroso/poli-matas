import processing.pdf.*;

Manager manager;
String file_name = "exp_mapa_02_";
String file_extension = ".pdf";
String current_counter;

PImage ref;
boolean[] target;
int cell_size = 5;
int col, lin;

ArrayList<Blobs> blobs = new ArrayList<Blobs>();
ArrayList<Path> particles = new ArrayList<Path>();
int threshold = 127;

boolean mp = false;

SaveImage svimg;
PGraphics img;

ArrayList<Boids> boids = new ArrayList<Boids>();

void settings() {
  svimg = new SaveImage();
  size(svimg.tempw, svimg.temph);
}

void setup() {
  String path = sketchPath();
  manager = new Manager(path, file_name, file_extension);
  current_counter = manager.currentCounter();
  String save_path = file_name + current_counter + file_extension;

  ref = loadImage("path-9.jpg");
  ref.resize(width, height);
  noStroke();
  smooth();
  img = createGraphics(svimg.w, svimg.h, PDF, save_path);

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

  for (int i = 0; i < 350; i++) {
    float x = random(20, 160);
    float y = random(20, 45);
    particles.add(new Path(x, y));
  }
  for (int i = 0; i < 700; i++) {
    float x = random(20, 235);
    float y = random(50, 95);
    particles.add(new Path(x, y));
  }

  // BOIDS

  for (int i = 0; i < 800; i++) {
    boids.add(new Boids());
  }
}

void draw() {
  fill(255, 15);
  //fill(255);
  noStroke();
  rect(0, 0, width, height);

  if (mp) {
    particles.add(new Path(mouseX, mouseY));
  }
  


  //image(ref, 0, 0);
  //  stroke(0);
  ////rectMode(CORNER);
  //rect(20, 20, 140, 25);
  //rect(20, 50, 215, 45);
  //for (Blobs b : blobs) {
    //b.display();
    //b.displayPixels();
  //}

  for (Path p : particles) {
    p.seek(blobs);
    p.target();
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
  } else if (key == 's') {
    svimg.save(particles, boids, img);
    String path = sketchPath();
    manager = new Manager(path, file_name, file_extension);
    current_counter = manager.currentCounter();
    String save_path = file_name + current_counter + file_extension;
    img = createGraphics(svimg.w, svimg.h, PDF, save_path);
  }
}
