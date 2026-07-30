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
    x += sin(frameCount * 0.02) * 1.5; // Hovering movement
    if (bossHealth < 10) speedY = 0.5; // Enrage speed
  }
  void hitEffect() { bossHealth--; }
  boolean isDestroyed() { return bossHealth <= 0; }
  void display() { 
    pushMatrix(); translate(x, y);
    // Shield pulse effect
    noFill(); stroke(0, 255, 255, 50 + sin(pulse) * 50); strokeWeight(3);
    ellipse(0, 0, w + 20, h + 20);
    // Tint based on health level
    tint(255, map(bossHealth, 0, 25, 100, 255), map(bossHealth, 0, 25, 100, 255));
    image(img, -w/2, -h/2, w, h); noTint();
    popMatrix();
  }
}
