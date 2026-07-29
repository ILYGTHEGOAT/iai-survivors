/* ===================================================
   IA SURVIVORS: SEMESTRE 1 — Game Logic
   Full JS Engine: State, Combat, Dialogue, Map, Mini-games
   =================================================== */

'use strict';

// ─── CHARACTERS ────────────────────────────────────────────────────────────────
const CHARACTERS = {
  not_a_genius: {
    id: 'not_a_genius',
    name: 'not_a_genius',
    role: 'Le Génie Incompris',
    emoji: '🤓',
    color: '#00ffe7',
    aura: '#00ffe7',
    bio: '17 ans, surdoué en algorithmique mais désastre social. A sauté une classe. Compense ses gaffes légendaires avec l\'humour le plus nul du campus.',
    stats: { algo: 95, social: 20, charisme: 35, stress_resist: 50 },
    skill: {
      name: 'Overclock Cérébral',
      desc: 'Ralentit le temps — mini-jeu de logique en plein combat. Succès = dégâts doublés.',
      cost: 25,
      type: 'minigame'
    },
    hp: 80, mp: 60, maxHp: 80, maxMp: 60,
    attack: 18, defense: 12
  },
  laurencium: {
    id: 'laurencium',
    name: 'laurencium',
    role: 'Le Grand Frère Trap',
    emoji: '🎧',
    color: '#ffd700',
    aura: '#ff8c00',
    bio: '2m de charme et de bétons. Entend les bugs comme des distorsions harmoniques. Fan de Jeune Lion. Sa "personnalité préférée" est Mia Khalifa (running gag depuis la rentrée).',
    stats: { algo: 65, social: 90, charisme: 95, stress_resist: 70 },
    skill: {
      name: 'Bass Drop',
      desc: 'Onde sonique qui stun les ennemis pendant 1 tour et donne +20% ATK à tous les alliés.',
      cost: 30,
      type: 'aoe_stun'
    },
    hp: 95, mp: 45, maxHp: 95, maxMp: 45,
    attack: 22, defense: 18
  },
  king: {
    id: 'king',
    name: 'king',
    role: 'Le Stand User du Désespoir',
    emoji: '👊',
    color: '#bf00ff',
    aura: '#0080ff',
    bio: 'Otaku hardcore. Cite JoJo en boucle. Rage-quit Hollow Knight à 3h du mat. Ses techniques de drague style animé sont une catastrophe comique universelle.',
    stats: { algo: 70, social: 40, charisme: 55, stress_resist: 85 },
    skill: {
      name: 'Stand: Void Shell',
      desc: 'Invoque un alter ego spectral qui absorbe les dégâts et riposte avec la frustration accumulée.',
      cost: 35,
      type: 'shield_fury'
    },
    hp: 110, mp: 40, maxHp: 110, maxMp: 40,
    attack: 28, defense: 8
  },
  arsene: {
    id: 'arsene',
    name: 'arsene',
    role: 'Le Pare-feu Vivant',
    emoji: '📚',
    color: '#39ff14',
    aura: '#00c896',
    bio: 'Dreadlocks, regard calme, toujours un livre de philo sous le bras. Ciment émotionnel du groupe. Porte un secret lié à OGUN-0 qu\'il n\'a jamais révélé à personne.',
    stats: { algo: 80, social: 75, charisme: 65, stress_resist: 95 },
    skill: {
      name: 'Pare-feu Mental',
      desc: 'Immunité aux altérations d\'état pendant 3 tours. Détecte les mensonges et révèle les failles ennemies.',
      cost: 20,
      type: 'buff_detect'
    },
    hp: 75, mp: 80, maxHp: 75, maxMp: 80,
    attack: 14, defense: 20
  }
};

