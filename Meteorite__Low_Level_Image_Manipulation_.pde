class Meteorite extends Entity { 
  PImage sprite;

  Meteorite(float x, float y, PImage img) { 
    super(x, y, 60, 60); 
    // Create an independent copy to avoid mutating the global loaded asset
    this.sprite = img.get(); 
  }

  void hitEffect() { 
    sprite.loadPixels(); // Access pixel buffer
    
    for (int i = 0; i < sprite.pixels.length; i++) {
      int p = sprite.pixels[i];
      
      // Extract ARGB channels using bit shifts and bitwise AND
      int a = (p >> 24) & 0xFF;
      int r = (p >> 16) & 0xFF;
      int g = (p >> 8)  & 0xFF;
      int b = p         & 0xFF;
      
      // Skip transparent pixels so PNG transparency remains intact
      if (a > 0) {
        // Shift toward red and constrain channel values between 0 and 255
        r = min(255, r + 50);
        g = (int)(g * 0.8);
        b = (int)(b * 0.8);
        
        // Reconstruct the 32-bit ARGB pixel using bitwise OR and left shifts
        sprite.pixels[i] = (a << 24) | (r << 16) | (g << 8) | b;
      }
    }
    
    sprite.updatePixels(); // Commit pixel changes back to image buffer
  }

  void display() { 
    image(sprite, x - w/2, y - h/2, w, h); 
  } 
}
