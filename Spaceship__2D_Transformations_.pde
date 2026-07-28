class Spaceship extends Entity {
  float angle;

  Spaceship() { 
    super(300, 200, 30, 30); 
  }

  void update() {
    // Calculates angle toward mouse. Radians are used for rotation
    angle = atan2(mouseY - y, mouseX - x);
  }

  void display() {
    // Rule: Use pushMatrix/popMatrix to isolate this object's movement
    pushMatrix();      
    // Rule: Order counts! translate() to the center BEFORE rotation
    translate(x, y);   
    rotate(angle);     
    
    fill(0, 255, 0);
    triangle(w, 0, -w/2, -h/2, -w/2, h/2); 
    popMatrix();       
  }
}
