class Spaceship extends Entity {

  Spaceship() { 
    super(300, 340, 40, 30); 
  }

  void update() {
    // Keep ship anchored near the bottom base
    x = constrain(mouseX, 40, width - 40);
  }

  void display() {
    pushMatrix();
    translate(x, y);
    
    // Render Hull
    fill(0, 200, 255);
    triangle(0, -h/2, -w/2, h/2, w/2, h/2);
    
    popMatrix();
  }
}
