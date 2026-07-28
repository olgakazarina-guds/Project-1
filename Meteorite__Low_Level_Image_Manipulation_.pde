class Meteorite extends Entity { 
  PImage originalSprite;
  PImage sprite;
  float speedY;
  int hitCount = 0;

  Meteorite(float x, float y, PImage img) { 
    super(x, y, 50, 50); 
    this.originalSprite = img.get();
    this.sprite = img.get(); 
    this.speedY = random(1.0, 2.5);
  }

  void update() {
    y += speedY;
  }

  void hitEffect() { 
    hitCount++;
    sprite.loadPixels(); // Direct pixel manipulation
    
    for (int i = 0; i < sprite.pixels.length; i++) {
      int p = sprite.pixels[i];
      
      int a = (p >> 24) & 0xFF;
      int r = (p >> 16) & 0xFF;
      int g = (p >> 8)  & 0xFF;
      int b = p         & 0xFF;
      
      if (a > 0) {
        r = min(255, r + 60);
        g = (int)(g * 0.5);
        b = (int)(b * 0.5);
        
        sprite.pixels[i] = (a << 24) | (r << 16) | (g << 8) | b;
      }
    }
    
    sprite.updatePixels();
  }

  boolean isDestroyed() {
    return hitCount >= 3;
  }

  void display() { 
    image(sprite, x - w/2, y - h/2, w, h); 
  } 
}
