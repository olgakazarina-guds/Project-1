class Spaceship extends Entity {
  float angle;

  Spaceship() { 
    super(300, 200, 30, 30); 
  }

  void update() {
    // Points ship toward mouse using radians [6]
    angle = atan2(mouseY - y, mouseX - x);
  }

  void display() {
    pushMatrix();      // Rule: Isolate this object's coordinate system [4]
    translate(x, y);   // Rule: translate() to center BEFORE rotating [5]
    rotate(angle);     // Rotate around ship center
    
    fill(0, 255, 0);
    triangle(w, 0, -w/2, -h/2, -w/2, h/2); 
    
    popMatrix();       // FIX: Restore the global coordinate system [4]
  }
}
