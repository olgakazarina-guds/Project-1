class Meteorite extends Entity {
  PImage sprite;

  Meteorite(float x, float y, PImage img) {
    super(x, y, 60, 60);
    this.sprite = img.get(); 
  }

  void hitEffect() {
    sprite.loadPixels(); 
    int len = sprite.pixels.length;

    for (int i = 0; i < len; i++) {
      int c = sprite.pixels[i]; 
      
      int a = (c >> 24) & 0xFF; 
      int r = 255 - ((c >> 16) & 0xFF); 
      int g = 255 - ((c >> 8) & 0xFF); 
      int b = 255 - (c & 0xFF);         
      
      // Pure bitwise color assembly (faster execution)
      sprite.pixels[i] = (a << 24) | (r << 16) | (g << 8) | b;
    }
    sprite.updatePixels();
  }

  void display() {
    image(sprite, x - w/2, y - h/2, w, h);
  }
}
