// PIXEL DEFENDER: Digitalis Protocol
// Team Name: Digitalis | Developer: Olga Kazarina (S-01132)
// TOPICS: 2D Transformations, Array Slot Reuse, Image Manipulation, Parallax

import processing.sound.*;

// --- GLOBAL OBJECTS ---
Spaceship ship; 
Cannon cannon;
ArrayList<Meteorite> meteorites = new ArrayList<Meteorite>();
BossMeteorite boss = null;
Laser[] lasers = new Laser[10]; // TOPIC: ARRAYS - Fixed size array for object pooling
Star[] stars = new Star[200]; 

// --- AUDIO, IMAGES & FONTS ---
SoundFile engineSnd, laserSnd, explosionSnd;
boolean audioEnabled = false; // Safety flag to prevent crashes if sounds fail
PImage meteorImg;
PFont titleFont, storyFont; 

int gameState = 0; // State Machine: 0=START, 1=PLAY, 2=GAMEOVER, 3=VICTORY
int score = 0;
int health = 100;
int shakeTimer = 0; 

void setup() { 
  size(600, 400); 
  pixelDensity(1); // Standardizes pixels for high-resolution Mac/Retina screens
  
  // INITIALIZE FONTS (Using standard names to ensure cross-platform compatibility)
  titleFont = createFont("SansSerif", 40); 
  storyFont = createFont("Serif", 13);
  
  // TOPIC: ARRAYS - Creating star objects for background depth
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star(i % 3); 
  }
  
  // LOAD IMAGE ASSETS
  meteorImg = loadImage("meteor.png"); 
  if (meteorImg == null) { meteorImg = createImage(60, 60, ARGB); }
  
  // LOAD SOUNDS (Safety Net: ensures the game runs even if audio files are missing)
  try {
    engineSnd = new SoundFile(this, "engine.wav");
    laserSnd = new SoundFile(this, "laser.wav");
    explosionSnd = new SoundFile(this, "explosion.wav");
    
    if (engineSnd != null && engineSnd.duration() > 0) {
      audioEnabled = true;
      engineSnd.loop();
      engineSnd.amp(0.3);
    }
  } catch (Exception e) { 
    println("Audio failed. Silent Mode Active."); 
    audioEnabled = false; 
  }
  
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
  
  // Restart audio safely
  if (audioEnabled && !engineSnd.isPlaying()) engineSnd.loop();
}

void draw() { 
  background(10); 

  // TOPIC: TRANSFORMATIONS - Using the Matrix Stack to apply global screen shake
  pushMatrix();
  if (shakeTimer > 0) {
    translate(random(-7, 7), random(-7, 7));
    shakeTimer--;
  }

  // STATE MACHINE SWITCHER
  if (gameState == 0) { drawStarfield(); drawStartScreen(); } 
  else if (gameState == 1) { drawStarfield(); drawGameLoop(); } 
  else if (gameState == 2) { if (audioEnabled) engineSnd.stop(); drawGameOverScreen(); } 
  else if (gameState == 3) { if (audioEnabled) engineSnd.stop(); drawVictoryScreen(); }
  
  popMatrix();
}

