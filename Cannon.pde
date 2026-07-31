class Cannon extends Entity {
  float angle;
  Spaceship parent;

  Cannon(Spaceship s) { 
    super(s.x, s.y, 20, 6); 
    this.parent = s; 
  }

  void update() {
    // Keep cannon anchored to the ship's position
    x = parent.x; 
    y = parent.y;
    
    // FORMULA: atan2 calculates the angle (in radians) between the ship and the mouse
    angle = atan2(mouseY - y, mouseX - x);
  }

  void display() {
    // TOPIC: TRANSFORMATIONS - Isolating the rotation so only the cannon turns
    pushMatrix();
    translate(x, y); 
    rotate(angle);
    
    // Draw the barrel
    fill(200, 50, 50); 
    rect(0, -h/2, w, h);
    
    // Draw the turret base
    fill(100); 
    ellipse(0, 0, 12, 12);
    
    popMatrix();
  }
}