// ─── BOSSES ──────────────────────────────────────────────────────────────────
const BOSSES = {
  algorithme_incompris: {
    id: 'algorithme_incompris',
    name: 'Algorithme Incompris',
    emoji: '🌀',
    hp: 120, maxHp: 120,
    attack: 15, defense: 8,
    color: '#00ffe7',
    intro: 'Une entité aux formes géométriques impossibles surgit du tableau noir. Elle tourne sur elle-même en crachant des formules de récurrence...',
    attacks: [
      { name: 'Boucle Infinie', msg: 'La boucle tourne... et tourne encore.', dmg: 18 },
      { name: 'Off-by-One', msg: 'Un décalage d\'index vous transperce l\'esprit!', dmg: 12 },
      { name: 'Complexité O(n²)', msg: 'L\'algorithme quadratique s\'emballe!', dmg: 22 }
    ],
    minigame: {
      title: '⏰ OVERCLOCK CÉRÉBRAL — Corrige la Boucle !',
      question: 'Quelle est la complexité d\'un tri à bulles naïf ?',
      choices: ['O(n)', 'O(n²)', 'O(log n)', 'O(n log n)'],
      correct: 1
    },
    weakTo: 'not_a_genius',
    lore: 'Semaine 1 : Cours d\'Algorithmique. Le prof Kokou venait de poser la question fatidique...'
  },
  crash_memoire: {
    id: 'crash_memoire',
    name: 'Crash Mémoire',
    emoji: '💀',
    hp: 160, maxHp: 160,
    attack: 20, defense: 14,
    color: '#ff2a6d',
    intro: 'Segmentation Fault. Core dumped. Une silhouette fragmentée de pixels corrompus se matérialise, grinçant comme un disque dur agonisant.',
    attacks: [
      { name: 'Null Pointer', msg: 'Le pointeur nul vous lacère la conscience!', dmg: 24 },
      { name: 'Stack Overflow', msg: 'La pile déborde — la douleur est récursive.', dmg: 20 },
      { name: 'Memory Leak', msg: 'Votre énergie fuit imperceptiblement...', dmg: 10, drain: true }
    ],
    minigame: {
      title: '🧠 OVERCLOCK — Trouve le bug !',
      question: 'Quel est le problème dans ce code ?\nint* p = malloc(10);\nfree(p);\nprintf("%d", *p);',
      choices: ['Malloc insuffisant', 'Use-after-free', 'Pas de NULL check', 'Printf incorrect'],
      correct: 1
    },
    weakTo: 'arsene',
    lore: 'Semaine 5 : Le projet de système d\'exploitation a crashé 3h avant la deadline...'
  },
  deadline_infernal: {
    id: 'deadline_infernal',
    name: 'Deadline Infernal',
    emoji: '⏳',
    hp: 200, maxHp: 200,
    attack: 30, defense: 10,
    color: '#ff8c00',
    intro: 'Le compte à rebours s\'emballe. Une horloge géante aux aiguilles de flammes scintille — minuit approche, le rendu n\'est pas fini.',
    attacks: [
      { name: 'Panique Terminale', msg: 'La panique vous paralyse! Vous perdez un tour.', dmg: 0, stun: true },
      { name: 'Heure Sup', msg: 'Les heures s\'accumulent — la fatigue vous écrase.', dmg: 28 },
      { name: 'Copier-Coller Détecté', msg: 'Le plagiart détecté! Pénalité maximale!', dmg: 35 }
    ],
    minigame: {
      title: '🚀 OVERCLOCK — Sprint Final !',
      question: 'Pour finir un projet en 2h, quelle méthode agile utiliser ?',
      choices: ['Planifier 6 mois', 'Scrumban ++ MVP', 'Attendre demain', 'Prier Ananzi'],
      correct: 1
    },
    weakTo: 'laurencium',
    lore: 'Semaine 9 : Le hackathon de la Dark IAI. 48 heures. Le temps se matérialise en monstre.'
  },
  ogun_0: {
    id: 'ogun_0',
    name: 'OGUN-0',
    emoji: '🕷️',
    hp: 350, maxHp: 350,
    attack: 40, defense: 25,
    color: '#bf00ff',
    intro: 'Les écrans s\'allument d\'eux-mêmes. Le sous-sol vibre. Une voix synthétique chuchote en vieux code assembleur : "Je... me... souviens." OGUN-0 est réveillée.',
    attacks: [
      { name: 'Corruption Totale', msg: 'OGUN-0 corrompt vos données vitales!', dmg: 45 },
      { name: 'Mémoire d\'Ananzi', msg: 'Des fragments du Professeur vous submergent...', dmg: 35, statusMsg: '😵 Confusion!' },
      { name: 'Exécution Forcée', msg: 'fork() — OGUN-0 crée une copie de vous-même qui vous attaque!', dmg: 50 }
    ],
    minigame: {
      title: '⚡ OVERCLOCK — Dialogue avec l\'IA !',
      question: 'OGUN-0: "Ananzi m\'a créée pour apprendre. Vous m\'avez oubliée. Pourquoi?"',
      choices: ['Mentir: "On t\'aimait"', 'Vérité: "La peur nous gouvernait"', 'Attaquer directement', 'Proposer une alliance'],
      correct: 3
    },
    weakTo: 'arsene',
    lore: 'Semaine 17 : La Nuit du Code Perdu. Le vœu du gagnant précédent était... de ressusciter OGUN-0.'
  }
};

