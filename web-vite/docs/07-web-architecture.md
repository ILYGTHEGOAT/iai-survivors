# ARCHITECTURE WEB & DEPLOIEMENT VERCEL

> *"Le code que personne ne peut charger est du code qui n'existe pas. L'architecture n'est pas un choix technique — c'est une promesse faite au joueur : peu importe ton téléphone, peu importe ta connexion, l'histoire sera racontée."*

---

## TABLE DES MATIERES

1. [Stack Technique Choisie](#1-stack-technique-choisie)
2. [Structure des Fichiers](#2-structure-des-fichiers)
3. [Design Responsive](#3-design-responsive)
4. [Gestion des Assets](#4-gestion-des-assets)
5. [Deploiement Continu](#5-deploiement-continu)
6. [Optimisations de Performance](#6-optimisations-de-performance)
7. [PWA — Progressive Web App](#7-pwa--progressive-web-app)
8. [Accessibilité](#8-accessibilité)
9. [Analytiques & Télémétrie](#9-analytiques--télémétrie)

---

# 1. STACK TECHNIQUE CHOISIE

---

## 1.1 Philosophie Architecturelle

IAI Survivors est un jeu narratif mobile-first qui doit tourner sur des appareils low-end vendus en Afrique de l'Ouest — des téléphones à 1 Go de RAM, des écrans 720p, des connexions 3G intermittentes. Cette contrainte n'est pas un obstacle : c'est le cœur de notre philosophie d'architecture. Chaque kilooctet compte. Chaque milliseconde de rendu compte. Chaque choix technique doit répondre à une seule question : **est-ce que ça fonctionne sur un Tecno Spark Go en pleine saison des pluies, avec une connexion EDGE ?**

Nous avons choisi de ne pas utiliser de moteur de jeu existant. Pas Phaser. Pas PixiJS. Pas Babylon.js. Pas Godot-exporté-en-Wasm. Ces outils sont excellents pour ce qu'ils font — mais ils ne font pas ce dont nous avons besoin. Phaser seul ajoute ~1 Mo gzippé au bundle. PixiJS ajoute ~400 Ko. Pour un jeu qui doit peser moins de 800 Ko gzippé au total, ces poids sont inacceptables.

Notre moteur de jeu est un **framework sur mesure**, écrit en JavaScript vanilla, qui ne contient strictement que ce dont IAI Survivors a besoin. Rien de plus. C'est la philosophie du Professeur Ananzi appliquée au code : **"Bien écrire du code, c'est comme tisser du kente : chaque ligne doit avoir un sens, chaque pattern doit raconter une histoire."** Chaque fonction de notre moteur raconte l'histoire d'un besoin précis du gameplay.

---

## 1.2 Moteur de Jeu — Canvas 2D Natif

### Pourquoi Canvas 2D brut et pas un moteur existant ?

| Critère | Canvas 2D brut | Phaser 3 | PixiJS |
|---------|---------------|----------|--------|
| Taille bundle (gzippé) | ~0 Ko (natif) | ~1 100 Ko | ~400 Ko |
| RAM consommée | ~2-5 Mo | ~15-30 Mo | ~10-20 Mo |
| Time to Interactive | ~1-2s | ~4-6s | ~3-4s |
| Contrôle total du rendu | Complet | Limité | Modéré |
| Learning curve équipe | Basique | Moyenne | Moyenne |
| Compatibilité navigateur | > 99% | > 95% | > 95% |
| Support offline natif | Trivial | Complexe | Complexe |

Le Canvas 2D API est natif à chaque navigateur depuis 2009. Il ne nécessite aucune dépendance, aucun polyfill, aucun bundler plugin spécial. C'est le API de rendu le plus universellement supporté qui existe — il fonctionne même sur des navigateurs qui n'ont pas WebGL (ce qui élimine environ 5% des appareils les plus anciens).

Notre moteur de jeu, qu'on appellera internement **`OgunEngine`** (en hommage au projet OGUN d'Ananzi), est composé de cinq couches :

1. **Couche Noyau** (`Game.js`) — Boucle de jeu principale, gestion des scènes, lifecycle hooks
2. **Couche Rendu** (`Renderer.js`) — Gestion du canvas, caméra, layers, sprite batching
3. **Couche Entrée** (`Input.js`) — Abstraction unifiée touch/mouse/keyboard
4. **Couche Audio** (`Audio.js`) — Système audio adaptatif multi-canal
5. **Couche Persistence** (`Storage.js`) — Sauvegarde, cache, IndexedDB

### Architecture du Game Loop

Le game loop utilise `requestAnimationFrame` (rAF) avec un **delta time fixe** pour garantir la cohérence physique sur tous les appareils, qu'ils tournent à 30fps ou 60fps.

```
┌─────────────────────────────────────────────────┐
│                  GAME LOOP                       │
│                                                  │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐  │
│  │  INPUT    │───▶│  UPDATE  │───▶│  RENDER  │  │
│  │  CAPTURE  │    │  (fixed) │    │  (rAF)   │  │
│  └──────────┘    └──────────┘    └──────────┘  │
│       ▲                              │          │
│       └──────────────────────────────┘          │
│                   next frame                     │
│                                                  │
│  Fixed timestep: 1000/60 = 16.67ms             │
│  Accumulator pattern for physics               │
│  Max frame skip: 5 (prevent spiral of death)   │
└─────────────────────────────────────────────────┘
```

```javascript
// src/engine/Game.js — Boucle de jeu principale
const FIXED_TIMESTEP = 1000 / 60; // 16.67ms
const MAX_FRAME_SKIP = 5;

class Game {
  constructor(canvas) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.scenes = new Map();
    this.currentScene = null;
    this.accumulator = 0;
    this.lastTime = 0;
    this.running = false;
    this.targetFPS = 60;
    this.currentFPS = 0;
    this.frameCount = 0;
    this.fpsTimer = 0;

    // Object pooling pour éviter le GC pendant le gameplay
    this._updatePool = [];
    this._renderPool = [];
  }

  start() {
    this.running = true;
    this.lastTime = performance.now();
    requestAnimationFrame(this.loop.bind(this));
  }

  loop(timestamp) {
    if (!this.running) return;

    const deltaTime = timestamp - this.lastTime;
    this.lastTime = timestamp;

    // Clamp delta pour éviter les pics après tab switch
    const clampedDelta = Math.min(deltaTime, FIXED_TIMESTEP * MAX_FRAME_SKIP);

    this.accumulator += clampedDelta;

    // Updates fixes (physique, AI, timeline)
    while (this.accumulator >= FIXED_TIMESTEP) {
      if (this.currentScene?.update) {
        this.currentScene.update(FIXED_TIMESTEP);
      }
      this.accumulator -= FIXED_TIMESTEP;
    }

    // Render interpolé
    const alpha = this.accumulator / FIXED_TIMESTEP;
    if (this.currentScene?.render) {
      this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
      this.currentScene.render(this.ctx, alpha);
    }

    // FPS counter
    this.frameCount++;
    this.fpsTimer += clampedDelta;
    if (this.fpsTimer >= 1000) {
      this.currentFPS = this.frameCount;
      this.frameCount = 0;
      this.fpsTimer -= 1000;
    }

    requestAnimationFrame(this.loop.bind(this));
  }

  addScene(name, scene) {
    this.scenes.set(name, scene);
    scene.game = this;
  }

  switchScene(name, data = {}) {
    if (this.currentScene?.exit) {
      this.currentScene.exit();
    }
    this.currentScene = this.scenes.get(name);
    if (this.currentScene?.enter) {
      this.currentScene.enter(data);
    }
  }
}
```

---

## 1.3 Framework — Vanilla JavaScript avec ES Modules

### Le choix radical du vanilla

IAI Survivors n'utilise **aucun framework JavaScript** — ni React, ni Vue, ni Svelte, ni Angular. Ce n'est pas un choix par ignorance, c'est un choix par conviction. Notre jeu EST le framework. Chaque composant est un ES Module standard, importé nativement par le navigateur via les `import` statements. Pas de JSX, pas de virtual DOM, pas de reactive data binding — juste du DOM manipulation directe quand nécessaire, et du Canvas 2D pour 95% de l'affichage.

Les raisons de ce choix :

**1. Pas de layer d'abstraction entre le code et le navigateur.**
Quand nous dessinons un sprite sur le Canvas, nous appelons `ctx.drawImage()`. Pas de `this.props.sprite`, pas de `setState()`, pas de reconciliation algorithm. Le code fait exactement ce que le navigateur fait. C'est plus rapide, plus prévisible, et plus facile à déboguer.

**2. Pas de runtime overhead.**
React ajoute ~42 Ko gzippé de runtime. Vue ajoute ~33 Ko. Svelte compile away mais ajoute quand même un stub de runtime (~8 Ko). Notre moteur ajoute ~0 Ko de runtime framework — tout est notre propre code, tree-shaké à l'extrême.

**3. Connaissance intime du code.**
Dans un projet de cette taille (~15 000-20 000 lignes de code estimé), chaque développeur peut comprendre l'intégralité du codebase. Il n'y a pas de "boîtes noires" de framework. Quand quelque chose casse, on sait exactement pourquoi, parce que c'est notre code.

**4. Compatibilité maximale.**
ES Modules sont supportés dans tous les navigateurs modernes (Chrome 61+, Firefox 60+, Safari 11+, Edge 16+). Pour les navigateurs très anciens, Vite les transformera en IIFE pendant le build.

### Build Tool — Vite

Vite est le seul outil de build utilisé dans le projet. Il remplace Webpack, Babel, ESLint dev server et un dizaine d'autres outils. Ses avantages pour notre cas d'usage :

- **Dev server instantané** : démarrage en < 200ms grâce au native ESM en développement
- **HMR (Hot Module Replacement)** : modification de n'importe quel fichier → rechargement en < 50ms
- **Production build basé sur Rollup** : tree shaking agressif, code splitting, minification terser
- **Asset handling natif** : images, audio, fonts — tout est géré automatiquement
- **Pas de config** pour les cas standards — une configuration minimale suffit

```javascript
// vite.config.js
import { defineConfig } from 'vite';
import { resolve } from 'path';

export default defineConfig({
  root: 'src',
  publicDir: '../public',
  build: {
    outDir: '../dist',
    emptyOutDir: true,
    target: 'es2018',  // Compatibilité Android 7+
    minify: 'terser',
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'src/main.js')
      },
      output: {
        // Code splitting par scene
        manualChunks: {
          engine: ['src/engine/Game.js', 'src/engine/Renderer.js', 'src/engine/Input.js'],
          audio: ['src/engine/Audio.js'],
          scenes_title: ['src/scenes/Title.js'],
          scenes_combat: ['src/scenes/Combat.js'],
          scenes_dialogue: ['src/scenes/Dialogue.js'],
          scenes_schedule: ['src/scenes/Schedule.js']
        }
      }
    },
    terserOptions: {
      compress: {
        drop_console: true,   // Pas de console.log en prod
        drop_debugger: true,
        pure_funcs: ['console.log', 'console.debug']
      }
    }
  },
  css: {
    // Pas de CSS framework — tout est inline Canvas ou minimal DOM
    modules: true
  },
  optimizeDeps: {
    // Pré-bundle des dépendances pour le dev
    include: ['howler']
  }
});
```

### Pourquoi pas TypeScript ?

Ce choix sera controversé, mais il est délibéré. TypeScript ajoute une couche de compilation, un fichier `tsconfig.json` complexe, des types à maintenir, et une courbe d'apprentissage supplémentaire pour les contributeurs ouest-africains qui sont majoritairement formés en JavaScript pur. Nous compensons ce choix par :

- **JSDoc annotations** sur toutes les fonctions publiques
- **Tests unitaires** avec Vitest pour garantir les contrats d'API
- **Convention de naming strict** : `camelCase` pour les variables/fonctions, `PascalCase` pour les classes, `UPPER_SNAKE_CASE` pour les constantes
- **ESLint avec règles strictes** pour capturer les erreurs communes

```javascript
/**
 * Gère le système de combat tour par tour.
 * @class CombatSystem
 * @param {Object} config - Configuration du combat
 * @param {Character} config.player - Le personnage du joueur
 * @param {Enemy[]} config.enemies - Les ennemis à combattre
 * @param {number} config.turnLimit - Nombre max de tours (défaut: 20)
 */
class CombatSystem {
  /** @type {Character} */
  player;

  /** @type {Enemy[]} */
  enemies;

  /** @type {'player_turn'|'enemy_turn'|'resolving'|'victory'|'defeat'} */
  state;
}
```

---

## 1.4 Rendu — HTML5 Canvas 2D API

### Le pipeline de rendu

Notre système de rendu est conçu pour le pixel art. Il n'utilise **aucun filtrage bilinéaire**, **aucun antialiasing**, et **aucun smoothing**. Chaque pixel est exactement là où il doit être, avec une précision absolue.

Le Canvas est dimensionné à la **résolution native du jeu** (320×180 pixels en mode portrait, redimensionné via CSS pour remplir l'écran). Cette résolution de base est un multiple de 16, ce qui aligne parfaitement avec notre grille de tiles 16×16.

```
┌──────────────────────────────────────────────────────┐
│              PIPELINE DE RENDU                       │
│                                                       │
│  ┌─────────┐   ┌──────────┐   ┌──────────────────┐  │
│  │  SCENE   │──▶│  LAYERS  │──▶│  CANVAS OUTPUT   │  │
│  │  TREE    │   │ (ordered)│   │  (320×180 → screen)│ │
│  └─────────┘   └──────────┘   └──────────────────┘  │
│                                                       │
│  Layers (de l'arrière vers l'avant) :                │
│  0: background   (static, offscreen canvas)          │
│  1: environment  (tiles animées, parallax)           │
│  2: entities     (personnages, ennemis)              │
│  3: effects      (particules, explosions)            │
│  4: ui           (HUD, dialogues)                    │
│  5: overlay      (transitions, fade)                 │
└──────────────────────────────────────────────────────┘
```

```javascript
// src/engine/Renderer.js
class Renderer {
  constructor(canvas, width = 320, height = 180) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d', {
      alpha: false,           // Pas de transparence = plus rapide
      desynchronized: true,   // Réduire le input lag
      willReadFrequently: false
    });

    // Résolution de travail (pixel art)
    this.width = width;
    this.height = height;

    // Désactiver TOUS les smoothing
    this.ctx.imageSmoothingEnabled = false;
    this.ctx.mozImageSmoothingEnabled = false;
    this.ctx.webkitImageSmoothingEnabled = false;
    this.ctx.msImageSmoothingEnabled = false;

    // Offscreen canvas pour le background static
    this.bgCanvas = document.createElement('canvas');
    this.bgCanvas.width = width;
    this.bgCanvas.height = height;
    this.bgCtx = this.bgCanvas.getContext('2d');
    this.bgCtx.imageSmoothingEnabled = false;

    // Caméra
    this.camera = {
      x: 0,
      y: 0,
      targetX: 0,
      targetY: 0,
      smoothing: 0.1,
      shake: { intensity: 0, duration: 0, timer: 0 }
    };

    // Calcul du scaling CSS
    this._updateScaling();
    window.addEventListener('resize', () => this._updateScaling());
  }

  _updateScaling() {
    const screenW = window.innerWidth;
    const screenH = window.innerHeight;

    // Calculer le scale integer le plus proche pour pixel-perfect
    const scaleX = Math.floor(screenW / this.width) || 1;
    const scaleY = Math.floor(screenH / this.height) || 1;
    const scale = Math.min(scaleX, scaleY);

    // Appliquer le scale via CSS
    this.canvas.style.width = `${this.width * scale}px`;
    this.canvas.style.height = `${this.height * scale}px`;

    // Centrer le canvas
    this.canvas.style.position = 'absolute';
    this.canvas.style.left = `${(screenW - this.width * scale) / 2}px`;
    this.canvas.style.top = `${(screenH - this.height * scale) / 2}px`;

    // Ajouter les letterbox bars
    this._updateLetterbox(screenW, screenH, scale);
  }

  _updateLetterbox(screenW, screenH, scale) {
    const gameW = this.width * scale;
    const gameH = this.height * scale;
    const barX = (screenW - gameW) / 2;
    const barY = (screenH - gameH) / 2;

    document.body.style.margin = '0';
    document.body.style.padding = '0';
    document.body.style.overflow = 'hidden';
    document.body.style.backgroundColor = '#000';
    document.body.style.display = 'flex';
    document.body.style.justifyContent = 'center';
    document.body.style.alignItems = 'center';
  }

  updateCamera(targetX, targetY) {
    this.camera.targetX = targetX - this.width / 2;
    this.camera.targetY = targetY - this.height / 2;

    // Lissage de la caméra (lerp)
    this.camera.x += (this.camera.targetX - this.camera.x) * this.camera.smoothing;
    this.camera.y += (this.camera.targetY - this.camera.y) * this.camera.smoothing;

    // Limites de la caméra (ne pas sortir de la map)
    this.camera.x = Math.max(0, Math.min(this.camera.x, this.mapWidth - this.width));
    this.camera.y = Math.max(0, Math.min(this.camera.y, this.mapHeight - this.height));

    // Screen shake
    if (this.camera.shake.timer > 0) {
      this.camera.shake.timer--;
      const offsetX = (Math.random() - 0.5) * this.camera.shake.intensity * 2;
      const offsetY = (Math.random() - 0.5) * this.camera.shake.intensity * 2;
      this.camera.x += offsetX;
      this.camera.y += offsetY;
    }
  }

  // Draw optimisé avec camera offset
  drawSprite(sprite, x, y, frame = 0) {
    const screenX = Math.round(x - this.camera.x);
    const screenY = Math.round(y - this.camera.y);

    // Culling : ne pas dessiner si hors écran
    if (screenX + sprite.width < 0 || screenX > this.width ||
        screenY + sprite.height < 0 || screenY > this.height) {
      return;
    }

    this.ctx.drawImage(
      sprite.sheet,
      frame * sprite.frameWidth, 0,
      sprite.frameWidth, sprite.height,
      screenX, screenY,
      sprite.frameWidth, sprite.height
    );
  }

  drawText(text, x, y, options = {}) {
    const {
      color = '#ffffff',
      shadow = true,
      shadowColor = '#000000',
      align = 'left',
      font = 'pixel'
    } = options;

    this.ctx.font = `8px ${font}`;
    this.ctx.textAlign = align;
    this.ctx.textBaseline = 'top';

    if (shadow) {
      this.ctx.fillStyle = shadowColor;
      this.ctx.fillText(text, x + 1, y + 1);
    }

    this.ctx.fillStyle = color;
    this.ctx.fillText(text, x, y);
  }
}
```

### Object Pooling pour les particules

Le système de particules est l'un des plus gros consommateurs de mémoire dans un jeu 2D. Pour éviter les pics de GC (Garbage Collection) qui provoquent des micro-freezes, nous utilisons un **pattern Object Pool** — un pré-allocated pool d'objets réutilisables.

```javascript
// src/engine/ParticlePool.js
class ParticlePool {
  constructor(maxSize = 500) {
    this.pool = new Array(maxSize);
    this.activeCount = 0;

    // Pré-allocation : tous les objets sont créés une seule fois
    for (let i = 0; i < maxSize; i++) {
      this.pool[i] = {
        x: 0, y: 0,
        vx: 0, vy: 0,
        life: 0, maxLife: 0,
        size: 1, color: '#fff',
        active: false
      };
    }
  }

  spawn(x, y, config) {
    if (this.activeCount >= this.pool.length) return null;

    // Trouver un slot inactif (skip les actifs)
    let particle = null;
    for (let i = 0; i < this.pool.length; i++) {
      if (!this.pool[i].active) {
        particle = this.pool[i];
        break;
      }
    }

    if (!particle) return null;

    particle.x = x;
    particle.y = y;
    particle.vx = config.vx || 0;
    particle.vy = config.vy || 0;
    particle.life = config.life || 30;
    particle.maxLife = particle.life;
    particle.size = config.size || 1;
    particle.color = config.color || '#fff';
    particle.active = true;

    this.activeCount++;
    return particle;
  }

  update() {
    for (let i = 0; i < this.pool.length; i++) {
      const p = this.pool[i];
      if (!p.active) continue;

      p.x += p.vx;
      p.y += p.vy;
      p.life--;

      if (p.life <= 0) {
        p.active = false;
        this.activeCount--;
      }
    }
  }

  render(ctx, camera) {
    for (let i = 0; i < this.pool.length; i++) {
      const p = this.pool[i];
      if (!p.active) continue;

      const alpha = p.life / p.maxLife;
      ctx.globalAlpha = alpha;
      ctx.fillStyle = p.color;
      ctx.fillRect(
        Math.round(p.x - camera.x),
        Math.round(p.y - camera.y),
        p.size, p.size
      );
    }
    ctx.globalAlpha = 1;
  }
}
```

---

## 1.5 Audio — Web Audio API + Howler.js

### Architecture audio à deux couches

Notre système audio est conçu pour supporter la **musique adaptative** (décrite en détail dans `06-music.md`) tout en restant léger et compatible. Il utilise une architecture à deux couches :

**Couche 1 — Web Audio API (native)** : Le cœur du système adaptatif. Permet le mixage en temps réel, les crossfades, les filtres, les effets spatiaux, et le changement dynamique des pistes musicales. C'est un API puissant mais complexe, implémenté directement dans notre module `Audio.js`.

**Couche 2 — Howler.js (fallback)** : Pour les effets sonores simples, les musiques de fond non adaptatives, et la compatibilité avec les anciens navigateurs qui n'ont pas le Web Audio API. Howler.js est la seule dépendance externe du projet (en dehors de Vite lui-même).

```javascript
// src/engine/Audio.js
class AudioSystem {
  constructor() {
    // Contexte Web Audio (créé à l'interaction utilisateur)
    this.ctx = null;
    this.masterGain = null;
    this.musicGain = null;
    this.sfxGain = null;
    this.initialized = false;

    // Canaux musicaux adaptatifs
    this.musicChannels = {
      drums: null,      // Canal percussions
      bass: null,       // Canal basse
      melody: null,     // Canal mélodie
      harmony: null,    // Canal harmonie
      ambient: null     // Canal ambiant
    };

    // File d'effets sonores
    this.sfxPool = [];
    this.maxConcurrentSFX = 4;

    // Audio sprites pour les SFX (un seul fichier audio contenant tous les SFX)
    this.sfxSprites = null;
  }

  async init() {
    // Web Audio API nécessite une interaction utilisateur pour démarrer
    this.ctx = new (window.AudioContext || window.webkitAudioContext)();

    // Master gain (volume global)
    this.masterGain = this.ctx.createGain();
    this.masterGain.connect(this.ctx.destination);
    this.masterGain.gain.value = 0.8;

    // Sous-canaux
    this.musicGain = this.ctx.createGain();
    this.musicGain.connect(this.masterGain);
    this.musicGain.gain.value = 0.6;

    this.sfxGain = this.ctx.createGain();
    this.sfxGain.connect(this.masterGain);
    this.sfxGain.gain.value = 0.8;

    // Analyser pour la visualisation (optionnel)
    this.analyser = this.ctx.createAnalyser();
    this.analyser.fftSize = 256;
    this.masterGain.connect(this.analyser);

    this.initialized = true;
  }

  // Chargement d'un canal musical adaptatif
  async loadMusicChannel(name, url) {
    const response = await fetch(url);
    const arrayBuffer = await response.arrayBuffer();
    const audioBuffer = await this.ctx.decodeAudioData(arrayBuffer);

    this.musicChannels[name] = {
      buffer: audioBuffer,
      source: null,
      gainNode: this.ctx.createGain(),
      panNode: this.ctx.createStereoPanner(),
      playing: false,
      volume: 1,
      loop: true
    };

    this.musicChannels[name].gainNode.connect(this.musicGain);
    this.musicChannels[name].panNode.connect(this.musicChannels[name].gainNode);
  }

  // Lecture d'un canal avec crossfade
  playChannel(name, fadeTime = 2) {
    const channel = this.musicChannels[name];
    if (!channel || channel.playing) return;

    const source = this.ctx.createBufferSource();
    source.buffer = channel.buffer;
    source.loop = channel.loop;
    source.connect(channel.panNode);

    // Fade in
    channel.gainNode.gain.setValueAtTime(0, this.ctx.currentTime);
    channel.gainNode.gain.linearRampToValueAtTime(
      channel.volume,
      this.ctx.currentTime + fadeTime
    );

    source.start();
    channel.source = source;
    channel.playing = true;
  }

  // Crossfade entre deux canaux
  crossfade(fromName, toName, duration = 2) {
    const from = this.musicChannels[fromName];
    const to = this.musicChannels[toName];

    if (from?.playing) {
      from.gainNode.gain.linearRampToValueAtTime(
        0,
        this.ctx.currentTime + duration
      );
      setTimeout(() => this.stopChannel(fromName), duration * 1000);
    }

    if (to) {
      this.playChannel(toName, duration);
    }
  }

  // Audio sprites pour les SFX
  playSFX(name) {
    if (!this.sfxSprites || this._activeSFX >= this.maxConcurrentSFX) return;

    const sprite = this.sfxSprites[name];
    if (!sprite) return;

    const source = this.ctx.createBufferSource();
    source.buffer = this.sfxSprites.buffer;
    source.connect(this.sfxGain);

    source.start(0, sprite[0] / 1000, sprite[1] / 1000);
    this._activeSFX++;

    source.onended = () => { this._activeSFX--; };
  }

  // Adaptation dynamique en fonction du gameplay
  adaptToGameState(state) {
    switch (state) {
      case 'exploration':
        this.setChannelVolume('drums', 0.3);
        this.setChannelVolume('melody', 0.7);
        this.setChannelVolume('bass', 0.4);
        break;
      case 'combat_intro':
        this.setChannelVolume('drums', 0.5);
        this.setChannelVolume('melody', 0.3);
        // Ajouter un riser (montée en tension)
        this.playSFX('tension_riser');
        break;
      case 'combat_active':
        this.setChannelVolume('drums', 1.0);
        this.setChannelVolume('bass', 0.9);
        this.setChannelVolume('melody', 0.6);
        this.setChannelVolume('harmony', 0.8);
        break;
      case 'boss_phase_2':
        this.setChannelVolume('drums', 1.0);
        this.setChannelVolume('bass', 1.0);
        this.setChannelVolume('melody', 1.0);
        this.setChannelVolume('harmony', 1.0);
        this.setChannelVolume('ambient', 0.3);
        // Activer le filtre low-pass sur l'ambiance
        this.applyFilter('ambient', 'lowpass', 800);
        break;
      case 'dialogue':
        this.setChannelVolume('drums', 0);
        this.setChannelVolume('bass', 0.2);
        this.setChannelVolume('melody', 0.4);
        this.setChannelVolume('harmony', 0.6);
        this.setChannelVolume('ambient', 0.8);
        break;
    }
  }

  setChannelVolume(name, value) {
    const channel = this.musicChannels[name];
    if (!channel) return;
    channel.volume = value;
    channel.gainNode.gain.linearRampToValueAtTime(
      value,
      this.ctx.currentTime + 0.1
    );
  }
}
```

### Format audio et compatibilité

| Format | Usage | Qualité | Taille | Compatibilité |
|--------|-------|---------|--------|---------------|
| **OGG Vorbis** | Musique (format principal) | Excellente | Petite | Chrome, Firefox, Android |
| **MP3** | Musique (fallback iOS/Safari) | Bonne | Moyenne | Universel |
| **WebM** | SFX (alternative) | Bonne | Petite | Chrome, Firefox |
| **WAV** | SFX critiques (pas de décodage) | Parfaite | Grande | Universel |

Notre build génère les deux premiers formats (OGG + MP3) pour chaque fichier audio. Le Web Audio API détecte automatiquement le format supporté par le navigateur.

---

## 1.6 Stockage — localStorage + IndexedDB

### Stratégie de persistence à deux niveaux

**Niveau 1 — localStorage** : Données de petite taille, accès synchrone, stockées en JSON. Utilisé pour :
- Données de sauvegarde (position du joueur, stats, choix narratifs)
- Préférences utilisateur (volume, langue, options d'accessibilité)
- Flags de déblocage (secrets découverts, endings atteints)

Taille maximale : 5 Mo (suffisant pour des centaines de sauvegardes JSON).

**Niveau 2 — IndexedDB** : Données volumineuses, accès asynchrone. Utilisé pour :
- Cache des assets (spritesheets, audio) après téléchargement
- Sauvegarde complète des données de progression (dialogues lus, arbres narratifs)
- Cache offline des données de jeu (enemies.json, items.json, etc.)

```javascript
// src/engine/Storage.js
class Storage {
  constructor() {
    this.dbName = 'iai-survivors-db';
    this.dbVersion = 1;
    this.db = null;
  }

  async init() {
    return new Promise((resolve, reject) => {
      const request = indexedDB.open(this.dbName, this.dbVersion);

      request.onerror = () => reject(request.error);
      request.onsuccess = () => {
        this.db = request.result;
        resolve();
      };

      request.onupgradeneeded = (event) => {
        const db = event.target.result;

        // Object store pour les assets cachés
        if (!db.objectStoreNames.contains('assets')) {
          db.createObjectStore('assets', { keyPath: 'url' });
        }

        // Object store pour les sauvegardes
        if (!db.objectStoreNames.contains('saves')) {
          const savesStore = db.createObjectStore('saves', { keyPath: 'id' });
          savesStore.createIndex('timestamp', 'timestamp');
        }

        // Object store pour les données de jeu
        if (!db.objectStoreNames.contains('gamedata')) {
          db.createObjectStore('gamedata', { keyPath: 'key' });
        }
      };
    });
  }

  // === localStorage (synchrone, rapide) ===

  saveGame(slot, data) {
    const saveData = {
      version: '1.0',
      timestamp: Date.now(),
      ...data
    };
    localStorage.setItem(`save_${slot}`, JSON.stringify(saveData));
  }

  loadGame(slot) {
    const raw = localStorage.getItem(`save_${slot}`);
    if (!raw) return null;
    try {
      return JSON.parse(raw);
    } catch {
      return null;
    }
  }

  getSettings() {
    const defaults = {
      musicVolume: 0.6,
      sfxVolume: 0.8,
      language: 'fr',
      reducedMotion: false,
      highContrast: false,
      textSize: 'normal'
    };
    const raw = localStorage.getItem('settings');
    return raw ? { ...defaults, ...JSON.parse(raw) } : defaults;
  }

  saveSettings(settings) {
    localStorage.setItem('settings', JSON.stringify(settings));
  }

  // === IndexedDB (asynchrone, pour gros volumes) ===

  async cacheAsset(url, data) {
    const tx = this.db.transaction('assets', 'readwrite');
    const store = tx.objectStore('assets');
    return new Promise((resolve, reject) => {
      const request = store.put({ url, data, cachedAt: Date.now() });
      request.onsuccess = () => resolve();
      request.onerror = () => reject(request.error);
    });
  }

  async getCachedAsset(url) {
    const tx = this.db.transaction('assets', 'readonly');
    const store = tx.objectStore('assets');
    return new Promise((resolve, reject) => {
      const request = store.get(url);
      request.onsuccess = () => resolve(request.result?.data || null);
      request.onerror = () => reject(request.error);
    });
  }

  async saveNarrativeState(state) {
    const tx = this.db.transaction('gamedata', 'readwrite');
    const store = tx.objectStore('gamedata');
    return new Promise((resolve, reject) => {
      const request = store.put({ key: 'narrative_state', ...state });
      request.onsuccess = () => resolve();
      request.onerror = () => reject(request.error);
    });
  }

  // Nettoyage des données obsolètes
  async clearOldCache(maxAge = 30 * 24 * 60 * 60 * 1000) { // 30 jours
    const tx = this.db.transaction('assets', 'readwrite');
    const store = tx.objectStore('assets');
    const cutoff = Date.now() - maxAge;

    return new Promise((resolve, reject) => {
      const request = store.openCursor();
      request.onsuccess = (event) => {
        const cursor = event.target.result;
        if (cursor) {
          if (cursor.value.cachedAt < cutoff) {
            cursor.delete();
          }
          cursor.continue();
        } else {
          resolve();
        }
      };
      request.onerror = () => reject(request.error);
    });
  }
}
```

---

# 2. STRUCTURE DES FICHIERS

---

## 2.1 Arbre Complet du Projet

Chaque fichier et répertoire a un rôle précis. Voici l'arborescence complète avec les justifications techniques pour chaque choix.

```
iai-survivors/
│
├── public/                          # Fichiers servis tels quels (pas de build Vite)
│   ├── index.html                   # Point d'entrée HTML minimal
│   ├── manifest.json                # PWA manifest
│   ├── sw.js                        # Service Worker
│   ├── favicon.ico                  # Favicon standard
│   ├── robots.txt                   # SEO (minime pour un jeu)
│   └── assets/                      # Tous les assets statiques
│       ├── sprites/
│       │   ├── characters/          # Spritesheets par personnage
│       │   │   ├── amara.png        # 320×48 — idle, walk, attack, hurt, special
│       │   │   ├── amara.json       # Atlas metadata (frame positions, durations)
│       │   │   ├── kofi.png
│       │   │   ├── kofi.json
│       │   │   ├── fatima.png
│       │   │   ├── fatima.json
│       │   │   └── ...              # PNJ, boss, enemies
│       │   ├── enemies/
│       │   │   ├── zombie_dev.png
│       │   │   ├── zombie_dev.json
│       │   │   ├── recursive_demon.png
│       │   │   ├── null_reference.png
│       │   │   └── ...              # Tous les ennemis par type
│       │   ├── bosses/
│       │   │   ├── ogun_corrupted_p1.png   # Phase 1
│       │   │   ├── ogun_corrupted_p2.png   # Phase 2
│       │   │   ├── ogun_corrupted_p3.png   # Phase 3 (forme finale)
│       │   │   ├── ogun_corrupted_p1.json
│       │   │   ├── ogun_corrupted_p2.json
│       │   │   └── ogun_corrupted_p3.json
│       │   ├── ui/
│       │   │   ├── buttons.png       # Boutons (normal, hover, pressed)
│       │   │   ├── panels.png        # Panels de dialogue, menus
│       │   │   ├── icons.png         # Icônes d'items, stats, actions
│       │   │   ├── health_bar.png    # Barre de vie (segments)
│       │   │   ├── energy_bar.png    # Barre d'énergie
│       │   │   └── cursor.png        # Curseur de sélection
│       │   ├── environments/
│       │   │   ├── campus_overworld.png  # Tilemap principal
│       │   │   ├── campus_overworld.json # Tiled JSON export
│       │   │   ├── lab_interior.png
│       │   │   ├── lab_interior.json
│       │   │   ├── underground.png
│       │   │   ├── underground.json
│       │   │   ├── bg_night.png      # Backgrounds statiques
│       │   │   └── bg_corrupted.png
│       │   └── effects/
│       │       ├── particles.png     # Sprite sheet particules (8×8 frames)
│       │       ├── explosion.png     # Animation explosion
│       │       ├── heal.png          # Animation soin
│       │       ├── transition_wipe.png
│       │       └── screen_glitch.png
│       │
│       ├── audio/
│       │   ├── music/
│       │   │   ├── campus.ogg        # Thème campus (boucle)
│       │   │   ├── campus.mp3        # Fallback MP3
│       │   │   ├── combat.ogg        # Combat normal
│       │   │   ├── combat.mp3
│       │   │   ├── boss.ogg          # Boss fight
│       │   │   ├── boss.mp3
│       │   │   ├── dialogue.ogg      # Musique de dialogue
│       │   │   ├── dialogue.mp3
│       │   │   ├── tension.ogg       # Montée en tension
│       │   │   ├── tension.mp3
│       │   │   └── ending.ogg        # Thème de fin
│       │   │       ending.mp3
│       │   └── sfx/
│       │       ├── ui_click.ogg      # Audio sprite: tous les SFX UI
│       │       ├── combat_sfx.ogg    # Audio sprite: tous les SFX combat
│       │       ├── ambient_sfx.ogg   # Audio sprite: ambiance
│       │       └── voices.ogg        # Audio sprite: cris, murmures
│       │
│       ├── fonts/
│       │   ├── pixel_regular.woff2   # Police pixel art principale
│       │   ├── pixel_bold.woff2      # Police pixel art gras
│       │   └── pixel_mono.woff2      # Police mono (pour le terminal)
│       │
│       └── data/
│           ├── config.json           # Configuration globale du jeu
│           ├── enemies.json          # Stats de tous les ennemis
│           ├── items.json            # Stats de tous les items
│           ├── skills.json           # Compétences débloquables
│           ├── dialogues/
│           │   ├── week1.json        # Dialogues Semaine 1
│           │   ├── week2.json        # Dialogues Semaine 2
│           │   ├── week3.json        # Dialogues Semaine 3
│           │   ├── week4.json        # Dialogues Semaine 4
│           │   └── week5.json        # Dialogues Semaine 5 + fin
│           └── encounters.json       # Tables de encounters aléatoires
│
├── src/                              # Code source principal
│   ├── main.js                       # Point d'entrée — bootstrap le jeu
│   │
│   ├── engine/                       # Moteur de jeu (framework sur mesure)
│   │   ├── Game.js                   # Boucle de jeu, gestion des scènes
│   │   ├── Renderer.js               # Canvas 2D, caméra, sprite batching
│   │   ├── Input.js                  # Capture et abstraction des entrées
│   │   ├── Audio.js                  # Système audio adaptatif
│   │   ├── Storage.js                # localStorage + IndexedDB
│   │   ├── Assets.js                 # Loader asynchrone d'assets
│   │   ├── Scene.js                  # Classe de base pour les scènes
│   │   ├── ParticlePool.js           # Pool de particules pré-allouées
│   │   └── Timer.js                  # Gestion des timers/delays
│   │
│   ├── systems/                      # Systèmes de gameplay
│   │   ├── Combat.js                 # Moteur de combat tour par tour
│   │   ├── Dialogue.js               # Système de dialogue avec choix
│   │   ├── Schedule.js               # Gestion du temps hebdomadaire
│   │   ├── Stats.js                  # Gestion des statistiques personnages
│   │   ├── Relationships.js          # Système de liens sociaux
│   │   ├── Inventory.js              # Gestion de l'inventaire
│   │   ├── Story.js                  # Machine à états narratifs
│   │   ├── Crafting.js               # Système de craft (assemblage de code)
│   │   └── Minigames/                # Moteurs de mini-jeux
│   │       ├── CodeAssembler.js      # Puzzle: assembler du code
│   │       ├── BugHunter.js          # Puzzle: chasser les bugs
│   │       ├── DataPipeline.js       # Puzzle: connecter des données
│   │       └── TerminalHack.js       # Puzzle: hack terminal
│   │
│   ├── scenes/                       # Scènes du jeu (screens)
│   │   ├── Boot.js                   # Écran de chargement initial
│   │   ├── Title.js                  # Menu principal
│   │   ├── Schedule.js               # Planificateur hebdomadaire
│   │   ├── Combat.js                 # Scène de combat
│   │   ├── Dialogue.js               # Mode visual novel
│   │   ├── Exploration.js            # Exploration libre
│   │   ├── Minigame.js               # Scène de mini-jeux
│   │   ├── Inventory.js              # Écran d'inventaire
│   │   ├── Map.js                    # Carte du campus
│   │   └── Ending.js                 # Scènes de fin
│   │
│   ├── entities/                     # Entités du jeu
│   │   ├── Character.js              # Classe de base personnage
│   │   ├── Player.js                 # Personnage du joueur
│   │   ├── Enemy.js                  # Classe de base ennemi
│   │   ├── Boss.js                   # Boss avec phases
│   │   └── NPC.js                    # PNJ interactifs
│   │
│   ├── ui/                           # Composants d'interface
│   │   ├── HUD.js                    # Interface en jeu (vie, énergie, stats)
│   │   ├── Menu.js                   # Menu pause, options
│   │   ├── DialogBox.js              # Boîte de dialogue
│   │   ├── Toast.js                  # Notifications temporaires
│   │   ├── TouchControls.js          # Contrôles tactiles virtuels
│   │   ├── Transition.js             # Transitions entre scènes
│   │   └── ScreenFade.js             # Effets de fondu
│   │
│   └── utils/                        # Utilitaires
│       ├── math.js                   # Lerp, clamp, distance, easing
│       ├── random.js                 # RNG seedé (reproductible)
│       ├── helpers.js                # Fonctions utilitaires diverses
│       ├── constants.js              # Constantes de gameplay
│       └── format.js                 # Formatage texte, nombres
│
├── package.json                      # Dépendances et scripts
├── vite.config.js                    # Configuration Vite
├── vercel.json                       # Configuration de déploiement Vercel
├── .gitignore                        # Fichiers ignorés par Git
├── .eslintrc.json                    # Règles de linting
└── README.md                         # Documentation du projet
```

---

## 2.2 Fichiers Clés Détaillés

### `public/index.html`

Le fichier HTML est minimaliste — il n'y a qu'un `<canvas>` et un `<div>` pour l'overlay DOM. Tout le rendu se fait sur le Canvas.

```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <meta name="apple-mobile-web-app-capable" content="yes">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="theme-color" content="#0a0a1a">
  <meta name="description" content="IAI Survivors — Survive l'IAI, decode l'avenir.">

  <title>IAI Survivors</title>

  <link rel="manifest" href="/manifest.json">
  <link rel="icon" href="/favicon.ico">
  <link rel="apple-touch-icon" href="/assets/icons/icon-192.png">

  <!-- Préchargement critique -->
  <link rel="preload" href="/assets/sprites/ui/panels.png" as="image">
  <link rel="preload" href="/assets/fonts/pixel_regular.woff2" as="font" type="font/woff2" crossorigin>
  <link rel="preload" href="/assets/data/config.json" as="fetch" crossorigin>

  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    html, body {
      width: 100%;
      height: 100%;
      overflow: hidden;
      background: #0a0a1a;
      font-family: 'pixel_regular', monospace;
      touch-action: none;              /* Empêcher le scroll/pinch-zoom */
      -webkit-touch-callout: none;     /* Empêcher le menu contextuel */
      user-select: none;               /* Pas de sélection de texte */
      -webkit-user-select: none;
    }

    #game-canvas {
      image-rendering: pixelated;      /* Pixel art crisp */
      image-rendering: -moz-crisp-edges;
      image-rendering: crisp-edges;
      display: block;
    }

    #ui-overlay {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      pointer-events: none;            /* Le canvas reçoit les événements */
      z-index: 10;
    }

    /* Loading screen (avant le canvas) */
    #loading-screen {
      position: fixed;
      top: 0; left: 0;
      width: 100%; height: 100%;
      background: #0a0a1a;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      color: #00ff41;
      font-family: monospace;
      z-index: 100;
    }

    #loading-screen .title {
      font-size: 1.5rem;
      margin-bottom: 1rem;
      animation: pulse 1.5s ease-in-out infinite;
    }

    #loading-screen .progress {
      font-size: 0.8rem;
      opacity: 0.7;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.5; }
    }

    /* Letterbox bars */
    .letterbox {
      position: fixed;
      background: #000;
      z-index: 5;
    }
    .letterbox-top { top: 0; left: 0; width: 100%; }
    .letterbox-bottom { bottom: 0; left: 0; width: 100%; }
    .letterbox-left { top: 0; left: 0; height: 100%; }
    .letterbox-right { top: 0; right: 0; height: 100%; }

    /* Animations de transition */
    .fade-in { animation: fadeIn 0.3s ease-out; }
    .fade-out { animation: fadeOut 0.3s ease-out; }

    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    @keyframes fadeOut { from { opacity: 1; } to { opacity: 0; } }
  </style>
</head>
<body>
  <!-- Loading screen (visible avant le chargement du JS) -->
  <div id="loading-screen">
    <div class="title">IAI SURVIVORS</div>
    <div class="progress" id="load-progress">Chargement des systèmes...</div>
  </div>

  <!-- Canvas principal du jeu -->
  <canvas id="game-canvas"></canvas>

  <!-- Overlay DOM pour les éléments UI non-canvas -->
  <div id="ui-overlay"></div>

  <!-- Module d'entrée -->
  <script type="module" src="/src/main.js"></script>
</body>
</html>
```

### `public/manifest.json`

```json
{
  "name": "IAI Survivors",
  "short_name": "IAI Survivors",
  "description": "Survive l'IAI, decode l'avenir. Un jeu narratif survival horror pixel art.",
  "start_url": "/",
  "display": "standalone",
  "orientation": "any",
  "background_color": "#0a0a1a",
  "theme_color": "#00ff41",
  "categories": ["games", "entertainment"],
  "icons": [
    {
      "src": "/assets/icons/icon-72.png",
      "sizes": "72x72",
      "type": "image/png"
    },
    {
      "src": "/assets/icons/icon-96.png",
      "sizes": "96x96",
      "type": "image/png"
    },
    {
      "src": "/assets/icons/icon-128.png",
      "sizes": "128x128",
      "type": "image/png"
    },
    {
      "src": "/assets/icons/icon-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "/assets/icons/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ],
  "screenshots": [
    {
      "src": "/assets/screenshots/combat.png",
      "sizes": "1280x720",
      "type": "image/png",
      "form_factor": "wide",
      "label": "Combat contre un zombie_dev"
    },
    {
      "src": "/assets/screenshots/dialogue.png",
      "sizes": "720x1280",
      "type": "image/png",
      "form_factor": "narrow",
      "label": "Dialogue avec Amara"
    }
  ]
}
```

### `src/main.js`

```javascript
// src/main.js — Point d'entrée du jeu
import { Game } from './engine/Game.js';
import { Renderer } from './engine/Renderer.js';
import { Input } from './engine/Input.js';
import { AudioSystem } from './engine/Audio.js';
import { Storage } from './engine/Storage.js';
import { AssetLoader } from './engine/Assets.js';

// Scenes
import { BootScene } from './scenes/Boot.js';
import { TitleScene } from './scenes/Title.js';
import { ScheduleScene } from './scenes/Schedule.js';
import { CombatScene } from './scenes/Combat.js';
import { DialogueScene } from './scenes/Dialogue.js';
import { ExplorationScene } from './scenes/Exploration.js';
import { MinigameScene } from './scenes/Minigame.js';
import { EndingScene } from './scenes/Ending.js';

async function init() {
  const progress = document.getElementById('load-progress');
  const loadingScreen = document.getElementById('loading-screen');

  // 1. Initialiser le canvas
  progress.textContent = 'Initialisation du rendu...';
  const canvas = document.getElementById('game-canvas');
  const game = new Game(canvas);

  // 2. Initialiser les sous-systèmes
  progress.textContent = 'Chargement des systèmes...';
  const renderer = new Renderer(canvas);
  const input = new Input(canvas);
  const audio = new AudioSystem();
  const storage = new Storage();
  const assets = new AssetLoader();

  // Attacher les systèmes au game
  game.renderer = renderer;
  game.input = input;
  game.audio = audio;
  game.storage = storage;
  game.assets = assets;

  // 3. Initialiser le stockage
  progress.textContent = 'Ouverture de la base de données...';
  await storage.init();

  // 4. Charger les assets critiques
  progress.textContent = 'Chargement des assets critiques...';
  await assets.loadCritical([
    '/assets/sprites/ui/buttons.png',
    '/assets/sprites/ui/panels.png',
    '/assets/sprites/ui/icons.png',
    '/assets/fonts/pixel_regular.woff2',
    '/assets/data/config.json'
  ]);

  // 5. Enregistrer les scènes
  progress.textContent = 'Chargement des scènes...';
  game.addScene('boot', new BootScene());
  game.addScene('title', new TitleScene());
  game.addScene('schedule', new ScheduleScene());
  game.addScene('combat', new CombatScene());
  game.addScene('dialogue', new DialogueScene());
  game.addScene('exploration', new ExplorationScene());
  game.addScene('minigame', new MinigameScene());
  game.addScene('ending', new EndingScene());

  // 6. Lancer le jeu
  progress.textContent = 'Démarrage...';
  game.switchScene('boot');

  // Masquer l'écran de chargement
  loadingScreen.style.display = 'none';

  // Démarrer la boucle de jeu
  game.start();

  // 7. Enregistrer le Service Worker
  if ('serviceWorker' in navigator) {
    try {
      await navigator.serviceWorker.register('/sw.js');
      console.log('Service Worker enregistré');
    } catch (err) {
      console.warn('Service Worker non enregistré:', err);
    }
  }
}

// Démarrer quand le DOM est prêt
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}
```

---

# 3. DESIGN RESPONSIVE

---

## 3.1 Approche Mobile-First

IAI Survivors est conçu **d'abord pour les téléphones**, ensuite pour les tablettes, ensuite pour les ordinateurs. Cette priorité inversée par rapport aux sites web classiques est intentionnelle : la majorité de notre public cible jouera sur mobile, souvent sur des appareils à budget limité.

### Résolution de base

Le jeu est conçu à une résolution de travail de **320×180 pixels** (16:9, format paysage) en mode normal, et **180×320 pixels** en mode portrait. Ces résolutions sont choisies pour plusieurs raisons :

1. Elles sont des multiples de 16, ce qui s'aligne parfaitement avec notre grille de tiles 16×16
2. Elles produisent un rendu pixel art authentic avec un scale CSS entier (x2, x3, x4, etc.)
3. Elles sont suffisamment basses pour maintenir 60fps sur des appareils très modestes

Le Canvas DOM est toujours dimensionné à 320×180. C'est le CSS qui le redimensionne pour remplir l'écran :

```css
#game-canvas {
  width: 100vw;
  height: 100vh;
  object-fit: contain;
  image-rendering: pixelated;
  image-rendering: -moz-crisp-edges;
  image-rendering: crisp-edges;
}
```

### Calcul du Scale Factor

```javascript
// src/engine/Renderer.js — Calcul du scale optimal
_calculateScale() {
  const screenW = window.innerWidth;
  const screenH = window.innerHeight;
  const gameW = this.width;   // 320
  const gameH = this.height;  // 180

  // Calculer le plus grand scale entier qui tient à l'écran
  const maxScaleX = Math.floor(screenW / gameW);
  const maxScaleY = Math.floor(screenH / gameH);
  const scale = Math.max(1, Math.min(maxScaleX, maxScaleY));

  // Vérifier que le scale entier ne déborde pas
  if (gameW * scale <= screenW && gameH * scale <= screenH) {
    return scale; // Scale entier = pixel parfait
  }

  // Fallback : scale fractional (moins crisp mais pas de débordement)
  return Math.min(screenW / gameW, screenH / gameH);
}
```

---

## 3.2 Gestion de l'Orientation

Le jeu supporte à la fois le mode **portrait** et le mode **paysage**. Chaque mode a un layout d'UI distinct, optimisé pour la tenue du téléphone.

### Mode Portrait (tenu verticalement)

```
┌────────────────────────┐
│  ┌──────────────────┐  │  Zone dialogue / narration
│  │   DIALOGUE BOX   │  │  (haut de l'écran, visible)
│  │  "Amara: ..."    │  │
│  └──────────────────┘  │
│                         │
│  ┌──────────────────┐  │  Zone d'action principale
│  │                  │  │  (centre, zone de jeu)
│  │   SCÈNE DE JEU   │  │
│  │                  │  │
│  └──────────────────┘  │
│                         │
│  ┌──────────────────┐  │  Zone de stats / contrôles
│  │  HP ████░░  ENER │  │  (bas, à portée du pouce)
│  │  [ATK] [DEF] [SP]│  │
│  └──────────────────┘  │
└────────────────────────┘
```

### Mode Paysage (tenu horizontalement)

```
┌──────────────────────────────────────────────┐
│  ┌────────┐ ┌──────────────────┐ ┌────────┐ │
│  │ STATS  │ │                  │ │ ACTIONS│ │
│  │        │ │   SCÈNE DE JEU   │ │        │ │
│  │ Amara  │ │                  │ │ [ATK]  │ │
│  │ HP ████│ │                  │ │ [DEF]  │ │
│  │ EN ███ │ │                  │ │ [SP]   │ │
│  │        │ │                  │ │        │ │
│  │ Kofi   │ └──────────────────┘ └────────┘ │
│  │ HP ██░ │                                  │
│  └────────┘ ┌──────────────────┐            │
│             │   DIALOGUE BOX   │            │
│             └──────────────────┘            │
└──────────────────────────────────────────────┘
```

### Détection et Transition

```javascript
// src/engine/Renderer.js — Gestion de l'orientation
class OrientationManager {
  constructor() {
    this.current = this._detect();
    this.listeners = [];

    // Écouter les changements d'orientation
    window.addEventListener('orientationchange', () => {
      // Petit délai pour laisser le navigateur se stabiliser
      setTimeout(() => {
        const newOrientation = this._detect();
        if (newOrientation !== this.current) {
          const old = this.current;
          this.current = newOrientation;
          this.listeners.forEach(fn => fn(old, newOrientation));
        }
      }, 100);
    });

    // Fallback pour les appareils sans API orientationchange
    window.addEventListener('resize', () => {
      const newOrientation = this._detect();
      if (newOrientation !== this.current) {
        const old = this.current;
        this.current = newOrientation;
        this.listeners.forEach(fn => fn(old, newOrientation));
      }
    });
  }

  _detect() {
    // 1. Essayer Screen Orientation API
    if (screen.orientation) {
      return screen.orientation.type.includes('portrait') ? 'portrait' : 'landscape';
    }

    // 2. Essayer window.orientation (déprécié mais utile)
    if (typeof window.orientation !== 'undefined') {
      return Math.abs(window.orientation) === 90 ? 'landscape' : 'portrait';
    }

    // 3. Fallback : dimensions de l'écran
    return window.innerHeight > window.innerWidth ? 'portrait' : 'landscape';
  }

  onOrientationChange(callback) {
    this.listeners.push(callback);
  }
}
```

---

## 3.3 Breakpoints et Adaptations

| Breakpoint | Largeur | Comportement |
|-----------|---------|-------------|
| **Mobile Portrait** | 320-480px | Scale x1 ou x2, UI compacte, touch controls toujours visibles |
| **Mobile Landscape** | 481-896px | Scale x2 ou x3, layout colonnes, touch controls adaptatives |
| **Tablette Portrait** | 897-1024px | Scale x3, plus d'espace pour les détails UI |
| **Tablette Paysage** | 1025-1366px | Scale x4, layout étendu,两侧 stats visibles |
| **Desktop** | 1367px+ | Scale x5+, support clavier/souris complet |

---

## 3.4 Contrôles Tactiles

Le système de contrôles tactiles est **la pièce maîtresse de l'expérience mobile**. Il doit être invisible — le joueur ne doit jamais penser aux contrôles, seulement au jeu.

```javascript
// src/ui/TouchControls.js
class TouchControls {
  constructor(canvas) {
    this.canvas = canvas;
    this.joystick = {
      active: false,
      startX: 0,
      startY: 0,
      currentX: 0,
      currentY: 0,
      dx: 0,     // Direction normalisée (-1 à 1)
      dy: 0,
      deadzone: 8,
      maxRadius: 32
    };

    this.buttons = new Map();
    this.touches = new Map();

    // Zones de toucher
    this.zones = {
      joystick: { x: 0, y: 0, w: 100, h: 100 },  // Bas gauche
      action: { x: 0, y: 0, w: 80, h: 80 },       // Bas droit
      menu: { x: 0, y: 0, w: 24, h: 24 }          // Haut droit
    };

    this._setupListeners();
  }

  _setupListeners() {
    // Touch start
    this.canvas.addEventListener('touchstart', (e) => {
      e.preventDefault();
      for (const touch of e.changedTouches) {
        const { x, y } = this._getCanvasCoords(touch);
        this._handleTouchStart(touch.identifier, x, y);
      }
    }, { passive: false });

    // Touch move
    this.canvas.addEventListener('touchmove', (e) => {
      e.preventDefault();
      for (const touch of e.changedTouches) {
        const { x, y } = this._getCanvasCoords(touch);
        this._handleTouchMove(touch.identifier, x, y);
      }
    }, { passive: false });

    // Touch end
    this.canvas.addEventListener('touchend', (e) => {
      e.preventDefault();
      for (const touch of e.changedTouches) {
        this._handleTouchEnd(touch.identifier);
      }
    }, { passive: false });

    // Keyboard fallback (pour desktop)
    this.keys = new Set();
    window.addEventListener('keydown', (e) => this.keys.add(e.code));
    window.addEventListener('keyup', (e) => this.keys.delete(e.code));
  }

  _getCanvasCoords(touch) {
    const rect = this.canvas.getBoundingClientRect();
    return {
      x: (touch.clientX - rect.left) * (this.canvas.width / rect.width),
      y: (touch.clientY - rect.top) * (this.canvas.height / rect.height)
    };
  }

  _handleTouchStart(id, x, y) {
    // Vérifier si c'est dans la zone joystick (bas gauche)
    if (x < this.canvas.width / 2 && y > this.canvas.height * 0.6) {
      this.joystick.active = true;
      this.joystick.startX = x;
      this.joystick.startY = y;
      this.joystick.currentX = x;
      this.joystick.currentY = y;
      this.touches.set(id, 'joystick');
    }
    // Zone d'action (bas droit)
    else if (x > this.canvas.width * 0.7 && y > this.canvas.height * 0.6) {
      this.touches.set(id, 'action');
      this._emit('action', { pressed: true });
    }
    // Zone menu (haut droit)
    else if (x > this.canvas.width * 0.8 && y < this.canvas.height * 0.2) {
      this.touches.set(id, 'menu');
      this._emit('menu', { pressed: true });
    }
  }

  _handleTouchMove(id, x, y) {
    if (this.touches.get(id) === 'joystick') {
      this.joystick.currentX = x;
      this.joystick.currentY = y;

      // Calculer la direction
      let dx = x - this.joystick.startX;
      let dy = y - this.joystick.startY;
      const dist = Math.sqrt(dx * dx + dy * dy);

      if (dist > this.joystick.deadzone) {
        const clampedDist = Math.min(dist, this.joystick.maxRadius);
        this.joystick.dx = (dx / dist) * (clampedDist / this.joystick.maxRadius);
        this.joystick.dy = (dy / dist) * (clampedDist / this.joystick.maxRadius);
      } else {
        this.joystick.dx = 0;
        this.joystick.dy = 0;
      }
    }
  }

  _handleTouchEnd(id) {
    if (this.touches.get(id) === 'joystick') {
      this.joystick.active = false;
      this.joystick.dx = 0;
      this.joystick.dy = 0;
    } else if (this.touches.get(id) === 'action') {
      this._emit('action', { pressed: false });
    }
    this.touches.delete(id);
  }

  // Input unifié (touch + keyboard)
  getMovement() {
    // Touch joystick
    if (this.joystick.active) {
      return { x: this.joystick.dx, y: this.joystick.dy };
    }

    // Keyboard fallback
    let dx = 0, dy = 0;
    if (this.keys.has('ArrowLeft') || this.keys.has('KeyA')) dx -= 1;
    if (this.keys.has('ArrowRight') || this.keys.has('KeyD')) dx += 1;
    if (this.keys.has('ArrowUp') || this.keys.has('KeyW')) dy -= 1;
    if (this.keys.has('ArrowDown') || this.keys.has('KeyS')) dy += 1;

    return { x: dx, y: dy };
  }

  isActionPressed() {
    return this.keys.has('Space') || this.keys.has('Enter') || this._actionActive;
  }

  _emit(event, data) {
    window.dispatchEvent(new CustomEvent(`touch:${event}`, { detail: data }));
  }
}
```

### Positionnement des zones de toucher

Les zones de toucher sont positionnées par rapport au canvas de jeu, **pas par rapport à l'écran**. Elles sont recalculées à chaque redimensionnement :

```javascript
updateZones() {
  const w = this.canvas.width;
  const h = this.canvas.height;

  this.zones.joystick = {
    x: 8,                          // 8px du bord gauche
    y: h - 60,                     // 60px du bas
    w: 50,                         // 50×50 pixels (en résolution jeu)
    h: 50
  };

  this.zones.action = {
    x: w - 58,                     // 58px du bord droit
    y: h - 60,
    w: 50,
    h: 50
  };

  this.zones.menu = {
    x: w - 30,
    y: 4,
    w: 26,
    h: 20
  };
}
```

---

# 4. GESTION DES ASSETS

---

## 4.1 Pipeline de Chargement

Le chargement des assets est **progressif et asynchrone**. Le jeu ne se bloque pas pendant le téléchargement — il affiche un écran de chargement animé pendant que les assets critiques se téléchargent, puis lance le gameplay avec les assets nécessaires.

```javascript
// src/engine/Assets.js
class AssetLoader {
  constructor() {
    this.cache = new Map();
    this.loading = new Map();  // Promesses en cours
    this.loaded = 0;
    this.total = 0;
  }

  // Chargement critique (bloque le lancement)
  async loadCritical(urls) {
    this.total += urls.length;
    await Promise.all(urls.map(url => this.loadImage(url)));
  }

  // Chargement non-critique (en arrière-plan)
  loadBackground(urls) {
    urls.forEach(url => this.loadImage(url));
  }

  // Chargement par scène (lazy loading)
  async loadForScene(sceneName) {
    const manifest = this._getSceneManifest(sceneName);
    this.total += manifest.length;

    const promises = manifest.map(async (entry) => {
      const asset = await this.loadAsset(entry);
      this.loaded++;
      return asset;
    });

    return Promise.all(promises);
  }

  async loadImage(url) {
    if (this.cache.has(url)) return this.cache.get(url);
    if (this.loading.has(url)) return this.loading.get(url);

    const promise = new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => {
        this.cache.set(url, img);
        this.loaded++;
        resolve(img);
      };
      img.onerror = () => reject(new Error(`Failed to load: ${url}`));
      img.src = url;
    });

    this.loading.set(url, promise);
    return promise;
  }

  async loadAudio(url) {
    if (this.cache.has(url)) return this.cache.get(url);

    const response = await fetch(url);
    const arrayBuffer = await response.arrayBuffer();
    this.cache.set(url, arrayBuffer);
    this.loaded++;
    return arrayBuffer;
  }

  async loadJSON(url) {
    if (this.cache.has(url)) return this.cache.get(url);

    const response = await fetch(url);
    const data = await response.json();
    this.cache.set(url, data);
    this.loaded++;
    return data;
  }

  getProgress() {
    return this.total > 0 ? this.loaded / this.total : 0;
  }

  // Libérer les assets d'une scène précédente
  unloadScene(sceneName) {
    const manifest = this._getSceneManifest(sceneName);
    manifest.forEach(entry => {
      this.cache.delete(entry.url);
    });
  }

  _getSceneManifest(sceneName) {
    const manifests = {
      title: [
        { url: '/assets/sprites/ui/title_screen.png', type: 'image' },
        { url: '/assets/audio/music/title.ogg', type: 'audio' },
      ],
      combat: [
        { url: '/assets/sprites/characters/amara.png', type: 'image' },
        { url: '/assets/sprites/enemies/zombie_dev.png', type: 'image' },
        { url: '/assets/audio/music/combat.ogg', type: 'audio' },
        { url: '/assets/audio/sfx/combat_sfx.ogg', type: 'audio' },
        { url: '/assets/data/enemies.json', type: 'json' },
      ],
      dialogue: [
        { url: '/assets/sprites/ui/dialog_box.png', type: 'image' },
        { url: '/assets/audio/music/dialogue.ogg', type: 'audio' },
      ],
      // ...
    };
    return manifests[sceneName] || [];
  }
}
```

---

## 4.2 Format des Spritesheets

Tous les spritesheets sont packagés avec **TexturePacker** (ou équivalent open-source : ShTexturePacker, Free Texture Packer) au format JSON Hash.

### Convention de nommage

```
[entite]_[action]_[direction].png
[entite]_[action]_[direction].json
```

Exemples :
```
amara_idle_front.png      → Amara, idle, face caméra
amara_walk_front.png      → Amara, marche, face caméra
amara_attack_right.png    → Amara, attaque, droite
zombie_dev_walk_front.png → Zombie dev, marche, face caméra
ogun_corrupted_phase1.png → OGUN corrompu, phase 1
```

### Résolution des sprites

| Type | Taille par frame | Frames par animation | Format |
|------|-----------------|---------------------|--------|
| Personnages (joueurs) | 32×48 | 4-8 frames | Spritesheet vertical |
| Ennemis (base) | 32×32 | 4-6 frames | Spritesheet horizontal |
| Boss (phase 1) | 64×64 | 8-12 frames | Spritesheet horizontal |
| Boss (phase finale) | 96×96 | 12-16 frames | Spritesheet horizontal |
| UI elements | 16×16 | Variable | Spritesheet grid |
| Particules | 8×8 | 4-6 frames | Spritesheet horizontal |

### Format du fichier JSON Atlas

```json
{
  "frames": {
    "idle_0": {
      "frame": { "x": 0, "y": 0, "w": 32, "h": 48 },
      "spriteSourceSize": { "x": 0, "y": 0, "w": 32, "h": 48 },
      "sourceSize": { "w": 32, "h": 48 }
    },
    "idle_1": {
      "frame": { "x": 32, "y": 0, "w": 32, "h": 48 },
      "spriteSourceSize": { "x": 0, "y": 0, "w": 32, "h": 48 },
      "sourceSize": { "w": 32, "h": 48 }
    },
    "walk_0": {
      "frame": { "x": 0, "y": 48, "w": 32, "h": 48 },
      "spriteSourceSize": { "x": 0, "y": 0, "w": 32, "h": 48 },
      "sourceSize": { "w": 32, "h": 48 }
    }
  },
  "meta": {
    "image": "amara.png",
    "size": { "w": 256, "h": 192 },
    "scale": "1",
    "frameTags": [
      { "name": "idle", "from": 0, "to": 1, "direction": "forward" },
      { "name": "walk", "from": 2, "to": 5, "direction": "forward" },
      { "name": "attack", "from": 6, "to": 9, "direction": "forward" },
      { "name": "hurt", "from": 10, "to": 11, "direction": "forward" }
    ]
  }
}
```

---

## 4.3 Stratégie Audio Détailée

### Budget audio total : 15 MB

| Catégorie | Format | Nombre | Taille estimée |
|-----------|--------|--------|---------------|
| Musiques principales | OGG + MP3 | 8 pistes × 2 formats | ~8 Mo |
| Audio sprites SFX | OGG | 4 fichiers | ~2 Mo |
| Audio sprites voix | OGG | 2 fichiers | ~1 Mo |
| Ambiances | OGG | 3 fichiers | ~2 Mo |
| Musiques de boss (phases) | OGG + MP3 | 3 pistes × 2 formats | ~2 Mo |
| **Total** | | | **~15 Mo** |

### Audio Sprites — Principe

Un **audio sprite** est un unique fichier audio contenant tous les effets sonores d'une catégorie, séparés par des silences. Un fichier JSON définit les timestamps de début/fin de chaque SFX.

```json
{
  "combat_sfx.ogg": {
    "sprite": {
      "sword_swing": [0, 300],
      "sword_hit": [400, 250],
      "magic_cast": [800, 500],
      "magic_hit": [1400, 350],
      "enemy_hit": [1900, 200],
      "enemy_die": [2200, 600],
      "player_hurt": [2900, 300],
      "level_up": [3300, 800],
      "crit_hit": [4200, 250],
      "miss": [4600, 200]
    }
  }
}
```

Avantage : un seul fichier à télécharger, un seul décodage, des latences minimales entre les SFX.

---

## 4.4 Format des Données

### `public/data/config.json`

```json
{
  "version": "1.0.0",
  "game": {
    "title": "IAI Survivors",
    "targetFPS": 60,
    "baseResolution": { "width": 320, "height": 180 },
    "tileSize": 16,
    "maxPartySize": 4
  },
  "combat": {
    "maxTurns": 20,
    "escapeChance": 0.3,
    "critMultiplier": 1.5,
    "defenseReduction": 0.5
  },
  "schedule": {
    "weekdays": ["lundi", "mardi", "mercredi", "jeudi", "vendredi", "samedi", "dimanche"],
    "slotsPerDay": 3,
    "slotNames": ["matin", "apres-midi", "soir"],
    "maxEnergyPerSlot": 100
  },
  "characters": {
    "amara": { "name": "Amara", "role": "hacker", "baseHP": 120, "baseEnergy": 100 },
    "kofi": { "name": "Kofi", "role": "analyste", "baseHP": 100, "baseEnergy": 120 },
    "fatima": { "name": "Fatima", "role": "creatrice", "baseHP": 110, "baseEnergy": 110 }
  },
  "display": {
    "showFPS": false,
    "reducedMotionDefault": false,
    "highContrastDefault": false
  },
  "audio": {
    "masterVolume": 0.8,
    "musicVolume": 0.6,
    "sfxVolume": 0.8,
    "maxConcurrentSFX": 4
  }
}
```

### `public/data/enemies.json`

```json
{
  "zombie_dev": {
    "name": "Zombie Dev",
    "description": "Un développeur dont le code est devenu sa prison.",
    "sprite": "/assets/sprites/enemies/zombie_dev.png",
    "atlas": "/assets/sprites/enemies/zombie_dev.json",
    "stats": {
      "hp": 40,
      "attack": 8,
      "defense": 3,
      "speed": 5,
      "xp": 15
    },
    "attacks": [
      { "name": "Bug Infligé", "damage": 10, "accuracy": 0.9, "type": "physical" },
      { "name": "Stack Overflow", "damage": 15, "accuracy": 0.7, "type": "magic" }
    ],
    "drops": [
      { "item": "debug_tool", "chance": 0.3 },
      { "item": "code_fragment", "chance": 0.5 }
    ],
    "encounterZones": ["campus_grounds", "lab_basement"],
    "spawnWeight": 1.0
  },
  "null_reference": {
    "name": "Null Reference",
    "description": "Une entité qui n'existe pas... mais qui te fait quand même du mal.",
    "sprite": "/assets/sprites/enemies/null_reference.png",
    "atlas": "/assets/sprites/enemies/null_reference.json",
    "stats": {
      "hp": 25,
      "attack": 12,
      "defense": 1,
      "speed": 9,
      "xp": 20
    },
    "attacks": [
      { "name": "Undefined", "damage": 18, "accuracy": 0.85, "type": "magic" },
      { "name": "TypeError", "damage": 8, "accuracy": 1.0, "type": "debuff", "effect": "confusion" }
    ],
    "drops": [
      { "item": "type_safety_talisman", "chance": 0.2 }
    ],
    "encounterZones": ["underground_level1", "underground_level2"],
    "spawnWeight": 0.6
  }
}
```

---

# 5. DEPLOIEMENT CONTINU

---

## 5.1 Configuration Vercel

```json
// vercel.json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite",
  "headers": [
    {
      "source": "/assets/(.*)",
      "headers": [
        {
          "key": "Cache-Control",
          "value": "public, max-age=31536000, immutable"
        }
      ]
    },
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ],
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

### Pourquoi Vercel ?

| Critère | Vercel | Netlify | GitHub Pages | Cloudflare Pages |
|---------|--------|---------|-------------|-----------------|
| Edge network | Oui (global) | Oui | Non | Oui |
| Build time gratuit | 6000 min/mois | 300 min/mois | Illimité | 500 builds/mois |
| Bandwidth gratuit | 100 Go/mois | 100 Go/mois | 100 Go/mois | Illimité |
| Preview deploys | Oui (par PR) | Oui (par PR) | Non | Oui |
| Serverless functions | Oui | Oui | Non | Oui |
| Analytics intégrées | Oui | Oui | Non | Non |
| Configuration | Très simple | Simple | Simple | Moyen |

Vercel est notre choix principal car son réseau CDN est l'un des plus rapides au monde, et sa configuration pour Vite est native — pas de build plugin à configurer.

---

## 5.2 Pipeline CI/CD

### GitHub Actions — Workflow de Déploiement

```yaml
# .github/workflows/deploy.yml
name: Deploy IAI Survivors

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Test
        run: npm test

      - name: Build
        run: npm run build

      - name: Check bundle size
        run: |
          BUNDLE_SIZE=$(du -sb dist/ | cut -f1)
          GZIP_SIZE=$(tar -czf - dist/ | wc -c)
          echo "Bundle size: $BUNDLE_SIZE bytes"
          echo "Gzipped: $GZIP_SIZE bytes"

          # Fail si le bundle dépasse 2MB
          if [ $BUNDLE_SIZE -gt 2097152 ]; then
            echo "ERROR: Bundle size exceeds 2MB limit!"
            exit 1
          fi

      - name: Deploy to Vercel (Production)
        if: github.ref == 'refs/heads/main'
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'

      - name: Deploy to Vercel (Preview)
        if: github.ref == 'refs/heads/develop'
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}

      - name: Comment PR with preview URL
        if: github.event_name == 'pull_request'
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          comment-on-pr: true
```

### Branche main vs develop

```
develop ──────────────────────────────▶ Production (preview)
   │                                      URL: iai-survivors-xxxx.vercel.app
   │
   └── feature/combat-system ──────────▶ Preview (PR)
                                          URL: iai-survivors-git-xxxx.vercel.app

main ─────────────────────────────────▶ Production (live)
                                          URL: iai-survivors.vercel.app
```

---

## 5.3 Budget de Performance

Le budget de performance est **non négociable**. Il définit les limites maximales que le jeu ne doit jamais dépasser.

| Métrique | Cible | Seuil critique |
|----------|-------|---------------|
| **First Contentful Paint (FCP)** | < 1.5s sur 3G | < 2s sur 3G |
| **Time to Interactive (TTI)** | < 3s sur 3G | < 4s sur 3G |
| **Total Blocking Time (TBT)** | < 200ms | < 500ms |
| **Largest Contentful Paint (LCP)** | < 2.5s | < 4s |
| **Cumulative Layout Shift (CLS)** | < 0.1 | < 0.25 |
| **Bundle total (gzippé)** | < 500 Ko | < 800 Ko |
| **Assets totaux** | < 10 Mo | < 15 Mo |
| **Mémoire JS peak** | < 50 Mo | < 80 Mo |
| **FPS minimum (low-end)** | 30 fps | 24 fps |

### Mesure des performances

```javascript
// src/engine/Performance.js
class PerformanceMonitor {
  constructor() {
    this.fps = 0;
    this.frameTime = 0;
    this.memoryUsage = 0;
    this.lastCheck = performance.now();
    this.frameTimes = [];
  }

  startFrame() {
    this._frameStart = performance.now();
  }

  endFrame() {
    const duration = performance.now() - this._frameStart;
    this.frameTimes.push(duration);

    if (this.frameTimes.length > 60) {
      this.frameTimes.shift();
    }

    // Calculer le FPS moyen sur 1 seconde
    const now = performance.now();
    if (now - this.lastCheck >= 1000) {
      this.fps = this.frameTimes.length;
      this.frameTime = this.frameTimes.reduce((a, b) => a + b, 0) / this.frameTimes.length;
      this.lastCheck = now;
      this.frameTimes = [];

      // Vérifier la mémoire
      if (performance.memory) {
        this.memoryUsage = performance.memory.usedJSHeapSize / 1024 / 1024;
      }
    }
  }

  // Réduction automatique de qualité si FPS trop bas
  shouldReduceQuality() {
    return this.fps < 30;
  }

  getQualityLevel() {
    if (this.fps >= 55) return 'high';
    if (this.fps >= 35) return 'medium';
    return 'low';
  }
}
```

---

# 6. OPTIMISATIONS DE PERFORMANCE

---

## 6.1 Optimisations de Rendu

### Dirty Rectangle Rendering

Au lieu de redessiner l'intégralité du canvas à chaque frame, nous ne redessinons que les zones qui ont changé (les "dirty rectangles"). Pour un jeu de dialogue ou de menu, cela peut réduire le travail de rendu de 90%.

```javascript
// src/engine/DirtyRectRenderer.js
class DirtyRectRenderer {
  constructor(width, height) {
    this.width = width;
    this.height = height;
    this.dirtyRects = [];
    this.fullRedraw = true;  // Première frame = full redraw
  }

  markDirty(x, y, w, h) {
    this.dirtyRects.push({ x, y, w, h });
  }

  markFullRedraw() {
    this.fullRedraw = true;
  }

  getDirtyRects() {
    if (this.fullRedraw) {
      this.fullRedraw = false;
      this.dirtyRects = [];
      return [{ x: 0, y: 0, w: this.width, h: this.height }];
    }

    // Merge les rectangles qui se chevauchent
    const merged = this._mergeRects(this.dirtyRects);
    this.dirtyRects = [];
    return merged;
  }

  _mergeRects(rects) {
    // Algorithme simplifié de merge
    if (rects.length === 0) return [];
    if (rects.length === 1) return rects;

    // Trier par position
    rects.sort((a, b) => a.x - b.x || a.y - b.y);

    const merged = [rects[0]];
    for (let i = 1; i < rects.length; i++) {
      const last = merged[merged.length - 1];
      const curr = rects[i];

      // Si chevauchement ou adjacence, merge
      if (curr.x <= last.x + last.w && curr.y <= last.y + last.h &&
          curr.x + curr.w >= last.x && curr.y + curr.h >= last.y) {
        const newX = Math.min(last.x, curr.x);
        const newY = Math.min(last.y, curr.y);
        const newW = Math.max(last.x + last.w, curr.x + curr.w) - newX;
        const newH = Math.max(last.y + last.h, curr.y + curr.h) - newY;
        merged[merged.length - 1] = { x: newX, y: newY, w: newW, h: newH };
      } else {
        merged.push(curr);
      }
    }

    return merged;
  }
}
```

### Offscreen Canvas pour les Backgrounds Static

Les backgrounds qui ne changent jamais (ou très rarement) sont dessinés une seule fois sur un **Offscreen Canvas** en mémoire, puis recopiés sur le canvas principal via `drawImage()`. C'est beaucoup plus rapide que de redessiner tous les tiles à chaque frame.

```javascript
class BackgroundRenderer {
  constructor(width, height) {
    this.bgCanvas = document.createElement('canvas');
    this.bgCanvas.width = width;
    this.bgCanvas.height = height;
    this.bgCtx = this.bgCanvas.getContext('2d');
    this.bgCtx.imageSmoothingEnabled = false;
    this.isDirty = true;
  }

  renderBackground(tilemap, tileset, camera) {
    if (!this.isDirty) return;

    this.bgCtx.clearRect(0, 0, this.bgCanvas.width, this.bgCanvas.height);

    for (let y = 0; y < tilemap.height; y++) {
      for (let x = 0; x < tilemap.width; x++) {
        const tileId = tilemap.data[y * tilemap.width + x];
        if (tileId === 0) continue; // Tile vide

        const tileX = (tileId % tileset.columns) * tileset.tileWidth;
        const tileY = Math.floor(tileId / tileset.columns) * tileset.tileHeight;

        this.bgCtx.drawImage(
          tileset.image,
          tileX, tileY,
          tileset.tileWidth, tileset.tileHeight,
          x * tileset.tileWidth - camera.x,
          y * tileset.tileHeight - camera.y,
          tileset.tileWidth, tileset.tileHeight
        );
      }
    }

    this.isDirty = false;
  }

  draw(ctx) {
    ctx.drawImage(this.bgCanvas, 0, 0);
  }
}
```

---

## 6.2 Optimisations Mémoire

### Asset Unloading

Quand le joueur quitte une scène, tous les assets de cette scène sont **libérés de la mémoire** pour faire de la place à la scène suivante.

```javascript
class MemoryManager {
  constructor() {
    this.sceneAssets = new Map();
  }

  registerAsset(sceneName, asset) {
    if (!this.sceneAssets.has(sceneName)) {
      this.sceneAssets.set(sceneName, []);
    }
    this.sceneAssets.get(sceneName).push(asset);
  }

  unloadScene(sceneName) {
    const assets = this.sceneAssets.get(sceneName);
    if (!assets) return;

    assets.forEach(asset => {
      // Si c'est une Image, libérer le blob
      if (asset instanceof HTMLImageElement) {
        asset.src = '';
      }
      // Si c'est un AudioBuffer, rien à faire (GC s'en charge)
    });

    this.sceneAssets.delete(sceneName);

    // Forcer le GC si disponible
    if (window.gc) {
      window.gc();
    }
  }
}
```

### Limite des Canaux Audio

Le Web Audio API peut créer un nombre illimité de **AudioBufferSourceNode**, mais chaque canal actif consomme de la mémoire et du CPU. Notre limite de 4 canaux SFX simultanés est un compromis entre qualité sonore et performance.

```javascript
class AudioChannelManager {
  constructor(maxChannels = 4) {
    this.maxChannels = maxChannels;
    this.activeChannels = [];
  }

  acquireChannel(sourceNode) {
    // Si tous les canaux sont occupés, arrêter le plus ancien
    if (this.activeChannels.length >= this.maxChannels) {
      const oldest = this.activeChannels.shift();
      try { oldest.stop(); } catch (e) { /* déjà arrêté */ }
    }

    this.activeChannels.push(sourceNode);
    sourceNode.onended = () => {
      const idx = this.activeChannels.indexOf(sourceNode);
      if (idx !== -1) this.activeChannels.splice(idx, 1);
    };
  }
}
```

---

## 6.3 Optimisations Réseau

### Service Worker pour le Offline Play

Après le premier chargement, le Service Worker met en cache tous les assets statiques. Le joueur peut ensuite jouer **entièrement hors-ligne** — essentiel dans les zones avec une couverture réseau intermittente.

```javascript
// public/sw.js
const CACHE_NAME = 'iai-survivors-v1';
const STATIC_ASSETS = [
  '/',
  '/index.html',
  '/assets/data/config.json',
  '/assets/sprites/ui/buttons.png',
  '/assets/sprites/ui/panels.png',
  '/assets/sprites/ui/icons.png',
  '/assets/fonts/pixel_regular.woff2',
  '/assets/audio/sfx/ui_click.ogg',
  '/assets/audio/sfx/combat_sfx.ogg'
];

// Install: cacher les assets critiques
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(STATIC_ASSETS);
    })
  );
  self.skipWaiting();
});

// Activate: nettoyer les anciens caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames
          .filter((name) => name !== CACHE_NAME)
          .map((name) => caches.delete(name))
      );
    })
  );
  self.clients.claim();
});

