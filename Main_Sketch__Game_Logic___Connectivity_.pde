// PIXEL DEFENDER: Final Version
// Team Name: Digitalis
// Topics: 2D Transformations, Array Slot Reuse, Low-Level Image Manipulation

Spaceship ship;
Meteorite meteor;
// FIX: Increased array size for better gameplay [History]
Laser[] lasers = new Laser[1]; 
PImage meteorImg;

void setup() {
  size(600, 400); // Rule: size() must be the first line
  meteorImg = loadImage("meteor.png"); // Assets must be in /data folder
  
  ship = new Spaceship();
  meteor = new Meteorite(100, 100, meteorImg);
  
  // Pro-Tip: Initialize the array pool to prevent NullPointerExceptions [2]
  for (int i = 0; i < lasers.length; i++) {
    lasers[i] = new Laser();
  }
}

void draw() {
  background(51); // Rule: Redraw background to prevent "smearing" [3]
  
  ship.update();
  ship.display();
  meteor.display();
  
  for (int i = 0; i < lasers.length; i++) {
    if (lasers[i].active) {
      lasers[i].update();
      lasers[i].display();
      
      // FIX: The Functional Link (Collision Detection) [History]
      // Use dist() to check if laser hits the meteorite
      float d = dist(lasers[i].x, lasers[i].y, meteor.x, meteor.y);
      if (d < 30) { 
        meteor.hitEffect(); // Trigger manual bit-shifting flash
        lasers[i].active = false; // Recycle laser slot [History]
      }
    }
  }
}

void mousePressed() {
  // Search-and-Fill logic for "Infinite Ammo" [History]
  for (int i = 0; i < lasers.length; i++) {
    if (!lasers[i].active) {
      lasers[i].spawn(ship.x, ship.y, ship.angle);
      break; 
    }
  }
}
