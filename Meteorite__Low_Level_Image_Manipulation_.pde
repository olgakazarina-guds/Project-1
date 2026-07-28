class Meteorite extends Entity {
  PImage sprite;

  Meteorite(float x, float y, PImage img) {
    super(x, y, 60, 60);
    this.sprite = img.get(); // Working copy of the image
  }

  // Phase 4: Low-Level Pixel Buffer Management
  void hitEffect() {
    sprite.loadPixels(); // Rule: Access object buffer, not window buffer
    
    for (int i = 0; i < sprite.pixels.length; i++) {
      int c = sprite.pixels[i]; // Access 32-bit color integer
      
      // Extract channels using bit shifting (>>) and binary AND mask (& 0xFF)
      int a = (c >> 24) & 0xFF; 
      int r = 255 - ((c >> 16) & 0xFF); // Manual Color Inversion
      int g = 255 - ((c >> 8) & 0xFF); 
      int b = 255 - (c & 0xFF); 
      
      // Reconstruct the 32-bit integer and save to the buffer
      sprite.pixels[i] = color(r, g, b, a); 
    }
    
    sprite.updatePixels(); // Commit memory changes back to the PImage
  }

  void display() {
    image(sprite, x - w/2, y - h/2, w, h);
  }
}
