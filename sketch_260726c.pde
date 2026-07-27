// PIXEL DEFENDER
// Topics: 2D Transformations, Arrays, Low-Level Image Manipulation
// Pro-Tip: Image data is handled in the object buffer, not just the display window.

Spaceship ship;
Meteorite meteor;
Laser[] lasers = new Laser[4]; // Array to manage active projectiles
int laserCount = 0;
PImage meteorImg;

void setup() {
  size(600, 400); // size() must be the first line
  meteorImg = loadImage("meteor.png"); // Place in /data folder
  ship = new Spaceship();
  meteor = new Meteorite(100, 100, meteorImg);
}

void draw() {
  background(51); // Wipe the slate each frame to prevent smearing
  
  ship.update();
  ship.display();
  meteor.display();
  
  for (int i = 0; i < laserCount; i++) {
    if (lasers[i].active) {
      lasers[i].update();
      lasers[i].display();
      
      // Collision detection
      if (dist(lasers[i].x, lasers[i].y, meteor.x, meteor.y) < 30) {
        meteor.hitEffect(); // Trigger manual pixel manipulation
        lasers[i].active = false;
      }
    }
  }
}

void mousePressed() {
  if (laserCount < lasers.length) {
    lasers[laserCount] = new Laser(ship.x, ship.y, ship.angle);
    laserCount++;
  }
}

// --- CLASSES ---

class Entity { // Base class to share common features 
  float x, y, w, h;
  Entity(float x, float y, float w, float h) {
    this.x = x; this.y = y; this.w = w; this.h = h;
  }
}

class Spaceship extends Entity {
  float angle;
  Spaceship() { super(300, 200, 30, 30); }

  void update() {
    angle = atan2(mouseY - y, mouseX - x); // Points ship toward mouse
  }

  void display() {
    pushMatrix(); // Save current coordinate system 
    translate(x, y); // Move origin to ship center 
    rotate(angle); // Rotate around ship's own center 
    fill(0, 255, 0);
    triangle(w, 0, -w/2, -h/2, -w/2, h/2); 
    popMatrix(); // Restore coordinate system 
  }
}

class Laser extends Entity {
  float vx, vy;
  boolean active = true;
  Laser(float x, float y, float a) {
    super(x, y, 5, 5);
    vx = cos(a) * 5; vy = sin(a) * 5;
  }
  void update() { x += vx; y += vy; if (x<0 || x>width) active = false; }
  void display() { fill(255, 0, 0); ellipse(x, y, w, h); }
}

class Meteorite extends Entity {
  PImage sprite;
  Meteorite(float x, float y, PImage img) {
    super(x, y, 60, 60);
    this.sprite = img.get(); // Working copy of image [16]
  }

  void hitEffect() {
    sprite.loadPixels(); // Load pixels into the image object's buffer
    for (int i = 0; i < sprite.pixels.length; i++) {
      int c = sprite.pixels[i];
      // Use Bit Shifting and binary AND mask to extract channels
      int a = (c >> 24) & 0xFF; 
      int r = 255 - ((c >> 16) & 0xFF); // Invert Red
      int g = 255 - ((c >> 8) & 0xFF);  // Invert Green
      int b = 255 - (c & 0xFF);         // Invert Blue
      sprite.pixels[i] = color(r, g, b, a); // Reconstruct color
    }
    sprite.updatePixels(); // Commit changes back to image object 
  }

  void display() {
    image(sprite, x - w/2, y - h/2, w, h);
  }
}
