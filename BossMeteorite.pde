class BossMeteorite extends Entity { 
  PImage originalSprite;
  PImage sprite;
  float speedY = 0.5;
  int bossHealth = 15;

  BossMeteorite(float x, float y, PImage img) { 
    super(x, y, 120, 120); // Twice the size of regular meteorites
    this.originalSprite = img.get();
    this.sprite = img.get(); 
  }

  void update() {
    y += speedY; // Boss moves slowly down
  }

  void hitEffect() { 
    bossHealth--;
    sprite.loadPixels(); // Pixel manipulation intensity scales as Boss takes damage
    
    for (int i = 0; i < sprite.pixels.length; i++) {
      int p = sprite.pixels[i];
      int a = (p >> 24) & 0xFF;
      int r = (p >> 16) & 0xFF;
      int g = (p >> 8)  & 0xFF;
      int b = p         & 0xFF;
      
      if (a > 0) {
        r = min(255, r + 25);
        g = (int)(g * 0.85);
        b = (int)(b * 0.85);
        sprite.pixels[i] = (a << 24) | (r << 16) | (g << 8) | b;
      }
    }
    
    sprite.updatePixels();
  }

  boolean isDestroyed() {
    return bossHealth <= 0;
  }

  void display() { 
    image(sprite, x - w/2, y - h/2, w, h); 
  } 
}
