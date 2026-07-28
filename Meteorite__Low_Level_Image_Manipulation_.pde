class Meteorite extends Entity {
  PImage sprite;

  Meteorite(float x, float y, PImage img) {
    super(x, y, 60, 60);
    // Pro-Tip: img.get() creates a working copy so the original asset stays clean
    this.sprite = img.get(); 
  }

  // FIX POINT B: Completing the bit-shifting manipulation loop [History]
  void hitEffect() {
    // Pro-Tip: Access the object's buffer (sprite.pixels), not the window buffer! 
    sprite.loadPixels(); 
    
    for (int i = 0; i < sprite.pixels.length; i++) {
      int c = sprite.pixels[i]; // Access raw 32-bit color integer
      
      // Pro-Tip: Bit shifting (>>) and masking (& 0xFF) is "way faster" than red() or green()
      int a = (c >> 24) & 0xFF; 
      int r = 255 - ((c >> 16) & 0xFF); // Manual Inversion [29]
      int g = 255 - ((c >> 8) & 0xFF);  
      int b = 255 - (c & 0xFF);         
      
      sprite.pixels[i] = color(r, g, b, a); 
    }
    
    // Rule: You MUST call updatePixels() to commit changes back to memory
    sprite.updatePixels(); 
  }

  void display() {
    image(sprite, x - w/2, y - h/2, w, h);
  }
}
