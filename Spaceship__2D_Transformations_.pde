class Spaceship extends Entity {
  Spaceship() { 
    super(300, 350, 60, 50); 
  }

  void update() {
    x = constrain(mouseX, 40, width - 40);
  }

  void display() {
    pushMatrix();
    translate(x, y);
    
    // --- 1. Engine Glow (Layered for "heat" effect) ---
    noStroke();
    fill(255, 100, 0, 150);
    ellipse(0, 18, 20, 25 + random(10)); // Outer flame
    fill(255, 255, 0);
    ellipse(0, 15, 10, 15 + random(5));  // Inner core

    // --- 2. Main Wings (Forward Swept) ---
    fill(60, 70, 80); // Dark metal
    stroke(20);
    strokeWeight(2);
    // Left Wing
    beginShape();
    vertex(-10, -5);
    vertex(-35, 15);
    vertex(-30, 25);
    vertex(-10, 15);
    endShape(CLOSE);
    // Right Wing
    beginShape();
    vertex(10, -5);
    vertex(35, 15);
    vertex(30, 25);
    vertex(10, 15);
    endShape(CLOSE);

    // --- 3. Central Fuselage (The Body) ---
    fill(90, 100, 115); // Lighter metal
    rect(-10, -15, 20, 35, 5); // Main body block
    
    // Nose Cone
    fill(40, 50, 60);
    triangle(-10, -15, 10, -15, 0, -30);

    // --- 4. Cockpit (Glass Detail) ---
    fill(0, 180, 255, 180); // Translucent Blue
    noStroke();
    ellipse(0, -5, 12, 20);
    fill(255, 150); // Reflection shine
    ellipse(-3, -8, 3, 6);

    // --- 5. Weapon Barrels ---
    fill(30);
    rect(-28, 5, 4, 15);
    rect(24, 5, 4, 15);
    
    popMatrix();
  }
}