// Fetch: cache-first pour les assets, network-first pour les données
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Assets statiques: cache-first
  if (url.pathname.startsWith('/assets/')) {
    event.respondWith(
      caches.match(request).then((cached) => {
        return cached || fetch(request).then((response) => {
          // Mettre en cache pour la prochaine fois
          const clone = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
          return response;
        });
      })
    );
    return;
  }

  // Données JSON: network-first (pour les mises à jour)
  if (url.pathname.endsWith('.json')) {
    event.respondWith(
      fetch(request).then((response) => {
        const clone = response.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
        return response;
      }).catch(() => caches.match(request))
    );
    return;
  }

  // HTML: network-first avec fallback cache
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request).catch(() => caches.match('/index.html'))
    );
    return;
  }
});
```

### Versioning des Assets

Chaque asset est versionné via un hash dans son nom de fichier. Cela garantit que le navigateur ne sert jamais un fichier en cache obsolète.

```javascript
// Pendant le build, Vite ajoute automatiquement un hash
// Avant: /assets/sprites/characters/amara.png
// Après: /assets/sprites/characters/amara.a3f2b1c.png

// Le Service Worker utilise le hash comme clé de cache
const versionedAssets = import.meta.glob('/assets/**/*', { eager: true, as: '?url' });
```

---

## 6.4 Optimisations Spécifiques Mobile

### Détection de la Puissance de l'Appareil

```javascript
class DeviceProfiler {
  static getProfile() {
    const profile = {
      tier: 'low',     // 'low', 'medium', 'high'
      maxParticles: 50,
      maxEnemies: 3,
      enableShadows: false,
      enableParallax: false,
      enableScreenShake: true,
      musicQuality: 'low'  // 'low', 'medium', 'high'
    };

    // Détection par la mémoire disponible
    if (navigator.deviceMemory) {
      if (navigator.deviceMemory >= 4) {
        profile.tier = 'high';
        profile.maxParticles = 200;
        profile.maxEnemies = 6;
        profile.enableShadows = true;
        profile.enableParallax = true;
        profile.musicQuality = 'high';
      } else if (navigator.deviceMemory >= 2) {
        profile.tier = 'medium';
        profile.maxParticles = 100;
        profile.maxEnemies = 4;
        profile.musicQuality = 'medium';
      }
    }

    // Détection par le nombre de cœurs CPU
    if (navigator.hardwareConcurrency) {
      if (navigator.hardwareConcurrency >= 8) {
        profile.tier = 'high';
      } else if (navigator.hardwareConcurrency <= 2) {
        profile.tier = 'low';
        profile.maxParticles = 30;
        profile.maxEnemies = 2;
      }
    }

    // Détection par le GPU (WebGL renderer)
    try {
      const canvas = document.createElement('canvas');
      const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
      if (gl) {
        const debugInfo = gl.getExtension('WEBGL_debug_renderer_info');
        if (debugInfo) {
          const renderer = gl.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL);
          // Les GPU mobiles low-end ont souvent des noms génériques
          if (renderer.includes('SwiftShader') || renderer.includes('Software')) {
            profile.tier = 'low';
          }
        }
      }
    } catch (e) {
      // WebGL non disponible = très ancien appareil
      profile.tier = 'low';
    }

