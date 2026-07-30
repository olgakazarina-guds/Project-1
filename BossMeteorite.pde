class BossMeteorite extends Entity { 
  PImage bossImg;
  float speedY = 0.2;
  int bossHealth = 25;
  float pulse = 0;

  BossMeteorite(float x, float y, PImage fallbackImg) { 
    super(x, y, 160, 140);
    // Attempt to load a specific boss image
    this.bossImg = loadImage("boss_ship.png");
    // If you haven't added the file yet, it uses the fallback meteorite image
    if (this.bossImg == null) this.bossImg = fallbackImg; 
  }

  void update() {
    y += speedY;
    pulse += 0.05;
    // Slight side-to-side hovering
    x += sin(frameCount * 0.02) * 1.5;
  }

  void hitEffect() { 
    bossHealth--;
    // Visual damage: brief red tint
  }

  boolean isDestroyed() {
    return bossHealth <= 0;
  }

  void display() { 
    pushMatrix();
    translate(x, y);

    // --- 1. Defensive Shield Aura ---
    noFill();
    strokeWeight(3);
    stroke(0, 255, 255, 50 + sin(pulse) * 50);
    ellipse(0, 0, w + 20, h + 20);
    
    // --- 2. The Boss Body ---
    // We apply a red tint based on health
    tint(255, map(bossHealth, 0, 25, 50, 255), map(bossHealth, 0, 25, 50, 255));
    image(bossImg, -w/2, -h/2, w, h);
    noTint(); // Reset tint for other drawings

    // --- 3. Glow Core (Indicates health stage) ---
    float coreSize = map(bossHealth, 0, 25, 10, 50);
    fill(255, 0, 0, 150 + sin(pulse * 2) * 100);
    noStroke();
    ellipse(0, 0, coreSize, coreSize);
    
    // --- 4. Mechanical Details (Rotating Rings) ---
    noFill();
    stroke(100, 255, 100, 150);
    strokeWeight(2);
    pushMatrix();
    rotate(frameCount * 0.05);
    rect(-w/2 - 10, -h/2 - 10, w + 20, h + 20, 10);
    popMatrix();

    popMatrix();
  }
}