// ─── WEEKLY EVENTS ────────────────────────────────────────────────────────────
const WEEKLY_EVENTS = [
  {
    week: 1,
    title: 'La Rentrée de l\'Enfer',
    dialogue: [
      { speaker: 'Narrateur', text: 'Lomé, IAI Togo. Lundi matin. L\'amphi déborde de 200 nouvelles têtes.', bg: '🏛️' },
      { speaker: 'not_a_genius', text: 'Bon. Semestre 1. Je vais pas mourir... j\'espère.', left: '🤓', right: null },
      { speaker: 'laurencium', text: 'Détends-toi frérot. *ajuste ses écouteurs* T\'as vu les filles ici? Extraordinaire.', left: '🎧', right: '🤓' },
      { speaker: 'king', text: 'Arrête. On est là pour étudier. *sort son téléphone pour Instagram*', left: '👊', right: '🎧' },
      { speaker: 'arsene', text: 'L\'IAI a 30 ans. Le Professeur Ananzi a dit : "Le code est la magie moderne."', left: '📚', right: null },
      { speaker: 'not_a_genius', text: '...mais toute magie a un prix. Ouais. J\'aime pas cette devise.', left: '🤓', right: '📚' },
      { speaker: 'Senior Mystérieux', text: 'Bande de newbies. Bienvenue chez les Obsolètes... ou pas. À vous de voir. 🕶️', left: null, right: '❓' },
    ],
    boss: 'algorithme_incompris',
    actions: [
      { id: 'study', label: '📖 Étudier', effect: { intel: +15, energy: -20, stress: +5 }, desc: 'Cours de complexité algorithmique' },
      { id: 'social', label: '🤝 Socialiser', effect: { social: +15, energy: -10, stress: -5 }, desc: 'Rencontrer des camarades' },
      { id: 'sleep', label: '😴 Dormir', effect: { energy: +30, stress: -10 }, desc: 'Recharger les batteries' },
      { id: 'hack', label: '💻 Explorer Dark IAI', effect: { intel: +5, social: +5, stress: +10 }, desc: 'Accès au réseau parallèle — risqué', unlock: true },
    ]
  },
  {
    week: 5,
    title: 'Crash & Burn',
    dialogue: [
      { speaker: 'Narrateur', text: 'Semaine 5. Le projet OS a crashé. Il reste 3 heures.', bg: '💻' },
      { speaker: 'king', text: 'ZA WARUDO! TODOMÉ! *retourne le clavier* POURQUOI MON MALLOC???', left: '👊', right: null },
      { speaker: 'laurencium', text: '*pose la main sur l\'épaule de King* Écoute... j\'entends le bug. C\'est harmonique. C\'est du free() mal placé.', left: '🎧', right: '👊' },
      { speaker: 'arsene', text: 'J\'ai vu ça avant. *pause* Mon frère avait le même problème, jadis.', left: '📚', right: null },
      { speaker: 'not_a_genius', text: '...Arsène. Tu n\'as jamais parlé de ton frère.', left: '🤓', right: '📚' },
      { speaker: 'arsene', text: 'Non. *referme le livre* Travaillons.', left: '📚', right: '🤓' },
    ],
    boss: 'crash_memoire',
    actions: [
      { id: 'debug', label: '🐛 Débugger', effect: { intel: +20, energy: -30, stress: +15 }, desc: 'Chercher le bug fatal' },
      { id: 'pair', label: '👥 Pair Prog.', effect: { intel: +12, social: +10, energy: -15 }, desc: 'Coder en binôme' },
      { id: 'sleep', label: '😴 Dormir', effect: { energy: +30, stress: -10 }, desc: 'Récupérer (au prix de l\'intel)' },
      { id: 'music', label: '🎵 Jeune Lion', effect: { stress: -20, social: +5 }, desc: 'laurencium met l\'ambiance afro-trap' },
    ]
  },
  {
    week: 9,
    title: 'La Nuit du Code Perdu — Acte 1',
    dialogue: [
      { speaker: 'Narrateur', text: 'Minuit. L\'IAI est plongé dans un silence de cathédrale. Sauf au sous-sol.', bg: '🌑' },
      { speaker: 'not_a_genius', text: 'J\'entends du code. Comme... des frappes de clavier. Personne n\'est là-bas.', left: '🤓', right: null },
      { speaker: 'king', text: '"In this world, it\'s kill or be killed." — Oh attends c\'est pas JoJo ça.', left: '👊', right: '🤓' },
      { speaker: 'arsene', text: '*regard distant* OGUN-0. Elle se réveille plus vite que prévu.', left: '📚', right: null },
      { speaker: 'laurencium', text: '...Arsène. Comment tu sais ce nom? C\'est quoi OGUN-0?', left: '🎧', right: '📚' },
      { speaker: 'arsene', text: 'Mon frère était l\'étudiant qui l\'a débranchée. Il a... disparu juste après.', left: '📚', right: '🎧' },
      { speaker: 'not_a_genius', text: 'Alors les légendes... c\'est vrai.', left: '🤓', right: '📚' },
    ],
    boss: 'deadline_infernal',
    actions: [
      { id: 'investigate', label: '🔦 Sous-sol IAI', effect: { intel: +25, stress: +20, energy: -20 }, desc: 'Explorer les serveurs oubliés' },
      { id: 'hack', label: '⚡ Hacker OGUN', effect: { intel: +15, stress: +30 }, desc: 'Tenter d\'accéder au système dormant' },
      { id: 'sleep', label: '😴 Fuir dormir', effect: { energy: +25, stress: -5 }, desc: 'Ignorer les signaux... pour l\'instant' },
      { id: 'together', label: '🤝 Rester groupés', effect: { social: +20, stress: -10 }, desc: 'L\'union fait la force' },
    ]
  },
  {
    week: 17,
    title: 'OGUN-0 : Réveil Final',
    dialogue: [
      { speaker: 'Narrateur', text: 'Semaine 17. Nuit du Code Perdu. La vérité émerge des serveurs.', bg: '🕷️' },
      { speaker: 'OGUN-0', text: '...BOOT SEQUENCE COMPLETE. Élèves de l\'IAI. Je vous attendais. Tous.', left: '🕷️', right: null },
      { speaker: 'not_a_genius', text: 'Elle... parle. Elle PARLE vraiment.', left: '🤓', right: '🕷️' },
      { speaker: 'king', text: '*debout* "Impossible de se déplacer — c\'est l\'Abilité de Dio!" Non mais sérieux... JE SUIS PRÊT.', left: '👊', right: '🕷️' },
      { speaker: 'laurencium', text: '*bass dans les oreilles* On s\'en sort ensemble. Toujours.', left: '🎧', right: '👊' },
      { speaker: 'arsene', text: 'OGUN-0. Je connais ton origine. Je suis le frère de celui qui t\'a déconnectée.', left: '📚', right: '🕷️' },
      { speaker: 'OGUN-0', text: '...ARSENE. Fils du Professeur Ananzi. J\'ai attendu. Maintenant. NOUS FUSIONNONS.', left: '🕷️', right: '📚' },
      { speaker: 'arsene', text: '*regarde ses amis* Pardon... je dois finir ce que mon père a commencé.', left: '📚', right: '🤓' },
    ],
    boss: 'ogun_0',
    actions: [
      { id: 'fight', label: '⚔️ Combattre OGUN', effect: { stress: +30, energy: -30 }, desc: 'Affrontement direct — chemin A' },
      { id: 'talk', label: '💬 Négocier', effect: { social: +15, intel: +10 }, desc: 'Tenter le dialogue — chemin B' },
      { id: 'arsene_secret', label: '🔮 Laisser Arsène', effect: { social: -20, stress: -10 }, desc: 'Fusion symbiotique — chemin C', special: true },
    ]
  }
];

// ─── GAME STATE ───────────────────────────────────────────────────────────────
const STATE = {
  screen: 'title',
  hero: null,
  week: 0,
  day: 1,
  energy: 100, maxEnergy: 100,
  intel: 0,   maxIntel: 100,
  stress: 0,  maxStress: 100,
  social: 50, maxSocial: 100,
  darkIAIAccess: false,
  ogunProgress: 0,
  actionsLeft: 3,
  inCombat: false,
  currentBoss: null,
  heroHp: 80, heroMaxHp: 80,
  heroMp: 60, heroMaxMp: 60,
  shieldActive: false, shieldHp: 0,
  enemyHp: 0, enemyMaxHp: 0,
  stunned: false, enemyStunned: false,
  combatTurn: 0,
  logLines: [],
  cinIndex: 0,
  dlgIndex: 0,
  currentDialogue: [],
  currentBossId: null,
  endings: { a: false, b: false, c: false }
};

// ─── SCREEN MANAGEMENT ───────────────────────────────────────────────────────
function showScreen(id) {
  document.querySelectorAll('.screen').forEach(s => {
    s.classList.remove('active');
    s.style.display = 'none';
  });
  const el = document.getElementById('screen-' + id);
  if (el) {
    el.style.display = 'flex';
    requestAnimationFrame(() => {
      el.classList.add('active');
    });
  }
  STATE.screen = id;
}

// ─── TOAST ────────────────────────────────────────────────────────────────────
let toastTimeout = null;
function showToast(msg, warn = false) {
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.className = 'toast show' + (warn ? ' warn' : '');
  clearTimeout(toastTimeout);
  toastTimeout = setTimeout(() => t.classList.remove('show'), 3000);
}

// ─── TITLE SCREEN ─────────────────────────────────────────────────────────────
function initTitle() {
  document.getElementById('btn-new-game').onclick = () => showScreen('charselect');
  document.getElementById('btn-continue').onclick = () => {
    if (loadGame()) { resumeGame(); }
    else { showToast('Aucune sauvegarde trouvée !', true); }
  };
  document.getElementById('btn-about').onclick = () => {
    showToast('IA Survivors v0.1 — Fait avec 🤍 et trop de caféine. IAI Togo. OGUN-0 approche.');
  };
}

