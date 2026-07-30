import processing.sound.*;

// --- GLOBAL OBJECTS ---
Spaceship ship; 
Cannon cannon;
ArrayList<Meteorite> meteorites = new ArrayList<Meteorite>();
BossMeteorite boss = null;
Laser[] lasers = new Laser[10]; // ARRAY SLOT REUSE: Fixed size array to save memory
Star[] stars = new Star[200]; 

// --- AUDIO & ASSETS ---
SoundFile engineSnd, laserSnd, explosionSnd;
PImage meteorImg;
int gameState = 0; // 0=START, 1=PLAY, 2=GAMEOVER, 3=VICTORY
int score = 0;
int health = 100;
int shakeTimer = 0; 

void setup() { 
  size(600, 400); 
  
  // Initialize stars for Parallax effect
  for (int i = 0; i < stars.length; i++) {
    stars[i] = new Star(i % 3); 
  }
  
  // Load images with fallback to prevent crashes
  meteorImg = loadImage("meteor.png"); 
  if (meteorImg == null) {
    meteorImg = createImage(60, 60, ARGB);
  }
  
  // Initialize Audio with error handling
  try {
    engineSnd = new SoundFile(this, "engine.wav");
    laserSnd = new SoundFile(this, "laser.wav");
    explosionSnd = new SoundFile(this, "explosion.wav");
    engineSnd.loop();
  } catch (Exception e) { println("Sound files missing."); }
  
  resetGame();
}

void resetGame() {
  score = 0; health = 100; boss = null;
  ship = new Spaceship(); 
  cannon = new Cannon(ship);
  meteorites.clear();
  for (int i = 0; i < 3; i++) {
    meteorites.add(new Meteorite(random(50, width-50), random(-200, -50), meteorImg));
  }
  for (int i = 0; i < lasers.length; i++) lasers[i] = new Laser(); 
  if (engineSnd != null) engineSnd.loop();
}

void draw() { 
  background(10); 

  // TRANSFORMATIONS: Screen shake effect
  pushMatrix();
  if (shakeTimer > 0) {
    translate(random(-7, 7), random(-7, 7));
    shakeTimer--;
  }

  if (gameState == 0) { drawStarfield(); drawStartScreen(); } 
  else if (gameState == 1) { drawStarfield(); drawGameLoop(); } 
  else if (gameState == 2) { if(engineSnd!=null) engineSnd.stop(); drawGameOverScreen(); } 
  else if (gameState == 3) { if(engineSnd!=null) engineSnd.stop(); drawVictoryScreen(); }
  
  popMatrix();
}

void drawGameLoop() {
  ship.update(); 
  
  // SPATIAL AUDIO: Map mouse speed to pitch and ship position to Left/Right speakers
  if (engineSnd != null) {
    float mouseSpeed = abs(mouseX - pmouseX); 
    engineSnd.rate(map(mouseSpeed, 0, 40, 0.8, 1.4));
    engineSnd.pan(map(ship.x, 0, width, -1.0, 1.0));
  }

  ship.display(); 
  cannon.update();
  cannon.display();

  // Update Lasers
  for (Laser l : lasers) { 
    if (l.active) { l.update(); l.display(); } 
  } 

  // Boss Spawn at 150 points
  if (score >= 150 && boss == null) boss = new BossMeteorite(width/2, -150, meteorImg);

  if (boss != null) {
    boss.update(); boss.display();
    for (Laser l : lasers) {
      if (l.active && dist(l.x, l.y, boss.x, boss.y) < boss.w/1.8) {
        boss.hitEffect();
        if (explosionSnd != null) explosionSnd.play(0.6, 0.7);
        l.active = false;
        if (boss.isDestroyed()) { score += 1000; gameState = 3; }
      }
    }
    if (boss.y > height) { health = 0; gameState = 2; }
  }

  // Meteorite collisions and health logic
  for (int j = meteorites.size()-1; j >= 0; j--) {
    Meteorite m = meteorites.get(j);
    m.update(); m.display();
    for (Laser l : lasers) {
      if (l.active && dist(l.x, l.y, m.x, m.y) < m.w/2) {
        m.hitEffect();
        if (explosionSnd != null) explosionSnd.play(random(0.9, 1.3), 0.3);
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
      meteorites.remove(j);
      meteorites.add(new Meteorite(random(50, width-50), random(-150, -50), meteorImg));
      if (health <= 0) gameState = 2;
    }
  }
  drawHUD();
}

void drawStarfield() { for (Star s : stars) { s.update(); s.display(); } }

void drawHUD() {
  fill(255); textSize(14); textAlign(LEFT, TOP);
  text("SECTOR SCORE: " + score, 20, 20);
  noFill(); stroke(0, 168, 255); rect(width-125, 20, 105, 15, 3);
  fill(health > 30 ? color(0, 168, 255) : color(255, 50, 50));
  rect(width-123, 22, map(health, 0, 100, 0, 101), 11);
  if (boss != null) {
    fill(255, 0, 0); textAlign(CENTER, TOP); text("VOID HARBINGER INTEGRITY", width/2, 12);
    noFill(); stroke(255, 0, 0); rect(width/2-100, 28, 200, 10, 2);
    fill(200, 0, 0); rect(width/2-100, 28, map(boss.bossHealth, 0, 25, 0, 200), 10);
  }
}

void drawStartScreen() {
  textAlign(CENTER, CENTER); fill(0, 168, 255); textSize(48); text("PIXEL DEFENDER", width/2, height/2-60);
  fill(200); textSize(15); text("The void is cold, but your lasers are hotter.", width/2, height/2-20);
  fill(100); textSize(12); text("Team Digitalis | Interceptor v2.0 | Protocol: Active", width/2, height/2+10);
  fill(255, 140, 0, 150 + 105*sin(frameCount*0.1)); text("PRESS ANY KEY TO ENGAGE", width/2, height/2+65);
}

void drawGameOverScreen() {
  background(30, 0, 0); textAlign(CENTER, CENTER); fill(255, 50, 50); textSize(40); text("SYSTEM FAILURE", width/2, height/2-40);
  fill(255); text("Interceptor Lost in Astra-Sector.\nFinal Score: " + score, width/2, height/2+30);
  fill(255, 255, 0); text("PRESS ANY KEY TO REBOOT", width/2, height/2+100);
}

void drawVictoryScreen() {
  background(0, 20, 40); drawStarfield(); textAlign(CENTER, CENTER); fill(0, 255, 150); textSize(40); text("MISSION ACCOMPLISHED", width/2, height/2-40);
  fill(255); text("Goliath-Class Core-Eater Neutralized.\nFinal Score: " + score, width/2, height/2+30);
  fill(0, 168, 255); text("PRESS ANY KEY TO RETURN TO BASE", width/2, height/2+100);
}

void mousePressed() { 
  if (gameState == 1) {
    for (Laser l : lasers) { 
      if (!l.active) { l.spawn(ship.x, ship.y, cannon.angle); if(laserSnd!=null) laserSnd.play(1.0, 0.4); break; } 
    } 
  }
}

void keyPressed() { if (gameState != 1) { resetGame(); gameState = 1; } }
