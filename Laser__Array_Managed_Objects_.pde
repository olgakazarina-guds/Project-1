class Laser extends Entity {
  float vx, vy;
  boolean active = false;

  Laser() {
    super(0, 0, 5, 5);
  }

  void spawn(float x, float y, float a) {
    this.x = x;
    this.y = y;
    this.vx = cos(a) * 5; 
    this.vy = sin(a) * 5;
    this.active = true;
  }
  
  void update() { 
    x += vx; 
    y += vy; 
    if (x < 0 || x > width || y < 0 || y > height) {
      active = false; 
    }
  }
  
  void display() { 
    noStroke();
    fill(255, 0, 0); 
    ellipse(x, y, w, h); 
  }
}
