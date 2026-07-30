class Spaceship extends Entity {
  Spaceship() { 
    super(300, 350, 50, 40); 
  }

  void update() {
    x = constrain(mouseX, 40, width - 40);
  }

  void display() {
    pushMatrix();
    translate(x, y);
    
    // 1. Thruster Flame (Flickering)
    fill(255, 140, 0, random(150, 255));
    triangle(-10, 15, 10, 15, 0, 15 + random(10, 20));

    // 2. Wings (Charcoal Blue)
    fill(44, 62, 80);
    stroke(0, 168, 255); // Electric Cyan edge
    strokeWeight(1);
    beginShape();
    vertex(0, -20);    // Nose
    vertex(-25, 15);   // Left Wing Tip
    vertex(-10, 10);   // In-cut
    vertex(10, 10);    // In-cut
    vertex(25, 15);    // Right Wing Tip
    endShape(CLOSE);
    
    // 3. Cockpit (Cyan Dome)
    fill(0, 168, 255, 200);
    noStroke();
    ellipse(0, 0, 12, 18);
    
    // 4. Weapon Ports
    fill(100);
    rect(-20, 5, 4, 8);
    rect(16, 5, 4, 8);
    
    popMatrix();
  }
}
