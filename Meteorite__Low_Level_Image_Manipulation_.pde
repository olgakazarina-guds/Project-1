class Meteorite extends Entity { 
  PImage originalSprite;
  PImage damagedSprite;
  float speedY;
  int hitCount = 0;
  int flashTimer = 0; 

  Meteorite(float x, float y, PImage img) { 
    super(x, y, 50, 50); 
    this.originalSprite = img.get();
    this.damagedSprite = img.get(); 
    this.speedY = random(1.0, 2.5);
    createDamagedSprite();
  }

  void createDamagedSprite() {
    damagedSprite.loadPixels();
    for (int i = 0; i < damagedSprite.pixels.length; i++) {
      int p = damagedSprite.pixels[i];
      int a = (p >> 24) & 0xFF;
      if (a > 0) {
        // Bright Red damage flash
        damagedSprite.pixels[i] = (a << 24) | (255 << 16) | (50 << 8) | 50;
      }
    }
    damagedSprite.updatePixels();
  }

  void update() {
    y += speedY;
    if (flashTimer > 0) flashTimer--;
  }

  void hitEffect() { 
    hitCount++;
    flashTimer = 10; 
  }

  // --- ENSURE THIS METHOD IS HERE ---
  boolean isDestroyed() {
    return hitCount >= 3; 
  }

  void display() { 
    PImage toDisplay = (flashTimer > 0) ? damagedSprite : originalSprite;
    image(toDisplay, x - w/2, y - h/2, w, h); 
  } 
}
