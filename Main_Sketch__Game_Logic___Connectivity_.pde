// PIXEL DEFENDER: Final Version 
// Team Name: Digitalis 
// Topics: 2D Transformations, Array Slot Reuse, Low-Level Image Manipulation

Spaceship ship; 
Meteorite meteor;

// Fixed array size to 10 for Array Slot Reuse demonstration
Laser[] lasers = new Laser[10]; 
PImage meteorImg;

void setup() { 
  size(600, 400); // Rule: size() must be the first line
  
  // Note: Place "meteor.png" inside the "data" subfolder of your sketch directory
  meteorImg = loadImage("meteor.png"); 
  ship = new Spaceship(); 
  meteor = new Meteorite(100, 100, meteorImg);

  for (int i = 0; i < lasers.length; i++) { 
    lasers[i] = new Laser(); 
  } 
}

void draw() { 
  background(51); // Redraw background to prevent "smearing"

  ship.update(); 
  ship.display(); 
  meteor.display();

  for (int i = 0; i < lasers.length; i++) { 
    if (lasers[i].active) { 
      lasers[i].update(); 
      lasers[i].display();
      
      // Collision detection logic
      float d = dist(lasers[i].x, lasers[i].y, meteor.x, meteor.y);
      if (d < meteor.w / 2) {
        meteor.hitEffect();       // Triggers pixel manipulation
        lasers[i].active = false; // Recycle the laser slot
      }
    } 
  } 
}

void mousePressed() { 
  for (int i = 0; i < lasers.length; i++) { 
    if (!lasers[i].active) { 
      lasers[i].spawn(ship.x, ship.y, ship.angle); 
      break; 
    } 
  } 
}
