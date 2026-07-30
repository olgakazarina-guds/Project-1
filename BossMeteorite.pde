class BossMeteorite extends Entity { 
  PImage sprite;
  float speedY = 0.3;
  int bossHealth = 20;
  float rotation = 0;

  BossMeteorite(float x, float y, PImage img) { 
    super(x, y, 130, 130);
    this.sprite = img.get(); 
  }

  void update() {
    y += speedY;
    rotation += 0.02;
    // Stage 3 Enrage: Moves faster when low health
    if (bossHealth < 5) speedY = 0.8;
  }

  void hitEffect() { 
    bossHealth--;
    sprite.loadPixels();
    for (int i = 0; i < sprite.pixels.length; i++) {
      int p = sprite.pixels[i];
      int a = (p >> 24) & 0xFF;
      if (a > 0) {
        // Shift to Molten Red (Bitwise)
        int r = min(255, ((p >> 16) & 0xFF) + 30);
        int g = max(0, ((p >> 8) & 0xFF) - 20);
        int b = max(0, (p & 0xFF) - 20);
        sprite.pixels[i] = (a << 24) | (r << 16) | (g << 8) | b;
      }
    }
    sprite.updatePixels();
  }

  void display() { 
    pushMatrix();
    translate(x, y);
    
    // Core Glow
    if (bossHealth < 10) {
      fill(255, 0, 0, 100 + 100 * sin(frameCount * 0.2));
      ellipse(0, 0, w, w);
    }

    rotate(rotation);
    image(sprite, -w/2, -h/2, w, h); 
    
    // Stage 1 & 2: Rotating Obsidian Plates
    if (bossHealth > 10) {
      fill(30);
      stroke(200, 0, 0);
      for (int i = 0; i < 4; i++) {
        rotate(HALF_PI);
        rect(w/2 - 10, -20, 15, 40);
      }
    }
    popMatrix();
  }
}
