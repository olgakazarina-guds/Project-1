class Meteorite extends Entity { 
  PImage originalSprite;
  PImage damagedSprite;
  float speedY;
  int hitCount = 0;
  int flashTimer = 0; // New timer for the flash effect

  Meteorite(float x, float y, PImage img) { 
    super(x, y, 50, 50); 
    this.originalSprite = img.get();
    this.damagedSprite = img.get(); 
    this.speedY = random(1.0, 2.5);
    
    // Pre-calculate the "damaged" look once to save CPU
    createDamagedSprite();
  }

  void createDamagedSprite() {
    damagedSprite.loadPixels();
    for (int i = 0; i < damagedSprite.pixels.length; i++) {
      int p = damagedSprite.pixels[i];
      int a = (p >> 24) & 0xFF;
      if (a > 0) {
        // Make it bright red
        damagedSprite.pixels[i] = (a << 24) | (255 << 16) | (50 << 8) | 50;
      }
    }
    damagedSprite.updatePixels();
  }

  void update() {
    y += speedY;
    if (flashTimer > 0) flashTimer--; // Countdown the flash
  }

  void hitEffect() { 
    hitCount++;
    flashTimer = 10; // Flash for 10 frames
  }

  boolean isDestroyed() {
    return hitCount >= 3;
  }

  void display() { 
    // If flashTimer is active, show damagedSprite, otherwise show original
    PImage toDisplay = (flashTimer > 0) ? damagedSprite : originalSprite;
    image(toDisplay, x - w/2, y - h/2, w, h); 
  } 
}
