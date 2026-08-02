// PIXEL DEFENDER: Digitalis Protocol
// Team Name: Digitalis 
// Topics: 2D Transformations, Array Slot Reuse, Image Manipulation, Parallax

import processing.sound.*;

// --- GLOBAL OBJECTS ---
Spaceship ship; 
Cannon cannon;
ArrayList<Meteorite> meteorites = new ArrayList<Meteorite>();
BossMeteorite boss = null;
Laser[] lasers = new Laser[10]; // TOPIC: ARRAYS - Fixed size array to save memory
Star[] stars = new Star[200]; 

// --- ASSETS, SOUND & FONTS ---
SoundFile engineSnd, laserSnd, explosionSnd;
PImage meteorImg;
PFont titleFont, storyFont; 

int gameState = 0; // 0=START, 1=PLAY, 2=GAMEOVER, 3=VICTORY
int score = 0;
int health = 100;
int shakeTimer = 0; 

void setup() { 
  size(600, 400); 
  pixelDensity(1); // Ensures correct scaling on high-res (Mac) screens
  
  // INITIALIZE FONTS
  titleFont = createFont("Georgia-Bold", 40);
  storyFont = createFont("Verdana", 13);
  
  // TOPIC: ARRAYS - Creating star objects for background depth
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star(i % 3); 
  }
  
  // LOAD IMAGE ASSETS
  meteorImg = loadImage("meteor.png"); 
  if (meteorImg == null) { meteorImg = createImage(60, 60, ARGB); }
  
  // LOAD SOUNDS (Wrapped in try/catch to prevent crashes if files are missing)
  try {
    engineSnd = new SoundFile(this, "engine.wav");
    laserSnd = new SoundFile(this, "laser.wav");
    explosionSnd = new SoundFile(this, "explosion.wav");
    
    if (engineSnd != null) {
      engineSnd.loop();
      engineSnd.amp(0.3); // Set initial background volume
    }
  } catch (Exception e) { println("Sound files missing. Running in silent mode."); }
  
  resetGame();
}

void resetGame() {
  score = 0; health = 100; shakeTimer = 0; boss = null;
  ship = new Spaceship(); 
  cannon = new Cannon(ship);
  
  meteorites.clear();
  for (int i = 0; i < 3; i++) {
    meteorites.add(new Meteorite(random(50, width - 50), random(-200, -50), meteorImg));
  }
  
  for (int i = 0; i < lasers.length; i++) lasers[i] = new Laser(); 
  
  // Restart engine sound safely
  if (engineSnd != null && !engineSnd.isPlaying()) engineSnd.loop();
}

void draw() { 
  background(10); 

  // TOPIC: TRANSFORMATIONS - Use push/pop to apply screen shake to the whole game
  pushMatrix();
  if (shakeTimer > 0) {
    translate(random(-7, 7), random(-7, 7));
    shakeTimer--;
  }

  // STATE MACHINE
  if (gameState == 0) { drawStarfield(); drawStartScreen(); } 
  else if (gameState == 1) { drawStarfield(); drawGameLoop(); } 
  else if (gameState == 2) { if (engineSnd != null) engineSnd.stop(); drawGameOverScreen(); } 
  else if (gameState == 3) { if (engineSnd != null) engineSnd.stop(); drawVictoryScreen(); }
  
  popMatrix();
}

void drawGameLoop() {
  ship.update(); 
  
  // AUDIO: Change engine pitch based on mouse movement speed
  if (engineSnd != null) {
    float speed = abs(mouseX - pmouseX); 
    engineSnd.rate(map(speed, 0, 40, 0.8, 1.3));
    engineSnd.amp(map(speed, 0, 40, 0.15, 0.3));
  }

  ship.display(); 
  cannon.update();
  cannon.display();

  for (Laser l : lasers) { if (l.active) { l.update(); l.display(); } } 

  // SPAWN BOSS Logic
  if (score >= 150 && boss == null) boss = new BossMeteorite(width / 2, -150, meteorImg);

  if (boss != null) {
    boss.update(); boss.display();
    for (Laser l : lasers) {
      if (l.active && dist(l.x, l.y, boss.x, boss.y) < boss.w / 1.8) {
        boss.hitEffect();
        if (explosionSnd != null) explosionSnd.play(0.6, 0.1); 
        l.active = false;
        if (boss.isDestroyed()) { score += 1000; gameState = 3; }
      }
    }
    if (boss.y > height) { health = 0; gameState = 2; }
  }

  // METEORITE COLLISION: Iterating backwards through ArrayList
  for (int j = meteorites.size() - 1; j >= 0; j--) {
    Meteorite m = meteorites.get(j);
    m.update(); m.display();
    for (Laser l : lasers) {
      // FORMULA: dist() calculates if laser coordinate is inside meteorite radius
      if (l.active && dist(l.x, l.y, m.x, m.y) < m.w / 2) {
        m.hitEffect();
        if (explosionSnd != null) explosionSnd.play(random(1.3, 1.6), 0.05); 
        l.active = false;
        if (m.isDestroyed()) {
          score += 10;
          meteorites.remove(j);
          meteorites.add(new Meteorite(random(50, width-50), random(-150, -50), meteorImg));
          break;
        }
      }
    }
    if (m.y > height) {
      health -= 20; shakeTimer = 20; 
      if (explosionSnd != null) explosionSnd.play(0.5, 0.2); 
      meteorites.remove(j);
      meteorites.add(new Meteorite(random(50, width-50), random(-150, -50), meteorImg));
      if (health <= 0) gameState = 2; 
    }
  }
  drawHUD();
}

