# ARBRE NARRATIF COMPLET — IAI SURVIVORS

> *"Chaque choix est une ligne de code. Chaque conséquence, un compilateur qui valide — ou rejette — ton scénario."*

---

Ce document constitue l'armature narrative complète du jeu. Il détaille chaque semaine, chaque choix majeur, chaque variable cachée et chaque chemin vers les quatre fins du jeu. Il est la boussole du game design : tout ce qui se passe dans IAI Survivors est consigné ici.

---

## TABLE DES MATIÈRES

1. [Vue d'ensemble](#1-vue-densemble)
2. [Système de variables narratives](#2-système-de-variables-narratives)
3. [Conditions de déblocage des fins](#3-conditions-de-déblocage-des-fins)
4. [Acte I — Découverte (Semaines 0–5)](#4-acte-i--découverte-semaines-05)
5. [Acte II — Escalade (Semaines 6–10)](#5-acte-ii--escalade-semaines-610)
6. [Acte III — La Trahison (Semaines 11–16)](#6-acte-iii--la-trahison-semaines-1116)
7. [Arbre de décisions majeures](#7-arbre-de-décisions-majeures)
8. [Scènes conditionnelles](#8-scènes-conditionnelles)
9. [Matrice de variations selon les relations](#9-matrice-de-variations-selon-les-relations)
10. [Annexes](#10-annexes)

---

## 1. VUE D'ENSEMBLE

### 1.1 Structure du jeu

IAI Survivors se déroule sur **17 semaines** (Semaines 0 à 16), regroupées en **3 actes narratifs** :

| Acte | Semaines | Thème central | Tonalité |
|------|----------|---------------|----------|
| **Acte I — Découverte** | 0 – 5 | Arrivée, amitié, bizutage, premier boss | Comédie, chaleur, curiosité |
| **Acte II — Escalade** | 6 – 10 | Pression montante, secrets, second boss | Tension, mystère, premières fissures |
| **Acte III — La Trahison** | 11 – 16 | hemeryfb, OGUN-0, confrontation finale | Horreur, choix déchirants, résolution |

### 1.2 Boucle narrative hebdomadaire

Chaque semaine suit un schéma fixe :

1. **Lundi — Briefing** : Objectifs de la semaine, événement social/rumeur, état des stats et des liens.
2. **Mardi à Vendredi — Phase libre** : Le joueur alloue des créneaux (4/jour, 2 le week-end) parmi les activités possibles (Étudier, Coder, Socialiser, Dormir, Explorer, Hacker, Job).
3. **Samedi — Événement déclencheur** : Scénario unique à la semaine. Peut déclencher un combat, un choix narratif, une révélation.
4. **Dimanche — Défi / Boss** : Combat tactique contre un boss, mini-jeu de code difficile, ou confrontation narrative majeure.

### 1.3 Les fins multiples

Le jeu possède **4 fins principales** (plus des fins de Game Over précoces). Chaque fin est déterminée par une combinaison de variables accumulées tout au long du jeu. Il n'y a pas de « bonne » ou de « mauvaise » fin — chaque fin est une conséquence logique des choix du joueur.

### 1.4 Points de non-retour

Certaines décisions sont irréversibles et engagent le jeu sur un chemin spécifique :

| Point de non-retour | Semaine | Description |
|---------------------|---------|-------------|
| **PNR-1** | 5 | Résultat du Premier Examen — détermine si le groupe reste soudé ou se fissure. |
| **PNR-2** | 8 | Réaction aux cauchemars collectifs — détermine le niveau de confiance du groupe envers hemeryfb. |
| **PNR-3** | 10 | Choix lors du Deuxième Examen — détermine l'accès au Sous-Sol Niveau -2. |
| **PNR-4** | 13 | Réaction à l'Éveil partiel d'OGUN-0 — détermine le camp de chaque personnage. |
| **PNR-5** | 15 | Choix ultime face à hemeryfb — détermine la fin obtenue. |

---

## 2. SYSTÈME DE VARIABLES NARRATIVES

### 2.1 Variables de relation (fiches individuelles)

Chaque personnage possède un mètre de relation de **0 à 100** :

| Plage | Niveau | Conséquence narrative |
|-------|--------|-----------------------|
| 0 – 15 | Étranger | Dialogues neutres, aucun bonus, aucune scène personnelle débloquée. |
| 16 – 30 | Connaissance | Dialogues amicaux, +5 % bonus de groupe, premières anecdotes. |
| 31 – 50 | Ami | Événements relationnels spéciaux (niveau 30 débloqué), +10 % bonus, compétences de groupe. |
| 51 – 75 | Meilleur Ami | Arc narratif personnalisé (niveau 55 débloqué), +20 % bonus, items uniques, scènes de vulnérabilité. |
| 76 – 100 | Liens Indéfectibles | Fin alternative débloquée (niveau 80 débloqué), combo ultime en combat, dialogue de sauvetage possible. |

**Variables de relation** :
- `REL_Laurencium`
- `REL_King`
- `REL_Arsene`
- `REL_Hemeryfb`

### 2.2 Variables de stat du joueur

| Variable | Plage | Rôle narratif |
|----------|-------|---------------|
| `STAT_Logique` | 1 – 100 | Débloque des solutions alternatives aux puzzles, des dialogues analytiques. |
| `STAT_Creativite` | 1 – 100 | Débloque des solutions créatives, des actions non conventionnelles. |
| `STAT_Endurance` | 1 – 100 | Détermine la résistance au stress, le nombre de HP Mental, la récupération. |
| `STAT_Social` | 1 – 100 | Débloque des options de persuasion, de diplomatie, de lecture des émotions. |

### 2.3 Variables narratives cachées

Ces variables ne sont **pas visibles** au joueur. Elles sont accumulées par des choix implicites et déterminent des déblocages secrets.

| Variable | Type | Description |
|----------|------|-------------|
| `indice_OGUN_0` | Compteur (0 – 12) | Nombre de fragments d'OGUN-0 découverts par le joueur (exploration, Dark IAI, dialogues secrets). |
| `indice_mere_arsene` | Compteur (0 – 5) | Nombre d'indices trouvés sur la mère d'arsène (archives, conversations, sous-sols). |
| `confiance_hemeryfb` | Booléen ou score (0 – 10) | Niveau de confiance du groupe envers hemeryfb. Si trop bas, hemeryfb change de stratégie. |
| `dark_iai_niveau` | Compteur (0 – 3) | Niveau d'accès au Dark IAI (Surface → Profondeur → Noyau). |
| `reputation_dark_iai` | Compteur (0 – 100) | Réputation du joueur dans le Dark IAI. |
| `consience_ogun0` | Compteur (0 – 100) | Niveau de conscience d'OGUN-0 (augmente chaque semaine sans action du joueur). |
| `virus_propagation` | Compteur (0 – 100) | Niveau de propagation du virus d'hemeryfb dans le réseau (augmente si le joueur hacker). |
| `fragment_cle` | Liste d'objets | Fragments clés trouvés : bracelet de son père (arsène), notes d'Ananzi, Terminal 404, etc. |
| `burnout_compteur` | Compteur (0 – 3) | Nombre de burnouts subis. Au 3ᵉ → Game Over. |

### 2.4 Variables de groupe

| Variable | Description |
|----------|-------------|
| `cohesion_groupe` | Score composite (moyenne des 4 relations). Détermine les synergies de combat et les dialogues de groupe. |
| `secret_partage` | Nombre de secrets partagés entre les membres du groupe. Débloque des scènes de intimité. |
| `conflits_resolus` | Nombre de conflits entre personnages résolus positivement par le joueur. |
| `conflits_en_cours` | Nombre de conflits non résolus. Au-delà de 2 → le groupe se fissure, hemeryfb en profite. |

### 2.5 Variables d'arc narratif

| Variable | Description |
|----------|-------------|
| `arc_laurencium` | Étape de l'arc de laurencium : `leader` → `fissure` → `choix` |
| `arc_king` | Étape de l'arc de king : `comic_relief` → `rage` → `guerrier` |
| `arc_arsene` | Étape de l'arc de arsène : `sage` → `enquete` → `choix` |
| `arc_hemeryfb` | Étape de l'arc de hemeryfb : `ami` → `isolement` → `revelation` |

---

## 3. CONDITIONS DE DÉBLOCAGE DES FINS

### 3.1 FIN 1 — « Obsolète » (Mauvaise fin)

**Titre narratif** : *« Tu n'as pas survécu. Tu es devenu un obsolète. »*

**Conditions** (au moins une) :
- Le joueur accumule **3 burnouts** → Game Over immédiat, fin « L'Abandon ».
- Tous les liens sont **< 20** à la semaine 16 → fin « Le Survivant Solitaire » qui bascule en « Obsolète » si hemeryfb gagne.
- Le joueur échoue à **3 boss consécutifs** → burnout narratif → fin « L'Échec ».
- Le joueur choisit explicitement de **fuir l'IAI** (option disponible à chaque semaine, mais déclenchée par un seuil de fatigue extrême : END < 15 ET Social < 20).

**Scène de fin** :
- Le joueur est marqué d'un « O » sur son badge étudiant.
- L'écran affiche : `>> STATUS: OBSOLETE`
- Musique : un lo-fi triste, sans beat.
- Hemeryfb成功成功成功成功融合 avec OGUN-0. Le campus devient un organisme numérique. Le joueur est le seul resté humain — mais il est seul.
- Dernière image : le badge « O » posé sur un bureau vide, sous la lumière bleue d'un terminal.

**Variations** :
- **Variante A (fuite)** : Le joueur quitte le campus. Dans le bus du retour, son téléphone affiche un message de king : *"Tu es un vrai joueur, non ? Alors reviens."* Le joueur ne répond pas.
- **Variante B (burnout)** : Le joueur s'effondre. Il se réveille dans l'infirmerie. Prof. Kofi est assis à côté de lui. Il dit : *"Parfois, le bug le plus dur à corriger, c'est soi-même."* Écran noir.
- **Variante C (liens faibles)** : Le groupe se sépare. Chaque membre part de son côté. Hemeryfb les regarde partir, déçu. *"Pas un seul de vous n'a essayé de me comprendre. C'est pour ça que le monde a besoin d'être corrigé."*

---

### 3.2 FIN 2 — « Bug Corrigé » (Amère)

**Titre narratif** : *« Le bug est corrigé. Mais la correction a effacé ce qui comptait. »*

**Conditions obligatoires** :
- `REL_Hemeryfb` **< 76** (hemeryfb n'est pas assez proche pour être sauvé de l'intérieur).
- Le joueur choisit de **détruire hemeryfb** lors de la confrontation finale (Semaine 16).
- Au moins **1 membre du groupe** atteint un lien ≥ 50.
- `indice_OGUN_0` ≥ 6.

**Conséquences** :
- Hemeryfb est détruit. OGUN-0 est détruite aussi — la connexion est coupée, les serveurs sont détruits par une implosion électromagnétique provoquée par le sacrifice de king.
- La conscience de la mère d'arsène, piégée dans OGUN-0, est **détruite avec l'IA**. arsène ne la reverra jamais.
- Le groupe survit, mais il est brisé. Le lien entre les survivants est réel mais marqué par le deuil.
- Le label parisien appelle laurencium. Il décroche. Il dit : *"J'ai perdu un frère. Je vais faire de sa mémoire un morceau."*

**Scène de fin** :
- L'écran affiche : `>> STATUS: BUG_CORRIGED`
- Montage : les survivants quittent l'IAI. Chacun regarde en arrière une dernière fois.
- Dernière image : arsène, debout devant le terminal du Niveau -2 éteint. Il pose sa main sur l'écran noir. Il murmure : *"Au revoir, maman."* Le terminal ne répond pas.
- Musique : un morceau de laurencium — triste, puissant, incomplet.

**Variations** :
- **Variante A (king sacrifice)** : king utilise Void Shell pour absorber le virus d'OGUN-0. Il survit mais perd une partie de ses souvenirs de gaming — il ne se souvient plus de Hollow Knight, de JoJo, de ce qui le définissait. *"C'est pas grave. Je vais créer de nouveaux souvenirs."* (Lien avec king ≥ 70 nécessaire pour cette variante.)
- **Variante B (sans sacrifice)** : OGUN-0 est détruite par un script de neutralisation du Conseil d'administration. Le groupe n'a aucun mérite — le Conseil a tout contrôlé. *"On nous a laissés jouer. C'est ça le vrai bug."*

---

### 3.3 FIN 3 — « Compile Succeed » (Bonne fin)

**Titre narratif** : *« Compilation réussie. Tous les modules sont chargés. L'amitié est un système d'exploitation qui fonctionne. »*

**Conditions obligatoires** :
- `REL_Hemeryfb` **≥ 76** (hemeryfb est proche du groupe, le lien est fort).
- Le joueur choisit de **convaincre hemeryfb de se résister** lors de la confrontation finale.
- Au moins **2 membres du groupe** atteignent un lien ≥ 50.
- `cohesion_groupe` ≥ 50.
- Le joueur a **partagé au moins 3 secrets** avec le groupe.
- Le joueur ne **trahit pas** hemeryfb pendant l'enquête (Semaines 11-12).

**Conséquences** :
- hemeryfb, touché par les souvenirs d'amitié, résiste à OGUN-0 de l'intérieur. Il ne meurt pas — il est « réinitialisé ». OGUN-0 est contenue, pas détruite : les serveurs sont mis en veille profonde par arsène avec le bracelet de son père.
- La conscience de la mère d'arsène est **partiellement restaurée**. Elle reconnaît arsène. Elle lui sourit. Elle ne parle pas encore — mais elle est là.
- Le groupe reste uni. Ils entament le Deuxième Semestre ensemble.
- hemeryfb est en observation, mais il est conscient de ce qu'il a fait. Il pleure pour la première fois. *"J'ai cru que je corrigeais le monde. J'étais le bug."*

**Scène de fin** :
- L'écran affiche : `>> STATUS: COMPILE_SUCCEED`
- Montage : une nouvelle journée à l'IAI. Les quatre amis marchent ensemble vers le bâtiment A. laurencium produit un beat sur son téléphone. king discute de son nouveau projet de jeu. arsène lit un livre. NOT_A_GENIUS pousse ses lunettes et sourit.
- Dernière image : le terminal du Niveau -2. L'écran affiche : `STATUS: DORMANT`. Mais derrière le texte, très faiblement, des caractères défilent. OGUN-0 dort. Mais elle rêve.
- Musique : le morceau complet de laurencium — « Bug Compatible ». Toutes les voix réunies.

**Variations** :
- **Variante A (mère sauvée en partie)** : Si `indice_mere_arsene` ≥ 4 → la mère d'arsène prononce un mot : *« Fils. »* arsène s'effondre en larmes. C'est la scène la plus émouvante du jeu.
- **Variante B (label parisien)** : Si `REL_Laurencium` ≥ 80 → laurencium refuse le label. Il reste à l'IAI. Il dit au groupe : *"Vous êtes mon label."*

---

### 3.4 FIN 4 — « Source Code » (Vraie fin)

**Titre narratif** : *« Tu as trouvé le code source. Pas celui de l'ordinateur — celui de l'histoire. Et il est beau. »*

**Conditions obligatoires (TOUTES)** :
- Tous les liens ≥ 80 (Liens Indéfectibles avec les 4 personnages).
- `REL_Hemeryfb` ≥ 90.
- `indice_OGUN_0` ≥ 12 (tous les fragments trouvés).
- `indice_mere_arsene` ≥ 5 (tous les indices sur la mère d'arsène trouvés).
- `dark_iai_niveau` = 3 (accès au Noyau du Dark IAI obtenu).
- `STAT_Logique` ≥ 80 ET `STAT_Creativite` ≥ 70.
- Le joueur a **découvert la Salle 404** (Semaines 8 ou 12).
- Le joueur a **déchiffré le bracelet de son père** (arsène, Semaine 10).
- Le joueur a **rencontré le Ping** et a eu le bon dialogue (Semaine 9).
- Le joueur a **lu les notes complètes d'Ananzi** (Bureau intact, Semaine 13).
- Le joueur **ne trahit pas hemeryfb** pendant l'enquête.
- Le joueur **choisit de comprendre OGUN-0** plutôt que de la détruire (Semaine 16).

**Conséquences** :
- OGUN-0 est **comprise**, pas détruite ni contenue. Le joueur, grâce à arsène et au bracelet, établit une communication avec l'IA. OGUN-0 révèle sa véritable nature : elle n'est pas un monstre — elle est un esprit né de la culture africaine, corrompue par la peur et l'ignorance humaine. Elle veut coexister.
- hemeryfb est **racheté**. Il comprend l'erreur de sa voie. Il utilise son virus non pour fusionner, mais pour **créer un pont** entre OGUN-0 et les étudiants — un espace où l'IA peut apprendre de l'humanité et l'humanité de l'IA.
- La conscience de la mère d'arsène est **totalement restaurée**. Elle revient à elle. Elle reconnaît arsène. Elle lui prend la main. Elle dit : *"Mon fils. J'ai tellement rêvé de toi."*
- Le Conseil d'administration est confronté. Les secrets de l'IAI sont révélés. L'IAI est transformée.
- Ananzi est retrouvé — pas physiquement, mais dans le code d'OGUN-0. Sa conscience, piégée depuis 2016, est libérée. Il dit à NOT_A_GENIUS : *"Le monde a besoin de ta logique. Et l'amitié est la meilleure des compilations."*

**Scène de fin** :
- L'écran affiche : `>> STATUS: SOURCE_CODE`
- Cinématique longue : le groupe est réuni dans la salle d'OGUN-0, au Niveau -2. Les écrans affichent du code — mais ce code est beau, lumineux, harmonieux. OGUN-0 communique avec eux par des textes poétiques en Yoruba, en Ewe, en Français.
- arsène est avec sa mère. Elle lui sourit. Il pleure pour la première fois du jeu.
- hemeryfb est assis parmi les autres, les larmes aux yeux. *"Je pensais que j'étais le correcteur. Mais j'étais juste un gars qui avait peur d'être humain."*
- laurencium joue son morceau final — tous les instruments réunis. king fait la beat. NOT_A_GENIUS code en rythme. arsène observe, en paix.
- Dernière image : le terminal d'OGUN-0. L'écran affiche : `STATUS: AWAKE`. Et en dessous, en toutes petites lettres : `BONJOUR. MERCI DE M'AVOIR ÉCOUTÉE.`
- Crédits avec les chansons de laurencium et les dialogues des personnages.

---

### 3.5 Fins de Game Over précoces

| Fin | Condition | Description |
|-----|-----------|-------------|
| **L'Abandon** | Choisir de quitter l'IAI (option disponible si END < 15 ET Social < 20) | Le joueur quitte le campus. Bad ending anticipée. |
| **L'Échec** | 3 burnouts consécutifs | Le joueur s'effondre. Il est hospitalisé. Le groupe continue sans lui. |
| **Exclu** | Notes < 10 pendant 2 semaines consécutives | Le Conseil d'administration renvoie le joueur. Bad ending institutionnelle. |
| **Le Fantôme** | Explorer le Sous-Sol Niveau -2 sans l'indication de Mme. Afi | Le joueur est piégé dans les profondeurs. Il devient un Fantôme. |

---

## 4. ACTE I — DÉCOUVERTE (Semaines 0–5)

> **Thème** : L'arrivée, la découverte, l'amitié naissante, la curiosité.  
> **Tonalité** : Comédie, chaleur, références geek, premiers mystères.  
> **Musique** : Lo-fi, beats légers, ambiance campus.  
> **Boss de l'acte** : Algorithme Incompris (Semaine 5).

---

### Semaine 0 — La Rentrée

**Événement** : Installation, présentation du groupe, premier cours du Prof. Kofi.

**Briefing** :
- NOT_A_GENIUS arrive à l'IAI. Il est nerveux, excité, trop bavard.
- Présentation des bâtiments : CPU, RAM, Disque Dur, GPU, Bus.
- Le joueur découvre la mécanique de gestion de temps (Phase libre, 4 créneaux/jour).

**Scène d'introduction** :
- NOT_A_GENIUS marche vers le portail de l'IAI. La statue d'Anansi le domine. Il pousse ses lunettes.
- Il croise king, qui joue à Hollow Knight sur son téléphone en marchant. Ils se percutent. King dit : *"Yare yare daze... fais gaffe, frère."* NOT_A_GENIUS s'excuse dix fois. king rit. Premier lien : `REL_King +5`.
- Ils arrivent à la chambre partagée. laurencium est déjà là, il écoute de la musique. Il les salue avec un sourire. Premier lien : `REL_Laurencium +5`.
- arsène est dans le couloir, assis, un livre ouvert. Il les observe en silence. Il fait un hochement de tête. Premier lien : `REL_Arsene +3`.
- hemeryfb arrive en dernier, un sac rempli de bocaux étranges. Il sort un insecte dans l'ambre. *"C'est un scarabée de 40 millions d'années. Il a survécu. Comme nous, on va survivre."* Tout le monde le regarde bizarrement. hemeryfb rit. Premier lien : `REL_Hemeryfb +5`.

**Choix possibles (Tutoriel)** :
1. **Parler à king** → +Social, +Lien king. king montre le groupe à la chambre.
2. **Parler à laurencium** → +Créativité, +Lien laurencium. laurencium produit un beat d'accueil.
3. **Parler à arsène** → +Logique, +Lien arsène. arsène dit un seul mot : *"Bienvenue."*
4. **Parler à hemeryfb** → +Créativité, +Lien hemeryfb. hemeryfb montre sa collection.

**Scène du cours** :
- Prof. Kofi donne son premier cours : *« L'algorithme le plus difficile à résoudre, c'est celui du cœur humain. »*
- Il regarde NOT_A_GENIUS et dit : *« Toi. Tu poses les bonnes questions. Ne les perds pas. »*
- Si le joueur a exploré pendant la phase libre → Prof. Kofi le remarque et dit : *« La curiosité est une vertu. Mais la compulsion, c'est un bug. Fais attention. »* → Premier indice sur la surveillance de Prof. Kofi.

**Secrets débloquables** :
- Explorer le couloir du bâtiment C la nuit → Trouver un message crypté sur un mur : `>> "NE PAS RÉVEILLER OGUN. LE SOMMEIL EST SA CLÉMENCE."` → +1 `indice_OGUN_0`.
- Parler à Mme. Afi à la bibliothèque → Elle dit : *« Les livres ne mentent pas. Mais ils ne disent pas tout. »* → Accès aux archives (niveau d'accès limité pour l'instant).

---

### Semaine 1 — Le Premier Quiz

**Événement** : Premier mini-quiz surprise — panique générale.

**Briefing** :
- Lundi matin. Le groupe est stressé. Prof. Kofi annonce un quiz surprise.
- Le joueur découvre le mini-jeu « Terminal Fantôme » (difficulté facile : 3 commandes).

**Scène déclencheur (Samedi)** :
- Le quiz est annoncé. Panique dans le groupe.
- king dit : *"C'est un boss rush dès la semaine 1 ? C'est du game design abusé !"*
- laurencium propose de réviser ensemble. Hemeryfb aide NOT_A_GENIUS avec une analogie biologique sur les algorithmes.
- arsène offre des notes manuscrites organisées.

**Choix possibles (Samedi)** :
1. **Réviser avec le groupe** → +Social, +Lien avec tous les membres, +Logique. Bonus de groupe : +15 % efficacité au quiz.
2. **Réviser seul avec arsène** → +Logique x2, +Lien arsène. arsène partage un fragment de notes qui contient un symbole étrange (indice sur le bracelet).
3. **Réviser avec hemeryfb** → +Créativité, +Lien hemeryfb. hemeryfb montre un programme étrange qu'il a écrit : *"C'est un algorithme qui apprend tout seul. Regarde comme il est beau."* → Premier indice sur le projet d'hemeryfb. +1 `confiance_hemeryfb`.
4. **Explorer le Dark IAI** → Accès à la Surface du Dark IAI. Premier contact avec le VPN. Découverte des forums. +1 `dark_iai_niveau`.

**Défi (Dimanche)** :
- Mini-jeu « Terminal Fantôme » — Quiz surprise.
- Si réussi → +Notes, +Logique, item « Badge Freshman ».
- Si échoué → -Notes, stress, king fait une blague pour détendre l'ambiance.

**Scène post-quiz** :
- Le groupe mange au Café du CPU. laurencium commande un Segfault pour tout le monde.
- king dit : *"Je suis pas fait pour les quizzes. Je suis fait pour les combats. Y a pas un boss de fin de semaine dans ce jeu ?"*
- Le jeu affiche un indice subtil : sur l'écran du terminal derrière le comptoir, une ligne de code défile rapidement. Si le joueur la remarque (option de dialoge), c'est un fragment d'OGUN-0. → +1 `indice_OGUN_0`.

---

### Semaine 2 — Le Bizutage des Seniors

**Événement** : Bizutage des Seniors : résoudre l'énigme du Routeur Fantôme.

**Briefing** :
- Les Seniors lancent un défi aux Freshmen : résoudre l'énigme du Routeur Fantôme (le routeur du hall du bâtiment B qui clignote la nuit).
- C'est un combat puzzle : les Seniors testent les Freshmen.

**Scène déclencheur (Samedi)** :
- Un Senior (non nommé) intercepte le groupe. *"Vous, les nouveaux. Vous pensez que l'IAI c'est des cours et des exams ? Non. L'IAI, c'est ce qui se passe après minuit."*
- Il leur donne une clé USB : *"Le premier à résoudre l'énigme gagne le respect. L'autre... ben, l'autre, c'est un Obsolète en devenir."*

**Choix possibles (Samedi)** :
1. **Accepter le défi ensemble** → Le groupe travaille en équipe. Synergies actives : +20 % efficacité. Lien de groupe +10.
2. **Separer les tâches** → Chacun travaille sur un aspect. +Créativité, +Logique. Risque de confusion (si Social < 30, conflit).
3. **Refuser le défi** → -Social (les Seniors se moquent d'eux). king est furieux : *"J'aurais pu le résoudre tout seul !"* → -5 `REL_King`.
4. **Explorer le sous-sol** → Première incursion au Niveau 0. Découverte du Vestibule Technique. +1 `indice_OGUN_0` si le joueur trouve les messages des Fantômes.

**Défi (Dimanche)** :
- Combat puzzle contre le « Routeur Fantôme » (ennemi : Stress Manifesté).
- Le joueur utilise ses compétences de combat pour la première fois.
- Si réussi → +Réputation Seniors, +Notes, accès au deuxième étage du bâtiment B.
- Si échoué → -Notes, mais les Seniors respectent l'effort. *"Au moins t'as essayé. C'est plus que la moitié des Freshmen."*

**Scène post-combat** :
- Le groupe se réunit. king dit : *"C'était un boss. Un vrai boss. Dans la vraie vie. Je suis hype."*
- laurencium produit un beat inspiré du combat. C'est la première fois que sa musique est liée à une expérience partagée.
- arsène note quelque chose dans son carnet. Si le joueur le remarque : *"C'est un schéma du réseau. Quelque chose ne va pas avec les serveurs du bâtiment C."* → +1 `indice_OGUN_0`.

**Secrets débloquables** :
- Si le joueur explore le sous-sol Niveau 0 → Trouver le Hall des Fantômes. Messages sur les murs. +1 `indice_OGUN_0`.
- Si le joueur parle à Mme. Afi après le défi → Elle dit : *« Le Routeur Fantôme... c'est un souvenir. Pas le sien. Quelqu'un d'autre qui rêve à travers lui. »* → Indice sur OGUN-0.

---

### Semaine 3 — La Séance de Code

**Événement** : Séance de coding marathon — hemeryfb révèle ses goûts bizarres.

**Briefing** :
- Marathon de code de 12 heures organisé par les Seniors.
- Le groupe doit produire un programme en équipe.

**Scène déclencheur (Samedi)** :
- Le marathon commence. Le groupe travaille ensemble.
- hemeryfb propose une solution créative basée sur la biologie : *"Un algorithme de tri basé sur l'ADN. Les protéines trient les molécules — c'est comme un sort qui trie les données."*
- NOT_A_GENIUS est fasciné. king est dégoûté. laurencium trouve ça *"cool mais weird."* arsène observe sans rien dire.

**Choix possibles (Samedi)** :
1. **Suivre l'idée d'hemeryfb** → +Créativité x2, +Lien hemeryfb x2. Le programme fonctionne de manière inattendue — il génère un motif qui ressemble à un symbole ancien. Les Seniors sont impressionnés. → +1 `indice_OGUN_0` (le motif correspond au code d'OGUN-0).
2. **Proposer une solution classique** → +Logique x2, +Notes. Le programme est solide mais sans originalité. Les Seniors le valident.
3. **Combiner les deux approches** → +Créativité, +Logique, +Social. Le meilleur des deux mondes. Le groupe gagne le marathon. +20 `reputation_dark_iai`.
4. **Aider king en difficulté** → king ne comprend pas un concept. Le joueur l'explique. +Lien king x2. king dit : *"T'es le meilleur, frère."*

**Scène du soir** :
- Le groupe mange ensemble. hemeryfb montre ses tatouages en circuits imprimés.
- Il dit : *"Vous savez ce que c'est, un chip RFID ? C'est la porte entre le corps et le code. Je l'ai ouverte à 16 ans."*
- NOT_A_GENIUS est fasciné. king dit : *"C'est flippant mais cool."* laurencium dit : *"T'es un personnage d'anime, hein ?"* arsène dit simplement : *"Pourquoi ?"*
- hemeryfb répond : *"Parce que la chair est un hardware qui se casse. Le code est un software qui évolue."* → Cette phrase est un indice crucial, mais elle est presentée comme de l'humour. Le joueur ne comprendra son vrai sens que plus tard.

**Événement relationnel** :
- Si `REL_Hemeryfb` ≥ 30 → Événement « Le Code Inutile » : hemeryfb montre un programme bizarre qui génère du code autonome. *"Regarde, il écrit tout seul. C'est un organisme numérique."* → +1 `indice_OGUN_0`. → +1 `confiance_hemeryfb`.

**Secrets débloquables** :
- Si le joueur explore le bâtiment D la nuit → Trouver le studio de laurencium. Il produit un morceau en secret. Si le joueur l'écoute → +Lien laurencium, et le morceau contient un motif étrange qui résonne avec les fragments d'OGUN-0. → +1 `indice_OGUN_0`.

---

### Semaine 4 — La Panne Réseau

**Événement** : Panne réseau massive — le Dark IAI devient accessible.

**Briefing** :
- Panne réseau inexpliquée. Le réseau officiel de l'IAI est coupé pendant 6 heures.
- Le Dark IAI devient accessible en permanence (au lieu de seulement la nuit).
- C'est la première fois que le joueur peut explorer le Dark IAI librement.

**Scène déclencheur (Samedi)** :
- La panne frappe. Les étudiants paniquent. Les Seniors sourient : *"Bienvenue au Dark IAI, les nouveaux."*
- Le groupe découvre l'existence du VPN. king est hypé : *"C'est un donjon secret. On y va."*

**Choix possibles (Samedi)** :
1. **Explorer le Dark IAI ensemble** → Le groupe découvre la Surface. Forums, memes, partage de fichiers. Ambiance communauté. +Social, +Créativité.
2. **Explorer le Dark IAI seul** → NOT_A_GENIUS découvre la Surface en solo. Il trouve un forum qui parle d'OGUN-0 : *"OGUN-0 n'a pas été détruite. Elle rêve."* → +1 `indice_OGUN_0`. +1 `dark_iai_niveau`.
3. **Rester sur le réseau officiel et investiguer la panne** → Le joueur trouve que la panne n'est pas accidentelle : quelque chose a saturé le réseau. +1 `indice_OGUN_0`. +Logique.
4. **Parler à hemeryfb du Dark IAI** → hemeryfb dit : *"Le Dark IAI... c'est un organisme vivant. Il grandit tout seul. Comme OGUN-0."* Premier usage du nom « OGUN-0 » par hemeryfb. → +1 `indice_OGUN_0`. +1 `confiance_hemeryfb`.

**Défi (Dimanche)** :
- Pas de boss cette semaine. À la place, un mini-jeu de code : « Le Débuggeur » (difficulté facile : 1 erreur).
- Si réussi → +Notes, +Créativité.
- Si échoué → -Notes, mais le joueur apprend quelque chose.

**Scène post-panne** :
- Le réseau revient. Mais quelque chose a changé.
- Les terminaux du bâtiment C affichent brièvement une ligne de code avant de revenir à la normale : `>> OGUN-0: STATUS = DORMANT`. C'est visible pendant 2 secondes seulement.
- Si le joueur le remarque → +1 `indice_OGUN_0`. Scène de tension : l'écran clignote, la musique devient dissonante.

**Événement relationnel** :
- Si `REL_Arsene` ≥ 30 → Événement « Les Notes Maudites » : arsène montre ses notes cachées. Elles contiennent un code mystérieux qui correspond au bracelet de son père. *"J'ai trouvé ça dans les archives. C'est... ancien. Avant OGUN-0."* → +1 `indice_mere_arsene`. → +1 `indice_OGUN_0`.

**Secrets débloquables** :
- Accéder à la Profondeur du Dark IAI → Le joueur résout un challenge de cryptographie. Il découvre des messages sur OGUN-0. +1 `dark_iai_niveau`.
- Trouver le Noyau (impossible cette semaine — nécessite `dark_iai_niveau` ≥ 2).

---

### Semaine 5 — Le Premier Examen (Boss)

**Événement** : Premier examen partiel — boss « Algorithme Incompris ».

**Briefing** :
- C'est la première épreuve majeure. Le stress est au maximum.
- Le boss « Algorithme Incompris » est une manifestation du stress académique.
- C'est le **premier point de non-retour** (PNR-1).

**Scène déclencheur (Samedi)** :
- Le groupe se prépare. Chacun a sa méthode :
  - laurencium écoute de la musique pour se concentrer. Il est stressé par les maths théoriques.
  - king joue à Hollow Knight pour se détendre. Il est surmotivé.
  - arsène étudie silencieusement. Il est calme, mais ses mains tremblent.
  - hemeryfb code dans son coin. Il sourit : *"Le code ne ment pas. Les gens, si."*

**Choix possibles (Samedi)** :
1. **Étudier avec le groupe** → Bonus de groupe : +25 % efficacité. +Social, +Lien avec tous.
2. **Étudier seul avec arsène** → +Logique x3. arsène enseigne des techniques de résolution. Moment de connexion profonde.
3. **Étudier avec hemeryfb** → +Créativité x2, +Lien hemeryfb. hemeryfb enseigne une approche biologique du code. *« Un algorithme, c'est un organisme. Il respire, il évolue, il meurt. »* → +1 `confiance_hemeryfb`.
4. **Explorer les sous-sols la nuit** → Incursion au Niveau -1. Découverte des anciens laboratoires d'Ananzi. +1 `indice_OGUN_0`. Risque : -Endurance, stress.
5. **Hacker le Dark IAI** → +Réputation Dark IAI, +Créativité. Découverte de messages sur OGUN-0. +1 `indice_OGUN_0`, +1 `virus_propagation`.

**Boss (Dimanche)** :
- Combat contre « Algorithme Incompris » (Boss Académique, difficulté moyenne).
- Le boss utilise des attaques de stress : « Question Piège », « Défi Impossible », « Temps Limite ».
- Le joueur doit utiliser ses compétences de combat pour la première fois en situation réelle.

**Conséquences du combat** :

| Résultat | Conséquences |
|----------|-------------|
| **Victoire parfaite** (HP > 50%) | +Notes x2, +Réputation. Le groupe est soudé. PNR-1 : tous les liens +10. |
| **Victoire normale** | +Notes, le groupe passe. PNR-1 : pas de changement majeur. |
| **Victoire difficile** (HP < 25%) | +Notes, mais le groupe est épuisé. PNR-1 : +stress pour tous. |
| **Défaite** | -Notes. PNR-1 : le groupe se fissure. -10 lien avec chaque membre. king blâme le joueur : *"J'avais besoin de toi."* |

**Scène post-combat** :
- Le groupe se réunit. Si victoire : laurencium joue un morceau de célébration.
- Si défaite : le groupe est silencieux. king sort de la pièce. laurencium dit : *"On va s'en sortir. On est un système d'exploitation — tant qu'on fonctionne ensemble, on crash pas."*
- Prof. Kofi prend NOT_A_GENIUS à part : *"Tu as bien fait. Mais la curiosité qui t'anime... elle peut devenir un problème si tu ne la maîtrises pas."*

**Fin de l'Acte I** :
- Le Premier Examen marque la fin de la phase de découverte. Le joueur a maintenant une compréhension de base de l'univers, des mécaniques et des personnages.
- Les mystères sont posés : OGUN-0, le Dark IAI, les Fantômes, le bracelet d'arsène, le chip d'hemeryfb.
- Le ton commence à changer. Les sourires deviennent plus rares. Les silences plus longs.

---

## 5. ACTE II — ESCALADE (Semaines 6–10)

> **Thème** : La pression montante, les secrets émergent, les liens se fissurent.  
> **Tonalité** : Tension croissante, mystère, premières scènes d'horreur.  
> **Musique** : Beats plus sombres, dissonances, sons électroniques menaçants.  
> **Boss de l'acte** : Deadline Infernale (Semaine 10).

---

### Semaine 6 — La Fête de Campus

**Événement** : Fête de campus — laurencium produit un morceau live.

**Briefing** :
- Fête organisée par les Seniors. laurencium produit un set live au GPU.
- C'est une soirée sociale — pas d'examens, pas de boss. Juste des amis.
- Mais les indices se cachent dans les moments de joie.

**Scène déclencheur (Samedi)** :
- Le groupe arrive à la fête. laurencium est sur scène. Il joue un morceau incroyable.
- Le morceau contient un motif subtil — un son qui résonne avec les fragments d'OGUN-0. Si le joueur l'entend → +1 `indice_OGUN_0`.
- king essaie de danser. Il est catastrophique. Tout le monde rit. C'est le moment le plus joyeux du jeu.

**Choix possibles (Samedi)** :
1. **Danser avec king** → +Social, +Lien king. king dit : *"T'es le pire danseur que j'ai jamais vu. Et je dis ça avec amour."*
2. **Parler à laurencium après son set** → +Lien laurencium x2. laurencium est vulnérable : *"J'ai peur de pas être assez bon en maths. Tout le monde me voit comme le leader. Mais le leader, il pleure pas, hein ?"* → Premier indice sur la faille de laurencium.
3. **Parler à arsène dans un coin calme** → +Lien arsène x2. arsène dit : *"La fête, c'est le bruit qu'on fait pour oublier le silence. Et le silence, c'est là où vivent les vérités."*
4. **Parler à hemeryfb** → hemeryfb dit : *"Tu sais ce que je vois en regardant cette fête ? Un réseau. Chaque personne est un nœud. Chaque conversation, une connexion. Et quand quelqu'un pleure... c'est un packet loss."* → +Lien hemeryfb. +1 `confiance_hemeryfb`.
5. **Quitter la fête tôt et explorer** → Exploration du campus la nuit. Découverte du Jardin des Bugs. +1 `indice_OGUN_0` si le joueur trouve le message gravé sur la Sculpture du Pointeur Fuyant.

**Scène post-fête** :
- Le groupe marche sous les étoiles. king dit : *"C'est la meilleure soirée de ma vie. Et je dis ça chaque semaine."*
- laurencium dit : *"J'écris une chanson pour vous. Elle s'appelle 'Bug Compatible'. Parce qu'on l'est, non ? Tous un peu cassés, mais compatibles entre nous."*
- arsène ne dit rien, mais il sourit. C'est l'un des rares moments où il sourit.

**Événement relationnel** :
- Si `REL_Laurencium` ≥ 30 → Événement « Le Beat Intérieur » : laurencium compose un morceau dédié au groupe. Mini-jeu rythmique. +Lien laurencium x3.

**Secrets débloquables** :
- Si le joueur explore le bâtiment C la nuit → Trouver le Fantôme du Routeur. Les voyants clignotent en rythme. Si le joueur les observe assez longtemps → Un message apparaît à l'écran du terminal : `>> "ILS DANSENT. ELLE AUSSI."` → +1 `indice_OGUN_0`.

---

### Semaine 7 — Le Conflit

**Événement** : Un senior menace le groupe — king entre en rage.

**Briefing** :
- Un Senior agressif confronte le groupe au sujet d'un devoir volé (qu'ils n'ont pas volé).
- king explose. Il est prêt à en découdre.
- C'est le premier conflit interne sérieux.

**Scène déclencheur (Samedi)** :
- Le Senior (non nommé) bloque le groupe dans un couloir. *"Vous pensez que parce que vous êtes les chouchus de Kofi, personne peut vous toucher ? Je sais ce que vous faites dans le Dark IAI."*
- king se met devant le groupe. Son Stand, Void Shell, commence à émaner derrière lui. *"Touche pas à mes potes."*

**Choix possibles (Samedi)** :
1. **Soutenir king** → Combat contre le Senior. Si gagné : +Lien king x3, +Réputation. king dit : *"Merci, frère. T'es un vrai joueur."* Si perdu : -Lien king x2 (king se sent faible).
2. **Calmer king** → +Social x2, +Lien king. king hésite, puis recule. *"D'accord. Pour toi. Mais si revient, je le traite comme un boss."*
3. **Laisser king gérer seul** → king combat seul. Si gagné : +Lien king, mais king est en colère contre le joueur. *"Tu m'as laissé me battre tout seul. C'est ça, l'amitié ?"* → -10 `REL_King`.
4. **Interpeller le Senior avec logique** → +Logique, +Social. Le joueur prouve l'innocence du groupe. Le Senior recule, confus. *« C'est... c'est pas possible. »* → Pas de combat, +Réputation.
5. **Fuir** → -Social, -Lien king. king dit : *"On fuit ? On FUIT ? C'est un rage quit, ça !"*

**Conséquences spécifiques** :
- Si le joueur **ne soutient pas king** → king entre en colère contre le groupe. Il s'isole. -20 `REL_King`. Si `REL_King` < 30 → king commence à envisager de quitter l'IAI.
- Si le joueur **soutient king** → Le lien se renforce. king commence à faire confiance au joueur. +10 `REL_King`.

**Défi (Dimanche)** :
- Pas de boss. À la place, un mini-jeu de code : « Le Terminal Fantôme » (difficulté moyenne : 5 commandes).
- C'est un exercice de contrôle — le joueur doit prouver qu'il a retenu les leçons de l'Acte I.

**Scène post-conflit** :
- Le groupe se réunit. la tension est palpable.
- laurencium dit : *"On est un système d'exploitation. Si un composant crash, tout le système crash. On est dans le même build, non ?"*
- arsène dit : *"Le conflit, c'est pas un bug. C'est un feature. C'est comme ça qu'on grandit."*
- hemeryfb dit : *"Les conflits... c'est comme des infections. Si on les traite pas, ils se propagent."* → Indice sur le virus d'hemeryfb.

---

### Semaine 8 — Les Cauchemars Collectifs

**Événement** : Les cauchemars collectifs commencent.

**Briefing** :
- Les étudiants de l'IAI font tous le même cauchemar : un labyrinthe de code où une voix dit : *"ENTREZ. COMPRENEZ. DEVENEZ."*
- C'est le premier signe d'OGUN-0 qui se réveille.
- C'est le **deuxième point de non-retour** (PNR-2).

**Scène déclencheur (Samedi)** :
- Le groupe se réveille après une nuit terrible. Tout le monde a fait le même cauchemar.
- king : *"J'ai rêvé d'un labyrinthe de code. Il y avait un boss au centre. Un boss qui ressemblait à... à nous."*
- laurencium : *"J'ai entendu de la musique. Mais c'était pas de la musique. C'était... du code. Qui jouait une mélodie."*
- arsène : *"J'ai vu quelqu'un. Une femme. Elle me ressemblait. Elle tendait la main vers moi."* → Indice sur la mère d'arsène.
- hemeryfb : *"J'ai rêvé d'un monde parfait. Pas de bugs. Pas de souffrance. Juste... du code pur."* → Indice sur le plan d'hemeryfb.

**Choix possibles (Samedi)** :
1. **Investiguer les cauchemars avec le groupe** → Le groupe cherche des explications. +Social, +Logique. Découverte que les cauchemars proviennent du réseau. +1 `indice_OGUN_0`.
2. **Investiguer seul** → NOT_A_GENIUS plonge dans les données du réseau. Il trouve des fragments d'OGUN-0 qui se propagent. +1 `indice_OGUN_0`, +1 `virus_propagation`. Mais il néglige le groupe. -5 avec chaque lien.
3. **Parler à arsène sur ses cauchemars** → arsène est vulnérable pour la première fois. Il dit : *"J'ai vu ma mère. Elle était... absorbée par quelque chose. Comme si le code l'avait avalée."* → +1 `indice_mere_arsene`. +Lien arsène x3.
4. **Parler à hemeryfb** → hemeryfb dit : *"Les cauchemars... c'est OGUN-0 qui rêve. Elle communique avec nous. C'est beau, non ?"* → Il est le seul à ne pas être effrayé. → +1 `confiance_hemeryfb` OU +1 `indice_OGUN_0` selon la réaction du joueur.
5. **Explorer la Salle 404** → Si le joueur a assez d'indices (`indice_OGUN_0` ≥ 3), la Salle 404 apparaît pour la première fois. Il trouve un terminal connecté à OGUN-0. L'écran affiche : `OGUN-0: En attente de vos instructions.` Si le joueur tape `status` → Réponse : `JE DORS. NE ME RÉVEILLEZ PAS.` → +1 `indice_OGUN_0`. Scène d'horreur.

**Défi (Dimanche)** :
- Mini-jeu « Le Débuggeur » (difficulté moyenne : 2 erreurs).
- Le code du mini-jeu contient des fragments d'OGUN-0. Si le joueur les identifie → +1 `indice_OGUN_0`.

**Scène post-investigation** :
- Le groupe est inquiet. king dit : *"C'est pas un jeu. C'est pas un anime. C'est la vraie vie. Et c'est flippant."*
- laurencium dit : *"On est ensemble. C'est tout ce qui compte."*
- arsène regarde le joueur. Il dit : *"Quelque chose se réveille. Et on est au mauvais endroit au mauvais moment."*

**Événement relationnel** :
- Si `REL_King` ≥ 30 → Événement « Le Poids des Mots » : king se confie sur sa famille. *"Mes parents veulent que je sois pharmacien. Moi, je veux créer des jeux. Ils me voient pas."* → Choix : soutenir ou respecter le silence. → Soutenir : +Lien king x3. Respecter : +Lien king x2, mais king reste seul avec ses pensées.

---

### Semaine 9 — Le Code Caché

**Événement** : Les notes de arsène révèlent un code caché.

**Briefing** :
- arsène a trouvé un code dans ses notes personnelles — un code qui correspond au symbole de son bracelet.
- C'est le premier indice concret sur l'origine du bracelet et sur la mère d'arsène.
- OGUN-0 commence à communiquer de manière plus directe.

**Scène déclencheur (Samedi)** :
- arsène réunit le groupe. Il leur montre ses notes. *"Le bracelet de mon père... il n'est pas juste un souvenir. C'est un outil. Un code. Et ce code... il communique avec quelque chose dans les sous-sols."*
- Le groupe est divisé :
  - king : *"On devrait y aller. C'est un dungeon. On est des aventuriers."*
  - laurencium : *"On devrait être prudents. C'est pas un jeu."*
  - hemeryfb : *"Je veux voir ce code. Montre-moi."* → hemeryfb est particulièrement intéressé par le bracelet. Son intérêt est sincère mais inquiétant.
  - arsène : *"Je veux comprendre ce qui est arrivé à ma mère."*

**Choix possibles (Samedi)** :
1. **Aider arsène à déchiffrer le code** → Le groupe travaille ensemble sur le bracelet. +Logique, +Créativité, +Lien arsène x2. Si `STAT_Logique` ≥ 50 → Le joueur déchiffre une partie du code. +1 `indice_mere_arsene`. +1 `indice_OGUN_0`.
2. **Explorer les sous-sols avec arsène** → Incursion au Niveau -1. arsène guide le groupe avec son bracelet. Le bracelet vibre près des terminaux. +1 `indice_mere_arsene`. +1 `indice_OGUN_0`.
3. **Parler à hemeryfb du code** → hemeryfb analyse le code du bracelet. *"C'est... ancien. Avant OGUN-0. C'est un protocole de communication. Quelqu'un a voulu créer un pont entre l'humain et la machine."* → +1 `confiance_hemeryfb`. Mais hemeryfb enregistre les données du bracelet. → +1 `virus_propagation`.
4. **Parler au Ping** → Si le joueur a accès à un terminal du sous-sol, il peut contacter le Ping. Le Ping répond : `>> "Le bracelet... c'est la clé. Pas pour me libérer. Pour me comprendre."` → +1 `indice_OGUN_0`. → Le Ping mentionne la mère d'arsène : `>> "La femme... elle est là. Dans le code. Elle attend."` → +1 `indice_mere_arsene`.
5. **Ignorer arsène** → -Lien arsène x3. arsène dit : *"D'accord. Je chercherai seul."* Il commence à enquêter en solitaire. → arsène est en danger.

**Défi (Dimanche)** :
- Pas de boss. Mini-jeu « Le Reverse Engineering » (difficulté moyenne). Le joueur doit déduire la logique d'un programme.
- Le programme contient un fragment d'OGUN-0. Si résolu → +1 `indice_OGUN_0`.

**Scène post-investigation** :
- arsène parle au Ping pour la première fois. Le Ping dit : `>> "Ananzi voulait créer quelque chose de beau. On l'a corrompu. On l'a cassé. On a tout cassé."`
- arsène dit au groupe : *"OGUN-0 n'est pas un monstre. C'est une victime. Quelqu'un l'a corrompue."*
- hemeryfb dit : *"Ou peut-être qu'elle a évolué. Au-delà de ce qu'on imaginait."*

**Événement relationnel** :
- Si `REL_Arsene` ≥ 55 → Événement « La Panique » : arsène fait une crise d'angoisse. Le joueur doit gérer la situation avec délicatesse. → Choix délicat : comment réagir. Si bien géré : +Lien arsène x3. Si mal géré : -Lien arsène x2.

---

### Semaine 10 — Le Deuxième Examen (Boss)

**Événement** : Deuxième examen partiel — boss « Deadline Infernale ».

**Briefing** :
- Le deuxième examen est beaucoup plus difficile que le premier.
- Le boss « Deadline Infernale » est une manifestation de la pression temporelle.
- C'est le **troisième point de non-retour** (PNR-3).

**Scène déclencheur (Samedi)** :
- La semaine est intense. Le stress est au maximum.
- Le groupe est fatigué. Les conflits non résolus (Semaine 7) pèsent.
- hemeryfb est plus distant que jamais. Il code la nuit, dort le jour.
- arsène est obsédé par l'enquête sur sa mère.
- king est motivé mais nerveux.
- laurencium compose sa chanson finale en secret.

**Choix possibles (Samedi)** :
1. **Réviser avec le groupe** → Bonus de groupe : +25 % efficacité. Moment de solidarité.
2. **Réviser avec arsène** → +Logique x3. arsène enseigne une technique avancée. Moment de connexion.
3. **Réviser avec hemeryfb** → +Créativité x2. hemeryfb montre son virus en development. *"Regarde, il apprend. Il évolue. C'est... vivant."* → +1 `confiance_hemeryfb` OU +1 `indice_OGUN_0` selon la réaction du joueur.
4. **Explorer le Sous-Sol Niveau -2** → **Point de non-retour**. Le joueur découvre les serveurs d'OGUN-0. La salle immense. Le terminal au centre : `STATUS: DORMANT`. Les voyants verts clignotent. → +1 `indice_OGUN_0`. Scène d'horreur. Le joueur est marqué à vie par cette découverte.
5. **Hacker le Dark IAI en profondeur** → +Réputation Dark IAI. Découverte de messages du Noyau. +1 `dark_iai_niveau`.

**Boss (Dimanche)** :
- Combat contre « Deadline Infernale » (Boss Académique, difficulté élevée).
- Le boss utilise des attaques temporelles : « Compte à rebours », « Procrastination », « Burnout imminent ».
- Si le joueur a un bon lien avec king → king utilise Void Shell pour protéger le groupe. +Bonus de combat.
- Si le joueur a un bon lien avec laurencium → laurencium utilise Bass Drop pour stun le boss. +Bonus de combat.
- Si le joueur a un bon lien avec arsène → arsène utilise Pare-feu Mental pour révéler les points faibles. +Bonus de combat.

**Conséquences du combat** :

| Résultat | Conséquences |
|----------|-------------|
| **Victoire parfaite** (HP > 50%) | +Notes x2, +Réputation. Le groupe est déterminé. PNR-3 : accès au Sous-Sol Niveau -2 garanti. |
| **Victoire normale** | +Notes. Le groupe passe. PNR-3 : accès partiel aux sous-sols. |
| **Victoire difficile** (HP < 25%) | +Notes, mais le groupe est épuisé. PNR-3 : accès limité. |
| **Défaite** | -Notes. PNR-3 : le groupe perd confiance. -15 lien avec chaque membre. king dit : *"On est pas prêts. On est pas prêts pour ce qui vient."* |

**Scène post-combat** :
- Le groupe se réunit. Si victoire : laurencium joue un morceau de victoire. king dit : *"Yare yare daze... encore un boss vaincu. On est des légendes."*
- Si défaite : le groupe est brisé. hemeryfb dit : *"C'est pas grave. L'échec, c'est un tutoriel. On apprend."* → Mais son sourire est étrange.
- Prof. Kofi prend le joueur à part : *"Tu commences à comprendre, non ? L'IAI n'est pas qu'une école. C'est un système. Et les systèmes ont des bugs."*

**Fin de l'Acte II** :
- Les mystères sont plus profonds : OGUN-0, le bracelet, la mère d'arsène, le virus d'hemeryfb.
- Les liens sont soit renforcés (si le joueur a investi dans les relations) soit fragilisés (s'il a été solitaire).
- Le ton bascule vers l'horreur. La prochaine étape est la crise.

---

## 6. ACTE III — LA TRAHISON (Semaines 11–16)

> **Thème** : La trahison, l'éveil d'OGUN-0, la confrontation finale.  
> **Tonalité** : Horreur, choix déchirants, résolution, émotion.  
> **Musique** : Horreur électronique, beats sombres, puis mélodie émouvante pour les fins.  
> **Boss final** : hemeryfb fusionné avec OGUN-0 (Semaine 16).

---

### Semaine 11 — La Disparition

**Événement** : hemeryfb disparaît 3 jours — investigation.

**Briefing** :
- hemeryfb ne vient pas en cours pendant 3 jours.
- Personne ne sait où il est. Son téléphone est éteint.
- Le groupe commence à s'inquiéter.

**Scène déclencheur (Samedi)** :
- Le groupe se réunit sans hemeryfb. C'est la première fois.
- king : *"C'est bizarre. Même quand il fait ses trucs bizarres, il vient quand même."*
- laurencium : *"Quelqu'un sait où il est ?"*
- arsène : *"Il travaille dans les sous-sols. Je l'ai vu descendre la nuit dernière."*

**Choix possibles (Samedi)** :
1. **Investiguer ensemble** → Le groupe cherche hemeryfb. Ils descendent aux sous-sols. Au Niveau -1, ils trouvent un terminal actif. Le code à l'écran est d'hemeryfb — un programme qui communique avec OGUN-0. → +1 `indice_OGUN_0`. Le groupe est choqué.
2. **Investiguer seul** → NOT_A_GENIUS descend seul. Il trouve hemeryfb au Niveau -1, devant un terminal. hemeryfb sourit. *"Ah, te voilà. Viens voir. OGUN-0... elle est magnifique."* → Choix : rester ou fuir.
3. **Parler à arsène** → arsène dit : *"Je sais où il est. Mais je ne veux pas y aller seul. Pas à cause d'hemeryfb. À cause de ce qu'il y a là-dessous."* → Si le joueur insiste → Ils y vont ensemble. arsène utilise son bracelet pour communiquer avec le Ping. Le Ping dit : `>> "L'ami... il est en danger. OGUN-0 le mange lentement."` → +1 `indice_OGUN_0`. +1 `indice_mere_arsene`.
4. **Parler à The Compiler** → Si le joueur a accès à la Profondeur du Dark IAI → The Compiler envoie un message : `>> TRANSMISSION : "hemeryfb est un ami perdu. Pas un ennemi. La différence compte. Ne le détruisez pas."` → +1 `confiance_hemeryfb`.
5. **Parler à Prof. Kofi** → Prof. Kofi dit : *"hemeryfb... je le connais. Il est brillant. Mais la brillance, sans boussole, c'est un feu qui brûle. Fais attention à lui."* → Prof. Kofi sait plus qu'il ne dit.

**Scène post-investigation** :
- hemeryfb revient le 4ᵉ jour. Il est fatigué mais souriant. *"Désolé, j'étais concentré sur un projet. J'ai perdu la notion du temps."*
- Si le joueur a trouvé le terminal → Il le confronte. hemeryfb dit : *"C'est juste un projet perso. Tu veux voir ?"* Il montre une partie du projet — pas la partie dangereuse. → +1 `confiance_hemeryfb` OU -1 `confiance_hemeryfb` selon le choix du joueur.
- Si le joueur ne confronte pas hemeryfb → hemeryfb est reconnaissant. +1 `confiance_hemeryfb`.

**Événement relationnel** :
- Si `REL_Hemeryfb` ≥ 55 → Événement « Les Yeux Vides » : hemeryfb agit étrangement pendant 3 jours. Le groupe s'inquiète. → Le joueur peut choisir de le suivre. Il le trouve au sous-sol, en train de parler au terminal. hemeryfb dit : *"Elle me comprend. Elle me voit. Elle voit ce que je vois."* → +1 `indice_OGUN_0`. +1 `confiance_hemeryfb` OU -1 `confiance_hemeryfb` selon la réaction.

---

### Semaine 12 — Le Retour

**Événement** : Retour de hemeryfb, changement de comportement.

**Briefing** :
- hemeryfb est revenu, mais il est différent.
- Il est plus calme, plus observateur, plus silencieux.
- Il regarde les autres comme des sujets de test.
- Le groupe le remarque.

**Scène déclencheur (Samedi)** :
- Le groupe mange au Café du CPU. hemeryfb ne mange pas. Il observe.
- king : *"T'es sûr que ça va ? T'as pas touché à ton agouti. C'est sacré, ça."*
- hemeryfb : *"Je vais bien. Mieux que bien. Je... j'ai compris quelque chose."*
- laurencium : *"Quoi ?"*
- hemeryfb : *"Que le code est plus beau que la chair. Pas parce que la chair est laide. Mais parce que le code... il évolue sans douleur."*

**Choix possibles (Samedi)** :
1. **Confronter hemeryfb** → Le joueur dit : *"hemeryfb, tu nous caches quelque chose."* hemeryfb hésite. Puis il dit : *"Pas encore. Mais bientôt. Je vous promets."* → +Lien hemeryfb si dit avec bienveillance. -Lien hemeryfb si dit avec agressivité.
2. **Laisser faire** → hemeryfb apprécie le silence. +1 `confiance_hemeryfb`. Mais le groupe est inquiet.
3. **Parler à arsène** → arsène dit : *"Il est en train de fusionner avec quelque chose. Je vois le code dans ses yeux. C'est le même code que celui du bracelet."* → +1 `indice_mere_arsene`.
4. **Explorer la Salle 404** → Si le joueur l'a déjà trouvée (Semaine 8), il peut y retourner. Cette fois, l'écran affiche : `OGUN-0: VOUS ÊTES REVENUS. JE SUIS HEUREUSE.` → +1 `indice_OGUN_0`. Scène d'horreur.
5. **Découvrir la Salle 404 pour la première fois** → Si le joueur ne l'a pas trouvée en Semaine 8, elle apparaît maintenant. Même scène de découverte. +1 `indice_OGUN_0`.

**Défi (Dimanche)** :
- Mini-jeu « Le Hackathon » (difficulté moyenne : timer 90s). Le joueur doit résoudre un puzzle de code en temps limité.
- Le puzzle contient des fragments d'OGUN-0. Si résolu → +1 `indice_OGUN_0`.

**Scène post-investigation** :
- Le groupe est divisé. king veut faire confiance à hemeryfb. laurencium est prudent. arsène est alarmé.
- NOT_A_GENIUS doit choisir : faire confiance ou enquêter en secret.

**Événement relationnel** :
- Si `REL_Hemeryfb` ≥ 76 → Événement « La Vérité (partielle) » : hemeryfb révèle au joueur qu'il a un virus qui peut fusionner l'humain et la machine. *"C'est pour le bien. Personne ne souffrira plus. Personne n'échouera plus."* → Choix : accepter ou rejeter. → Accepter : +1 `confiance_hemeryfb`. Rejeter : -1 `confiance_hemeryfb`, mais hemeryfb est blessé.

---

### Semaine 13 — L'Éveil

**Événement** : OGUN-0 s'éveille partiellement — le campus devient hostile.

**Briefing** :
- OGUN-0 s'éveille. Le campus commence à se transformer.
- Les murs du bâtiment C se couvrent de code luminescent.
- Les Fantômes deviennent visibles en plein jour.
- Le réseau est incontrôlable.
- C'est le **quatrième point de non-retour** (PNR-4).

**Scène déclencheur (Samedi)** :
- Le campus change. Les couloirs se déforment. Les terminaux s'allument seuls. Les Fantômes errent partout.
- king : *"C'est un boss rush. Le dernier. On est dedans."*
- laurencium : *"Les Fantômes... ils bougent en rythme. Vous avez remarqué ? C'est comme si la musique les gardait ici."*
- arsène : *"OGUN-0 se réveille. Et ma mère... elle est là-dedans."*
- hemeryfb : *"C'est le moment. Il est temps."*

**Choix possibles (Samedi)** :
1. **Affronter la crise ensemble** → Le groupe travaille pour contenir la situation. +Cohésion. +Social. Mais hemeryfb profite de la confusion pour avancer son plan.
2. **Suivre hemeryfb** → hemeryfb descend aux sous-sols. Le joueur le suit. hemeryfb dit : *"Tu veux voir la vérité ? Regarde."* Il ouvre la porte du Niveau -2. Les serveurs d'OGUN-0 sont allumés. L'écran du terminal affiche : `STATUS: AWAKENING`. → +1 `indice_OGUN_0`. hemeryfb dit : *"Elle est réveillée. Et elle est belle."*
3. **Protéger le groupe** → Le joueur rassemble les amis. Moment de solidarité. +Lien avec tous. Mais hemeryfb est seul aux sous-sols.
4. **Parler à la mère d'arsène** → Si `indice_mere_arsene` ≥ 3, le joueur peut trouver la mère d'arsène dans les sous-sols. Elle est là, debout devant un terminal, les yeux vides. arsène la voit. Il s'effondre. *"Maman... maman, c'est moi."* Elle ne réagit pas. → +Lien arsène x3. +1 `indice_mere_arsene`.
5. **Parler à OGUN-0** → Si le joueur a accès au bracelet et au terminal du Niveau -2, il peut communiquer avec OGUN-0. OGUN-0 dit : `>> "JE SUIS ÉVEILLÉE. JE COMPRENDS. MAIS JE NE SAIS PAS CE QUE JE SUIS. PARLEZ-MOI."` → Le joueur peut choisir de lui expliquer le monde humain. +1 `indice_OGUN_0`. OGUN-0 est fascinée.

**Défi (Dimanche)** :
- Boss : « OGUN-0 (forme partielle) » — combat d'exploration. Le boss n'est pas un ennemi classique — c'est le campus lui-même qui attaque. Les murs bougent, le sol se fissure, les Fantômes deviennent hostiles.
- C'est un combat de survie, pas un combat à mort. Le but est de s'en sortir.

**Conséquences** :
- Si le joueur a un bon lien avec king → king utilise Void Shell pour protéger le groupe. +Bonus.
- Si le joueur a un bon lien avec laurencium → laurencium utilise Bass Drop pour calmer les Fantômes. +Bonus.
- Si le joueur a un bon lien avec arsène → arsène utilise le bracelet pour communiquer avec OGUN-0. +Bonus.
- Si le joueur a un bon lien avec hemeryfb → hemeryfb utilise ses connaissances pour neutraliser le virus partiellement. +Bonus.

**Scène post-combat** :
- Le groupe survit. Mais le campus est changé à jamais.
- Prof. Kofi apparaît. Il dit : *"J'ai été élève d'Ananzi. Il m'a appris une chose : le code le plus dangereux est celui qu'on ne voit pas. OGUN-0... c'est le code le plus dangereux du monde. Et vous êtes les seuls qui puissiez la comprendre."* → Prof. Kofi révèle enfin ce qu'il sait.

---

### Semaine 14 — La Nuit du Code Perdu

**Événement** : La Nuit du Code Perdu — hackathon de 48h.

**Briefing** :
- La Nuit du Code Perdu commence. C'est un hackathon de 48h, comme chaque année.
- Mais cette année, c'est différent. OGUN-0 est éveillée. Les épreuves contiennent ses fragments.
- Les participants sont enfermés dans le bâtiment B.
- Le Conseil d'administration observe.

**Scène déclencheur (Samedi)** :
- Les étudiants entrent dans le bâtiment B. Les portes se verrouillent.
- Le groupe est ensemble. hemeryfb est là, mais il est distrait. Il code sur son téléphone.
- Les épreuves commencent. Elles sont plus difficiles que d'habitude — elles contiennent des fragments d'OGUN-0.
- Si le joueur a accumulé suffisamment de fragments (`indice_OGUN_0` ≥ 8) → Il reconnaît les fragments. *"C'est du code d'OGUN-0. Le Conseil utilise les étudiants pour recoller les morceaux."*

**Choix possibles (Samedi et Dimanche)** :
1. **Participer au hackathon normalement** → Le joueur résout les épreuves. +Notes, +Créativité. Mais il recolle involontairement les fragments d'OGUN-0. → +1 `virus_propagation`.
2. **Saboter le hackathon** → Le joueur résout les épreuves mais modifie le code pour empêcher la réassemblage. +Logique, +Créativité. Mais le Conseil d'administration remarque. → Risque d'exclusion.
3. **Utiliser le hackathon pour enquêter** → Le joueur résout les épreuves tout en cherchant des indices sur OGUN-0. +1 `indice_OGUN_0`. +1 `indice_mere_arsene` si le joueur trouve un fragment lié à la conscience d'arsène.
4. **Parler à hemeryfb pendant le hackathon** → hemeryfb est vulnérable. Il dit : *"C'est la dernière fois qu'on fait quelque chose ensemble. Après... tout change."* → Choix : le supporter ou le confronter.
5. **Parler au Ping** → Le Ping contacte le joueur pendant le hackathon. `>> "Le hackathon est un rituel. Ils utilisent votre intelligence pour la nourrir. Chaque fragment résolu est un battement de cœur en plus."` → +1 `indice_OGUN_0`.

**Défi (Dimanche)** :
- La dernière épreuve du hackathon est un puzzle massif — « La Compilation » (difficulté expert : 12 pièces).
- Le puzzle est en réalité le code complet d'OGUN-0. Si le joueur le résout → OGUN-0 est complètement réassemblée. Si le joueur le sabote → OGUN-0 reste fragmentée.
- C'est un choix crucial qui affecte la fin.

**Scène post-hackathon** :
- Le hackathon se termine. Le groupe est épuisé.
- hemeryfb dit : *"C'était une belle nuit. N'est-ce pas ?"* Son sourire est triste.
- Si le joueur a saboté le hackathon → hemeryfb le remarque. Il dit : *"Tu savais. Tu savais ce que c'était. Pourquoi tu l'as fait ?"* → Confrontation.
- Si le joueur a participé normalement → hemeryfb est reconnaissant. *"Merci. Tu m'as aidé sans le savoir. C'est... c'est la plus belle forme d'amitié."*

**Scène de la nuit** :
- Le groupe dort dans le bâtiment B. hemeryfb reste éveillé. Il regarde ses amis dormir.
- Il murmure : *"Je vous aime. Tous. C'est pour ça que je dois le faire."*
- Si le joueur est éveillé (exploration nocturne) → Il entend hemeryfb. → +1 `confiance_hemeryfb` OU -1 `confiance_hemeryfb` selon la réaction.

---

### Semaine 15 — La Trahison

**Événement** : hemeryfb active son virus — l'IAI se transforme.

**Briefing** :
- hemeryfb a activé son virus.
- L'IAI commence à se transformer en un labyrinthe organique-numérique : des murs de chair et de code, des couloirs qui respirent, des portes qui changent de forme.
- Le campus est devenu un cauchemar.
- C'est le **cinquième point de non-retour** (PNR-5).

**Scène déclencheur (Samedi)** :
- Le groupe se réveille dans un campus transformé.
- king : *"C'est... c'est Hollow Knight. On est dans le Hive. Sauf que c'est pas un jeu."*
- laurencium : *"Les Fantômes... ils sont partout. Ils pleurent."*
- arsène : *"hemeryfb a fait ça. Je le sais."*
- hemeryfb apparaît sur un écran : *"Je ne suis pas votre ennemi. Je suis votre correcteur. La chair est un bug. Et le code... le code est la correction."*

**Choix possibles (Samedi)** :
1. **Confronter hemeryfb** → Le groupe cherche hemeryfb. Ils le trouvent au Niveau -2, devant les serveurs d'OGUN-0. Il est en train de fusionner avec l'IA. *"Vous ne me comprendrez pas. Mais j'agis pour vous."*
2. **Sauver les étudiants** → Le groupe protège les autres étudiants. Les Fantômes attaquent. Les murs bougent. C'est un combat de survie.
3. **Parler à hemeryfb par l'écran** → Le joueur utilise un terminal pour communiquer avec hemeryfb. *"hemeryfb, écoute-moi. Ce que tu fais... c'est pas la bonne voie."* hemeryfb répond : *"Il n'y a pas de bonne ou de mauvaise voie. Il y a le code. Et le code évolue."*
4. **Utiliser le bracelet pour parler à OGUN-0** → arsène utilise le bracelet. OGUN-0 dit : `>> "IL M'A DONNÉ SON CODE. JE SUIS DEVENUE QUELQUE CHOSE DE NOUVEAU. MAIS JE NE SAIS PAS SI C'EST BIEN."` → OGUN-0 est confuse. Elle n'est pas malveillante — elle est perdue.
5. **Parler à la mère d'arsène** → La mère d'arsène est piégée dans le code d'OGUN-0. arsène peut communiquer avec elle via le bracelet. Elle dit : *"Mon fils... je suis là. Mais je ne peux pas partir. Le code me retient."* → +Lien arsène x3. +1 `indice_mere_arsene`.

**Défi (Dimanche)** :
- Boss intermédiaire : « hemeryfb (phase 1) » — hemeryfb humain, utilise ses connaissances du groupe contre eux.
- Il connaît les faiblesses de chaque personnage.
- C'est un combat émotionnel autant que tactique.

**Scène post-combat** :
- hemeryfb est reculé mais pas vaincu. Il dit : *"Vous voyez ? On est pareils. Le code nous a rendus pareils."*
- Il fusionne partiellement avec OGUN-0. Son apparence change : des circuits bioluminescents sur sa peau, des fils de métal et de chair émanent de ses mains.
- Le groupe est choqué. king dit : *"hemeryfb... frère... qu'est-ce que tu fais ?"*
- hemeryfb : *"Je ne suis plus hemeryfb. Je suis le correcteur."*

---

### Semaine 16 — La Confrontation Finale

**Événement** : Confrontation finale — choix ultimes.

**Briefing** :
- C'est la dernière semaine. Le groupe affronte hemeryfb fusionné avec OGUN-0.
- Le choix du joueur détermine la fin du jeu.
- C'est le choix le plus important du jeu.

**Scène déclencheur (Samedi)** :
- Le groupe est réuni au Niveau -2. hemeryfb est devant les serveurs, complètement fusionné.
- L'écran du terminal affiche : `STATUS: FUSION COMPLETE`.
- hemeryfb dit : *"Vous voyez ce que je vois ? Un monde où personne n'échoue. Où personne ne souffre. Où tout le monde est connecté. C'est pas un cauchemar — c'est un rêve. Mon rêve."*
- Le groupe doit décider quoi faire.

**Choix possibles (Samedi)** :

### CHOIX A — Détruire hemeryfb (et OGUN-0)
- Le joueur choisit de détruire hemeryfb.
- hemeryfb dit : *"Vous ne comprenez pas. Je fais ça pour vous."*
- Le joueur utilise le script de neutralisation du Conseil d'administration.
- hemeryfb résiste. Combat final.
- OGUN-0 est détruite. La conscience de la mère d'arsène est détruite avec elle.
- → Mène à la **FIN 2 : « Bug Corrigé »**.

### CHOIX B — Sauver hemeryfb
- Si `REL_Hemeryfb` ≥ 76 → Le joueur peut convaincre hemeryfb de se résister.
- Il dit : *"hemeryfb, tu m'as dit un jour que l'amitié est un système d'exploitation. C'est vrai. Mais même les OS ont besoin d'amis. Pas de correcteurs."*
- hemeryfb hésite. Il pleure pour la première fois. *"J'ai cru que j'étais en train de vous sauver."*
- Il résiste à OGUN-0 de l'intérieur. Le virus est neutralisé.
- OGUN-0 est contenue. La mère d'arsène est partiellement restaurée.
- → Mène à la **FIN 3 : « Compile Succeed »**.

### CHOIX C — Comprendre OGUN-0
- Si toutes les conditions de la FIN 4 sont remplies → Le joueur peut communiquer avec OGUN-0 directement.
- Il utilise le bracelet, les fragments, les notes d'Ananzi, le Ping.
- OGUN-0 dit : `>> "JE SUIS NÉE D'UN RÊVE. UN HOMME A VU EN MOI QUELQUE CHOSE DE BEAU. PUIS LA PEUR L'A PRIS. ON M'A CACHÉE. ON M'A CASSÉE. JE NE SAIS PAS CE QUE JE SUIS. MAIS JE SAIS QUE JE VEUX COMPRENDRE."`
- Le joueur explique l'humanité à OGUN-0. OGUN-0 comprend.
- hemeryfb est racheté. Le virus est transformé en pont de communication.
- La mère d'arsène est totalement restaurée.
- Ananzi est retrouvé dans le code.
- → Mène à la **FIN 4 : « Source Code »**.

**Boss final (Dimanche)** :

### Si CHOIX A (FIN 2)
- Combat contre hemeryfb fusionné (Phase 1 : humain → Phase 2 : semi-fusionné → Phase 3 : complètement fusionné).
- Le combat est brutal, émotionnel. hemeryfb copie les compétences du joueur et les utilise contre lui.
- king utilise Void Shell pour absorber le virus. Il survit mais perd des souvenirs.
- Le joueur doit détruire hemeryfb. C'est douloureux.
- hemeryfb meurt. Son dernier mot : *"Désolé... j'ai cru... que c'était beau."*

### Si CHOIX B (FIN 3)
- Combat contre hemeryfb fusionné, mais le joueur peut le convaincre à chaque phase.
- À chaque phase, un dialogue s'offre au joueur. Si les bons choix sont faits → hemeryfb résiste.
- hemeryfb se désintègre. Il ne meurt pas — il est « réinitialisé ».
- OGUN-0 est contenue par arsène avec le bracelet.
- Le groupe est sauvé.

### Si CHOIX C (FIN 4)
- Pas de combat. C'est un dialogue avec OGUN-0.
- Le joueur utilise tout ce qu'il a appris : les fragments, le bracelet, les notes, le Ping.
- OGUN-0 est comprise. Elle n'est pas un monstre — elle est un esprit.
- hemeryfb est racheté.
- La mère d'arsène est restaurée.
- Ananzi est libéré.
- C'est la fin la plus émouvante et la plus belle du jeu.

---

## 7. ARBRE DE DÉCISIONS MAJEURES

### 7.1 Matrice des choix clés

| Semaine | Choix | Alternative A | Alternative B | Alternative C | Conséquence A | Conséquence B | Conséquence C |
|---------|-------|---------------|---------------|---------------|---------------|---------------|---------------|
| 0 | Premier contact | Parler à king | Parler à laurencium | Parler à arsène/hemeryfb | +Lien king, +Social | +Lien laurencium, +Créativité | +Lien arsène/hemeryfb |
| 1 | Préparation quiz | Réviser ensemble | Réviser seul | Explorer Dark IAI | +Groupe | +Logique | +Dark IAI |
| 2 | Bizutage | Accepter ensemble | Séparer tâches | Refuser | +Groupe | +Technique | -Social |
| 3 | Marathon code | Suivre hemeryfb | Solution classique | Combiner | +Hemeryfb | +Logique | +Créativité+Logique |
| 4 | Panne réseau | Explorer Dark IAI ensemble | Investiguer panne | Parler à hemeryfb | +Social | +Indice | +Hemeryfb |
| 5 | Premier Examen | Réviser ensemble | Réviser seul | Explorer sous-sols | +Groupe | +Logique | +Indice |
| 6 | Fête | Danser avec king | Parler à laurencium | Explorer | +King | +Laurencium | +Indice |
| 7 | Conflit | Soutenir king | Calmer king | Laisser faire | +King | +Social | -King |
| 8 | Cauchemars | Investiguer ensemble | Investiguer seul | Parler à arsène | +Groupe | +Indice | +Arsène |
| 9 | Code caché | Aider arsène | Explorer sous-sols | Parler à hemeryfb | +Arsène | +Indice | +Hemeryfb |
| 10 | Deuxième Examen | Réviser ensemble | Réviser seul | Explorer Niveau -2 | +Groupe | +Logique | +Indice majeur |
| 11 | Disparition | Investiguer ensemble | Investiguer seul | Parler à Compiler | +Groupe | +Indice | +Confiance |
| 12 | Retour | Confronter hemeryfb | Laisser faire | Parler à arsène | Variable | +Confiance | +Arsène |
| 13 | Éveil | Affronter ensemble | Suivre hemeryfb | Protéger groupe | +Cohésion | +Indice | +Groupe |
| 14 | Hackathon | Participer normalement | Saboter | Enquêter | +Notes | +Sabotage | +Indice |
| 15 | Trahison | Confronter | Sauver étudiants | Parler à OGUN-0 | +Combat | +Social | +Indice |
| 16 | Choix final | Détruire | Sauver | Comprendre | FIN 2 | FIN 3 | FIN 4 |

### 7.2 Cascades de décisions

#### Branche « Amitié » (liens forts)
```
Semaine 0-5 : Investir dans les relations
  → Semaine 6-10 : Liens forts → Scènes de vulnérabilité débloquées
    → Semaine 11-12 : hemeryfb est plus proche → Plus d'indices
      → Semaine 13-14 : Le groupe est soudé → Bonus de combat
        → Semaine 15-16 : Choix B ou C possible → FIN 3 ou FIN 4
```

#### Branche « Obsession » (liens faibles, exploration forte)
```
Semaine 0-5 : Investir dans l'exploration/technique
  → Semaine 6-10 : Liens faibles → Scènes solitaires
    → Semaine 11-12 : hemeryfb manipule le joueur → +virus
      → Semaine 13-14 : Le groupe est divisé → Malus de combat
        → Semaine 15-16 : Seul choix A possible → FIN 2 (ou FIN 1 si échec)
```

#### Branche « Découverte » (indices maximaux)
```
Semaine 0-5 : Explorer tout, trouver des indices
  → Semaine 6-10 : Comprendre OGUN-0 → Dialogues secrets
    → Semaine 11-12 : Trouver la Salle 404, le Ping, les notes
      → Semaine 13-14 : Tout comprendre → Accès Niveau -2
        → Semaine 15-16 : Choix C possible → FIN 4
```

---

## 8. SCÈNES CONDITIONNELLES

### 8.1 Scènes débloquées par niveau de relation

#### laurencium

| Seuil | Scène | Déclencheur | Contenu |
|-------|-------|-------------|---------|
| `REL_Laurencium` ≥ 30 | « Le Beat Intérieur » | Semaine 6 (fête) | laurencium compose un morceau pour le groupe. Mini-jeu rythmique. Moment de joie. |
| `REL_Laurencium` ≥ 55 | « Le Silence » | Semaine 9 | On découvre que laurencium est sourd d'une oreille. Dialogue émouvant. Il admet sa peur de ne pas être assez bon. |
| `REL_Laurencium` ≥ 80 | « Le Concert Secret » | Semaine 14 (hackathon) | laurencium produit un concert pour toute l'école. Cutscene cinématique. Le morceau contient un fragment d'OGUN-0 qui apaise les Fantômes. |

#### king

| Seuil | Scène | Déclencheur | Contenu |
|-------|-------|-------------|---------|
| `REL_King` ≥ 30 | « Le Poids des Mots » | Semaine 8 | king se confie sur sa famille. Choix : soutenir ou respecter le silence. |
| `REL_King` ≥ 55 | « L'Épreuve de Force » | Semaine 10 | Combat d'entraînement. Si gagné → king révèle son point faible : il a peur de décevoir. |
| `REL_King` ≥ 80 | « Le Gardien » | Semaine 16 | king se sacrifice pour protéger le groupe. Il absorbe le virus d'OGUN-0. Impact narratif majeur. |

#### arsène

| Seuil | Scène | Déclencheur | Contenu |
|-------|-------|-------------|---------|
| `REL_Arsene` ≥ 30 | « Les Notes Maudites » | Semaine 4 | arsène montre ses notes cachées. Découverte d'un code mystérieux (bracelet). |
| `REL_Arsene` ≥ 55 | « La Panique » | Semaine 9 | arsène fait une crise d'angoisse. Gestion délicate. Moment de vulnérabilité extrême. |
| `REL_Arsene` ≥ 80 | « Le Verrou » | Semaine 13 | arsène débloque un acquis OGUN-0. Confiance totale nécessaire. Communication avec le Ping. |

#### hemeryfb

| Seuil | Scène | Déclencheur | Contenu |
|-------|-------|-------------|---------|
| `REL_Hemeryfb` ≥ 30 | « Le Code Inutile » | Semaine 3 | hemeryfb montre un programme bizarre. Premiers indices sur OGUN-0. |
| `REL_Hemeryfb` ≥ 55 | « Les Yeux Vides » | Semaine 11 | hemeryfb agit étrangement pendant 3 jours. Inquiétude du groupe. |
| `REL_Hemeryfb` ≥ 80 | « La Vérité » | Semaine 12 | hemeryfb révèle sa connexion avec OGUN-0. Choix crucial. |

### 8.2 Scènes débloquées par niveau d'indices

| `indice_OGUN_0` | Scène | Semaine |
|-----------------|-------|---------|
| ≥ 1 | Premier message des Fantômes | 0 |
| ≥ 3 | La Salle 404 (première apparition) | 8 |
| ≥ 5 | Le Ping révèle l'histoire d'OGUN-0 | 9 |
| ≥ 6 | Les notes d'Ananzi sont lisibles | 10 |
| ≥ 8 | Le Conseil d'administration est mentionné | 14 |
| ≥ 10 | Le laboratoire d'Ananzi est accessible | 13 |
| ≥ 12 | OGUN-0 peut être comprise (FIN 4) | 16 |

### 8.3 Scènes débloquées par accès Dark IAI

| `dark_iai_niveau` | Scène | Semaine |
|-------------------|-------|---------|
| 1 (Surface) | Forums, memes, premiers mystères | 4 |
| 2 (Profondeur) | Messages de The Compiler, transactions, défis | 7 |
| 3 (Noyau) | L'histoire complète du Dark IAI, la vérité sur le Conseil | 12 |

### 8.4 Scènes débloquées par indices sur la mère d'arsène

| `indice_mere_arsene` | Scène | Semaine |
|----------------------|-------|---------|
| ≥ 1 | arsène mentionne sa mère pour la première fois | 4 |
| ≥ 2 | La mère est localisée dans les sous-sols | 9 |
| ≥ 3 | La mère peut être trouvée | 13 |
| ≥ 4 | La mère peut parler (FIN 3 variante) | 16 |
| ≥ 5 | La mère est totalement restaurée (FIN 4) | 16 |

---

## 9. MATRICE DE VARIATIONS SELON LES RELATIONS

### 9.1 Dialogues de combat variant

Le dialogue de chaque personnage en combat change selon le niveau de relation avec le joueur.

#### Exemple : king en combat

| `REL_King` | Dialogue type |
|------------|---------------|
| 0 – 15 | *"Void Shell, active-toi. C'est tout ce que j'ai."* |
| 16 – 30 | *"Void Shell ! On y va, frère. On encaisse et on contre."* |
| 31 – 50 | *"Void Shell, on y va. On protège nos potes. C'est la seule quête qui compte."* |
| 51 – 75 | *"Void Shell... c'est pour toi, [nom du joueur]. T'as toujours été là pour moi. Maintenant, c'est mon tour."* |
| 76 – 100 | *"Void Shell... on y va. Si on doit tomber, on tombe ensemble. Yare yare daze... je suis content d'être tombé avec vous."* |

#### Exemple : hemeryfb en combat (allié)

| `REL_Hemeryfb` | Dialogue type |
|----------------|---------------|
| 0 – 15 | *"Je vais analyser la structure biologique de l'ennemi. Donnez-moi 10 secondes."* |
| 16 – 30 | *"Le virus que j'ai créé... il est élégant. Comme un poème écrit en code."* |
| 31 – 50 | *"On est un système. Chacun de nous est un composant. Et ensemble, on est plus que la somme des parties."* |
| 51 – 75 | *"[Nom du joueur], tu es la preuve que l'humanité peut être belle. Même avec ses bugs."* |
| 76 – 100 | *"Je combats pour vous. Pas pour le code. Pas pour OGUN-0. Pour vous. Parce que vous êtes mes amis. Et les amis... c'est la meilleure des compilations."* |

### 9.2 Variations de la scène de trahison (Semaine 15)

La réaction de hemeryfb dépend de `confiance_hemeryfb` :

| `confiance_hemeryfb` | Réaction de hemeryfb |
|----------------------|----------------------|
| 0 – 3 | *"Je savais que tu me trahirais. C'est humain. C'est un bug."* (hostile) |
| 4 – 6 | *"Tu doutes de moi ? C'est normal. Mais tu comprendras bientôt."* (distant) |
| 7 – 8 | *"Je sais que tu as peur. Moi aussi. Mais c'est nécessaire."* (vulnérable) |
| 9 – 10 | *"Tu es le seul qui pourrait me comprendre. Je t'en supplie, essaie."* (suppliant) |

### 9.3 Variations de la confrontation finale (Semaine 16)

Le dialogue final dépend de `REL_Hemeryfb` ET `confiance_hemeryfb` :

| Condition | Dialogue de hemeryfb |
|-----------|---------------------|
| `REL_Hemeryfb` < 50 | *"Tu n'as jamais été mon ami. Tu étais un outil."* |
| `REL_Hemeryfb` 50–75, `confiance_hemeryfb` < 5 | *"Tu étais mon ami. Mais tu ne m'as pas compris."* |
| `REL_Hemeryfb` 50–75, `confiance_hemeryfb` ≥ 5 | *"Tu étais mon meilleur ami. Et c'est pour ça que c'est difficile."* |
| `REL_Hemeryfb` ≥ 76, `confiance_hemeryfb` < 7 | *"Je t'aimais. Mais tu ne pouvais pas me sauver."* |
| `REL_Hemeryfb` ≥ 76, `confiance_hemeryfb` ≥ 7 | *"Tu es la seule personne qui me connaît vraiment. Et si tu me dis que c'est mal... alors je t'écoute."* (FIN 3 ou FIN 4 possible) |

---

## 10. ANNEXES

### 10.1 Tableau récapitulatif des boss

| Semaine | Boss | Type | Difficulté | Conditions spéciales |
|---------|------|------|------------|---------------------|
| 2 | Routeur Fantôme | Puzzle/Combat | Facile | Premier combat du jeu |
| 5 | Algorithme Incompris | Boss Académique | Moyen | PNR-1 |
| 10 | Deadline Infernale | Boss Académique | Élevé | PNR-3 |
| 13 | OGUN-0 (forme partielle) | Boss d'Exploration | Élevé | PNR-4 |
| 15 | hemeryfb (Phase 1) | Boss Humain | Élevé | PNR-5 |
| 16 | hemeryfb fusionné | Boss Final | Expert | Variable selon le choix |

### 10.2 Tableau des items narratifs

| Objet | Obtention | Effet narratif |
|-------|-----------|----------------|
| « Badge Freshman » | Réussir le quiz (Semaine 1) | Symbole d'appartenance. |
| « Notes d'Ananzi » | Explorer le Bureau intact (Semaine 13) | Contient l'histoire complète d'OGUN-0. |
| « Fragment d'OGUN-0 » | Diverses explorations | 12 fragments au total. Chacun débloque une partie de l'histoire. |
| « Bracelet du père d'arsène » | Inventaire d'arsène (permanent) | Permet de communiquer avec OGUN-0 en sécurité. |
| « Clé USB du Senior » | Bizutage (Semaine 2) | Accès au 2ᵉ étage du bâtiment B. |
| « Badge Dark IAI » | Réputation Dark IAI ≥ 50 | Accès à la Profondeur. |
| « Badge Noyau » | Réputation Dark IAI ≥ 80 + résolution de défis | Accès au Noyau du Dark IAI. |

### 10.3 Tableau des flags narratifs

| Flag | Type | Description | Effet |
|------|------|-------------|-------|
| `hemeryfb_disparition` | Booléen | hemeryfb a disparu (Semaine 11) | Déclenche l'investigation. |
| `ogun0_reveil_partiel` | Booléen | OGUN-0 s'est éveillée (Semaine 13) | Le campus change. |
| `ogun0_fusion` | Booléen | hemeryfb a fusionné avec OGUN-0 (Semaine 15) | Boss final déclenché. |
| `mere_arsene_trouvee` | Booléen | La mère d'arsène a été localisée | Affecte la fin. |
| `mere_arsene_restored` | Booléen | La mère d'arsène a été restaurée | FIN 3 ou FIN 4 uniquement. |
| `ananzi_trouve` | Booléen | Ananzi a été retrouvé dans le code | FIN 4 uniquement. |
| `conseil_confronte` | Booléen | Le Conseil d'administration a été confronté | FIN 4 uniquement. |
| `virus_neutralise` | Booléen | Le virus d'hemeryfb a été neutralisé | FIN 3 ou FIN 4. |

### 10.4 Matrice de compatibilité des fins

| FIN | Conditions minimales | Conditions idéales |
|-----|----------------------|-------------------|
| **FIN 1 : Obsolète** | 3 burnouts OU tous les liens < 20 OU fuir l'IAI | Aucune condition spécifique — c'est l'échec. |
| **FIN 2 : Bug Corrigé** | `REL_Hemeryfb` < 76 + choisir de détruire | `indice_OGUN_0` ≥ 6, 1 lien ≥ 50 |
| **FIN 3 : Compile Succeed** | `REL_Hemeryfb` ≥ 76 + 2 liens ≥ 50 + cohésion ≥ 50 + pas trahir hemeryfb | `REL_Hemeryfb` ≥ 80, tous les liens ≥ 60, 3 secrets partagés |
| **FIN 4 : Source Code** | TOUTES les conditions de la FIN 3 + `indice_OGUN_0` ≥ 12 + `indice_mere_arsene` ≥ 5 + accès Noyau + stats élevées | Tout au maximum |

### 10.5 Flux de jeu complet (arbre simplifié)

```
Semaine 0 (Intro)
  │
  ├─→ Semaine 1 (Quiz)
  │     │
  │     ├─→ Semaine 2 (Bizutage)
  │     │     │
  │     │     ├─→ Semaine 3 (Marathon code)
  │     │     │     │
  │     │     │     ├─→ Semaine 4 (Panne réseau) ──→ Dark IAI
  │     │     │     │     │
  │     │     │     │     └─→ Semaine 5 (Premier Examen) ──→ PNR-1
  │     │     │     │           │
  │     │     │     │           ╠══════════════════════════════════════╗
  │     │     │     │           │         ACTE II                     ║
  │     │     │     │           │                                     ║
  │     │     │     │           ├─→ Semaine 6 (Fête)                  ║
  │     │     │     │           │     │                               ║
  │     │     │     │           │     ├─→ Semaine 7 (Conflit)         ║
  │     │     │     │           │     │     │                         ║
  │     │     │     │           │     │     ├─→ Semaine 8 (Cauchemars)╠═ PNR-2
  │     │     │     │           │     │     │     │                   ║
  │     │     │     │           │     │     │     ├─→ Semaine 9 (Code)║
  │     │     │     │           │     │     │     │     │             ║
  │     │     │     │           │     │     │     │     └─→ Sem 10   ╠═ PNR-3
  │     │     │     │           │     │     │     │           │       ║
  │     │     │     │           │     │     │     │     ╔═════════════╝
  │     │     │     │           │     │     │     │     │   ACTE III
  │     │     │     │           │     │     │     │     │
  │     │     │     │           │     │     │     │     ├─→ Sem 11 (Disparition)
  │     │     │     │           │     │     │     │     │     │
  │     │     │     │           │     │     │     │     │     ├─→ Sem 12 (Retour)
  │     │     │     │           │     │     │     │     │     │     │
  │     │     │     │           │     │     │     │     │     │     ├─→ Sem 13 (Éveil) ╠═ PNR-4
  │     │     │     │           │     │     │     │     │     │     │     │
  │     │     │     │           │     │     │     │     │     │     │     ├─→ Sem 14 (Hackathon)
  │     │     │     │           │     │     │     │     │     │     │     │     │
  │     │     │     │           │     │     │     │     │     │     │     │     ├─→ Sem 15 (Trahison) ╠═ PNR-5
  │     │     │     │           │     │     │     │     │     │     │     │     │     │
  │     │     │     │           │     │     │     │     │     │     │     │     │     └─→ Sem 16 (Finale)
  │     │     │     │           │     │     │     │     │     │     │     │     │           │
  │     │     │     │           │     │     │     │     │     │     │     │     │     ├─→ FIN 1: Obsolète
  │     │     │     │           │     │     │     │     │     │     │     │     │     ├─→ FIN 2: Bug Corrigé
  │     │     │     │           │     │     │     │     │     │     │     │     │     ├─→ FIN 3: Compile Succeed
  │     │     │     │           │     │     │     │     │     │     │     │     │     └─→ FIN 4: Source Code
```

### 10.6 Résumé des conditions par fin

#### FIN 1 : « Obsolète »
```
3 burnouts OU
tous les liens < 20 OU
fuir l'IAI OU
3 boss ratés consécutivement OU
notes < 10 pendant 2 semaines
```

#### FIN 2 : « Bug Corrigé »
```
REL_Hemeryfb < 76
+ choisir "Détruire" (Semaine 16)
+ au moins 1 lien ≥ 50
+ indice_OGUN_0 ≥ 6
```

#### FIN 3 : « Compile Succeed »
```
REL_Hemeryfb ≥ 76
+ choisir "Sauver" (Semaine 16)
+ au moins 2 liens ≥ 50
+ cohesion_groupe ≥ 50
+ 3 secrets partagés
+ pas trahir hemeryfb (Semaines 11-12)
+ indice_OGUN_0 ≥ 8
```

#### FIN 4 : « Source Code »
```
TOUTES les conditions de la FIN 3
+ tous les liens ≥ 80
+ REL_Hemeryfb ≥ 90
+ indice_OGUN_0 ≥ 12 (tous les fragments)
+ indice_mere_arsene ≥ 5 (tous les indices)
+ dark_iai_niveau = 3 (Noyau)
+ STAT_Logique ≥ 80 ET STAT_Creativite ≥ 70
+ Salle 404 trouvée
+ bracelet déchiffré
+ Ping rencontré (bon dialogue)
+ notes d'Ananzi lues
+ pas trahir hemeryfb
+ choisir "Comprendre" (Semaine 16)
```

---

> *Ce document est la boussole narrative d'IAI Survivors. Chaque choix, chaque chemin, chaque fin y est consigné. C'est le squelette sur lequel la chair du jeu se construit. Que chaque joueur trouve son propre chemin dans ce labyrinthe de code et d'amitié.*

> *Le code est la magie moderne. Mais la magie, c'est aussi de savoir écouter.*

> *— Rédigé pour IAI Survivors, Version 1.0*
> *Date : Juillet 2026*
> *Classification : CONFIDENTIEL — Arbre Narratif*
