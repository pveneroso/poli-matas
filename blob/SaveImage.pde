class SaveImage {
  int resolution = 300;
  float wcm = 44;
  float hcm = 61.4;
  int w, h;
  float inch_to_cm = 2.54;
  float scale;
  int temph, tempw;

  //PGraphics img;

  SaveImage() {
    float factor = (resolution/inch_to_cm);
    w = int(wcm * factor);
    h = int(hcm * factor);
    temph = int(displayHeight-50);
    tempw = int(w*temph/h);
    scale = w/tempw;
    //img = createGraphics(w,h);
  }

  void save(ArrayList<Path> p, PGraphics img) {
    img.beginDraw();
    img.noStroke();
    img.background(255);
    for (Path pa : p) {
      PVector scaled_point = new PVector(pa.position.x*scale, pa.position.y*scale);
      float scaled_radius = pa.r*scale;
      img.fill(0);
      img.ellipse(scaled_point.x, scaled_point.y, scaled_radius, scaled_radius);

      int counter = 0;
      //for (PVector tr : pa.history) {
      for (int i = 1; i < pa.history.size(); i++) {
        PVector tr = pa.history.get(i);
        PVector pr = pa.history.get(i-1);
        PVector scaled_trail = new PVector(tr.x*scale, tr.y*scale);
        PVector scaled_previous = new PVector(pr.x*scale, pr.y*scale);
        float cc = (255/pa.history.size())*counter;
        img.stroke(0, cc);
        img.strokeWeight(scaled_radius);
        img.line(scaled_trail.x, scaled_trail.y, scaled_previous.x, scaled_previous.y);
        //img.fill(0, cc);
        //img.ellipse(scaled_trail.x, scaled_trail.y, scaled_radius*2, scaled_radius*2);
        counter++;
      }
    }
    img.dispose();
    img.endDraw();
    //img.save("teste.pdf");
  }
}
