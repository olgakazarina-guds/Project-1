class Cannon extends Entity {
  float angle;
  Spaceship parent;

  Cannon(Spaceship s) { 
    super(s.x, s.y, 20, 6); 
    this.parent = s; 
  }

  void update() {
    x = parent.x; 
    y = parent.y;
    // FORMULA: atan2() calculates the angle from ship to mouse for accurate targeting
    angle = atan2(mouseY - y, mouseX - x);
  }

  void display() {
    // TOPIC: TRANSFORMATIONS - Using push/rotate to turn only the cannon turret
    pushMatrix();
    translate(x, y); 
    rotate(angle);
    fill(200, 50, 50); 
    rect(0, -h/2, w, h);
    fill(100); 
    ellipse(0, 0, 12, 12);
    popMatrix();
  }
}