    return profile;
  }
}
```

### Optimisation des Touch Events

```javascript
// Utiliser des event listeners passifs pour les scroll events
// (nous n'avons pas besoin de preventDefault sur les touches)
this.canvas.addEventListener('touchmove', handler, { passive: true });

// Utiliser des event listeners non-passifs seulement quand nécessaire
this.canvas.addEventListener('touchstart', handler, { passive: false });
```

### FPS Monitoring avec Réduction Automatique

```javascript
class AdaptiveQuality {
  constructor(performanceMonitor, renderer) {
    this.perf = performanceMonitor;
    this.renderer = renderer;
    this.currentQuality = 'high';
    this.frameCount = 0;
    this.lowFPSCount = 0;
  }

  update() {
    this.frameCount++;

    // Vérifier toutes les 60 frames
    if (this.frameCount >= 60) {
      const fps = this.perf.fps;

      if (fps < 24 && this.currentQuality !== 'low') {
        this.lowFPSCount++;
        if (this.lowFPSCount >= 3) {
          this._reduceQuality();
          this.lowFPSCount = 0;
        }
      } else if (fps >= 55) {
        this.lowFPSCount = 0;
        this._increaseQuality();
      }

      this.frameCount = 0;
    }
  }

  _reduceQuality() {
    const levels = ['high', 'medium', 'low'];
    const currentIdx = levels.indexOf(this.currentQuality);
    if (currentIdx < levels.length - 1) {
      this.currentQuality = levels[currentIdx + 1];
      this._applyQuality(this.currentQuality);
    }
  }

