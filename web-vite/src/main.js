import { Game } from './engine/Game.js';
import { Renderer } from './engine/Renderer.js';
import { Input } from './engine/Input.js';
import { Storage } from './engine/Storage.js';
import { Boot } from './scenes/Boot.js';

/** @type {Game} */
let game;

/** Hide the HTML loading screen */
function hideLoadingScreen() {
  const el = document.getElementById('loading-screen');
  if (el) {
    el.classList.add('hidden');
    setTimeout(() => el.remove(), 600);
  }
}

/** Update the HTML loading bar */
function updateLoadingBar(progress, text) {
  const bar = document.getElementById('loading-bar');
  const label = document.getElementById('loading-text');
  if (bar) bar.style.width = `${Math.round(progress * 100)}%`;
  if (label && text) label.textContent = text;
}

/** Main entry point */
async function init() {
  const canvas = document.getElementById('game-canvas');
  if (!canvas) throw new Error('Canvas element #game-canvas not found');

  const storage = new Storage('iai_survivors');
  const input = new Input(canvas);
  const renderer = new Renderer(canvas);

  game = new Game({ renderer, input, storage });

  updateLoadingBar(0.1, 'Initializing engine...');
  await game.init();

  game.loadScene(new Boot(game));

  updateLoadingBar(1.0, 'Ready');
  hideLoadingScreen();

  game.start();
}

init().catch((err) => {
  console.error('Failed to start IAI Survivors:', err);
  const loadingText = document.getElementById('loading-text');
  if (loadingText) {
    loadingText.textContent = 'Error — check console';
    loadingText.style.color = '#ff4444';
  }
});

if (import.meta.hot) {
  import.meta.hot.dispose(() => {
    if (game) game.destroy();
  });
}
