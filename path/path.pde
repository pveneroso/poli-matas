ArrayList<Followers> followers = new ArrayList<Followers>();
PImage ref;
boolean[] target;
int cell_size = 5;
int col, lin;

void settings() {
  size(566, 800);
}

void setup() {
  ref = loadImage("path.jpg");
  noStroke();
  smooth();

  ref.loadPixels();
  //target = new boolean[ref.pixels.length];
  col = floor(ref.width / cell_size);
  lin = floor(ref.height / cell_size);
  target = new boolean[col * lin];
  for (int i = 0; i < target.length; i++) {
    int x = (i % col) * cell_size;
    int y = floor(i / col) * cell_size;
    //println(x + " : " + y);
    int c = 0;
    for (int j = 0; j < cell_size * cell_size; j++) {
      int x1 = j % cell_size;
      int y1 = floor(j / cell_size);
      int index = ((y + y1) * ref.width) + (x + x1);      //((y+y1)*(ref.width/cell_size))+x+x1;
      int c1 = int((red(ref.pixels[index])+green(ref.pixels[index])+blue(ref.pixels[index]))/3);
      c += c1;
      //println(index);
    }
    c = c/(cell_size*cell_size);
    if (c < 180) {
      target[i] = true;
      //println(i + " true");
    }
  }

  for (int i = 0; i < target.length; i++) {
    if (target[i]) {
      int x = (i%col)*cell_size;
      int y = floor(i/col)*cell_size;
      fill(0);
      rect(x, y, cell_size, cell_size);
    }
  }

  for (int i = 0; i < 1000; i++) {
    followers.add(new Followers(target));
  }
  //println(target);
  //for(int i = 0; i < ref.pixels.length; i++){
  //  if(ref.pixels[i] == color(0)){
  //    target[i] = true;
  //  }
  //  else{
  //    target[i] = false;
  //  }
  //}
}

void draw() {
  fill(255, 15);
  //fill(255);
  rect(0, 0, width, height);
  //image(ref, 0, 0);
  //for (int i = 0; i < target.length; i++) {
  //  if (target[i]) {
  //    int x = (i%col)*cell_size;
  //    int y = floor(i/col)*cell_size;
  //    fill(0);
  //    rect(x, y, cell_size, cell_size);
  //  }
  //}

  for (Followers b : followers) {
    b.target();
    b.separation(followers);
    b.move();
    b.display();
  }
}
