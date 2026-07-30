class Star {
  float x, y, size, speed;
  int starColor;
  float twinkleOffset;

  Star(int layer) {
    x = random(width);
    y = random(height);
    twinkleOffset = random(1000);
    
    // Layer 1: Deep Space (Tiny, slow)
    if (layer == 0) {
      size = random(1, 2);
      speed = random(0.2, 0.5);
      starColor = color(150, 150, 200); // Pale blue tint
    } 
    // Layer 2: Mid-field
    else if (layer == 1) {
      size = random(2, 3);
      speed = random(0.8, 1.2);
      starColor = color(255, 255, 200); // Yellow tint
    } 
    // Layer 3: Foreground (Large, fast)
    else {
      size = random(3, 4);
      speed = random(2.0, 3.0);
      starColor = color(255); // Pure white
    }
  }

  void update() {
    y += speed;
    if (y > height) {
      y = -10;
      x = random(width);
    }
  }

  void display() {
    // Twinkle effect using sin()
    float alpha = 150 + 105 * sin(frameCount * 0.05 + twinkleOffset);
    noStroke();
    fill(starColor, alpha);
    ellipse(x, y, size, size);
  }
}
