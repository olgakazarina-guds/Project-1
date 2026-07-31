class Meteorite extends Entity { 
  PImage original, damaged;
  float speedY;
  int hitCount = 0, flashTimer = 0; 

  Meteorite(float x, float y, PImage img) { 
    super(x, y, 50, 50); 
    this.original = img.get();
    this.damaged = img.get(); 
    this.speedY = random(1.0, 2.5);
    
    // TOPIC: IMAGE MANIPULATION - Accessing raw pixels for hit-effect
    damaged.loadPixels();
    for (int i = 0; i < damaged.pixels.length; i++) {
      int p = damaged.pixels[i];
      // BITWISE: Extract alpha channel (transparency)
      int a = (p >> 24) & 0xFF; 
      if (a > 0) {
        // BITWISE: Set pixel to Red with original alpha
        damaged.pixels[i] = (a << 24) | (255 << 16) | (50 << 8) | 50;
      }
    }
    damaged.updatePixels();
  }

  void update() { y += speedY; if (flashTimer > 0) flashTimer--; }
  void hitEffect() { hitCount++; flashTimer = 10; }
  boolean isDestroyed() { return hitCount >= 3; }

  void display() { 
    PImage toShow = (flashTimer > 0) ? damaged : original;
    image(toShow, x - w/2, y - h/2, w, h); 
  } 
}