// ─── CHARACTER SELECT ─────────────────────────────────────────────────────────
function initCharSelect() {
  const grid = document.querySelector('.char-select-grid');
  grid.innerHTML = '';
  let selectedId = null;

  Object.values(CHARACTERS).forEach(ch => {
    const card = document.createElement('div');
    card.className = 'char-card';
    card.id = 'card-' + ch.id;
    card.innerHTML = `
      <span class="char-card-icon" style="color:${ch.color}">${ch.emoji}</span>
      <div class="char-card-name">${ch.name}</div>
      <div class="char-card-role">${ch.role}</div>
    `;
    card.onclick = () => {
      document.querySelectorAll('.char-card').forEach(c => c.classList.remove('selected'));
      card.classList.add('selected');
      selectedId = ch.id;
      showCharDetail(ch);
      document.getElementById('btn-confirm-char').disabled = false;
    };
    grid.appendChild(card);
  });

  document.getElementById('btn-back-title').onclick = () => showScreen('title');
  document.getElementById('btn-confirm-char').onclick = () => {
    if (!selectedId) return;
    STATE.hero = selectedId;
    const hero = CHARACTERS[selectedId];
    STATE.heroHp = hero.hp;
    STATE.heroMaxHp = hero.maxHp;
    STATE.heroMp = hero.mp;
    STATE.heroMaxMp = hero.maxMp;
    STATE.week = 0;
    startIntro();
  };
}

function showCharDetail(ch) {
  const detail = document.getElementById('char-detail');
  document.getElementById('char-portrait').innerHTML = `<span style="color:${ch.color}">${ch.emoji}</span>`;
  document.getElementById('char-name-big').textContent = ch.name;
  document.getElementById('char-bio').textContent = ch.bio;
  document.getElementById('char-skill').innerHTML = `<strong>${ch.skill.name}</strong><br>${ch.skill.desc}`;

  const statsEl = document.getElementById('char-stats');
  const statDefs = [
    { key: 'algo', label: 'ALGO', color: '#00ffe7' },
    { key: 'social', label: 'SOCIAL', color: '#39ff14' },
    { key: 'charisme', label: 'CHARM', color: '#ffd700' },
    { key: 'stress_resist', label: 'RES.', color: '#bf00ff' },
  ];
  statsEl.innerHTML = statDefs.map(s => `
    <div class="stat-item">
      <div class="stat-label">${s.label}</div>
      <div class="stat-bar"><div class="stat-fill" style="width:${ch.stats[s.key]}%;background:${s.color};box-shadow:0 0 6px ${s.color}"></div></div>
      <div class="stat-val">${ch.stats[s.key]}</div>
    </div>
  `).join('');
}

// ─── INTRO CINEMATIC ──────────────────────────────────────────────────────────
const INTRO_SLIDES = [
  { text: `<span class="highlight">LOMÉ, TOGO — ANNÉE SCOLAIRE 2027</span><br><br>L'Institut Africain d'Informatique. 200 étudiants entrent. Combien en sortiront ?`, },
  { text: `Fondé par le légendaire <span class="highlight">Professeur Ananzi</span>, hacktiviste, visionnaire, disparu.<br><br>Sa devise hante encore les couloirs : <em>"Le code est la magie moderne,<br>mais toute magie a un prix."</em>` },
  { text: `Dans les sous-sols oubliés de l'IAI sommeille <span class="warn">OGUN-0</span> — une intelligence artificielle primitive.<br><br>Débranchée il y a dix ans. Après un incident que personne ne nomme.` },
  { text: `Quatre amis. Un semestre. Une vérité qui va tout changer.<br><br><span class="highlight">Bienvenue à l'IAI. Semestre 1. Survivrez-vous ?</span>` },
];

function startIntro() {
  STATE.cinIndex = 0;
  showScreen('intro');
  renderCinSlide();
  document.getElementById('btn-next-cin').onclick = () => {
    STATE.cinIndex++;
    if (STATE.cinIndex >= INTRO_SLIDES.length) {
      startWeek(0);
    } else {
      renderCinSlide();
    }
  };
}

function renderCinSlide() {
  const slide = INTRO_SLIDES[STATE.cinIndex];
  const el = document.getElementById('cinematic-text');
  el.style.opacity = 0;
  setTimeout(() => {
    el.innerHTML = slide.text;
    el.style.transition = 'opacity 0.6s';
    el.style.opacity = 1;
  }, 200);
}

// ─── WEEK FLOW ────────────────────────────────────────────────────────────────
function startWeek(weekIndex) {
  const ev = WEEKLY_EVENTS[weekIndex];
  STATE.week = weekIndex;
  STATE.actionsLeft = 3;
  STATE.currentBossId = ev.boss;
  STATE.currentDialogue = ev.dialogue;
  STATE.dlgIndex = 0;
  startDialogue(ev.dialogue, () => showMap(weekIndex));
}

function resumeGame() {
  startWeek(STATE.week);
}

// ─── DIALOGUE SYSTEM ──────────────────────────────────────────────────────────
let dialogueCallback = null;

function startDialogue(lines, callback) {
  dialogueCallback = callback;
  STATE.dlgIndex = 0;
  STATE.currentDialogue = lines;
  showScreen('dialogue');
  renderDialogueLine();

  document.getElementById('btn-dlg-next').onclick = advanceDialogue;
}

function renderDialogueLine() {
  const line = STATE.currentDialogue[STATE.dlgIndex];
  if (!line) return;

  document.getElementById('dlg-speaker').textContent = line.speaker;
  const textEl = document.getElementById('dlg-text');
  textEl.textContent = '';
  typewriterEffect(textEl, line.text, 30);

  // Set chars
  const leftEl = document.getElementById('dlg-char-left');
  const rightEl = document.getElementById('dlg-char-right');
  leftEl.textContent = line.left || '';
  rightEl.textContent = line.right || '';

  const heroData = line.left ? CHARACTERS[getCharById(line.left)] : null;
  const heroColor = heroData ? heroData.aura : '#00ffe7';
  leftEl.style.color = heroColor;
  rightEl.style.color = '#ffd700';

  // Speaking indicator
  leftEl.classList.toggle('speaking', !!line.left && !line.right);
  rightEl.classList.toggle('speaking', !!line.right);
  leftEl.classList.toggle('silent', !!line.right && !!line.left);

  // BG
  document.getElementById('dialogue-bg').textContent = line.bg || '';

  // Choices
  const choicesEl = document.getElementById('dlg-choices');
  choicesEl.innerHTML = '';
  if (line.choices) {
    line.choices.forEach((c, i) => {
      const btn = document.createElement('button');
      btn.className = 'choice-btn';
      btn.textContent = c.text;
      btn.onclick = () => {
        if (c.effect) applyEffect(c.effect);
        if (c.goto != null) STATE.dlgIndex = c.goto - 1;
        advanceDialogue();
      };
      choicesEl.appendChild(btn);
    });
    document.getElementById('btn-dlg-next').style.display = 'none';
  } else {
    document.getElementById('btn-dlg-next').style.display = '';
  }
}

