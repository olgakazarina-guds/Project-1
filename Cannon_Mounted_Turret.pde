class Cannon extends Entity {
  float angle;
  Spaceship parentShip;

  Cannon(Spaceship ship) {
    super(ship.x, ship.y, 20, 6);
    this.parentShip = ship;
  }

  void update() {
    this.x = parentShip.x;
    this.y = parentShip.y;
    // Angle rotation targeted toward the mouse crosshair
    angle = atan2(mouseY - y, mouseX - x);
  }

  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    
    // Render Cannon barrel
    fill(200, 50, 50);
    rect(0, -h/2, w, h);
    
    // Render Cannon base
    fill(100);
    ellipse(0, 0, 12, 12);
    popMatrix();
  }
}