  _increaseQuality() {
    const levels = ['high', 'medium', 'low'];
    const currentIdx = levels.indexOf(this.currentQuality);
    if (currentIdx > 0) {
      this.currentQuality = levels[currentIdx - 1];
      this._applyQuality(this.currentQuality);
    }
  }

  _applyQuality(level) {
    switch (level) {
      case 'low':
        this.renderer.ctx.imageSmoothingEnabled = false;
        // Réduire le nombre de particules actives
        window.game?.particlePool?.setMaxActive(30);
        // Désactiver les effets de transition
        window.game?.renderer?.disableTransitions?.();
        break;
      case 'medium':
        window.game?.particlePool?.setMaxActive(80);
        window.game?.renderer?.enableTransitions?.();
        break;
      case 'high':
        window.game?.particlePool?.setMaxActive(200);
        window.game?.renderer?.enableTransitions?.();
        break;
    }
  }
}
```

---

# 7. PWA — PROGRESSIVE WEB APP

---

## 7.1 Ajout à l'Écran d'Accueil

IAI Survivors est une PWA complète. Le joueur peut l'ajouter à son écran d'accueil comme une application native. L'expérience est indiscernable d'une app téléchargée depuis un store.

### Comportement en mode standalone

Quand le jeu est lancé depuis l'écran d'accueil (mode standalone), les éléments suivants sont gérés :

1. **Pas de barre d'adresse** — le jeu prend tout l'écran
2. **Pas de barre d'navigation** — plein écran total
3. **Splash screen personnalisé** — le `manifest.json` définit les couleurs et l'icône
4. **Gestion du lifecycle** — pause automatique quand l'app passe en arrière-plan
5. **Orientation lock** — le jeu force l'orientation actuelle

```javascript
// src/engine/Lifecycle.js
class AppLifecycle {
  constructor(game) {
    this.game = game;
    this.isStandalone = window.matchMedia('(display-mode: standalone)').matches;
    this.isVisible = true;

    // Détection du mode standalone
    if (this.isStandalone) {
      document.body.classList.add('standalone');
    }

    // Gestion de la visibilité
    document.addEventListener('visibilitychange', () => {
      this.isVisible = !document.hidden;
      if (!this.isVisible) {
        this.game.pause();
      } else {
        this.game.resume();
      }
    });

    // Gestion du focus/blur
    window.addEventListener('blur', () => {
      this.game.pause();
    });

    window.addEventListener('focus', () => {
      this.game.resume();
    });

    // Empêcher le sleep de l'écran (si supported)
    this._requestWakeLock();
  }

