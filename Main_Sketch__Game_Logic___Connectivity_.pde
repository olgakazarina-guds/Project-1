Spaceship ship;
Meteorite meteor;
Laser[] lasers = new Laser[9];
PImage meteorImg;

void setup() {
  size(600, 400);
  meteorImg = loadImage("meteor.png"); 
  
  ship = new Spaceship();
  meteor = new Meteorite(100, 100, meteorImg);

  // Pre-allocate pool to eliminate GC allocations during play
  for (int i = 0; i < lasers.length; i++) {
    lasers[i] = new Laser();
  }
}

void draw() {
  background(51);
  
  ship.update();
  ship.display();
  meteor.display();
  
  for (int i = 0; i < lasers.length; i++) {
    if (lasers[i].active) {
      lasers[i].update();
      lasers[i].display();
      
      // Fast squared distance check (30^2 = 900)
      float dx = lasers[i].x - meteor.x;
      float dy = lasers[i].y - meteor.y;
      if ((dx * dx + dy * dy) < 900) { 
        meteor.hitEffect();
        lasers[i].active = false;
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
