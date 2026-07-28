class Spaceship extends Entity {
  float angle;
  Spaceship() { super(300, 200, 30, 30); }

  void update() {
    // Points ship toward mouse using atan2 [radians]
    angle = atan2(mouseY - y, mouseX - x); 
  }

  void display() {
    pushMatrix();      // Rule: Isolate coordinate system
    translate(x, y);   // Rule: Translate origin to center BEFORE rotation
    rotate(angle);     // Rotate around ship center
    fill(0, 255, 0);
    triangle(w, 0, -w/2, -h/2, -w/2, h/2); 
    popMatrix();       // Restore coordinate system
  }
}