  async _requestWakeLock() {
    if ('wakeLock' in navigator) {
      try {
        this.wakeLock = await navigator.wakeLock.request('screen');
        this.wakeLock.release.addEventListener('release', () => {
          // Réacquérir quand le tab redevient visible
          if (this.isVisible) this._requestWakeLock();
        });
      } catch (err) {
        // Wake Lock non supporté ou refusé — pas grave
        console.log('Wake Lock non disponible');
      }
    }
  }
}
```

---

## 7.2 Stratégie de Cache du Service Worker

### Niveaux de cache

| Niveau | Contenu | Stratégie | TTL |
|--------|---------|-----------|-----|
| **Critique** | index.html, JS, CSS | Cache-first, update on activate | Permanent |
| **Assets** | Sprites, audio, fonts | Cache-first, immutable | Permanent |
| **Données** | JSON config, dialogues | Network-first, cache fallback | 1 heure |
| **Mises à jour** | Nouvelles versions | Stale-while-revalidate | 24 heures |

### Gestion des mises à jour

Quand une nouvelle version du jeu est déployée, le Service Worker détecte le changement et propose la mise à jour au joueur :

```javascript
// Détection de mise à jour
let newWorker = null;

if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/sw.js').then((reg) => {
    reg.addEventListener('updatefound', () => {
      newWorker = reg.installing;
      newWorker.addEventListener('statechange', () => {
        if (newWorker.state === 'activated') {
          showUpdateNotification();
        }
      });
    });
  });
}

