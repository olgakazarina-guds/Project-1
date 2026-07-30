// PIXEL DEFENDER: Digitalis Protocol - FINAL POLISHED VERSION
// Team Name: Digitalis 
// Topics: Parallax Starfields, Matrix Stack Balance, Bitwise Pixel Ops, Array Recycling

// --- GLOBAL OBJECTS ---
Spaceship ship; 
Cannon cannon;
ArrayList<Meteorite> meteorites = new ArrayList<Meteorite>();
BossMeteorite boss = null;
Laser[] lasers = new Laser[10]; 
Star[] stars = new Star[200]; 

// --- GAME ASSETS & STATE ---
PImage meteorImg;
int gameState = 0; // 0=START, 1=PLAY, 2=GAMEOVER, 3=VICTORY
int score = 0;
int health = 100;
int shakeTimer = 0; 

void setup() { 
  size(600, 400); 
  
  // Initialize Parallax Starfield
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star(i % 3); 
  }
  
  // Load asset with procedural fallback
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

  // Array Recycling: Initialize laser objects once
  for (int i = 0; i < lasers.length; i++) { 
    lasers[i] = new Laser(); 
  } 
}

void draw() { 
  background(10); // Deep Space Black

  // Apply Screen Shake via 2D Transformation
  pushMatrix();
  if (shakeTimer > 0) {
    translate(random(-7, 7), random(-7, 7));
    shakeTimer--;
  }

  // --- STATE MACHINE ---
  if (gameState == 0) {
    drawStarfield();
    drawStartScreen();
  } else if (gameState == 1) {
    drawStarfield();
    drawGameLoop();
  } else if (gameState == 2) {
    drawGameOverScreen();
  } else if (gameState == 3) {
    drawVictoryScreen();
  }
  
  popMatrix();
}

// --- CORE GAMEPLAY LOOP ---

void drawGameLoop() {
  ship.update(); 
  ship.display(); 
  cannon.update();
  cannon.display();

  // 1. Lasers Update (Recycling Logic)
  for (int i = 0; i < lasers.length; i++) { 
    if (lasers[i].active) { 
      lasers[i].update(); 
      lasers[i].display();
    } 
  } 

  // 2. Boss Logic (Void Harbinger)
  if (score >= 150 && boss == null) {
    boss = new BossMeteorite(width / 2, -150, meteorImg);
  }

  if (boss != null) {
    boss.update();
    boss.display();
    
    for (int i = 0; i < lasers.length; i++) {
      if (lasers[i].active) {
        float d = dist(lasers[i].x, lasers[i].y, boss.x, boss.y);
        if (d < boss.w / 1.8) { // Optimized collision radius
          boss.hitEffect();
          shakeTimer = 4; // Visual impact feedback
          lasers[i].active = false;
          if (boss.isDestroyed()) {
            score += 1000;
            gameState = 3; // Victory!
          }
        }
      }
    }
    if (boss.y > height) { health = 0; gameState = 2; }
  }

  // 3. Regular Meteorite Logic
  for (int j = meteorites.size() - 1; j >= 0; j--) {
    Meteorite m = meteorites.get(j);
    m.update();
    m.display();

    for (int i = 0; i < lasers.length; i++) {
      if (lasers[i].active && dist(lasers[i].x, lasers[i].y, m.x, m.y) < m.w / 2) {
        m.hitEffect(); // Triggers Bitwise damage and Red Flash
        lasers[i].active = false;
        if (m.isDestroyed()) {
          score += 10;
          meteorites.remove(j);
          meteorites.add(new Meteorite(random(50, width-50), random(-150, -50), meteorImg));
          break;
        }
      }
    }

    if (m.y > height) {
      health -= 20;
      shakeTimer = 20; // HEAVY shake on ship damage
      meteorites.remove(j);
      meteorites.add(new Meteorite(random(50, width-50), random(-150, -50), meteorImg));
      if (health <= 0) gameState = 2; 
    }
  }

  drawHUD();
}

// --- UI & SCREEN RENDERING ---

void drawStarfield() {
  for (Star s : stars) {
    s.update();
    s.display();
  }
}

void drawHUD() {
  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  text("SECTOR SCORE: " + score, 20, 20);

  // Digitalis HUD Style (Cyan/Orange)
  stroke(0, 168, 255);
  noFill();
  rect(width - 125, 20, 105, 15, 3);
  fill(health > 30 ? color(0, 168, 255) : color(255, 50, 50));
  noStroke();
  rect(width - 123, 22, map(health, 0, 100, 0, 101), 11);
  
  if (boss != null) {
    fill(255, 0, 0);
    textAlign(CENTER, TOP);
    textSize(12);
    text("VOID HARBINGER INTEGRITY", width / 2, 10);
    stroke(255, 0, 0, 150);
    noFill();
    rect(width / 2 - 100, 25, 200, 10, 2);
    fill(200, 0, 0);
    noStroke();
    rect(width / 2 - 100, 25, map(boss.bossHealth, 0, 25, 0, 200), 10);
  }
}

void drawStartScreen() {
  textAlign(CENTER, CENTER);
  fill(0, 168, 255);
  textSize(48);
  text("PIXEL DEFENDER", width / 2, height / 2 - 60);
  
  fill(200);
  textSize(15);
  text("The void is cold, but your lasers are hotter.", width / 2, height / 2 - 20);
  
  fill(100);
  textSize(12);
  text("Team Digitalis | Interceptor v2.0 | Protocol: Active", width / 2, height / 2 + 10);
  
  float pulse = 150 + 105 * sin(frameCount * 0.1);
  fill(255, 140, 0, pulse);
  textSize(18);
  text("PRESS ANY KEY TO ENGAGE", width / 2, height / 2 + 65);
}

void drawGameOverScreen() {
  background(30, 0, 0);
  textAlign(CENTER, CENTER);
  fill(255, 50, 50);
  textSize(40);
  text("SYSTEM FAILURE", width / 2, height / 2 - 40);
  fill(255);
  text("Interceptor Lost in Astra-Sector.\nFinal Score: " + score, width / 2, height / 2 + 30);
  fill(255, 255, 0);
  textSize(16);
  text("PRESS ANY KEY TO REBOOT", width / 2, height / 2 + 100);
}

void drawVictoryScreen() {
  background(0, 20, 40);
  drawStarfield();
  textAlign(CENTER, CENTER);
  fill(0, 255, 150);
  textSize(40);
  text("MISSION ACCOMPLISHED", width / 2, height / 2 - 40);
  fill(255);
  text("Goliath-Class Core-Eater Neutralized.\nFinal Score: " + score, width / 2, height / 2 + 30);
  fill(0, 168, 255);
  textSize(16);
  text("PRESS ANY KEY TO RETURN TO BASE", width / 2, height / 2 + 100);
}

// --- INPUT HANDLING ---

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
  if (gameState == 0 || gameState == 2 || gameState == 3) {
    resetGame();
    gameState = 1;
  }
}
