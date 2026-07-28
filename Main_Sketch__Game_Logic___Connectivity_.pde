// PIXEL DEFENDER: Final Version 
// Team Name: Digitalis 
// Topics: 2D Transformations, Array Slot Reuse, Low-Level Image Manipulation

Spaceship ship; 
Cannon cannon;
ArrayList<Meteorite> meteorites = new ArrayList<Meteorite>();
BossMeteorite boss = null;

Laser[] lasers = new Laser[10]; 
PImage meteorImg;

int gameState = 0; // 0 = START, 1 = PLAY, 2 = GAME OVER, 3 = VICTORY
int score = 0;
int health = 100;
int shakeTimer = 0; // Controls screen trembling

void setup() { 
  size(600, 400); // Rule: size() must be the first line
  
  // Load asset with a fallback check to prevent NullPointerException
  meteorImg = loadImage("meteor.png"); 
  if (meteorImg == null) {
    meteorImg = createImage(60, 60, ARGB);
    meteorImg.loadPixels();
    for (int i = 0; i < meteorImg.pixels.length; i++) {
      meteorImg.pixels[i] = color(150, 150, 150);
    }
    meteorImg.updatePixels();
  }
  
  resetGame();
}

void resetGame() {
  score = 0;
  health = 100;
  shakeTimer = 0;
  boss = null;
  
  ship = new Spaceship(); 
  cannon = new Cannon(ship);
  
  meteorites.clear();
  for (int i = 0; i < 3; i++) {
    meteorites.add(new Meteorite(random(50, width - 50), random(-200, -50), meteorImg));
  }

  for (int i = 0; i < lasers.length; i++) { 
    lasers[i] = new Laser(); 
  } 
}

void draw() { 
  background(30); 

  // Apply Screen Shake / Tremble if active
  pushMatrix();
  if (shakeTimer > 0) {
    translate(random(-5, 5), random(-5, 5));
    shakeTimer--;
  }

  if (gameState == 0) {
    drawStartScreen();
  } else if (gameState == 1) {
    drawGameLoop();
  } else if (gameState == 2) {
    drawGameOverScreen();
  } else if (gameState == 3) {
    drawVictoryScreen();
  }
  
  popMatrix();
}

void drawStartScreen() {
  textAlign(CENTER, CENTER);
  fill(0, 255, 200);
  textSize(32);
  text("PIXEL DEFENDER", width / 2, height / 2 - 40);
  
  fill(255);
  textSize(16);
  text("Defend the ship! Destroy meteorites & defeat the Boss!\nClick to Aim & Fire.", width / 2, height / 2 + 10);
  
  fill(255, 255, 0);
  textSize(14);
  text("PRESS ANY KEY TO START", width / 2, height / 2 + 70);
}

void drawGameOverScreen() {
  textAlign(CENTER, CENTER);
  fill(255, 50, 50);
  textSize(32);
  text("GAME OVER", width / 2, height / 2 - 40);
  
  fill(255);
  textSize(18);
  text("Final Score: " + score, width / 2, height / 2 + 10);
  
  fill(255, 255, 0);
  textSize(14);
  text("PRESS ANY KEY TO RESTART", width / 2, height / 2 + 60);
}

void drawVictoryScreen() {
  textAlign(CENTER, CENTER);
  fill(0, 255, 100);
  textSize(32);
  text("VICTORY! BOSS DESTROYED!", width / 2, height / 2 - 40);
  
  fill(255);
  textSize(18);
  text("Final Score: " + score, width / 2, height / 2 + 10);
  
  fill(255, 255, 0);
  textSize(14);
  text("PRESS ANY KEY TO PLAY AGAIN", width / 2, height / 2 + 60);
}

void drawGameLoop() {
  ship.update(); 
  ship.display(); 
  
  cannon.update();
  cannon.display();

  // Lasers update
  for (int i = 0; i < lasers.length; i++) { 
    if (lasers[i].active) { 
      lasers[i].update(); 
      lasers[i].display();
    } 
  } 

  // Check Boss Spawn Condition (At 100 points)
  if (score >= 100 && boss == null) {
    boss = new BossMeteorite(width / 2, -100, meteorImg);
  }

  // Boss Logic
  if (boss != null) {
    boss.update();
    boss.display();
    
    // Laser collisions with Boss
    for (int i = 0; i < lasers.length; i++) {
      if (lasers[i].active) {
        float d = dist(lasers[i].x, lasers[i].y, boss.x, boss.y);
        if (d < boss.w / 2) {
          boss.hitEffect();
          lasers[i].active = false;
          
          if (boss.isDestroyed()) {
            score += 100;
            gameState = 3; // VICTORY!
            break;
          }
        }
      }
    }

    if (boss.y > height) {
      health = 0;
      shakeTimer = 20;
      gameState = 2; // Game Over
    }
  }

  // Regular Meteorites Logic
  for (int j = meteorites.size() - 1; j >= 0; j--) {
    Meteorite m = meteorites.get(j);
    m.update();
    m.display();

    for (int i = 0; i < lasers.length; i++) {
      if (lasers[i].active) {
        float d = dist(lasers[i].x, lasers[i].y, m.x, m.y);
        if (d < m.w / 2) {
          m.hitEffect();
          lasers[i].active = false;
          
          if (m.isDestroyed()) {
            score += 10;
            meteorites.remove(j);
            meteorites.add(new Meteorite(random(50, width - 50), random(-150, -50), meteorImg));
            break;
          }
        }
      }
    }

    // Impact / Missed meteorite
    if (m.y > height) {
      health -= 20;
      shakeTimer = 10; // Trigger ship trembling shake!
      meteorites.remove(j);
      meteorites.add(new Meteorite(random(50, width - 50), random(-150, -50), meteorImg));
      
      if (health <= 0) {
        gameState = 2; 
      }
    }
  }

  drawHUD();
}

void drawHUD() {
  fill(255);
  textSize(16);
  textAlign(LEFT, TOP);
  text("Score: " + score, 20, 20);

  // Ship Health Bar
  stroke(255);
  noFill();
  rect(width - 120, 20, 100, 15);
  fill(health > 30 ? color(0, 255, 0) : color(255, 0, 0));
  noStroke();
  rect(width - 120, 20, map(health, 0, 100, 0, 100), 15);
  
  // Boss Health Bar (if active)
  if (boss != null) {
    fill(255, 50, 50);
    textAlign(CENTER, TOP);
    text("BOSS HEALTH", width / 2, 10);
    stroke(255);
    noFill();
    rect(width / 2 - 100, 30, 200, 15);
    fill(255, 0, 0);
    noStroke();
    rect(width / 2 - 100, 30, map(boss.bossHealth, 0, 15, 0, 200), 15);
  }
}

void mousePressed() { 
  if (gameState == 1) {
    for (int i = 0; i < lasers.length; i++) { 
      if (!lasers[i].active) { 
        lasers[i].spawn(ship.x, ship.y, cannon.angle); 
        break; 
      } 
    } 
  }
}

void keyPressed() {
  if (gameState == 0) {
    gameState = 1;
  } else if (gameState == 2 || gameState == 3) {
    resetGame();
    gameState = 1;
  }
}
