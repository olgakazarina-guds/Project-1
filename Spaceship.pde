class Spaceship extends Entity {
  Spaceship() { super(300, 350, 60, 50); }
  void update() { x = constrain(mouseX, 40, width - 40); }
  void display() {
    pushMatrix(); // Isolate ship transformations
    translate(x, y);
    // Engine Glow
    fill(255, 100, 0, 150); ellipse(0, 18, 20, 25 + random(10)); 
    fill(255, 255, 0); ellipse(0, 15, 10, 15 + random(5));  
    // Detailed Hull
    fill(60, 70, 80); stroke(0, 168, 255); strokeWeight(1);
    beginShape(); vertex(-10, -5); vertex(-35, 15); vertex(-30, 25); vertex(-10, 15); endShape(CLOSE);
    beginShape(); vertex(10, -5); vertex(35, 15); vertex(30, 25); vertex(10, 15); endShape(CLOSE);
    fill(90, 100, 115); rect(-10, -15, 20, 35, 5); 
    fill(0, 180, 255, 180); ellipse(0, -5, 12, 20);
    popMatrix();
  }
}