void drawStarfield() { for (Star s : stars) { s.update(); s.display(); } }

void drawHUD() {
  if (storyFont != null) textFont(storyFont);
  
  // --- PLAYER HUD (Top Left and Top Right) ---
  textAlign(LEFT, TOP);
  fill(255);
  text("SCORE: " + score, 20, 20);
  
  // Ship Health Bar
  noFill(); 
  stroke(0, 168, 255); 
  rect(width - 125, 20, 105, 15, 3);
  fill(health > 30 ? color(0, 168, 255) : color(255, 50, 50));
  noStroke();
  rect(width - 123, 22, map(health, 0, 100, 0, 101), 11);
  
  // --- BOSS HUD (Appears only when Boss is active) ---
  if (boss != null) {
    textAlign(CENTER, TOP);
    fill(255, 0, 0);
    textSize(14);
    text("VOID HARBINGER INTEGRITY", width / 2, 45); 
    
    // Bar Background (Dark Red)
    stroke(255, 0, 0);
    fill(50, 0, 0); 
    rect(width / 2 - 100, 65, 200, 12, 5); 
    
    // Bar Fill (Bright Red)
    fill(255, 0, 0);
    noStroke();
    // Formula: Uses current boss health (0-25) to scale the width (0-200 pixels)
    float barWidth = map(boss.bossHealth, 0, 25, 0, 200);
    rect(width / 2 - 100, 65, barWidth, 12, 5);
  }
}
void drawStartScreen() {
  textAlign(CENTER, CENTER);
  if (titleFont != null) textFont(titleFont);
  fill(0, 50, 100); text("PIXEL DEFENDER", width/2+2, height/2-78); 
  fill(0, 168, 255); text("PIXEL DEFENDER", width / 2, height / 2 - 80);
  if (storyFont != null) textFont(storyFont);
  fill(200);
  text("Digitalis Interceptor stands alone.\nThe Void is approaching Earth's core.", width/2, height/2 - 10);
  fill(255, 255, 0, 150 + 105 * sin(frameCount * 0.1));
  text("PRESS ANY KEY TO ENGAGE", width / 2, height / 2 + 60);
}

void drawGameOverScreen() {
  background(30, 0, 0); textAlign(CENTER, CENTER);
  if (titleFont != null) textFont(titleFont);
  fill(255, 50, 50); text("SYSTEM FAILURE", width / 2, height / 2 - 50);
  if (storyFont != null) textFont(storyFont);
  fill(255); text("The Interceptor has fallen.", width/2, height/2 + 20);
  fill(255, 255, 0); text("Final Score: " + score + "\n\nPRESS ANY KEY TO REBOOT", width / 2, height / 2 + 100);
}

void drawVictoryScreen() {
  background(0, 20, 40); drawStarfield(); textAlign(CENTER, CENTER);
  if (titleFont != null) textFont(titleFont);
  fill(0, 255, 150); text("MISSION ACCOMPLISHED", width / 2, height / 2 - 50);
  if (storyFont != null) textFont(storyFont);
  fill(255); text("The Harbinger is silenced. Astra-Sector is safe.", width/2, height/2 + 20);
  fill(0, 168, 255); text("Final Score: " + score + "\n\nPRESS ANY KEY TO RETURN", width / 2, height / 2 + 100);
}

void mousePressed() { 
  if (gameState == 1) {
    for (Laser l : lasers) { 
      if (!l.active) { 
        l.spawn(ship.x, ship.y, cannon.angle); 
        if (laserSnd != null) laserSnd.play(1.3, 0.1); 
        break; 
      } 
    } 
  }
}

void keyPressed() { if (gameState != 1) { resetGame(); gameState = 1; } }