function showUpdateNotification() {
  // Afficher un toast : "Mise à jour disponible ! Recharger ?"
  window.dispatchEvent(new CustomEvent('game:update-available', {
    detail: {
      message: 'Une mise à jour est disponible !',
      action: () => {
        newWorker.postMessage({ type: 'SKIP_WAITING' });
        window.location.reload();
      }
    }
  }));
}
```

---

# 8. ACCESSIBILITÉ

---

## 8.1 Modes d'Accessibilité

IAI Survivors s'engage à être jouable par le plus grand nombre. Trois modes d'accessibilité sont disponibles dans les options.

### Mode Mouvement Réduit

Désactive toutes les animations non essentielles : parallaxe, particules, transitions de caméra, screen shake. Le gameplay reste identique, seules les animations cosmétiques sont simplifiées.

```javascript
class AccessibilityManager {
  constructor(settings) {
    this.settings = settings;
    this.reducedMotion = settings.reducedMotion ||
      window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  }

  shouldAnimate() {
    return !this.reducedMotion;
  }

  getParticleCount(baseCount) {
    return this.reducedMotion ? 0 : baseCount;
  }

  getTransitionType() {
    return this.reducedMotion ? 'instant' : 'fade';
  }

  getParallaxFactor() {
    return this.reducedMotion ? 0 : 1;
  }