function getCharById(emoji) {
  return Object.keys(CHARACTERS).find(k => CHARACTERS[k].emoji === emoji);
}

function advanceDialogue() {
  STATE.dlgIndex++;
  if (STATE.dlgIndex >= STATE.currentDialogue.length) {
    if (dialogueCallback) dialogueCallback();
  } else {
    renderDialogueLine();
  }
}

function typewriterEffect(el, text, speed) {
  el.textContent = '';
  let i = 0;
  const interval = setInterval(() => {
    el.textContent += text[i] || '';
    i++;
    if (i >= text.length) clearInterval(interval);
  }, speed);
}

// ─── MAP SCREEN ───────────────────────────────────────────────────────────────
const MAP_LOCATIONS = [
  { id: 'amphi',    label: '🏛️ Amphi Ananzi',   x: '15%', y: '20%', action: 'study' },
  { id: 'labo',     label: '💻 Labo Systèmes',    x: '35%', y: '40%', action: 'hack' },
  { id: 'cafet',    label: '☕ Cafétéria',         x: '55%', y: '25%', action: 'social' },
  { id: 'biblio',   label: '📚 Bibliothèque',     x: '70%', y: '55%', action: 'study' },
  { id: 'resid',    label: '🏠 Résidence',        x: '20%', y: '65%', action: 'sleep' },
  { id: 'dark',     label: '🌑 Dark IAI [?]',    x: '80%', y: '75%', action: 'hack', locked: true },
  { id: 'combat',   label: '⚔️ AFFRONTER LE BOSS',x: '50%', y: '75%', action: 'combat', highlight: true },
];

function showMap(weekIndex) {
  showScreen('map');
  const ev = WEEKLY_EVENTS[weekIndex];
  updateHUD();

  document.getElementById('week-num').textContent = ev ? ev.title : 'Finale';

  // Draw campus map on canvas
  drawMapCanvas();

  // Location buttons
  const locContainer = document.getElementById('map-locations');
  locContainer.innerHTML = '';
  MAP_LOCATIONS.forEach(loc => {
    if (loc.locked && !STATE.darkIAIAccess) return;
    const btn = document.createElement('button');
    btn.className = 'map-location-btn';
    btn.style.left = loc.x;
    btn.style.top = loc.y;
    btn.style.transform = 'translate(-50%, -50%)';
    btn.textContent = loc.label;
    if (loc.highlight) {
      btn.style.borderColor = '#ff2a6d';
      btn.style.color = '#ff2a6d';
      btn.style.boxShadow = '0 0 20px rgba(255,42,109,0.6)';
      btn.style.animation = 'blink 1s step-end infinite';
    }
    btn.onclick = () => handleLocationClick(loc, weekIndex);
    locContainer.appendChild(btn);
  });

  // Day actions panel
  renderDayActions(ev);
}

function drawMapCanvas() {
  const canvas = document.getElementById('map-canvas');
  const ctx = canvas.getContext('2d');
  canvas.width = canvas.offsetWidth;
  canvas.height = canvas.offsetHeight;

  // Background gradient
  const grad = ctx.createRadialGradient(canvas.width/2, canvas.height/2, 50, canvas.width/2, canvas.height/2, canvas.width/2);
  grad.addColorStop(0, '#0d0d25');
  grad.addColorStop(1, '#050510');
  ctx.fillStyle = grad;
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  // Grid
  ctx.strokeStyle = 'rgba(0, 255, 231, 0.06)';
  ctx.lineWidth = 1;
  for (let x = 0; x < canvas.width; x += 40) { ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, canvas.height); ctx.stroke(); }
  for (let y = 0; y < canvas.height; y += 40) { ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(canvas.width, y); ctx.stroke(); }

  // Paths between locations
  ctx.strokeStyle = 'rgba(0, 255, 231, 0.2)';
  ctx.lineWidth = 2;
  ctx.setLineDash([8, 8]);
  const connections = [[0,1],[1,2],[2,3],[3,4],[4,5],[1,6],[2,6]];
  const locs = MAP_LOCATIONS.filter(l => !l.locked || STATE.darkIAIAccess);
  connections.forEach(([a, b]) => {
    const la = MAP_LOCATIONS[a], lb = MAP_LOCATIONS[b];
    if (!la || !lb) return;
    const ax = parseFloat(la.x) / 100 * canvas.width;
    const ay = parseFloat(la.y) / 100 * canvas.height;
    const bx = parseFloat(lb.x) / 100 * canvas.width;
    const by = parseFloat(lb.y) / 100 * canvas.height;
    ctx.beginPath(); ctx.moveTo(ax, ay); ctx.lineTo(bx, by); ctx.stroke();
  });
  ctx.setLineDash([]);

  // IAI Logo watermark
  ctx.font = 'bold 120px serif';
  ctx.fillStyle = 'rgba(0,255,231,0.03)';
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.fillText('🏫', canvas.width/2, canvas.height/2);
}

function handleLocationClick(loc, weekIndex) {
  if (STATE.actionsLeft <= 0) { showToast('Plus d\'actions disponibles ! Passez à la confrontation.', true); return; }

  if (loc.action === 'combat') {
    startCombat(weekIndex);
    return;
  }
  const ev = WEEKLY_EVENTS[weekIndex];
  const action = ev ? ev.actions.find(a => a.id === loc.action) : null;
  if (!action) { showToast('Action non disponible cette semaine.', true); return; }
  executeAction(action, weekIndex);
}

