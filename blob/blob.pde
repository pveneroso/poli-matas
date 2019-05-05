PImage ref;
boolean[] target;
int cell_size = 5;
int col, lin;

ArrayList<Blobs> blobs = new ArrayList<Blobs>();
int threshold = 127;

void settings() {
  size(566, 800);
}

void setup() {
  ref = loadImage("path.jpg");
  noStroke();
  smooth();

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

  ArrayList<Blobs> ignore = new ArrayList<Blobs>();
  for (Blobs b : blobs) {
    for (Blobs c : blobs) {
      boolean ignore_blob = false;
      for (int i = 0; i < ignore.size(); i++) {
        Blobs ig = ignore.get(i);
        if (ig == b || ig == c) {
          ignore_blob = true;
        }
      }
      if (!ignore_blob) {
        if (b != c) {
          if (b.intersect(c.coordinates)) {
            b.join(c.coordinates, c.x, c.y, c.w, c.h);
            ignore.add(c);
            break;
          }
        }
      }
    }
  }
  for (int i = 0; i < ignore.size(); i++) {
    blobs.remove(ignore.get(i));
  }
}

void draw() {
  fill(255, 15);
  noStroke();
  rect(0, 0, width, height);
  //image(ref, 0, 0);
  for (Blobs b : blobs) {
    b.display();
    //b.displayPixels();
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
