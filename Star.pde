class Star {
  float x, y, speed, size;
  Star(int layer) {
    x = random(width); y = random(height);
    // TOPIC: PARALLAX - Distant layers (layer 0) move slower than foreground (layer 2)
    if (layer == 0) { size = 1; speed = 0.3; } 
    else if (layer == 1) { size = 2; speed = 1.0; } 
    else { size = 3; speed = 2.5; }
  }
  void update() {
    y += speed;
    if (y > height) { y = -10; x = random(width); }
  }
  void display() {
    // Twinkle effect using sin() to modulate brightness over time
    fill(255, 150 + 105 * sin(frameCount * 0.05)); 
    noStroke(); ellipse(x, y, size, size);
  }
}