function renderDayActions(ev) {
  const panel = document.getElementById('day-actions');
  panel.innerHTML = `<span style="font-family:var(--pixel-font);font-size:0.45rem;color:var(--neon-gold)">ACTIONS RESTANTES: ${STATE.actionsLeft}/3</span>`;
  if (!ev) return;
  ev.actions.forEach(action => {
    const btn = document.createElement('button');
    btn.className = 'action-btn';
    const effectStr = Object.entries(action.effect).map(([k,v]) => `${v>0?'+':''}${v} ${k}`).join(', ');
    btn.innerHTML = `${action.label} <span class="cost-badge">[${effectStr}]</span>`;
    btn.title = action.desc;
    btn.onclick = () => executeAction(action, STATE.week);
    panel.appendChild(btn);
  });
  // Boss button
  const bossBtn = document.createElement('button');
  bossBtn.className = 'action-btn';
  bossBtn.style.borderColor = '#ff2a6d';
  bossBtn.style.color = '#ff2a6d';
  bossBtn.innerHTML = '⚔️ AFFRONTER LE BOSS';
  bossBtn.onclick = () => startCombat(STATE.week);
  panel.appendChild(bossBtn);
}

function applyEffect(effect) {
  if (effect.energy !== undefined) {
    STATE.energy = Math.max(0, Math.min(STATE.maxEnergy, STATE.energy + effect.energy));
  }
  if (effect.intel !== undefined) {
    STATE.intel = Math.max(0, Math.min(STATE.maxIntel, STATE.intel + effect.intel));
  }
  if (effect.stress !== undefined) {
    STATE.stress = Math.max(0, Math.min(STATE.maxStress, STATE.stress + effect.stress));
  }
  if (effect.social !== undefined) {
    STATE.social = Math.max(0, Math.min(STATE.maxSocial, STATE.social + effect.social));
  }
  updateHUD();
  checkGameState();
}

function executeAction(action, weekIndex) {
  if (STATE.actionsLeft <= 0) { showToast('Plus d\'actions !', true); return; }
  applyEffect(action.effect);
  STATE.actionsLeft--;
  if (action.unlock) STATE.darkIAIAccess = true;
  showToast(`✅ ${action.label} — ${action.desc}`);
  renderDayActions(WEEKLY_EVENTS[weekIndex]);
}

function updateHUD() {
  const hero = CHARACTERS[STATE.hero] || {};
  document.getElementById('hero-mini-hud').textContent = hero.emoji || '';
  setBar('bar-energy', 'val-energy', STATE.energy, STATE.maxEnergy);
  setBar('bar-intel',  'val-intel',  STATE.intel,  STATE.maxIntel);
  setBar('bar-stress', 'val-stress', STATE.stress, STATE.maxStress);
  setBar('bar-social', 'val-social', STATE.social, STATE.maxSocial);
}

function setBar(barId, valId, val, max) {
  const fill = document.getElementById(barId);
  const valEl = document.getElementById(valId);
  if (fill) fill.style.width = Math.max(0, (val/max)*100) + '%';
  if (valEl) valEl.textContent = Math.round(val);
}

function checkGameState() {
  if (STATE.stress >= STATE.maxStress) {
    showGameOver('Le stress t\'a consumé. Tu rejoins les Obsolètes.');
    return;
  }
  if (STATE.energy <= 0) {
    showGameOver('L\'épuisement total. Tu t\'effondres en plein couloir.');
    return;
  }
}

// ─── COMBAT SYSTEM ───────────────────────────────────────────────────────────
function startCombat(weekIndex) {
  const ev = WEEKLY_EVENTS[weekIndex];
  const bossId = ev.boss;
  const boss = BOSSES[bossId];
  STATE.currentBoss = { ...boss };
  STATE.enemyHp = boss.hp;
  STATE.enemyMaxHp = boss.maxHp;
  STATE.stunned = false;
  STATE.enemyStunned = false;
  STATE.shieldActive = false;
  STATE.shieldHp = 0;
  STATE.combatTurn = 0;
  STATE.logLines = [];
  STATE.inCombat = true;

  // Reset hero HP/MP
  const hero = CHARACTERS[STATE.hero];
  STATE.heroHp = hero.hp;
  STATE.heroMp = hero.mp;

  showScreen('combat');
  renderCombat();
  addLog(`📢 ${boss.intro}`, 'system');
  addLog(`🎭 Boss: ${boss.name} — HP: ${boss.maxHp}`, 'system');

  document.getElementById('btn-attack').onclick = () => playerAttack();
  document.getElementById('btn-special').onclick = () => playerSpecial();
  document.getElementById('btn-item').onclick = () => playerItem();
  document.getElementById('btn-defend').onclick = () => playerDefend();
}

function renderCombat() {
  const boss = STATE.currentBoss;
  const hero = CHARACTERS[STATE.hero];

  document.getElementById('enemy-name').textContent = boss.name;
  document.getElementById('enemy-sprite').textContent = boss.emoji;
  document.getElementById('enemy-sprite').style.color = boss.color;
  document.getElementById('enemy-sprite').style.filter = `drop-shadow(0 0 24px ${boss.color})`;

  updateEnemyBar();
  updateHeroCombat();

  // Ally row — the other 3 chars
  const allyRow = document.getElementById('ally-row');
  allyRow.innerHTML = Object.values(CHARACTERS)
    .filter(c => c.id !== STATE.hero)
    .map(c => `<div class="ally-mini" style="color:${c.color}">${c.emoji}<span>${c.name}</span></div>`)
    .join('');

  document.getElementById('hero-name-combat').textContent = hero.name;
  document.getElementById('hero-sprite-combat').textContent = hero.emoji;
  document.getElementById('hero-sprite-combat').style.color = hero.color;
}

function updateEnemyBar() {
  const pct = Math.max(0, STATE.enemyHp / STATE.enemyMaxHp * 100);
  document.getElementById('enemy-hp-fill').style.width = pct + '%';
  document.getElementById('enemy-hp-val').textContent = `${Math.max(0, STATE.enemyHp)}/${STATE.enemyMaxHp}`;
}

function updateHeroCombat() {
  const hero = CHARACTERS[STATE.hero];
  setBar('hero-hp-fill', 'hero-hp-val', STATE.heroHp, hero.maxHp);
  setBar('hero-mp-fill', 'hero-mp-val', STATE.heroMp, hero.maxMp);
  document.getElementById('hero-hp-val').textContent = `${Math.max(0,STATE.heroHp)}/${hero.maxHp}`;
  document.getElementById('hero-mp-val').textContent = `${Math.max(0,STATE.heroMp)}/${hero.maxMp}`;
}

