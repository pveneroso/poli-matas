class Blobs {
  float x, y, w, h;
  ArrayList<PVector> coordinates = new ArrayList<PVector>();
  color c = color(random(255), random(255), random(255));

  Blobs(PVector coord) {
    coordinates.add(coord);
    x = coord.x;
    y = coord.y;
    w = 1;
    h = 1;
  }

  //boolean checkNeighbors(PVector coord) {
  //  boolean match = false;
  //  for (PVector c : coordinates) {
  //    if (c.x-1 == coord.x  && c.y-1 == coord.y) {
  //      match = true;
  //    } else if (c.x == coord.x  && c.y-1 == coord.y) {
  //      match = true;
  //    } else if (c.x+1 == coord.x  && c.y-1 == coord.y) {
  //      match = true;
  //    } else if (c.x-1 == coord.x  && c.y == coord.y) {
  //      match = true;
  //    } else if (c.x == coord.x  && c.y == coord.y) {
  //      match = true;
  //    } else if (c.x+1 == coord.x  && c.y == coord.y) {
  //      match = true;
  //    } else if (c.x-1 == coord.x  && c.y+1 == coord.y) {
  //      match = true;
  //    } else if (c.x == coord.x  && c.y+1 == coord.y) {
  //      match = true;
  //    } else if (c.x+1 == coord.x  && c.y+1 == coord.y) {
  //      match = true;
  //    }
  //  }
  //  return match;
  //}

  //boolean isNear(PVector coord) {
  //  boolean match = false;
  //  for (PVector c : coordinates) {
  //    //if(distSq(c.x, c.y, coord.x, coord.y) < 15){
  //    if (dist(c.x, c.y, coord.x, coord.y) < 1) { // 5
  //      match  = true;
  //    }
  //  }
  //  return match;
  //}

  boolean isNear(PVector coord) {
    boolean match = false;
      if (dist(x, y, coord.x, coord.y) < 2) { // 5
        match  = true;
    }
    return match;
  }

  float distSq(float x1, float y1, float x2, float y2) {
    float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
    return d;
  }

  void display() {
    //fill(255, 0, 0);
    noFill();
    stroke(0);
    rect(x, y, w, h);
  }

  void displayPixels() {
    noStroke();
    fill(c);
    for (PVector c : coordinates) {
      ellipse(c.x, c.y, 1, 1);
    }
  }

  boolean intersect(ArrayList<PVector> coords) {
    boolean match = false;
    for (PVector c : coords) {
      for (PVector b : coordinates) {
        if (dist(c.x, c.y, b.x, b.y) < 5) {
          match = true;
        }
      }
    }
    return match;
  }

  void join(ArrayList<PVector> coords, float _x, float _y, float _w, float _h) {
    coordinates.addAll(coords);

    PVector initial = coordinates.get(0);
    float minx = initial.x;
    float maxx = initial.x;
    float miny = initial.y;
    float maxy = initial.y;

    for (PVector c : coordinates) {
      minx = min(minx, c.x);
      maxx = max(maxx, c.x);
      miny = min(miny, c.y);
      maxy = max(maxy, c.y);
    }

    x = minx;
    y = miny;
    w = maxx - minx;
    h = maxy - miny;
  }

  void add(PVector coord) {
    coordinates.add(coord);

    x = min(coord.x, x);
    y = min(coord.y, y);

    if (coord.x >= x+w) {
      w = coord.x - x;
    }
    if (coord.y >= y+h) {
      h = coord.y - y;
    }
  }
}