  getScreenShakeEnabled() {
    return !this.reducedMotion;
  }
}
```

### Mode Contraste Élevé

Augmente le contraste de tous les éléments UI. Les bordures sont épaissies, les couleurs sont plus saturées, les textes ont un contour noir de 2px.

```javascript
renderDialogBox(ctx, text) {
  const isHighContrast = this.accessibility.settings.highContrast;

  // Fond de la boîte de dialogue
  ctx.fillStyle = isHighContrast ? '#000000' : 'rgba(10, 10, 26, 0.85)';
  ctx.fillRect(4, 120, 312, 56);

  // Bordure
  ctx.strokeStyle = isHighContrast ? '#ffffff' : '#00ff41';
  ctx.lineWidth = isHighContrast ? 2 : 1;
  ctx.strokeRect(4, 120, 312, 56);

  // Texte
  ctx.font = '8px pixel_regular';
  ctx.fillStyle = isHighContrast ? '#ffffff' : '#00ff41';

  if (isHighContrast) {
    // Contour noir pour améliorer la lisibilité
    ctx.strokeStyle = '#000000';
    ctx.lineWidth = 2;
    ctx.strokeText(text, 10, 130);
  }

  ctx.fillText(text, 10, 130);
}
```

### Taille de Texte

Trois niveaux de taille de texte : petit (défaut), moyen, grand. Les textes sont rendus sur le Canvas, donc le "scaling" est effectué en dessinant les caractères plus grands ou en utilisant une police de taille supérieure.

```javascript
getFontSize(sizeName = this.settings.textSize) {
  const sizes = {
    small: 8,    // Taille pixel art native
    normal: 10,  // Légèrement agrandi
    large: 14    // Très lisible
  };
  return sizes[sizeName] || 8;
}
```

### Labels pour Lecteurs d'Écran

Bien que le jeu soit principalement Canvas-based (et donc inaccessible aux lecteurs d'écran nativement), nous fournissons des **aria-labels** sur les éléments DOM interactifs et un **texte alternatif** pour les scènes clés.

```javascript
// Quand un dialogue s'affiche, mettre à jour l'aria-label
_updateAriaLabel(text) {
  const overlay = document.getElementById('ui-overlay');
  overlay.setAttribute('aria-live', 'polite');
  overlay.setAttribute('aria-label', text);
}
```

### Palette Adaptée aux Daltoniens

Trois palettes alternatives pour les types de daltonisme les plus courants :

| Type | Palette normale → Alternative |
|------|------------------------------|
| **Protanopie** (rouge-vert) | Rouge → Bleu foncé, Vert → Jaune |
| **Deuteranopie** (rouge-vert) | Rouge → Marron, Vert → Bleu |
| **Tritanopie** (bleu-jaune) | Bleu → Rose, Jaune → Gris |

```javascript
const COLORBLIND_PALETTES = {
  normal: {
    health: '#ff0000',
    energy: '#00ff00',
    mana: '#0000ff',
    warning: '#ffff00',
    danger: '#ff0000',
    safe: '#00ff00'
  },
  protanopia: {
    health: '#0044cc',
    energy: '#cccc00',
    mana: '#0000ff',
    warning: '#cccc00',
    danger: '#0044cc',
    safe: '#cccc00'
  },
  deuteranopia: {
    health: '#8b4513',
    energy: '#0066cc',
    mana: '#0000ff',
    warning: '#cccc00',
    danger: '#8b4513',
    safe: '#0066cc'
  },
  tritanopie: {
    health: '#ff0000',
    energy: '#cc99cc',
    mana: '#ff0000',
    warning: '#cccccc',
    danger: '#ff0000',
    safe: '#cccccc'
  }
};
```

---

# 9. ANALYTIQUES & TÉLÉMÉTRIE

---

## 9.1 Philosophie de Collecte

IAI Survivors respecte la vie privée de ses joueurs. La collecte de données est **totalement optionnelle**, **anonyme** et **transparente**. Le joueur est informé de ce qui est collecté et peut désactiver la télémétrie à tout moment.

### Ce qui est collecté (avec consentement)

| Donnée | Utilisation | Obligatoire ? |
|--------|------------|-------------|
| Session length | Comprendre l'engagement | Non |
| Chois narratifs (anonymisés) | Analyser les patterns de choix | Non |
| Endings atteints | Mesurer le taux de complétion | Non |
| Erreurs/crashes | Corriger les bugs | Non |
| Appareil (modèle, OS, navigateur) | Optimiser la compatibilité | Non |

### Ce qui n'est JAMAIS collecté

- Nom, email, ou toute donnée personnelle identifiable
- Position géographique
- Contacts ou données sociales
- Données de paiement (le jeu est gratuit)
- Historique de navigation hors du jeu

### Implémentation

```javascript
// src/engine/Analytics.js
class PrivacyAnalytics {
  constructor(storage) {
    this.storage = storage;
    this.enabled = false;
    this.sessionStart = Date.now();
    this.events = [];

    // Vérifier le consentement
    const consent = storage.getSettings().analyticsConsent;
    this.enabled = consent === true;
  }