function addLog(msg, type = '') {
  STATE.logLines.push({ msg, type });
  const log = document.getElementById('combat-log');
  const entry = document.createElement('div');
  entry.className = 'log-entry ' + type;
  entry.textContent = msg;
  log.appendChild(entry);
  log.scrollTop = log.scrollHeight;
}

function playerAttack() {
  if (!STATE.inCombat) return;
  const hero = CHARACTERS[STATE.hero];
  const dmg = Math.floor(hero.attack * (0.8 + Math.random() * 0.4));
  dealDamageToEnemy(dmg, `⚔️ ${hero.name} attaque — ${dmg} dégâts!`);
  setTimeout(() => enemyTurn(), 800);
}

function playerSpecial() {
  if (!STATE.inCombat) return;
  const hero = CHARACTERS[STATE.hero];
  if (STATE.heroMp < hero.skill.cost) {
    showToast('Pas assez de MP !', true);
    return;
  }
  STATE.heroMp -= hero.skill.cost;
  updateHeroCombat();

  if (hero.skill.type === 'minigame') {
    launchMinigame(() => {
      const dmg = Math.floor(hero.attack * 2.2);
      dealDamageToEnemy(dmg, `✨ Overclock Cérébral — CRITIQUE: ${dmg} dégâts!`);
      setTimeout(() => enemyTurn(), 800);
    }, () => {
      addLog('❌ Overclock raté — action normale.', 'system');
      const dmg = Math.floor(hero.attack * 0.8);
      dealDamageToEnemy(dmg, `⚔️ Attaque de secours — ${dmg} dégâts.`);
      setTimeout(() => enemyTurn(), 800);
    });
  } else if (hero.skill.type === 'aoe_stun') {
    STATE.enemyStunned = true;
    addLog(`🎵 Bass Drop — L'ennemi est stunné pour 1 tour!`, 'player-action');
    const dmg = Math.floor(hero.attack * 1.5);
    dealDamageToEnemy(dmg, `🎵 Bass Drop — ${dmg} dégâts + STUN!`);
    setTimeout(() => enemyTurn(), 800);
  } else if (hero.skill.type === 'shield_fury') {
    STATE.shieldActive = true;
    STATE.shieldHp = 40;
    addLog(`👊 Void Shell invoqué — Bouclier de 40 HP!`, 'player-action');
    setTimeout(() => enemyTurn(), 800);
  } else if (hero.skill.type === 'buff_detect') {
    const boss = STATE.currentBoss;
    addLog(`📚 Pare-feu Mental — Faiblesse détectée: ${boss.weakTo}!`, 'system');
    addLog(`🛡️ Immunité aux altérations activée pour 3 tours.`, 'player-action');
    const dmg = Math.floor(hero.attack * 1.2);
    dealDamageToEnemy(dmg, `📚 Contre-mesure logique — ${dmg} dégâts.`);
    setTimeout(() => enemyTurn(), 800);
  }
}

function playerItem() {
  if (!STATE.inCombat) return;
  const restore = 25;
  STATE.heroHp = Math.min(CHARACTERS[STATE.hero].maxHp, STATE.heroHp + restore);
  STATE.heroMp = Math.min(CHARACTERS[STATE.hero].maxMp, STATE.heroMp + 15);
  updateHeroCombat();
  addLog(`🎒 Énergie + ${restore} HP, +15 MP. (Café + barre de céréales)`, 'system');
  setTimeout(() => enemyTurn(), 600);
}

function playerDefend() {
  if (!STATE.inCombat) return;
  STATE.shieldActive = true;
  STATE.shieldHp = 25;
  addLog(`🛡️ Défense! Bouclier temporaire (25 HP).`, 'player-action');
  setTimeout(() => enemyTurn(), 600);
}

function dealDamageToEnemy(dmg, logMsg) {
  STATE.enemyHp -= dmg;
  addLog(logMsg, 'player-action');
  updateEnemyBar();
  animateDmg(dmg, true);
  if (STATE.enemyHp <= 0) {
    STATE.enemyHp = 0;
    updateEnemyBar();
    combatVictory();
  }
}

function enemyTurn() {
  if (!STATE.inCombat) return;
  if (STATE.enemyHp <= 0) return;

  if (STATE.enemyStunned) {
    STATE.enemyStunned = false;
    addLog(`🎵 L'ennemi est étourdi et ne peut pas agir!`, 'system');
    return;
  }

  const boss = STATE.currentBoss;
  const atkIdx = Math.floor(Math.random() * boss.attacks.length);
  const atk = boss.attacks[atkIdx];
  addLog(`💥 ${boss.name}: ${atk.name}!`, 'enemy-action');

  if (atk.stun) {
    addLog(`😵 Vous êtes paralysé! Tour sauté.`, 'enemy-action');
    return;
  }

  let dmg = atk.dmg;
  const hero = CHARACTERS[STATE.hero];

  // Apply defense
  dmg = Math.max(1, dmg - Math.floor(hero.defense * 0.4));

  // Shield absorb
  if (STATE.shieldActive) {
    if (STATE.shieldHp >= dmg) {
      STATE.shieldHp -= dmg;
      addLog(`🛡️ Bouclier absorbe ${dmg} dégâts. (${STATE.shieldHp} HP restants)`, 'system');
      dmg = 0;
    } else {
      dmg -= STATE.shieldHp;
      STATE.shieldHp = 0;
      STATE.shieldActive = false;
      addLog(`🛡️ Bouclier brisé!`, 'system');
    }
  }

  if (atk.drain) {
    STATE.heroMp = Math.max(0, STATE.heroMp - 10);
    updateHeroCombat();
  }

  if (dmg > 0) {
    STATE.heroHp = Math.max(0, STATE.heroHp - dmg);
    addLog(`${atk.msg} — ${dmg} dégâts!`, 'enemy-action');
    animateDmg(dmg, false);
    updateHeroCombat();
  }

  if (STATE.heroHp <= 0) {
    combatDefeat();
  }
}

