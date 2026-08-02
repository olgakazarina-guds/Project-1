# PIXEL DEFENDER: Digitalis Protocol
> **"The void is cold, but your lasers are hotter. Stand as the final shield against the crushing darkness."**

## 🌌 Project Overview
**Pixel Defender** is an interactive 2D space shooter developed in Processing. Players command the *Digitalis Interceptor v2.0* to defend the Astra-Sector from an onslaught of Void-Matter meteorites and the catastrophic *Void Harbinger* boss ship. 

This project was developed for **Coding Camp I: Fundamentals at the German University of Digital Science.**

---

## 🚀 Key Technical Features
This game demonstrates mastery of core programming topics through the following implementations:

1. **2D Transformations & Matrix Stack:** 
   - Uses `pushMatrix()`, `popMatrix()`, and `rotate()` to isolate the ship’s hull from its targeting turret.
   - Implements a global coordinate transformation for a **Screen Shake** effect upon taking damage.
2. **Object Pooling & Array Recycling:** 
   - Instead of dynamic object instantiation, the game uses a fixed-size `Laser[10]` array. Inactive slots are recycled to minimize heap overhead and prevent garbage collection stutters.
3. **Low-Level Image Manipulation:** 
   - Uses direct `pixels[]` access and **bitwise operations** (`(p >> 24) & 0xFF`) to mathematically generate red-tinted damage frames for meteorites, creating a dynamic "heat damage" effect.
4. **Parallax Void Engine:** 
   - A multi-layered background system where star layers move at independent speeds to simulate 3D depth in a 2D environment.
5. **Robustness & Error Handling:** 
   - Integrated `try/catch` blocks and `null` safety checks for asset loading to ensure the game remains playable even if external libraries or files are missing.

---

## 🎮 How to Play
1. **Movement:** Move your **Mouse** left/right to navigate the Interceptor.
2. **Aiming:** The turret automatically tracks your mouse crosshair using `atan2()` logic.
3. **Firing:** Click the **Left Mouse Button** to fire the plasma laser.
4. **States:** Press **Any Key** on the start or game-over screens to engage the protocol.

---

## 🛠️ Installation & Requirements
1. **Software:** Download and install [Processing 4.x](https://processing.org/download).
2. **Library:** 
   - Open Processing.
   - Go to **Sketch > Import Library > Manage Libraries...**
   - Search for **"Sound"** and install **"Sound | The Processing Foundation"**.
3. **Execution:**
   - Clone this repository or download the ZIP file.
   - Open the file **`PixelDefender.pde`**.
   - **Note:** If Processing displays a dialog box saying the file needs to be inside a folder named "PixelDefender," click **OK**.
   - The project is pre-configured; all assets (.wav, .png) are already located in the `/data` folder.
   - Press the **Run** (Play) button to engage the protocol.

---

## 📝 Iterative Balancing (Post-Mortem Notes)
During the final polish phase, several "Pivot" decisions were made to improve the user experience:
* **Gameplay Pacing:** The Boss spawn threshold was moved from 100 to 150 points to allow for a more satisfying difficulty curve.
* **Combat Rhythm:** Meteorite health was adjusted to 3 hits (down from 5) to create a snappier arcade feel.
* **Math Precision:** Collision detection was reverted from squared distance math back to the standard `dist()` function to ensure pixel-perfect accuracy for varying boss hitboxes.

---

## 👥 Development Team
Developed by the sole developer of **Team Digitalis**.

---
*Built with Processing, Bitwise Logic, and Spatial Audio.*

---

## 📜 Asset Attribution & Legal Disclaimer
The visual sprites and audio effects used in this project were sourced from open-source game asset repositories and public search engines.

*   **Graphics:** [Kenney.nl](https://kenney.nl), [OpenGameArt.org](https://opengameart.org), and [Itch.io](https://itch.io).
*   **Audio:** [Freesound.org](https://freesound.org) and [Bfxr.net](https://www.bfxr.net).

**Legal Notices:**
*   **Purpose:** This project is strictly for educational and non-commercial use as part of a university curriculum.
*   **Ownership:** I do not claim ownership of the external assets integrated into this project. All rights belong to their respective creators and artists.
*   **Copyright:** If you are the owner of an asset used here and w
