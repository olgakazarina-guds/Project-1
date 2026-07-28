// Main Sketch: Game Logic & Connectivity
Spaceship ship;
Meteorite meteor;
Laser[] lasers = new Laser[3]; // Capacity for 9 simultaneous shots
PImage meteorImg;

void setup() {
  size(600, 400); // Rule: Must be the first line
  meteorImg = loadImage("meteor.png"); // Place in /data folder
  
  ship = new Spaceship();
  meteor = new Meteorite(100, 100, meteorImg);
  
  // Initialize the array pool to prevent NullPointerExceptions
  for (int i = 0; i < lasers.length; i++) {
    lasers[i] = new Laser();
  }
}

void draw() {
  background(51); // Prevent "smearing" by wiping the slate
  
  ship.update();
  ship.display();
  meteor.display();
  
  for (int i = 0; i < lasers.length; i++) {
    if (lasers[i].active) {
      lasers[i].update();
      lasers[i].display();
      
      // THE FUNCTIONAL LINK: Collision Detection
      float d = dist(lasers[i].x, lasers[i].y, meteor.x, meteor.y);
      if (d < 30) { // Check distance against meteorite radius
        meteor.hitEffect(); // Trigger the manual bit-shifting flash
        lasers[i].active = false; // Deactivate laser for recycling
      }
    }
  }
}

void mousePressed() {
  // Array Slot Reuse: Search for an inactive laser slot
  for (int i = 0; i < lasers.length; i++) {
    if (!lasers[i].active) {
      lasers[i].spawn(ship.x, ship.y, ship.angle);
      break; 
    }
  }
}
