class Star {
  float x, y, size, speed;
  Star(int layer) {
    x = random(width); y = random(height);
    // PARALLAX: Different layers move at different speeds for 3D depth
    if (layer == 0) { size = 1; speed = 0.3; } 
    else if (layer == 1) { size = 2; speed = 1.0; } 
    else { size = 3; speed = 2.5; }
  }
  void update() {
    y += speed;
    if (y > height) { y = -10; x = random(width); }
  }
  void display() {
    fill(255, 150 + 105*sin(frameCount*0.05)); // Twinkle effect
    noStroke(); ellipse(x, y, size, size);
  }
}
