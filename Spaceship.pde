class Spaceship extends Entity {
  Spaceship() { super(300, 350, 60, 50); }

  void update() { x = constrain(mouseX, 40, width - 40); }

  void display() {
    // TOPIC: TRANSFORMATIONS - Using pushMatrix to isolate coordinates for the ship hull
    pushMatrix();
    translate(x, y); 
    
    // Thruster Engine Glow with random flickering
    noStroke(); fill(255, 100, 0, random(150, 255));
    triangle(-8, 15, 8, 15, 0, 15 + random(10, 20));

    // Wings (Sleek Geometric Design)
    fill(44, 62, 80); stroke(0, 168, 255); strokeWeight(1);
    beginShape(); vertex(-5, 0); vertex(-30, 20); vertex(-10, 15); endShape(CLOSE);
    beginShape(); vertex(5, 0); vertex(30, 20); vertex(10, 15); endShape(CLOSE);

    // Main Hull construction
    fill(52, 73, 94);
    beginShape(); vertex(0, -25); vertex(-10, 15); vertex(10, 15); endShape(CLOSE);
    
    // Cockpit details
    fill(0, 180, 255); ellipse(0, 0, 8, 15);
    popMatrix(); // End transformation isolate
  }
}