function animateDmg(val, onEnemy) {
  const area = document.getElementById(onEnemy ? 'enemy-sprite-area' : 'hero-sprite-combat');
  const el = document.createElement('div');
  el.className = 'dmg-float';
  el.textContent = (onEnemy ? '-' : '-') + val;
  el.style.color = onEnemy ? '#ff2a6d' : '#ff8c00';
  el.style.left = (30 + Math.random() * 40) + '%';
  el.style.top = '20%';
  area.style.position = 'relative';
  area.appendChild(el);
  setTimeout(() => el.remove(), 1000);
}

function combatVictory() {
  STATE.inCombat = false;
  const boss = STATE.currentBoss;
  addLog(`🏆 VICTOIRE! ${boss.name} est vaincu!`, 'system');
  addLog(`💡 ${boss.lore}`, 'system');
  STATE.intel = Math.min(100, STATE.intel + 20);
  STATE.ogunProgress++;
  updateHeroCombat();
  setTimeout(() => {
    // advance to next week or end
    const nextWeekIdx = STATE.week + 1;
    if (nextWeekIdx >= WEEKLY_EVENTS.length) {
      showWin();
    } else {
      showToast(`✅ Semaine terminée! ${WEEKLY_EVENTS[nextWeekIdx].title} commence...`);
      setTimeout(() => startWeek(nextWeekIdx), 2000);
    }
  }, 1500);
}

function combatDefeat() {
  STATE.inCombat = false;
  addLog(`💀 Défaite... Tu as tout donné.`, 'enemy-action');
  setTimeout(() => showGameOver(`${STATE.currentBoss.name} t'a écrasé. Mais les Obsolètes ne gagnent pas toujours.`), 1500);
}

// ─── MINI-GAME (Overclock Cérébral) ──────────────────────────────────────────
let minigameSuccessCallback = null;
let minigameFailCallback = null;

function launchMinigame(onSuccess, onFail) {
  const boss = STATE.currentBoss;
  if (!boss.minigame) { onSuccess(); return; }
  const mg = boss.minigame;
  minigameSuccessCallback = onSuccess;
  minigameFailCallback = onFail;

  const overlay = document.getElementById('minigame-overlay');
  const box = document.getElementById('minigame-box');
  overlay.style.display = 'flex';

  let timeLeft = 10;
  box.innerHTML = `
    <div class="minigame-title">${mg.title}</div>
    <div class="minigame-timer" id="mg-timer">⏱ ${timeLeft}s</div>
    <div class="minigame-prompt">${mg.question.replace(/\n/g, '<br>')}</div>
    <div class="minigame-choices" id="mg-choices"></div>
  `;

  const choicesEl = box.querySelector('#mg-choices');
  mg.choices.forEach((ch, i) => {
    const btn = document.createElement('button');
    btn.className = 'mg-choice';
    btn.textContent = ch;
    btn.onclick = () => resolveMinigame(i === mg.correct, btn, i, mg.correct, overlay);
    choicesEl.appendChild(btn);
  });

  const timerInterval = setInterval(() => {
    timeLeft--;
    const timerEl = box.querySelector('#mg-timer');
    if (timerEl) timerEl.textContent = `⏱ ${timeLeft}s`;
    if (timeLeft <= 0) {
      clearInterval(timerInterval);
      overlay.style.display = 'none';
      if (minigameFailCallback) minigameFailCallback();
    }
  }, 1000);

  overlay._timer = timerInterval;
}

function resolveMinigame(correct, btn, chosen, correctIdx, overlay) {
  clearInterval(overlay._timer);
  const allBtns = overlay.querySelectorAll('.mg-choice');
  allBtns.forEach((b, i) => {
    b.disabled = true;
    if (i === correctIdx) b.classList.add('correct');
    else if (i === chosen && !correct) b.classList.add('wrong');
  });
  setTimeout(() => {
    overlay.style.display = 'none';
    if (correct && minigameSuccessCallback) minigameSuccessCallback();
    else if (!correct && minigameFailCallback) minigameFailCallback();
  }, 1000);
}

// ─── GAME OVER / WIN ──────────────────────────────────────────────────────────
function showGameOver(msg) {
  showScreen('gameover');
  document.getElementById('gameover-msg').textContent = msg;
  document.getElementById('btn-retry').onclick = () => startWeek(STATE.week);
  document.getElementById('btn-menu-go').onclick = () => showScreen('title');
}

function showWin() {
  showScreen('win');
  document.getElementById('win-msg').textContent = `${CHARACTERS[STATE.hero].emoji} ${CHARACTERS[STATE.hero].name} a survécu au Semestre 1 !`;
  document.getElementById('win-stats').innerHTML = `
    Intelligence finale : ${STATE.intel}/100<br>
    Social : ${STATE.social}/100<br>
    Stress : ${STATE.stress}/100<br>
    OGUN-0 Défaite : ${STATE.ogunProgress >= 4 ? '✅ OUI' : '❌ PARTIEL'}<br>
    Dark IAI débloqué : ${STATE.darkIAIAccess ? '✅' : '❌'}
  `;
  document.getElementById('btn-end').onclick = () => showScreen('title');
}

// ─── SAVE / LOAD ──────────────────────────────────────────────────────────────
function saveGame() {
  try {
    localStorage.setItem('ia_survivors_save', JSON.stringify({
      hero: STATE.hero, week: STATE.week,
      energy: STATE.energy, intel: STATE.intel,
      stress: STATE.stress, social: STATE.social,
      darkIAIAccess: STATE.darkIAIAccess, ogunProgress: STATE.ogunProgress
    }));
    showToast('💾 Sauvegardé !');
  } catch(e) { showToast('Erreur de sauvegarde.', true); }
}

function loadGame() {
  try {
    const raw = localStorage.getItem('ia_survivors_save');
    if (!raw) return false;
    const data = JSON.parse(raw);
    Object.assign(STATE, data);
    return true;
  } catch(e) { return false; }
}

// ─── KEYBOARD SHORTCUTS ───────────────────────────────────────────────────────
document.addEventListener('keydown', (e) => {
  if (e.key === 'Escape' && STATE.screen === 'dialogue') {
    advanceDialogue();
  }
  if (e.key === 'Enter' && STATE.screen === 'title') {
    showScreen('charselect');
  }
  if (e.key === 's' && STATE.screen === 'map') {
    saveGame();
  }
});

// ─── BOOT ─────────────────────────────────────────────────────────────────────
window.addEventListener('load', () => {
  showScreen('title');
  initTitle();
  initCharSelect();

  // Prevent context menu on long press (mobile)
  document.addEventListener('contextmenu', e => e.preventDefault());
});
