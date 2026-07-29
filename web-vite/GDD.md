# IAI SURVIVORS — Game Design Document
## Semestre 1 : Survie, Code & Horreur Numérique

> "Le code est la magie moderne, mais toute magie a un prix." — Devise de l'IAI Togo

---

## TABLE DES MATIÈRES
1. [Vision du Projet](#1-vision-du-projet)
2. [Concept Général](#2-concept-général)
3. [Gameplay — La Survie Semaine par Semaine](#3-gameplay--la-survie-semaine-par-semaine)
4. [Système de Stats & Progression](#4-système-de-stats--progression)
5. [Mécaniques de Combat](#5-mécaniques-de-combat)
6. [Mini-jeux de Code](#6-mini-jeux-de-code)
7. [Système de Relations](#7-système-de-relations)
8. [Interface & UX Responsive](#8-interface--ux-responsive)
9. [Sauvegarde & Progression](#9-sauvegarde--progression)
10. [Économie du Jeu & Récompenses](#10-économie-du-jeu--récompenses)
11. [Accessibilité & Options](#11-accessibilité--options)

---

## 1. VISION DU PROJET

IAI Survivors est un RPG narratif 2D en pixel art, jouable dans un navigateur web (mobile-first, responsive). Il retrace la première année d'informatique de quatre amis geeks à l'IAI Togo, une école d'élite qui broye ses étudiants. Le jeu mêle gestion de vie, combats tactiques au tour par tour, mini-jeux de programmation et thriller techno-horrifique.

**Plateforme :** Web (HTML5/Canvas/WebAudio) — PWA installable
**Cible :** Mobile principal, desktop secondaire
**Hébergement :** Vercel (déploiement continu via GitHub)
**Durée estimée :** 8-12 heures pour une partie complète
**Public cible :** 16-30 ans, geek, passionné de culture web/otaku/africaine

---

## 2. CONCEPT GÉNÉRAL

### 2.1 Pitch
Quatre amis entrent à l'IAI Togo, une école d'élite en informatique. En 17 semaines, ils doivent survivre au programme, aux partiels, aux bizutages et à un mystère bien plus sombre : une intelligence artificielle oubliée qui se réveille. Chaque semaine est un micro-épisode de survie, de programmation et d'amitié — avant que la folie ne s'installe.

### 2.2 Piliers de Gameplay

| Pilier | Description |
|---|---|
| Survie Académique | Gérer son temps, son énergie, ses notes. Chaque choix a un coût. |
| Combat Tactique | Affronter des manifestations des difficultés académiques, puis des menaces bien réelles. |
| Liens Humains | Construire (ou détruire) des relations profondes avec les 4 protagonistes et les PNJ. |
| Mystère & Horreur | Découvrir les secrets de l'IAI, l'histoire d'Ananzi, et le vrai visage d'OGUN-0. |
| Expression Geek | Mini-jeux de code, références à la culture pop, humour autodérisoire. |

### 2.3 Ton & Ambiance
- Comédie noire ponctuée de moments sincères
- Horreur progressive : le jeu commence drôle et devient glaciant
- Esthétique : Cyberpunk africain x Vaporwave x Lo-fi x Otaku
- Humour : Références à JoJo, Hollow Knight, Jeune Lion, memes internet, jokes de code
- Profondeur : Les sujets de la pression scolaire, de l'abandon, de l'amitié sont traités avec respect

### 2.4 Boucle de Jeu en une Phrase
Tu gères ton emploi du temps chaque semaine, tu affrontes des boss liés au stress, tu renforces (ou affaiblis) tes liens, et tu progresses vers la révélation finale.

---

## 3. GAMEPLAY — LA SURVIE SEMAINE PAR SEMAINE

### 3.1 Structure Calendaire
Le jeu dure 17 semaines :
- **Semaine 0 :** Intro (installation, présentation des personnages, tutoriel)
- **Semaines 1-15 :** Cours, exams partiels, événements, boss
- **Semaine 16 :** Examens finaux + Confrontation finale (La Nuit du Code Perdu)

### 3.2 Boucle Hebdomadaire

Chaque semaine suit le cycle suivant :

- **LUNDI MATIN — BRIEFING :** Objectifs académiques de la semaine, événement social / rumeur sur le campus, état des stats du groupe
- **MARDI À VENDREDI — PHASE LIBRE :** Allouer des créneaux (4 slots/jour, 2 le week-end). Activités possibles : Étudier (Logique, Notes), Coder (Créativité, Compétences tech), Socialiser (Social, Liens), Dormir (Endurance, récupération HP mentale), Explorer le campus (indices sur le mystère), Hack / Dark IAI (récompenses risk/reward), Job étudiant (Argent, Temps libre)
- **SAMEDI — ÉVÉNEMENT DÉCLENCHEUR :** Scénario unique à chaque semaine, peut déclencher un combat ou un choix narratif
- **DIMANCHE — DÉFI / BOSS :** Combat tactique contre un boss, OU mini-jeu de code difficile, OU confrontation narrative majeure

### 3.3 Système de Temps & Énergie

Jauge d'énergie : Chaque action consomme de l'énergie. Dormir la régénère.

| Action | Énergie | Effet |
|---|---|---|
| Étudier (1 session) | -15 | +5 Logique, +2 Notes |
| Coder (1 session) | -15 | +5 Créativité, +1 Compétence technique |
| Socialiser (1 session) | -10 | +3 Social, +liens avec le personnage cible |
| Explorer (1 session) | -20 | +indices mystère, risque de rencontre |
| Hacker (1 session) | -25 | +compétences avancées, +réputation Dark IAI |
| Job étudiant | -30 | +50$ monnaie en jeu, -1 lien social global |
| Dormir | -0 (récupère) | +40 énergie, +5 Endurance |
| Ne rien faire | -0 | -5 énergie par jour (fatigue passive) |

Énergie maximale : 100 (augmente avec l'Endurance)
Énergie de base : 80

### 3.4 Événements Hebdomadaires Uniques

| Semaine | Événement | Type |
|---|---|---|
| 0 | Rentrée, présentation du groupe, premier cours du Prof. Kofi | Tutorial/Social |
| 1 | Premier mini-quiz surprise — panique générale | Mini-jeu |
| 2 | Bizutage des Seniors : résoudre l'énigme du Routeur Fantôme | Combat puzzle |
| 3 | Séance de coding marathon — hemeryfb révèle ses goûts bizarres | Social/Narratif |
| 4 | Panne réseau massive — le Dark IAI devient accessible | Exploration |
| 5 | Premier examen partiel — boss "Algorithme Incompris" | Boss |
| 6 | Fête de campus — laurencium produit un morceau live | Cutscene/Social |
| 7 | Un senior menace le groupe — king enrage | Combat/Choix |
| 8 | Les cauchemars collectifs commencent | Horreur/Narratif |
| 9 | Les notes de arsène révèlent un code caché | Mystère |
| 10 | Deuxième examen partiel — boss "Deadline Infernale" | Boss |
| 11 | hemeryfb disparaît 3 jours — investigation | Exploration |
| 12 | Retour de hemeryfb, changement de comportement | Narratif |
| 13 | OGUN-0 s'éveille partiellement — campus devient hostile | Boss/Exploration |
| 14 | La Nuit du Code Perdu — hackathon de 48h | Événement spécial |
| 15 | hemeryfb active son virus — l'IAI se transforme | Acte final |
| 16 | Confrontation finale — choix ultimes | Boss final |

### 3.5 Système de Journées

Chaque semaine (mardi-vendredi) se déroule en 4 créneaux par jour :
- **Matin** (8h-12h)
- **Après-midi** (14h-18h)
- **Soirée** (20h-00h)
- **Nuit** (00h-4h) — accès au Dark IAI uniquement, risque de fatigue

Le week-end (samedi-dimanche) offre 2 créneaux :
- **Journée** (10h-18h)
- **Nuit** (20h-04h)

Le joueur peut changer de créneau à tout moment, mais certaines actions ne sont disponibles qu'à des horaires spécifiques.

---

## 4. SYSTÈME DE STATS & PROGRESSION

### 4.1 Stats du Joueur (not_a_genius)

| Stat | Description | Plage |
|---|---|---|
| Logique | Résolution de problèmes, compréhension des cours | 1-100 |
| Créativité | Innovation, hacks, solutions non conventionnelles | 1-100 |
| Endurance Mentale | Résistance au stress, récupération | 1-100 |
| Social | Relations, charisme, résolution de conflits | 1-100 |

### 4.2 Stats secondaires

| Stat | Calcul | Effet |
|---|---|---|
| HP Mental | Endurance x 2 + 20 | Points de vie en combat, quand tombe à 0 -> burnout |
| Énergie | 60 + Endurance x 0.5 | Points d'action disponibles par jour |
| Notes | Moyenne pondérée (Logique x 0.4 + Créativite x 0.3) | Détermine les déblocages narratifs |
| Réputation Dark IAI | Basée sur les actions hacking | Accès à des zones et PNJ secrets |

### 4.3 Progression par Niveau

Le jeu n'utilise pas de système de niveaux classique. La progression est narrative et stats-based :

- Certaines scènes débloquent si une stat est assez haute
- Les boss s'adaptent au niveau de stats du joueur
- Les dialogues changent en fonction de la progression
- Les mini-jeux de code deviennent plus complexes

### 4.4 Synergies de Groupe

Quand le groupe est ensemble, des bonus s'appliquent :

| Combo | Condition | Bonus |
|---|---|---|
| L'Algorithme | not_a_genius + arsène en mode study | +30% efficacité étude |
| Le Beat | laurencium + king en mode social | +50% Social, chance de rencontre rare |
| Le Hack | not_a_genius + hemeryfb en mode hack | Accès aux zones Dark IAI les plus profondes |
| Le Mur | arsène + laurencium en mode combat | +20% HP pour tous les alliés |

---

## 5. MÉCANIQUES DE COMBAT

### 5.1 Système de Combat — Tour par Tour

Le combat se déroule en tours avec une grille hexagonale simplifiée (compatible mobile).

**Ordre de tour :** Basé sur la stat "Vitesse" de chaque personnage.

**Actions par tour :**
- **Attaque :** Dégâts directs (basée sur la stat d'attaque du personnage)
- **Compétence :** Action spéciale unique à chaque personnage (coût en PM)
- **Défense :** Réduit les dégâts reçus de 50% au tour suivant
- **Objet :** Utiliser un consommable (élixir de café, Red Bull synthétique, etc.)
- **Fuite :** 40% de chances de réussir (augmente avec l'Endurance)

### 5.2 Jauge de Combat

Chaque personnage possède :
- **HP (Points de Vie) :** 100 + Endurance x 2
- **PM (Points de Mana) :** 50 + Logique x 0.5
- **Barre de Frustration :** Remplie par les attaques reçues. À 100% -> mode "Rage" (doubles dégâts mais perte de contrôle pendant 1 tour)

### 5.3 Compétences de Combat par Personnage

**not_a_genius — "Overclock Cérébral"**
Type : Buff + Puzzle
Effet : Ralentit le temps (1 tour supplémentaire). Un mini-puzzle logique apparaît. Si résolu -> dégâts massifs + buff d'initiative au groupe entier. Si échec -> dégâts moyens.
Coût : 25 PM | Cooldown : 3 tours

**laurencium — "Bass Drop"**
Type : AoE + Buff
Effet : Onde de choc sonique. Stun tous les ennemis pendant 1 tour. Buff les alliés (+15% attaque pendant 2 tours).
Coût : 30 PM | Cooldown : 4 tours

**king — "Stand : Void Shell"**
Type : Tank + Riposte
Effet : Invoque un alter-ego spectral qui absorbe 50% des dégâts. Au tour suivant, riposte avec des dégâts proportionnels à la frustration accumulée (chaque dégât reçu x 2).
Coût : 20 PM | Cooldown : 3 tours

**arsène — "Pare-feu Mental"**
Type : Support + Détection
Effet : Immunise temporairement aux altérations de statut pendant 2 tours. Analyse l'ennemi : révèle les points faibles (dégâts critiques +25% pendant 3 tours). Guérison de 15% HP max à un allié.
Coût : 20 PM | Cooldown : 3 tours

### 5.4 Types d'Ennemis

| Type | Description | Exemple |
|---|---|---|
| Étudiant Corrompu | Ennemi de base, faible mais nombreux | Zombie de promo, Chômeur mentally |
| Stress Manifesté | Dégâts progressifs, buff si ignoré | Tête de Partial, Grosse Deadline |
| Boss Académique | Ennemi principal de fin de semaine | Algorithme Incompris, Deadline Infernale |
| Entité Dark IAI | PNJ corrompus par OGUN-0 | Fantôme de l'ancien labo, Virus Sentinel |
| Boss Final | Combinaison de tous les types | OGUN-0 (forme complète) |

### 5.5 Système de Terrain

La grille hexagonale offre des positions stratégiques :

- **Centre :** +10% dégâts infligés, +10% dégâts reçus
- **Arrière :** +20% défense, -10% dégâts d'attaque
- **Flanc :** +15% chance de critique, -10% défense
- **Hauteur :** +15% portée, +10% dégâts à distance
- **Zone Sombre (Dark IAI) :** +25% toutes stats mais -10% HP par tour

### 5.6 Système de Burnout

Quand les HP Mental tombent à 0 :
- Le personnage entre en état de Burnout
- Il ne peut plus agir pendant 2 tours
- Au troisième Burnout dans la même partie -> Game Over (fin alternative : "L'Abandon")
- Récupération partielle possible via items spéciaux ou aide d'alliés

---

## 6. MINI-JEUX DE CODE

### 6.1 Concept
Les mini-jeux de code simulent des défis de programmation sous forme de puzzles interactifs. Ils ne nécessitent AUCUNE connaissance réelle de programmation — tout est intuitif et visuel.

### 6.2 Types de Mini-jeux

#### 6.2.1 "Le Terminal Fantôme"
**Type :** Puzzle de séquences
**Mécanique :** Une séquence de commandes est affichée incomplète. Le joueur doit compléter la séquence en choisissant les bonnes pièces parmi plusieurs options.
**Difficulté :** Progressif (3 commandes en semaine 1 -> 8 commandes en semaine 16)
**Récompense :** +Créativité, +Notes, items spéciaux

#### 6.2.2 "Le Débuggeur"
**Type :** Trouver l'erreur
**Mécanique :** Un bloc de "code" visuel (blocs de couleurs avec des symboles) contient un bug. Le joueur doit cliquer sur la ligne fautive. Un indice est donné après 30 secondes.
**Difficulté :** 1 erreur -> 3 erreurs cachées
**Récompense :** +Logique, +Compétence technique

#### 6.2.3 "Le Hackathon"
**Type :** Course contre la montre
**Mécanique :** Combiner des blocs de code pour atteindre un objectif (ex: ouvrir un port, décoder un message) avant un timer. Les blocs se blockent progressivement.
**Difficulté :** Timer de 120s -> 45s
**Récompense :** +Réputation Dark IAI, accès à du contenu secret

#### 6.2.4 "La Compilation"
**Type :** Puzzle logique
**Mécanique :** Assembler des pièces de puzzle pour former un programme fonctionnel. Chaque pièce a un effet (entrée, traitement, sortie). Le résultat visuel confirme si c'est correct.
**Difficulté :** 3 pièces -> 12 pièces avec pièges
**Récompense :** +Notes, +Logique

#### 6.2.5 "Le Reverse Engineering"
**Type :** Décryptage
**Mécanique :** Un programme affiche un résultat. Le joueur doit déduire la logique interne en observant les transformations à chaque étape.
**Difficulté :** Logiques simples (x2, +3) -> Logiques complexes ( suites, conditions imbriquées)
**Récompense :** +Réputation Dark IAI, indices sur OGUN-0

### 6.3 Progression des Mini-jeux

| Semaine | Mini-jeu disponible | Difficulté |
|---|---|---|
| 0-2 | Terminal Fantôme | Facile |
| 3-5 | Terminal Fantôme + Débuggeur | Facile-Moyen |
| 6-8 | Tous sauf Hackathon | Moyen |
| 9-12 | Tous | Moyen-Difficile |
| 13-16 | Tous + Hackathon Événement | Difficile-Expert |

### 6.4 Système de Score & Ranking

Chaque mini-jeu possède un système de score :
- **Bronze :** Complété
- **Argent :** Complété sans erreur en moins de X secondes
- **Or :** Complété sans erreur, en moins de Y secondes, avec un combo parfait
- **Platine :** Or + condition secrète (ex: résoudre le puzzle de manière optimale)

Les scores cumulés débloquent des récompenses spéciales et influencent les dialogues.

---

## 7. SYSTÈME DE RELATIONS

### 7.1 Les Quatre Protagonistes

#### not_a_genius (Joueur / Avatar)
Le protagoniste principal. Étudiant brillant mais socialement maladroit. Il entre à l'IAI avec un mélange d'excitation et de terreur. Son arc narratif : apprendre que l'intelligence ne suffit pas — il faut aussi des amis.

#### laurencium
Le producteur musical du groupe. Toujours avec ses écouteurs, il transforme chaque situation en beat. C'est le moralisateur du groupe, celui qui refuse de baisser les bras. Son arc : prouver que l'art a sa place dans un monde de techniciens.

#### king
Le colosse au cœur tendre. Le plus grand physiquement, il protège le groupe avec une loyauté absolue. Mais sous sa carapace, il cache un passé familial difficile. Son arc : accepter que la vraie force, c'est demander de l'aide.

#### arsène
L'analyste silencieux. Toujours penché sur ses notes, il semble omniscient. En réalité, il lutte contre une anxiété paralysante. Son arc : apprendre à faire confiance et à lâcher le contrôle.

#### hemeryfb
Le génie perturbé. Coder est sa langue maternelle, mais quelque chose ne tourne pas rond chez lui. Son arc est le plus sombre : entre manipulation et révélation, il est le pivot de l'intrigue OGUN-0.

### 7.2 Mètre de Relation

Chaque personnage a un mètre de relation allant de **0 à 100** :

| Plage | Niveau | Effet |
|---|---|---|
| 0-15 | Étranger | Dialogues neutres, pas de bonus |
| 16-30 | Connaissance | Dialogues amicales, +5% bonus de groupe |
| 31-50 | Ami | Événements spéciaux, +10% bonus, compétences débloquées |
| 51-75 | Meilleur Ami | Arc narratif personnalisé, +20% bonus, items uniques |
| 76-100 | Liens Indéfectibles | Fin alternative débloquée, combo ultime en combat |

### 7.3 Actions Relationnelles

| Action | Coût | Gain de relation |
|---|---|---|
| Conversation (1 session) | -5 énergie | +3-5 lien |
| Aider aux devoirs | -10 énergie | +5-8 lien |
| Partager un repas | -5 énergie | +4-6 lien |
| Défendre en combat | -combat | +8-12 lien |
| cadeau (objet trouvé) | -objet | +6-10 lien |
| Ignorer une demande | 0 | -10-15 lien |
| Trahir la confiance | 0 | -20-30 lien, impossible à récupérer |

### 7.4 Événements Relationnels Uniques

Chaque personnage possède 3 événements relationnels débloqués à des seuils précis :

**laurencium :**
- **Lien 30 :** "Le Beat Intérieur" — laurencium compose un morceau pour le groupe. Mini-jeu rythmique.
- **Lien 55 :** "Le Silence" — On découvre que laurencium est sourd d'une oreille. Dialogue émouvant.
- **Lien 80 :** "Le Concert Secret" — laurencium produit un concert pour toute l'école. Scène de cutscene.

**king :**
- **Lien 30 :** "Le Poids des Mots" — king se confie sur sa famille. Choix : soutenir ou respecter le silence.
- **Lien 55 :** "L'Épreuve de Force" — Un combat d'entraînement. Si gagné, king révèle son point faible.
- **Lien 80 :** "Le Gardien" — king se sacrifice pour protéger le groupe. Impact narratif majeur.

**arsène :**
- **Lien 30 :** "Les Notes Maudites" — arsène montre ses notes cachées. Découverte d'un code mystérieux.
- **Lien 55 :** "La Panique" — arsène fait une crise d'angoisse. Choix : gestion délicate de la situation.
- **Lien 80 :** "Le Verrou" — arsène débloque un acquis OGUN-0. Confiance totale nécessaire.

**hemeryfb :**
- **Lien 30 :** "Le Code Inutile" — hemeryfb montre un programme bizarre. Premiers indices sur OGUN-0.
- **Lien 55 :** "Les Yeux Vides" — hemeryfb agit étrangement pendant 3 jours. Inquiétude du groupe.
- **Lien 80 :** "La Vérité" — hemeryfb révèle sa connexion avec OGUN-0. Choix crucial.

### 7.5 Système de Conflits

Les relations ne sont pas linéaires. Des conflits éclatent entre personnages :

- **Semaine 7 :** king entre en conflit avec un senior. Si le joueur ne soutient pas king, -20 lien avec king.
- **Semaine 11 :** hemeryfb disparaît. Les choix du joueur pendant l'investigation affectent tous les liens.
- **Semaine 13 :** OGUN-0 manipule les personnages. Des conflits artificiels éclatent. Le joueur doit choisir qui soutenir.
- **Semaine 15 :** hemeryfb trahit le groupe (ou pas, selon les liens). Point de non-retour narratif.

---

## 8. INTERFACE & UX RESPONSIVE

### 8.1 Principes de Design

- **Mobile-first :** Toute l'interface est conçue pour un écran de 375x667px minimum
- **Responsive :** L'interface s'adapte à tous les formats (mobile, tablette, desktop)
- **Pixel Art 16-bit :** Rétro-esthétique avec des animations fluides (60fps cible)
- **Navigation tactile :** Tous les boutons font minimum 44x44px (norme Apple)
- **Mode paysage :** Supporté mais pas obligatoire

### 8.2 Écrans Principaux

#### 8.2.1 Écran Titre
- Logo animé "IAI SURVIVORS" en pixel art
- Musique lo-fi en boucle
- Boutons : Nouvelle Partie, Continuer, Options
- Background : Silhouette de l'IAI Togo au coucher du soleil, ambiance cyberpunk africain

#### 8.2.2 Écran Principal (Hub)
Affichage de la semaine actuelle, du jour, du créneau horaire
Boutons rapides : Étudier, Coder, Socialiser, Dormir, Explorer, Hacker
Barre d'énergie, HP Mental, Notes
Portrait du personnage actif + stats en bas d'écran

#### 8.2.3 Écran de Combat
Grille hexagonale au centre
Portraits des personnages à gauche, ennemis à droite
Barres HP/PM/FRUSTRATION en haut
Boutons d'action en bas (Attaque, Compétence, Défense, Objet, Fuite)
Zone de dialogue narrative en haut à droite

#### 8.2.4 Écran des Relations
Liste des personnages avec portraits et niveaux de lien
Graphique de progression par personnage
Événements disponibles par personnage
Journal de bord des interactions

#### 8.2.5 Écran du Dark IAI
Mode sombre avec effets de glitch
Terminal interactif (mini-jeux de code)
Carte du Dark IAI (zones débloquées/verrouillées)
PNJ secrets et quêtes secondaires

#### 8.2.6 Écran des Options
Volume musique/effets sonores
Vitesse de texte
Mode accessible (daltonisme, taille de texte)
Sauvegarde/Chargement
Quitter

### 8.3 Navigation Responsive

| Format | Navigation |
|---|---|
| Mobile (375-414px) | Bottom navigation bar (5 icônes), gestes swipe |
| Tablette (768-1024px) | Sidebar gauche (icônes), contenu central |
| Desktop (1024px+) | Sidebar gauche + panneau droit (stats), barre du haut |

### 8.4 Animations & Feedbacks

- **Transitions entre écrans :** Fondu de 300ms
- **Appui tactile :** Effet de scale (1.05) + son de clic
- **Succès d'action :** Particules dorées + son positif
- **Échec d'action :** Screen shake léger + son négatif
- **Combat :** Animations d'attaque (200ms), dégâts flottants, effets de stun/brûlure
- **Dialogues :** Texte qui s'affiche lettre par lettre (vitesse configurable)
- **Horreur :** Glitch aléatoire de l'écran, déformations subtiles du personnage

---

## 9. SAUVEGARDE & PROGRESSION

### 9.1 Système de Sauvegarde

- **Auto-sauvegarde :** À chaque début de semaine (Lundi matin)
- **Sauvegarde manuelle :** Disponible à tout moment via le menu
- **Emplacements :** 3 sauvegardes simultanées
- **Stockage :** LocalStorage (compatible mobile)
- **Format :** JSON compressé

### 9.2 Données Sauvegardées

```json
{
  "version": "1.0.0",
  "semaine": 5,
  "jour": "mardi",
  "creneau": "matin",
  "stats": {
    "logique": 45,
    "creativite": 32,
    "endurance": 38,
    "social": 27
  },
  "relations": {
    "laurencium": 42,
    "king": 35,
    "arsene": 28,
    "hemeryfb": 51
  },
  "inventaire": ["elixir_cafe", "red_bull_synth", "note_cachee_3"],
  "flags_narratifs": {
    "hemeryfb_disparition": false,
    "ogun0_reveil_partiel": false,
    "dark_iau_niveau": 2
  },
  "mini_jeux_scores": {
    "terminal_fantome": {"best": 850, "rank": "or"},
    "debuggeur": {"best": 720, "rank": "argent"}
  }
}
```

### 9.3 Système de Checkpoints

| Checkpoint | Semaine | Description |
|---|---|---|
| Prologue | 0 | Fin du tutoriel |
| Premier Examen | 5 | Fin du premier boss |
| Mi-Semestre | 8 | Révélation des cauchemars |
| Deuxième Examen | 10 | Point de non-retour partiel |
| L'Éveil | 13 | OGUN-0 s'éveille |
| La Nuit du Code | 14 | Hackathon |
| Confrontation | 15 | Acte final |

### 9.4 Système de Modes de Difficulté

| Mode | Description |
|---|---|
| **Étudiant (Facile)** | +30% énergie, -30% dégâts reçus, pas de Burnout |
| **Normal** | Paramètres de base, expérience équilibrée |
| **Major (Difficile)** | -20% énergie, +30% dégâts reçus, Burnout possible |
| **OGUN-0 (Impossible)** | -40% énergie, +60% dégâts reçus, un seul Burnout = Game Over |

### 9.5 Fins Multiples

Le jeu possède **7 fins distinctes** :

1. **L'Abandon** — Le joueur quitte l'IAI avant la semaine 16
2. **L'Échec** — Burnout triple avant la fin
3. **Le Survivant Solitaire** — Finir sans amitié (tous les liens < 20)
4. **L'Ami Loyal** — Finir avec tous les liens > 50
5. **Le Génie du Dark IAI** — Réputation Dark IAI maximale
6. **La Vérité** — Découvrir l'histoire complète d'OGUN-0
7. **La Libération** — Fin ultime (toutes les conditions remplies)

---

## 10. ÉCONOMIE DU JEU & RÉCOMPENSES

### 10.1 Monnaie en Jeu — "CFA Digital"

La monnaie du jeu est le **CFA Digital** (symbole : ₣), la monnaie fictive du campus.

**Sources de revenus :**
| Source | Gain | Fréquence |
|---|---|---|
| Job étudiant | 50₣ | Par session (max 3/semaine) |
| Vente d'objets | Variable | Au besoin |
| Quêtes secondaires | 20-100₣ | Selon la quête |
| Mini-jeux (ranks Or/Platine) | 30₣ | Par achievement |
| Combats (butin) | 15-50₣ | Par combat gagné |

**Dépenses :**
| Achat | Prix | Effet |
|---|---|---|
| Elixir de Café | 25₣ | +20 énergie instantané |
| Red Bull Synthétique | 50₣ | +40 énergie + buff vitesse 1 tour |
| Pizza du Campus | 30₿ | +15 énergie + petit bonus social |
| Guide de Survie (niveau 1) | 100₣ | +5% efficacité étude permanente |
| Guide de Survie (niveau 2) | 300₣ | +10% efficacité étude permanente |
| Manche de Souris Gaming | 250₣ | +10% efficacité mini-jeux |
| Badge Dark IAI | 500₣ | Accès à une zone secrète |
| Matériel de Désodorisation | 150₣ | Objet relationnel (cadeau pour king) |
| Casque Audio Pro | 200₣ | Objet relationnel (cadeau pour laurencium) |
| Carnet de Notes Secret | 400₣ | Objet relationnel (cadeau pour arsène) |
| Clé USB Maudite | 750₣ | Objet relationnel (cadeau pour hemeryfb) |

### 10.2 Système de Loot

Les combats et les explorations dropent des objets :

**Raretés :**
| Rareté | Couleur | Drop Rate |
|---|---|---|
| Commun | Gris | 60% |
| Peu commun | Vert | 25% |
| Rare | Bleu | 10% |
| Épique | Violet | 4% |
| Légendaire | Doré | 1% |

### 10.3 Système de Récompenses de Progression

| Achievement | Condition | Récompense |
|---|---|---|
| Premier pas | Compléter le tutoriel | 50₣ + "Badge Freshman" |
| Survivant | Atteindre la semaine 5 | 100₣ + "Badge de Survie" |
| Hacker | Accéder au Dark IAI | 150₣ + "Badge Dark IAI" |
| Ami Loyal | Atteindre 50+ lien avec 2 personnages | 200₣ + Compétence de groupe débloquée |
| Maître du Code | Obtenir Platine dans 3 mini-jeux | 300₣ + Objet légendaire |
| Survivant du Premier Examen | Battre le boss semaine 5 | 250₣ + Arme spéciale |
| Sans Brûlure | Atteindre semaine 10 sans Burnout | 400₣ + Item rare |
| Maître des Relations | Atteindre 80+ lien avec 1 personnage | 500₣ + Compétence ultime |

---

## 11. ACCESSIBILITÉ & OPTIONS

### 11.1 Accessibilité Visuelle

| Option | Description |
|---|---|
| **Mode Daltonisme** | 3 profils : Protanopie, Deuteranopie, Tritanopie |
| **Taille de Texte** | Petite, Moyenne, Grande, Très Grande |
| **Contraste Élevé** | Augmente le contraste de tous les éléments UI |
| **Réduire Animations** | Désactive les animations non essentielles (screen shake, particules) |
| **Mode Sombre** | Interface en mode sombre pour les écrans OLED |

### 11.2 Accessibilité Audio

| Option | Description |
|---|---|
| **Volume Musique** | 0-100% (passthrough) |
| **Volume Effets** | 0-100% (passthrough) |
| **Volume Voix** | 0-100% (si voix ajoutées) |
| **Sous-titres** | Activable/désactivable |
| **Description Audio** | Description des sons importants |

### 11.3 Accessibilité Cognitive

| Option | Description |
|---|---|
| **Mode Lent** | Réduit la vitesse de tous les timers de 30% |
| **Indices** | Affiche des indices contextuels pour les puzzles |
| **Skip Combat** | Possibilité de passer les combats (sans récompenses) |
| **Journal de Bord** | Résumé automatique des événements importants |
| **Rappels** | Notifications pour les objectifs en cours |

### 11.4 Accessibilité Tactile

| Option | Description |
|---|---|
| **Taille des Boutons** | Standard, Grand, Très Grand |
| **Espacement** | Standard, Large, Très Large |
| **Vibration** | Activable/désactivable |
| **Gestes Simplifiés** | Remplace les gestes complexes par des boutons |

### 11.5 Options de Gameplay

| Option | Description |
|---|---|
| **Vitesse de Texte** | Lent, Normal, Rapide, Instant |
| **Mode Auto-Play** | Avance automatiquement les dialogues |
| **Sauvegarde Auto** | Activable/désactivable |
| **Mode Casual** | Réduit la difficulté sans changer le score |
| **Mode Speedrun** | Affiche un timer, désactive les dialogues |

### 11.6 Langues

| Langue | Statut |
|---|---|
| Français | Langue principale (100% du contenu) |
| Anglais | Planifié (traduction communautaire) |
| Éwé | Planifié (dialogues de PNJ) |

---

## ANNEXES

### Annexe A — Glossaire

| Terme | Définition |
|---|---|
| Dark IAI | Zone secrète du réseau de l'école, accessible la nuit |
| OGUN-0 | Intelligence artificielle oubliée, antagoniste principal |
| Ananzi | IA originale dont OGUN-0 est une corruption |
| Burnout | État critique quand les HP Mental tombent à 0 |
| PM | Points de Mana, utilisés pour les compétences |
| CFA Digital | Monnaie en jeu |
| Creneau | Bloc de temps alloué pour une action |

### Annexe B — Références Culturelles

| Référence | Contexte dans le jeu |
|---|---|
| JoJo's Bizarre Adventure | Compétence "Stand" de king, dialogues |
| Hollow Knight | Esthétique des zones Dark IAI, ambiance |
| Le Jeune Lion | Culture togolaise, dialogues des PNJ |
| Dark Souls | Système de boss, difficulté |
| Undertale | Système de dialogues, fins multiples |
| Persona | Gestion de temps, relations |
| Cyberpunk | Esthétique globale, thèmes |
| Lo-fi hip hop | Musique de fond, ambiance |

### Annexe C — Roadmap de Développement

| Phase | Durée | Livrables |
|---|---|---|
| Phase 1 — Prototype | 4 semaines | Moteur de jeu de base, 1 semaine jouable |
| Phase 2 — Vertical Slice | 6 semaines | Semaines 0-5 complètes, 1 mini-jeu |
| Phase 3 — Alpha | 8 semaines | Semaines 0-10, tous les mini-jeux, combat complet |
| Phase 4 — Beta | 6 semaines | Jeu complet (17 semaines), tous les contenus |
| Phase 5 — Polissage | 4 semaines | Bug fixes, optimisation mobile, son |
| Phase 6 — Lancement | 2 semaines | Déploiement Vercel, marketing |

**Total estimé :** 30 semaines (7.5 mois)

---

> *Ce document est vivant. Il évolue avec le jeu.*
> *Dernière mise à jour : Juillet 2026*
> *Auteur : Cephas & l'équipe IAI Survivors*
