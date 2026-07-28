class Meteorite extends Entity {
  PImage sprite;

  Meteorite(float x, float y, PImage img) {
    super(x, y, 60, 60);
    this.sprite = img.get(); // Pro-Tip: create a working copy [History]
  }

  // FIX: Completed the low-level manipulation loop [8, 9]
  void hitEffect() {
    // Pro-Tip: Access object buffer (sprite.pixels), not window buffer! [History]
    sprite.loadPixels(); 
    
    for (int i = 0; i < sprite.pixels.length; i++) {
      int c = sprite.pixels[i]; // Access raw 32-bit color integer [10]
      
      // Extraction via Bit Shifting (>>) and binary AND mask (& 0xFF) [8]
      int a = (c >> 24) & 0xFF; 
      int r = 255 - ((c >> 16) & 0xFF); // Manual Inversion [11]
      int g = 255 - ((c >> 8) & 0xFF);  
      int b = 255 - (c & 0xFF);         
      
      sprite.pixels[i] = color(r, g, b, a); 
    }
    
    sprite.updatePixels(); // Rule: Commit changes back to memory [12]
  }

  void display() {
    image(sprite, x - w/2, y - h/2, w, h);
  }
}
