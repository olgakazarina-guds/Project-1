class BossMeteorite extends Entity { 
  PImage img;
  float speedY = 0.2, pulse = 0;
  int bossHealth = 25;

  BossMeteorite(float x, float y, PImage fallback) { 
    super(x, y, 160, 140);
    this.img = loadImage("boss_ship.png");
    if (this.img == null) this.img = fallback; 
  }

  void update() {
    y += speedY; pulse += 0.05;
    // FORMULA: sin() creates a side-to-side floating motion for the boss
    x += sin(frameCount * 0.02) * 1.5; 
    if (bossHealth < 10) speedY = 0.5; // Difficulty increases at low health
  }

  void hitEffect() { bossHealth--; }
  boolean isDestroyed() { return bossHealth <= 0; }

  void display() { 
    pushMatrix();
    translate(x, y);
    // Shield visual using sin() for a pulsing animation
    noFill(); stroke(0, 255, 255, 50 + sin(pulse) * 50); strokeWeight(3);
    ellipse(0, 0, w + 20, h + 20);
    
    // TOPIC: IMAGE MANIPULATION - Using tint() to shift the image color as health drops
    tint(255, map(bossHealth, 0, 25, 100, 255), map(bossHealth, 0, 25, 100, 255));
    image(img, -w/2, -h/2, w, h);
    noTint(); // Safety: reset tint so other graphics are not affected
    popMatrix();
  }
}
