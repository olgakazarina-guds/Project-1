// PIXEL DEFENDER: Final Version
// Team Name: Digitalis
// Topics: 2D Transformations, Array Slot Reuse, Low-Level Image Manipulation

Spaceship ship;
Meteorite meteor;
// FIX POINT: Increased array size to 9 for better gameplay
Laser[] lasers = new Laser[3]; 
PImage meteorImg;

void setup() {
  // Rule: size() must be the very first line of setup()
  size(600, 400); 
  
  // Rule: Assets must be located in a folder named /data inside the sketch folder
  meteorImg = loadImage("meteor.png"); 
  
  ship = new Spaceship();
  meteor = new Meteorite(100, 100, meteorImg);
  
  // Pro-Tip: Initialize the array pool with objects to prevent NullPointerExceptions
  for (int i = 0; i < lasers.length; i++) {
    lasers[i] = new Laser();
  }
}

void draw() {
  // Rule: Redraw background every frame to prevent "smearing"
  background(51); 
  
  ship.update();
  ship.display();
  meteor.display();
  
  // Pro-Tip: Always check if an object is 'active' before processing it
  for (int i = 0; i < lasers.length; i++) {
    if (lasers[i].active) {
      lasers[i].update();
      lasers[i].display();
      
      // FIX POINT: The Functional Link (Collision Detection)
      // Check the distance between laser and meteorite center
      float d = dist(lasers[i].x, lasers[i].y, meteor.x, meteor.y);
      if (d < 30) { 
        meteor.hitEffect(); // Trigger the manual bit-shifting flash
        lasers[i].active = false; // "Recycle" the laser slot for reuse
      }
    }
  }
}

// User Interaction: Search-and-Fill Array Recycling
void mousePressed() {
  for (int i = 0; i < lasers.length; i++) {
    // If a slot is inactive, reuse it for a new shot
    if (!lasers[i].active) {
      lasers[i].spawn(ship.x, ship.y, ship.angle);
      break; // Rule: Exit the loop after finding ONE available slot
    }
  }
}