  enable() {
    this.enabled = true;
    this.storage.saveSettings({
      ...this.storage.getSettings(),
      analyticsConsent: true
    });
    this._trackSessionStart();
  }

  disable() {
    this.enabled = false;
    this.storage.saveSettings({
      ...this.storage.getSettings(),
      analyticsConsent: false
    });
    this.events = [];
  }

  trackEvent(category, action, label = null) {
    if (!this.enabled) return;

    this.events.push({
      t: Date.now() - this.sessionStart,  // Timestamp relatif
      c: category,
      a: action,
      l: label
    });

    // Envoyer batch toutes les 30 secondes
    if (this.events.length >= 10 || this.events.length > 0 &&
        this.events[this.events.length - 1].t > 30000) {
      this._flush();
    }
  }

  trackChoice(weekId, choiceId, outcome) {
    this.trackEvent('narrative', 'choice', `${weekId}:${choiceId}:${outcome}`);
  }

  trackEnding(endingId) {
    this.trackEvent('narrative', 'ending', endingId);
  }

  trackError(error, context) {
    this.trackEvent('error', error.message, context);
  }

  async _flush() {
    if (this.events.length === 0) return;

    const payload = {
      v: '1',
      sid: this._getAnonymousSessionId(),
      events: this.events.splice(0)  // Vide le tableau
    };

    try {
      await fetch('https://analytics.iai-survivors.dev/collect', {
        method: 'POST',
        body: JSON.stringify(payload),
        headers: { 'Content-Type': 'application/json' }
      });
    } catch {
      // Silencieux — ne pas perturber le jeu
    }
  }

  _getAnonymousSessionId() {
    // Hash aléatoire, pas lié à l'utilisateur
    let sid = sessionStorage.getItem('analytics_sid');
    if (!sid) {
      sid = Array.from(crypto.getRandomValues(new Uint8Array(16)))
        .map(b => b.toString(16).padStart(2, '0'))
        .join('');
      sessionStorage.setItem('analytics_sid', sid);
    }
    return sid;
  }
}
```

---

# ANNEXES

---

## A. Package.json

```json
{
  "name": "iai-survivors",
  "version": "1.0.0",
  "description": "Survive l'IAI, decode l'avenir.",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview",
    "lint": "eslint src/",
    "test": "vitest run",
    "test:watch": "vitest",
    "analyze": "vite build --mode analyze"
  },
  "dependencies": {
    "howler": "^2.2.4"
  },
  "devDependencies": {
    "vite": "^5.4.0",
    "vitest": "^2.0.0",
    "eslint": "^9.0.0",
    "terser": "^5.31.0"
  }
}
```

## B. .gitignore

```
node_modules/
dist/
.vercel/
*.log
.DS_Store
.env
.env.local
coverage/
```

## C. ESLint Configuration

```json
{
  "env": {
    "browser": true,
    "es2022": true,
    "es6": true
  },
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module"
  },
  "rules": {
    "no-unused-vars": "warn",
    "no-undef": "error",
    "no-console": ["warn", { "allow": ["warn", "error"] }],
    "eqeqeq": "error",
    "no-var": "error",
    "prefer-const": "error",
    "prefer-template": "warn"
  }
}
```

---

> *"L'architecture est le squelette du jeu. Sans squelette, le corps ne se tient pas. Mais le squelette doit être léger — assez léger pour porter le poids du rêve d'Ananzi sur un téléphone à 1 Go de RAM, au fin fond de Lomé, avec une connexion qui oscille entre 3G et rien du tout. C'est là que l'architecture prouve sa valeur : non pas dans les conditions parfaites, mais dans les conditions réelles."*