void drawGameLoop() {
  ship.update(); 
  
  // AUDIO MODULATION: Pitch changes based on mouse movement speed
  if (audioEnabled) {
    float speed = abs(mouseX - pmouseX); 
    engineSnd.rate(map(speed, 0, 40, 0.8, 1.3));
    engineSnd.amp(map(speed, 0, 40, 0.15, 0.3));
  }

  ship.display(); 
  cannon.update();
  cannon.display();

  // Projectile loop using fixed array
  for (Laser l : lasers) { if (l.active) { l.update(); l.display(); } } 

  // SPAWN BOSS Condition (Triggered at 150 points)
  if (score >= 150 && boss == null) boss = new BossMeteorite(width / 2, -150, meteorImg);

  if (boss != null) {
    boss.update(); boss.display();
    for (Laser l : lasers) {
      // FORMULA: dist() calculates circular collision
      if (l.active && dist(l.x, l.y, boss.x, boss.y) < boss.w / 1.8) {
        boss.hitEffect();
        if (audioEnabled) explosionSnd.play(0.6, 0.1); 
        l.active = false;
        if (boss.isDestroyed()) { score += 1000; gameState = 3; }
      }
    }
    if (boss.y > height) { health = 0; gameState = 2; }
  }

  // ArrayList management for enemies
  for (int j = meteorites.size() - 1; j >= 0; j--) {
    Meteorite m = meteorites.get(j);
    m.update(); m.display();
    for (Laser l : lasers) {
      if (l.active && dist(l.x, l.y, m.x, m.y) < m.w / 2) {
        m.hitEffect(); // TOPIC: IMAGE MANIPULATION (Bitwise flash)
        if (audioEnabled) explosionSnd.play(random(1.3, 1.6), 0.05); 
        l.active = false;
        if (m.isDestroyed()) {
          score += 10;
          meteorites.remove(j);
          meteorites.add(new Meteorite(random(50, width-50), random(-150, -50), meteorImg));
          break;
        }
      }
    }
    // Impact logic
    if (m.y > height) {
      health -= 20; shakeTimer = 20; 
      if (audioEnabled) explosionSnd.play(0.5, 0.2); 
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
  textAlign(LEFT, TOP); fill(255);
  text("SCORE: " + score, 20, 20);
  noFill(); stroke(0, 168, 255); rect(width - 125, 20, 105, 15, 3);
  fill(health > 30 ? color(0, 168, 255) : color(255, 50, 50));
  rect(width - 123, 22, map(health, 0, 100, 0, 101), 11);
  
  // BOSS HEALTH BAR: Centered at the top
  if (boss != null) {
    textAlign(CENTER, TOP); fill(255, 0, 0); textSize(12);
    text("VOID HARBINGER INTEGRITY", width / 2, 10); 
    stroke(255, 0, 0); fill(50, 0, 0); 
    rect(width / 2 - 100, 25, 200, 12, 5); 
    fill(255, 0, 0); noStroke();
    // FORMULA: map() determines the visual width based on health value
    rect(width / 2 - 100, 25, map(boss.bossHealth, 0, 25, 0, 200), 12, 5);
  }
}

void drawStartScreen() {
  textAlign(CENTER, CENTER);
  if (titleFont != null) textFont(titleFont);
  fill(0, 50, 100); text("PIXEL DEFENDER", width/2+2, height/2-78); // 3D Shadow
  fill(0, 168, 255); text("PIXEL DEFENDER", width / 2, height / 2 - 80);
  if (storyFont != null) textFont(storyFont);
  fill(200);
  text("Digitalis Interceptor stands alone.\nThe Void swarm is approaching Earth's core.", width/2, height/2 - 10);
  // FORMULA: sin() creates a smooth pulsing transparency for the prompt
  fill(255, 255, 0, 150 + 105 * sin(frameCount * 0.1));
  text("PRESS ANY KEY TO ENGAGE", width / 2, height / 2 + 60);
}

void drawGameOverScreen() {
  background(30, 0, 0); textAlign(CENTER, CENTER);
  if (titleFont != null) textFont(titleFont);
  fill(100, 0, 0); text("SYSTEM FAILURE", width/2+2, height/2-48); // Shadow
  fill(255, 50, 50); text("SYSTEM FAILURE", width / 2, height / 2 - 50);
  if (storyFont != null) textFont(storyFont);
  fill(255); text("The Interceptor has fallen.", width/2, height/2 + 20);
  fill(255, 255, 0); text("Final Score: " + score + "\n\nPRESS ANY KEY TO REBOOT", width / 2, height / 2 + 100);
}

void drawVictoryScreen() {
  background(0, 20, 40); drawStarfield(); textAlign(CENTER, CENTER);
  if (titleFont != null) textFont(titleFont);
  fill(0, 100, 50); text("MISSION ACCOMPLISHED", width/2+2, height/2-48); // Shadow
  fill(0, 255, 150); text("MISSION ACCOMPLISHED", width / 2, height / 2 - 50);
  if (storyFont != null) textFont(storyFont);
  fill(255); text("The Harbinger is silenced. Astra-Sector is safe.", width/2, height/2 + 20);
  fill(0, 168, 255); text("Final Score: " + score + "\n\nPRESS ANY KEY TO RETURN", width / 2, height / 2 + 100);
}

void mousePressed() { 
  if (gameState == 1) {
    // RECYCLING: Finding an inactive array slot to spawn a new laser
    for (Laser l : lasers) { 
      if (!l.active) { 
        l.spawn(ship.x, ship.y, cannon.angle); 
        if (audioEnabled) laserSnd.play(1.3, 0.1); 
        break; 
      } 
    } 
  }
}

void keyPressed() { if (gameState != 1) { resetGame(); gameState = 1; } }
