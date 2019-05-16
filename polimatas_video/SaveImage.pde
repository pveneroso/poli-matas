class SaveImage {
  int resolution = 300;
  float wcm = 16.256;
  float hcm = 9.144;
  int w, h;
  float inch_to_cm = 2.54;
  float scale;
  int temph, tempw;
  
  String path;

  //PGraphics img;

  SaveImage() {
    float factor = (resolution/inch_to_cm);
    w = int(wcm * factor);
    h = int(hcm * factor);
    temph = int(displayHeight-350);
    tempw = int(w*temph/h);
    scale = (w/tempw)+1;
    //img = createGraphics(w,h);
    path = "";
  }
  
  void setPath(String _path){
    path = _path;
  }

  void save(ArrayList<Path> p, ArrayList<Boids> b, PGraphics img) {
    img.beginDraw();
    img.noStroke();
    img.background(255);

    // PATH
    for (Path pa : p) {
      PVector scaled_point = new PVector(pa.position.x*scale, pa.position.y*scale);
      float scaled_radius = pa.r*scale*0.8;
      img.fill(pa.c);
      img.ellipse(scaled_point.x, scaled_point.y, scaled_radius, scaled_radius);

      int counter = 0;
      //for (PVector tr : pa.history) {
      for (int i = 1; i < pa.history.size(); i++) {
        PVector tr = pa.history.get(i);
        PVector pr = pa.history.get(i-1);
        PVector scaled_trail = new PVector(tr.x*scale, tr.y*scale);
        PVector scaled_previous = new PVector(pr.x*scale, pr.y*scale);
        float cc = (255/pa.history.size())*counter;
        img.stroke(pa.c, cc);
        img.strokeWeight(scaled_radius*2);
        if (dist(scaled_trail.x, scaled_trail.y, scaled_previous.x, scaled_previous.y) < width/2) {
          img.line(scaled_trail.x, scaled_trail.y, scaled_previous.x, scaled_previous.y);
        }  
        //img.fill(0, cc);
        //img.ellipse(scaled_trail.x, scaled_trail.y, scaled_radius*2, scaled_radius*2);
        counter++;
      }
    }

    // BOIDS
    for (Boids ba : b) {
      PVector scaled_point = new PVector(ba.position.x*scale, ba.position.y*scale);
      float scaled_radius = ba.radius*scale;
      img.fill(0);
      img.ellipse(scaled_point.x, scaled_point.y, scaled_radius, scaled_radius);

      int counter = 0;
      //for (PVector tr : pa.history) {
      for (int i = 1; i < ba.history.size(); i++) {
        PVector tr = ba.history.get(i);
        PVector pr = ba.history.get(i-1);
        PVector scaled_trail = new PVector(tr.x*scale, tr.y*scale);
        PVector scaled_previous = new PVector(pr.x*scale, pr.y*scale);
        float cc = (255/ba.history.size())*counter;
        img.stroke(ba.c, cc);
        img.strokeWeight(scaled_radius);
        if (dist(scaled_trail.x, scaled_trail.y, scaled_previous.x, scaled_previous.y) < width/2) {
          img.line(scaled_trail.x, scaled_trail.y, scaled_previous.x, scaled_previous.y);
        } 
        //img.fill(0, cc);
        //img.ellipse(scaled_trail.x, scaled_trail.y, scaled_radius*2, scaled_radius*2);
        counter++;
      }
    }
    img.dispose();
    img.endDraw();
    img.save(path);
  }
}
