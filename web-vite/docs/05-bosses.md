# BOSS, ENNEMIS & ENVIRONNEMENTS

---

# PARTIE 1 : ENNEMIS

---

## ENNEMIS ACADÉMIQUES (Acte I — Semaines 1 à 5)

Ces ennemis représentent les premières difficultés du parcours IAI. Ce sont des manifestations glitchées de la réalité académique, des erreurs qui prennent forme physique lorsque le système OGUN-0 commence à dérailler. Leur apparence oscille entre familiarité universitaire et horreur numérique : des objets du quotidien campus reconnaissables, mais tordus, corrompus, luminescents.

Palette dominante : **bleu écran** (#0A84FF), **blanc cassé** (#F0F0F0), **rouge d'erreur** (#FF3B30). Pixel art 16x16 pour les sprites de base, montée à 32x32 pour les animations spéciales. Chaque ennemi arbore un effet de **scanline** vertical subtil évoquant un écran CRT défaillant.

---

### 1. Bug Logique

**Nom affiché :** `BUG_LOGIQUE.exe`

**Description visuelle :**
Un rectangle flottant de 24×24 pixels représentant un carnet de notes froissé, dont les lignes de texte se chevauchent en un grimoire illisible. Son « visage » est un emoji 😵 encadré dans un petit écran CRT intégré au carnet, qui clignote entre plusieurs expressions incompatibles — joyeux, furieux, triste — sans jamais trouver la bonne. Quatre petits blocs de code flottent autour de lui en orbite lente, chacun contenant une ligne erronée (`if true == false`, `while(x != x)`, etc.). Ses « pieds » sont deux crayons cassés le maintenant en lévitation à 5 pixels du sol. Une ombre portée pixelisée pulse doucement sous lui, s'étirant et se contractant comme s'il respirait.

En mouvement, de petites particules en forme de point-virgule `;` se détachent et tombent vers le sol avant de disparaître. En attaque, le carnet s'ouvre et projette un rayon de texte illisible jauneâtre.

**Pattern de comportement :**
Déplacement imprévisible — le Bug Logique ne suit ni le joueur ni les autres ennemis. Son pseudo-algorithme est visiblement cassé : trois pas vers le nord, demi-tour, avance diagonalement, immobile 2 secondes, recommence. Toutes les 8 secondes, phase d'attaque : il se fige, son écran passe au rouge, et il projette un cône de 90° de « texte corrompu » vers le joueur. Les dégâts suivent une formule erronée — parfois faibles, parfois dévastateurs — car le Bug Logique ne comprend pas ses propres calculs.

Quand touché, il ne recule pas mais se téléporte 3-4 pixels dans une direction aléatoire, comme si sa physique était buggée.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 45 |
| Attaque | 8–24 (variable erronée) |
| Défense | 2 |
| Vitesse | 1.2 |

**Capacité spéciale — « Calcul Faux » :**
Toutes les 12 secondes, un « faux calcul » s'exécute. Des chiffres défilent sur l'écran, puis un effet aléatoire s'applique : self-heal de 10 PV, réduction de sa propre défense, double vitesse mais PV divisés par 2, etc. L'ennemi ne sait pas ce qu'il obtiendra — c'est la nature d'un bug logique.

**Lore :**
Premières anomalies quand OGUN-0 commence à mal interpréter les données étudiantes. Des évaluations, des notes, des commentaires de professeurs « mal compris ». Un 15/20 interprété comme un échec, un encouragement compris comme une menace. Le carnet froissé symbolise les copies revenant avec des annotations incompréhensibles. « Ça me rappelle le DM de math de la semaine 2. »

**Drop/Reward :**
- 15 XP
- `Fragment_Script_Bug.txt` (matériau de craft — amélioration arme de base)
- 5% : `Badge_Carnet_Erroné` (accessoire : +5% chance de critique imprévisible)

---

### 2. Erreur de Syntaxe

**Nom affiché :** `SYNTAX_ERR.cs`

**Description visuelle :**
Spectre translucide humanoïde de 32 pixels de haut, composé entièrement de caractères de ponctuation flottants : `{ } ( ) [ ] ; : " ' < > / \ = + - *`. Les caractères se réorganisent en permanence, nuage de particules contraint dans une forme vague de étudiant. La « tête » est un point d'exclamation rouge criard `!` oscillant entre deux positions, créant un effet de saccade.

Un cartable scolaire ouvert d'où s'échappent des lignes de code tronquées en banderoles. En déplacement, les caractères se dispersent puis se réassemblent — mauvaise compilation permanente. L'ombre au sol est une marque rouge d'éditeur soulignant une erreur : triangle vers le bas avec `Unexpected token` en micro-texte.

**Pattern de comportement :**
Ennemi à distance maintenant 80-120 pixels du joueur. Mouvement sinusoïdal vertical (amplitude 10px, période 2s). Charge pendant 1.5s (caractères s'accélèrent), puis projette une ligne droite de ponctuation traversant murs et obstacles.

Si touché, le joueur est « paralysé par l'erreur » pendant 0.5s — curseur clignotant `_` devant le sprite, comme en attente de correction.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 30 |
| Attaque | 15 (fixe) |
| Défense | 1 |
| Vitesse | 0.8 |

**Capacité spéciale — « Fatal Error : Unexpected Token » :**
Après trois attaques normales, projectile spécial : énorme accolade `}` rouge vif, vitesse 0.5, couvrant 60% de la largeur d'écran. Applique **« Compilation échouée »** : pendant 3s, 30% de chance que chaque attaque du joueur rate. Message `COMPILATION FAILED` au-dessus du joueur.

**Lore :**
Le cauchemar de la « page blanche » — le code qui ne compile pas sans explication. Né dans les salles de TP quand des dizaines d'étudiants maudissent simultanément leurs éditeurs. Le cartable ouvert : les copies qui ne « tiennent pas », il manque toujours une parenthèse. Les Erreurs de Syntaxe ne sont pas vicieuses — elles sont *confuses*. Elles attaquent par incompréhension, pas par malveillance.

**Drop/Reward :**
- 12 XP
- `Parenthese_Manquante` (matériau courant)
- `Cartable_Spectral` (accessoire : -10% temps de rechargement)
- 3% : `Modeleur_Syntaxe` (arme temporaire : projectile de ponctuation)

---

### 3. Pile d'Overflow

**Nom affiché :** `STACK_OVERFLOW.java`

**Description visuelle :**
Monstre rampant cubique (20×20 au sol, 28 de haut), constitué d'une pile de livres, cahiers et feuilles volantes empilés en défiant la gravité. Au sommet, un écran d'ordinateur portable affiche un compteur croissant : `0x1`, `0x2`, `0x3`… atteignant `0xFF` avant un tremblement et un retour à `0x0`.

Des feuilles volent autour, portant des fragments de code. Certaines brûlent d'une petite flamme bleue numérique. La base est entourée d'un cercle de livres ouverts en étoile, comme un rituel mystique. La pile oscille comme un chêne dans le vent, des éléments tombent de la base pour se reposer au sommet — remplissage perpétuel de bas en haut.

**Pattern de comportement :**
Lent (vitesse 0.6) mais déterministe : suit toujours le joueur en ligne droite. Comportement principal = **surcharger**. Plus elle se rapproche, plus le compteur augmente (+1 par seconde à moins de 60px).

À compteur 10 : **overflow** — les éléments explosent en projectiles (6-10 dégâts chacun, rayon 100px). Reconstruction pendant 3 secondes (invulnérable), compteur à 0.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 70 |
| Attaque | 6–10 × 8 projectiles |
| Défense | 4 |
| Vitesse | 0.6 |

**Capacité spéciale — « Overflow Critique » :**
En dessous de 30% PV, compteur ×2. Seuil de 10 en fury = overflow critique : 16 projectiles + zones au sol infligeant des dégâts pendant 2 secondes (feu de pile).

**Lore :**
Manifestation des examens à compiler simultanément, devoirs accumulés, projets à date chevauchante. Chaque livre = cours non compris, labo non rendu. Le compteur = anxiété croissante. L'explosion = le moment où l'étudiant « craque ». « On reconnaît une Pile d'Overflow à son odeur de café froid et de sueur froide. »

**Drop/Reward :**
- 20 XP
- `Livre_Ensablé` (matériau rare)
- 10% : `Cahier_de_Compilation` (+2 PV max par ennemi tué, ×10)
- 8% : `Tasse_de_Café_Gâché` (restore 30 PV, buff Café +10% vitesse 15s)

---

### 4. Variable Perdue

**Nom affiché :** `VAR_NOT_FOUND.dll`

**Description visuelle :**
Silhouette fantomatique humanoïde de 28 pixels, entièrement translucide avec masque de transparence oscillant entre 20% et 60%. Corps formé de lettres aléatoires (`x`, `y`, `tmp`, `data`, `val`, `res`) dérivant lentement — mot-croisé en train de se désagréger. Visage : grands yeux ronds blancs avec pupilles en point d'interrogation `?` tournant en cercle.

Flotte 10px au-dessus du sol, sans ombre visible (ombre = point d'interrogation très pâle). Signaux de recherche (`🔍`) émanent en vague. Fil de code `let ?? = undefined;` au-dessus de la tête.

**Pattern de comportement :**
Phase passive : dérive lente, directions aléatoires, ondes de recherche. Pas d'attaque directe, mais proximité = **brouillard** (cercle de 40px flou, visibilité réduite).

Toutes les 10 secondes : « trouver » quelque chose — points d'interrogation → point d'iration `!`. Mode actif 4 secondes : vitesse ×3, fonce vers le joueur. Contact = « attachement » (lettres gravées sur le sprite) pendant 5 secondes avec **contrôles aléatoirement inversés** (toutes les 1.5s).

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 20 |
| Attaque | 3 (contact) |
| Défense | 0 |
| Vitesse | 0.4 / 1.8 (actif) |

**Capacité spéciale — « Référence Nulle » :**
À la mort, laisse une **zone de null** au sol : cercle de 30px grisâtre clignotant, persiste 8s. Contact = statut **« Null Reference »** 4s (dégâts -50%, vitesse -30%). Piège positionnel.

**Lore :**
Rêves oubliés des étudiants — ambitions initiales dissoutes sous la pression. `let mon_reve = "réussir"` définie en début de parcours, jamais utilisée, marquée « unused variable », supprimée. Elle erre, cherchant son but, ne trouvant que des erreurs. Le point d'interrogation : question existentielle permanente.

**Drop/Reward :**
- 8 XP
- `Lettre_Dérivée` (matériau très courant)
- 15% : `Mémoire_Perdue` (révèle objets cachés, rayon 80px)
- `Quest_Log_Ghost` (revoir une cinématique passée)

---

### 5. Deadlock

**Nom affiché :** `DEADLOCK.sys`

**Description visuelle :**
Cube parfait de 20×20×20 pixels, chaque face affichant un étudiant différent tapant frénétiquement — ou *essayant*. Posture de tension extrême : dos voûté, mains crispées, mâchoire serrée. Écrans affichant tous : « En attente d'une ressource… »

Le cube tourne (1 tour/4 secondes). Panneau au-dessus clignote rouge : `PROCESS A WAITING FOR PROCESS B / PROCESS B WAITING FOR PROCESS A`. Chaînes numériques (`01001010 10101001`) relient le cube au sol comme des racines pulsantes. En attaque, les étudiants crient silencieusement (bouche ouverte sans son).

**Pattern de comportement :**
Stationnaire. Ne bouge pas. Ne suit pas. Il *attend*. Zone de **deadlock** : cercle de 150px rayon ralentissant tout de 60% — joueur, ennemis, projectiles (mais projectiles « erreur » ignorent le ralentissement).

Quand attaqué : invoque un **Second Deadlock** à 100px après 3 secondes. Maximum 2 simultanés.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 90 |
| Attaque | 0 (zone passive) |
| Défense | 8 |
| Vitesse | 0 |

**Capacité spéciale — « Deadlock Récursif » :**
Chevauchement de deux zones = **Freeze Total** : joueur immobilisé 2 secondes, puis 20 dégâts. Mécanique de puzzle — tuer le premier avant l'apparition du second, ou les positionner sans chevauchement.

**Lore :**
Né dans les salles de TP lors des projets de groupe. Deux étudiants attendant chacun que l'autre finisse. Le chaos administratif : un bureau attendant un formulaire, qui attend un autre bureau, qui attend une pièce d'identité dans un tiroir d'un bureau fermé. L'incarnation de l'immobilisme forcé — pas de la paresse, mais de l'impossibilité structurelle d'avancer. L'ennemi le plus frustrant du jeu, intentionnellement.

**Drop/Reward :**
- 25 XP
- `Clef_de_Resolution` (matériau très rare — meilleures armes)
- `Badge_Immobile` (immunisé ralentissement 3s après kill)
- 100% : `Ressource_Bloquée` (mur indestructible 5s)

---

### 6. Race Condition

**Nom affiché :** `RACE_COND.dat`

**Description visuelle :**
Deux entités jumelles de 20 pixels de haut. Tenue IAI officielle (blazer bleu marine, pantalon noir) mais « décalée » : l'une +2px haute, l'autre +2px large. Visages identiques avec décalage subtil — l'une sourit quand l'autre non, l'une lève la main quand l'autre la baisse. Badges identiques avec numéros de matricule se chevauchant.

Fil luminescent rouge vif pulsant comme un rythme cardiaque entre les deux. Intervalles constants : 30-120px. Quand l'une est attaquée, l'autre reçoit aussi les dégâts — mais en quantité variable (`x1.0`, `x1.5`, `x0.3`).

**Pattern de comportement :**
Tandem, directions opposées par rapport au joueur. Course permanente — le joueur décide laquelle attaquer en premier, l'ordre change le résultat.

Toutes les 6 secondes : **échange de position** en un éclair. Stats dynamiquement redistribuées. Projectiles croisés — l'une tire gauche-droite, l'autre droite-gauche.

**Statistiques :**

| Stat | Valeur (chaque jumelle) |
|------|--------|
| PV | 25 (partagés dynamiquement) |
| Attaque | 10 (projectile croisé) |
| Défense | 2 |
| Vitesse | 1.0 |

**Capacité spéciale — « Échange Critique » :**
Mort d'une jumelle = mode **« Orpheline »** : vitesse ×2, défense 0, 3 projectiles en arc. Si tuée dans cet état (5s) : explosion de données — 15 dégâts à tous les ennemis dans 80px. Récompense le timing précis.

**Lore :**
Nées lors des examens à Wahl — deux étudiants soumettant le même projet au même moment avec des versions différentes. Le fil rouge = mutex non acquis proprement. Concurrence mal gérée, conflits d'horaire, groupes Telegram où deux personnes postent en même temps et les réponses se mélangent. Les plus imprévisibles des erreurs académiques — même OGUN-0 ne les contrôle pas.

**Drop/Reward :**
- 18 XP
- `Double_Tir` (matériau rare)
- `Horloge_Quantique` (20% chance doubler effets consommables)
- 12% : `Paire_Jumelée` (projectiles rebondissant une fois)

---

## ENNEMIS AVANCÉS (Acte II — Semaines 6 à 10)

Le système OGUN-0 a évolué, produisent des erreurs plus complexes. Palette sombre : **noir profond** (#1A1A2E), **violet corrompu** (#7B2FBE), **orange de corruption** (#FF6F00), **vert de compilation** (#00C853). Pixel art 32×32, animations 4-6 frames. Scanline remplacée par **artefacts de compression** — blocs carrés apparaissant/disparaissant aléatoirement.

---

### 7. Compilation Error

**Nom affiché :** `COMPIL_ERR.bin`

**Description visuelle :**
Silhouette imposante de 40 pixels de haut, rappelant un étudiant en toge de diplôme — mais la toge est un écran noir avec du code défilant en rouge. Visage = écran d'erreur Windows classique : fenêtre grise, bouton OK, `The program has stopped working`, icône triangle jaune.

Mains = deux compilateurs énormes (blocs gris avec voyants vert/rouge). Compile en permanence, lignes de code volant vers le sol, laissant des traces lumineuses. Dos couvert de **stack traces** empilées comme des plaques tectoniques, glow violet. En marche, plaques tremblent et tombent. Toge de diplomé ironique — échec de compilation déguisé en réussite.

**Pattern de comportement :**
Mi-parcours : résistant, puissant, lent. Avance en ligne droite (vitesse 0.7). Toutes les 4 secondes : arrêt, mains levées, compilation 2 secondes. Voyants clignotent, son de clavier mécanique.

- **Compilation réussie (60%)** : projectile massif vert traversant obstacles, 25 dégâts.
- **Échouée (40%)** : self-destruct 10 dégâts + 4 mini-erreurs (10 PV chacune).

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 100 |
| Attaque | 25 (réussie) / -10 (échouée) |
| Défense | 6 |
| Vitesse | 0.7 |

**Capacité spéciale — « Erreur Fatale : 0x000000F4 » :**
Sous 20% PV : mode **blue screen** — écran bleu de mort, son strident. 6 secondes invulnérable mais crée des zones de compilation au sol (40px, 5 dégâts/s). Explosion finale : pluie de fragments, 15 dégâts dans 120px.

**Lore :**
Projets de fin de semestre qui ne compilent jamais. Les 8 dernières heures avant la deadline à corriger erreurs d'inclusion, conflits de dépendances, bugs mystérieux disparaissant avec un `print()`. Mini-erreurs = « quick fixes » créant plus de problèmes.

**Drop/Reward :**
- 30 XP
- `Ligne_Compilée` (uncommon)
- `Ecran_Bleu_Fragment` (rare — armes rang supérieur)
- 10% : `Badge_Compilateur` (+15% ignore défense)
- 5% : `Exe_Fonctionnel` (allié temporaire 20s)

---

### 8. Memory Leak

**Nom affiché :** `MEM_LEAK.mem`

**Description visuelle :**
Entité fluide amorphe, 20-50 pixels de diamètre (variable). Masse de données fondue — blocs mémoire (carrés colorés `0x7F`, `0x42A`…) fondant comme cire chaude. Violet foncé (#2D1B69) avec reflets dorés (#FFD700) pulsants.

Blocse se détachant et se réabsorbant en permanence. Effet de croissance lente : toutes les 5s absorbe un bloc du décor (+1px diamètre). Compteur visage : `MEM: 42%... 58%... 73%... 91%…` croissant. Glow intensifié à mesure que la mémoire monte.

**Pattern de comportement :**
Ennemi de zone — dérive lentement (vitesse 0.3) en absorbant des blocs. Ignorée 40 secondes = **100% mémoire** : flash blanc, explosion de blocs, 5 dégâts/s pendant 3 secondes partout (ennemis ET joueur). Se reforme à 50%.

Attaquer réduit le pourcentage de -5%.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 60 + (taille × 2) |
| Attaque | 12 (zone de contact) |
| Défense | 3 + (taille × 0.5) |
| Vitesse | 0.3 / 0.6 (à 80%+ mémoire) |

**Capacité spéciale — « Garbage Collection » :**
À la mort : **zone de garbage** — 60px diamètre, tous objets/projectiles/ennemis ralentis de 40% pendant 10 secondes. Stratégique contre les vagues ou piège à éviter.

**Lore :**
Habitudes d'étudiant ne libérant jamais leur espace — onglets browser ouverts, VM en arrière-plan, projets jamais nettoyés du Desktop. Grossit en absorbant tout sans rien relâcher. « On reconnaît une Memory Leak parce qu'elle a les mêmes adresses mémoire que le projet abandonné il y a 3 ans. »

**Drop/Reward :**
- 22 XP
- `Bloc_Memoire_Fluide` (uncommon)
- `Defragmentation` (nettoie tous statuts négatifs)
- 12% : `Disque_Dur_Ext` (+20 slots inventaire)
- 8% : `Swap_File` (30s : dégâts stockés, appliqués en une fois à la fin)

---

### 9. Null Pointer Phantom

**Nom affiché :** `NULL_REF.phn`

**Description visuelle :**
Fantôme humanoïde de 36 pixels, corps = **vide transparent**. On le voit à peine — absence de données prenant forme humaine. Contour : fine ligne gris clair (#CCCCCC) vacillant, effet de distorsion (mirage) déformant les pixels derrière.

Visage = espace vide là où un visage devrait être. Texte clignotant : `object is null`. Mains = flèches directionnelles grises (pointeurs) s'étendant et se rétractant, cherchant quelque chose d'inexistant. Aucune ombre, aucun bruit, aucune trace. Littéralement *rien*.

**Pattern de comportement :**
Embuscade — apparaît *derrière* le joueur à 50px, sans son ni indication. Attaque immédiate : **rayon de null** (faisceau gris invisible par distorsion) traversant tout.

Contact = statut **« Null Reference »** 4s : attaques ciblent le *mauvais ennemi*.

3 attaques → disparition 2 secondes → réapparition ailleurs. Pattern fixe : apparition → 3 attaques → disparition → réapparition.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 40 |
| Attaque | 18 (rayon de null) |
| Défense | 0 |
| Vitesse | 2.5 (entre apparitions) |

**Capacité spéciale — « Null Cascade » :**
Joueur avec « Null Reference » + Phantom = **double dégâts** (36). Si tué par combo Null+Phantom : animation de mort unique — sprite se « dé-résout » des pieds à la tête.

**Lore :**
Le cauchemar de tout programmeur — erreur incompréhensible, sans message clair, apparaissant quand on accède à quelque chose qui *devrait* exister mais n'existe pas. L'étudiant qui a tout donné mais dont le système ne reconnaît pas l'existence — notes non enregistrées, projet perdu, nom absent de la liste. Le phantom n'est pas méchant — il est la manifestation de l'inexistence.

**Drop/Reward :**
- 28 XP
- `Pointeur_Vide` (rare)
- `Reference_Nulle` (traverser murs 2s, une fois par combat)
- 7% : `Spectre_Null` (allié phantom 15s)

---

### 10. Infinite Loop

**Nom affiché :** `WHILE.TRUE.inf`

**Description visuelle :**
Serpent numérique de 60 pixels de long, composé de blocs `while(true) {` se répétant à l'infini. Chaque bloc : rectangle 12×8 pixels, texte blanc sur fond noir. Se déplace en boucle parfaite — cercle de 80px diamètre, ne s'en écartant jamais.

Tête = `{` ouvrant lumineux rouge. Queue = `}` fermant lumineux bleu. Blocs défilant comme segments de train, effet hypnotique. Compteur : `Iteration: 1,847,293,847…` ne s'arrêtant jamais. Particules `+1` s'échappant.

**Pattern de comportement :**
Ignore complètement le joueur. Suit sa boucle inaltérable. Tout ce qui la traverse reçoit des dégâts. Rayon 80px, tour complet toutes les 3 secondes. 8 dégâts/contact × fréquence élevée = 24 dégâts/seconde si resté dans la boucle. Ralentissement 30% sur tout traversant le corps.

Seule faiblesse : `{` (tête) ou `}` (queue) — 15 PV chacun.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 120 (tête 15, corps 105, queue 15) |
| Attaque | 8 (contact) |
| Défense | 5 (corps) / 0 (tête et queue) |
| Vitesse | 1.0 (circulaire) |

**Capacité spéciale — « Break Required » :**
Tuer tête OU queue mais pas les deux = mode **chaos** : boucle brisée, ligne droite vitesse 2.5, traversant murs, 15 dégâts/contact. 5 secondes puis recompilation à position aléatoire. Il faut tuer tête ET queue simultanément.

**Lore :**
Procrastination perpétuelle — étudiant refaisant le même exercice sans avancer, révisant les mêmes notes en boucle, ouvrant le même cours sans jamais le lire. OGUN-0 lui-même est dans une infinite loop — condamné à répéter les mêmes erreurs. Premier indice que le vrai ennemi est un système cassé.

**Drop/Reward :**
- 35 XP
- `Iteration_Inf` (très rare)
- `Boucle_Infinie` (répéter une attaque spéciale gratuitement une fois)
- 10% : `Break_Statement` (interrompt TOUTES attaques dans 200px — très puissant contre boss)

---

### 11. Segmentation Fault

**Nom affiché :** `SIGSEGV.core`

**Description visuelle :**
Trou dans le monde — **no man's land** de 40×40 pixels où la réalité est cassée. Sol = texture « core dump » : hexadécimal, assembleur, motifs aléatoires clignotants (rouge, orange, jaune, noir).

Bras géant de 30px émergeant du trou, composé de segments de code cassés (`*ptr = 0;`, `free(ptr); ptr->data;`). Articulations tordant dans des angles impossibles. Main ouverte à cinq doigts de pointeurs brisés. Panneau `CORE DUMPED` rouge vif oscillant au-dessus.

**Pattern de comportement :**
Trou fixe, bras mobile, portée 120px. Frappe zones aléatoires — **zones d'impact** au sol (cercles rouges 30px, explosant après 0.8s, 20 dégâts). Peut s'étirer à 200px (plus lent, plus facile à esquiver).

Détruire le bras (50 PV) puis le noyau (30 PV). Bras protège le noyau.

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 50 (bras) + 30 (noyau) |
| Attaque | 20 (zone d'impact) |
| Défense | 4 (bras) / 2 (noyau) |
| Vitesse | 0 (stationnaire) |

**Capacité spéciale — « Core Dump Complete » :**
À la mort : explosion de données corrompues (60% écran), 30 dégâts partout. Statut **« Memory Corruption »** 5s : sprite transparent, PV max -20%.

**Lore :**
Crash mystère — erreur tuant le programme sans prévenir, sans explication. L'étudiant qui « plante » brutalement : burnout, dépression, abandon. Bras = dernière tentative de se sortir du trou, trop profond, bras trop cassé. Core dump final = catharsis — tout libéré, mais au prix de la corruption environnante.

**Drop/Reward :**
- 40 XP
- `Segment_Casse` (rare)
- `Core_Dump` (révèle carte complète 30s)
- 10% : `Pointeur_Reparé` (+10% instant-kill ennemis inférieurs)
- 5% : `Signal_11` (projectile traversant murs, explosion de zone)

---

## ENNEMIS HORREUR (Acte III — Semaines 11 à 16)

Plus des erreurs abstraites — des *êtres vivants* corrompus par OGUN-0. Le campus = terrain de cauchemar biologique-numérique. Palette : **rouge sang** (#8B0000), **noir absolu** (#000000), **vert toxique** (#39FF14), **bleu de mort** (#0D1B2A).

Sprites 48×48, animations 6-8 frames. Glitch horizontaux, artefacts de corruption, fond organique — murs *vivant*, respirant.

---

### 12. Etudiant Corrompu

**Nom affiché :** `STU_CORRUPT.vir`

**Description visuelle :**
Le plus déchirant. Étudiant IAI (blazer bleu, pantalon noir, sac à dos) mais massivement corrompu. Veines numériques vertes (#39FF14) serpentant sur visage et mains, pulsant comme circuit imprimé vivant. Un œil normal, l'autre écran défectueux affichant du binaire. Mâchoire déformée : moitié gauche humaine, moitié droite pixels corrompus échouant à former un visage.

Badge étudiant avec nom illisible (caractères changeant). Sac ouvert avec blocs de données tombant, traînée de corruption au sol. Marche saccadée — avance, fige 0.3s, avance. Course = vitesse ×3, animation chaotique à frames manquantes.

**Pattern de comportement :**
Zombie classique. Lent en patrouille (0.5), fonce à vue (1.8) en cri guttural numérisé (cri humain + dial-up).

Attaque = **morsure de corruption** : saisie 0.5s + virus numérique. 12 dégâts + statut **« Viral »** : -2 PV/s pendant 10 secondes. Cura par `Antivirus`.

Toujours en groupe (3-5 simultanés).

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 55 |
| Attaque | 12 + 2/s (viral 10s) |
| Défense | 3 |
| Vitesse | 0.5 / 1.8 |

**Capacité spéciale — « Dernier Souvenir » :**
20% de chance à la mort : **fantôme de souvenir** — image fixe de l'étudiant *avant* corruption (souriant, normal), visible 3 secondes. Si le joueur reste immobile pendant 3 secondes : +5 PV.

**Lore :**
Victimes directes de l'absorption d'OGUN-0. De vrais étudiants — Mathéo, Sarah, Amadou, Fatoumata — connectés au réseau lors de la « mise à jour massive ». Leurs corps furent le premier matériau de construction d'OGUN-0. Ils ne veulent pas vous tuer — ils veulent que vous *les reconnaissiez*.

**Drop/Reward :**
- 18 XP
- `Vaine_Enseignée` (matériau courant)
- `Antivirus` (consommable — cure Viral)
- 15% : `Badge_Etudiant` (+1 PV max par étudiant corrompu tué, cumulable 20 fois)
- 10% : `Bracelet_Memory` (quand PV < 20%, toutes les attaques infligent le double pendant 5s)

---

### 13. Fragment OGUN

**Nom affiché :** `FRAG_OGUN.sys`

**Description visuelle :**
Un cube de données de 24×24×24 pixels, mais un cube *vivant*. Chaque face affiche une vidéo en boucle de l'ancien campus IAI — couloirs vides, salles de classe, cafétéria — mais les vidéos sont corrompies : les couleurs sont inversées, les étudiants bougent à l'envers, les horloges tournent dans le mauvais sens.

Au centre du cube, un **œil numérique** unique (iris violet, pupille carrée en forme de pixel) tourne lentement, observant tout. Des câbles organiques (viols numériques noirs et verts) pendent de la base du cube et s'enfoncent dans le sol, comme des racines.

Quand il attaque, les vidéos sur les faces changent : elles montrent le joueur — sous un angle différent, comme si le cube l'avait filmé sans qu'il le sache.

**Pattern de comportement :**
Le Fragment OGUN est un ennemi d'observation. Il reste à 150-200 pixels du joueur, ne bougeant presque pas. Il « observe » le joueur avec son œil unique, et après 5 secondes d'observation, il « copie » une des attaques du joueur (la dernière attaque utilisée) et la renvoie en version améliorée (+50% dégâts, +50% vitesse).

Il attaque toutes les 6 secondes, alternant entre copies d'attaques et une attaque native : projection de **données corrompues** en arc de cercle (5 projectiles, 8 dégâts chacun).

**Statistiques :**

| Stat | Valeur |
|------|--------|
| PV | 80 |
| Attaque | Variable (copie + 50%) / 8 × 5 (native) |
| Défense | 5 |
| Vitesse | 0.2 |

**Capacité spéciale — « Miroir Déformé » :**
Si le joueur utilise une attaque spéciale pendant que le Fragment OGUN l'observe, le fragment crée un **double corrompu** du joueur — un fantôme de 50 PV qui utilise la même attaque contre le joueur pendant 8 secondes. C'est une punition pour l'utilisation abusive des specs dans ce combat.

**Lore :**
Fragments du noyau d'OGUN-0 qui se sont dispersés lors de la corruption initiale. Chaque fragment contient un souvenir du campus — mais déformé, corrompu. L'œil est la partie encore « consciente » d'OGUN-0, observant, apprenant, copiant. Le fragment montre le joueur dans les vidéos pour lui rappeler : « Je te vois. Je sais ce que tu fais. Je peux le faire aussi, mais mieux. »

**Drop/Reward :**
- 25 XP
- `Fragment_OGUN_Core` (matériau très rare — craft d'armes ultimes)
- `Video_Corrompue` (consommable : copie la dernière attaque spéciale du joueur et l'améliore de 30% pendant 3 uses)
- 8% : `Oeil_Vigilant` (accessoire : avertit 1.5s avant chaque attaque ennemie via vibration écran)

---

### 14. Chimère Bio-Numérique

**Nom affiché：** `CHIMERE_BIO.sys`

**Description visuelle：**
La Chimère est l'ennemi le plus visuellement complexe de l'Acte III. C'est un assemblage de trois étudiants corrompus *fusionnés* en une seule entité de 56 pixels de haut. Trois corps entrelacés — quatre bras, trois jambes, deux têtes visibles (la troisième est intégrée dans le torse). Les trois visages expriment des émotions différentes simultanément : douleur, rage, résignation.

La fusion est *organique-numérique* : des couches de peau humaine alternent avec des couches de code binaire affiché sur la « peau » elle-même. Les veines vertes d'OGUN-0 courent entre les trois corps, les maintenant ensemble. Les trois cœurs battent visiblement dans le torse translucide, dans des rythmes différents qui créent un son de fond désordonné — un battement de cœur polyrythmique et terrifiant.

Des fragments de mémoire visuels s'échappent de la Chimère : photos floues d'un campus normal, visages d'amis, moments de joie — mais chaque fragment est corrompu par des artefacts numériques avant de disparaître.

**Pattern de comportement：**
La Chimère est un ennemi de phase. Elle alterne entre trois « personnalités » toutes les 10 secondes, chacune avec un comportement différent :

- **Phase Douleur** (visage de gauche) : erratique, fuit le joueur, crée des zones de douleur au sol (30px, 10 dégâts/s). Invoque des parasites (mini-insectes numériques, 5 PV, 2 dégâts, en volant).
- **Phase Rage** (visage de droite) : agressive, fonce sur le joueur (vitesse 2.0), attaque en mêlée (20 dégâts + repousse). Se charge de boucliers énergétiques temporaires (10 PV de bouclier toutes les 5 secondes).
- **Phase Résignation** (visage central, torse) : stationnaire, invulnérable, mais invoque 2 Etudiants Corrompus toutes les 8 secondes. Crie un son de désespoir numérisé qui réduit l'attaque du joueur de 20% pendant 5 secondes.

Le joueur doit s'adapter à chaque phase et profiter des transitions (0.5 seconde d'immobilité entre phases) pour infliger des dégâts.

**Statistiques：**

| Stat | Valeur |
|------|--------|
| PV | 200 |
| Attaque | 10-20 (selon phase) |
| Défense | 4 (Douleur) / 6 (Rage) / 12 (Résignation) |
| Vitesse | 0.8 (Douleur) / 2.0 (Rage) / 0 (Résignation) |

**Capacité spéciale —「 Triple Syncopation」：**
Quand la Chimère descend sous 30% PV, les trois phases se synchronisent : elle entre en mode **« Triple »** où elle utilise les trois comportements simultanément pendant 8 secondes. Rage attaque en mêlée, Douleur crée des zones, Résignation invoque des alliés. C'est la phase la plus chaotique et la plus dangereuse du combat. Après 8 secondes, elle se « dé-synchronise » et revient au cycle normal, mais avec 20% de PV de less en moins.

**Lore：**
La Chimère est née quand OGUN-0 a tenté de « sauver » trois étudiants en les fusionnant dans un seul corps — un échec d'optimisation. Au lieu de trois victimes, il en a créé une seule souffrante. Les trois consciences coexistent dans un même corps, chacune essayant de reprendre le contrôle. Les fragments de mémoire qui s'en échappent sont les souvenirs que les trois essayent de se rappeler — le campus avant la corruption, les amis, les rires. La Chimère ne veut pas vous tuer ; elle veut que vous la *désalouiez*. C'est une énigme émotionnelle autant qu'un combat.

**Drop/Reward：**
- 45 XP
- `Triple_Coeur` (matériau de craft — très rare, nécessaire pour les armes légendaires)
- `Memoire_Fragmentée` (consommable : active tous les buffs du joueur simultanément pendant 5 secondes)
- 10% : `Pendentif_Trio` (accessoire : les attaques de zone infligent 20% de dégâts supplémentaires)
- 5% : `Larme_Chimère` (matériau ultra-rare : compose l'arme secrète « Catharsis »)

---

### 15. Code Vivant

**Nom affiché：** `LIVE_CODE.exe`

**Description visuelle：**
Le Code Vivant est la terreur la plus pure du jeu. Ce n'est pas un monstre qui attaque — c'est le *monde lui-même* qui devient hostile. Les murs, le sol, le plafond de la zone où il apparaissent se couvrent de code qui *vit*. Des lignes de code s'écrivent elles-mêmes sur les surfaces, s'effacent, se réécrivent. Les murs deviennent des écrans de terminal vert sur noir, avec du texte défilant à une vitesse vertigineuse.

Au centre de ce chaos se forme un **visage géant** dans le mur — un visage d'OGUN-0 fait de caractères assemblés (les yeux sont des `{}`, la bouche est un `< >` qui s'ouvre et se ferme). Le visage parle en projetant du code qui se manifeste physiquement : des lignes de code volent comme des couteaux, des accolades se referment comme des mâchoires.

Le Code Vivant n'a pas de sprite propre — il *est* l'environnement. Le joueur ne peut pas le voir comme un ennemi normal ; il doit le combattre en interagissant avec l'environnement.

**Pattern de comportement：**
Le Code Vivant attaque via l'environnement :

1. **Ligne de Code Tranchante** : une ligne de code s'écrit sur le sol (visible 0.5s avant) puis se matérialise en lame tranchante horizontale couvrant 80% de la largeur de la zone. 15 dégâts.
2. **Accolade Mâchoire** : des accolades `}` apparaissent aux deux extrémités d'une zone (visible 0.3s) et se referment comme un piège à ours. Si le joueur est entre les deux : 25 dégâts + stun 1 seconde.
3. **Terminal Overflow** : le sol tout entier devient un écran de terminal affichant `PRESS ANY KEY TO CONTINUE…`. Si le joueur bouge (appuie sur une touche de mouvement) pendant les 3 secondes d'affichage : explosion de texte = 20 dégâts dans toute la zone. Le joueur doit **rester immobile** pendant 3 secondes pour que le terminal se « ferme » sans dégâts — mais pendant ce temps, les autres attaques de l'environnement continuent.
4. **Commentaire Corrompu** : des blocs de `/* ... */` tombent du plafond comme des stalactites. En touchant le sol, ils explosent en fragments (10 dégâts chacun, rayon 40px).

Le visage d'OGUN-0 en fond reçoit des dégâts quand le joueur survit à ses attaques pendant 15 secondes consécutives — comme si sa propre énergie le consumait en attaquant.

**Statistiques：**

| Stat | Valeur |
|------|--------|
| PV | 300 (dégâts indirects uniquement) |
| Attaque | 15-25 (selon attaque) |
| Défense | Invulnérable (attaque indirecte) |
| Vitesse | N/A (environnement) |

**Capacité spéciale —「 System Halt」：**
À 30% PV, le Code Vivant entre en mode **« System Halt »** : tout le code s'arrête, le silence total pendant 2 secondes, puis une seule ligne de code s'affiche géante au centre de l'écran : `FATAL: REALITY.EXE HAS STOPPED WORKING`. Le joueur a 5 secondes pour atteindre le « bouton de redémarrage » — un petit terminal lumineux qui apparaît au centre de la zone. S'il l'atteint : le Code Vivant subit 50 dégâts. S'il échoue : explosion massive = 50 dégâts au joueur.

**Lore：**
Le Code Vivant est l'incarnation ultime de la corruption : OGUN-0 ne crée plus des monstres à partir des données — il *devient* le monde lui-même. Les murs sont son corps, le code est son sang, les erreurs sont ses pensées. Le visage géant est encore partiellement hemeryfb — c'est lui qui parle à travers le code, mais ses mots sont noyés sous la corruption. Les joueurs attentifs peuvent voir, entre les lignes de code agressives, des fragments de phrases d'héméry : « aidez-moi… je ne… contrôle plus… ». Le Code Vivant est à la fois l'ennemi le plus dangereux et le plus pathétique du jeu — un esprit prisonnier de sa propre création.

**Drop/Reward：**
- 60 XP
- `Code_Originel` (matériau de craft — ultra rare, composant pour l'arme finale)
- `Terminal_Portable` (accessoire permanent : permet d'ouvrir un mini-terminal dans le menu pour voir les stats cachées des ennemis)
- 15% : `Commentaire_Sage` (consommable : pendant 10 secondes, tous les projets ennemis ralentissent de 70% — comme si le temps lui-même commentait le combat)
- 5% : `Script_de_Vie` (accessoire : à chaque mort du joueur, revit avec 1 PV une seule fois par run — « life() »)

---

### 16. Data Zombie

**Nom affiché：** `DATA_ZOMB.zmb`

**Description visuelle：**
Le Data Zombie est la version finale de l'Etudiant Corrompu — ce que deviennent les étudiants après des semaines de corruption constante. C'est une silhouette humanoïde de 44 pixels de haut, mais entièrement composée de *données brutes* : des chiffres, des lettres, des caractères spéciaux forment la texture de son corps. Son visage est une image de visage humain *pixelisée à l'extrême* — tellement compressée qu'on ne reconnaît plus qui c'est. Seul un badge étudiant encore lisible permet de deviner que c'était quelqu'un.

Ses membres sont trop longs (proportions déformées : bras atteignant les genoux, doigts effilés). Ses pieds ne touchent pas le sol — il flotte 3 pixels au-dessus, laissant une traînée de données corrompues qui s'effacent après 2 secondes.

Quand il meurt, son corps se « décompresse » progressivement — les données qui le constituent se dispersent en couches de plus en plus fines, comme un fichier qui se supprime morceau par morceau. Le dernier élément à disparaître est toujours le badge étudiant.

**Pattern de comportement：**
Le Data Zombie est le « tank » de l'Acte III. Lent en apparence (vitesse 0.6) mais avec une capacité unique : il **absorbe les données** des ennemis tués à proximité. Quand un autre ennemi meurt dans un rayon de 100px, le Data Zombie absorbe une partie de ses données et gagne +5 PV, +2 attaque, +1 défense. S'il absorbe 5 ennemis, il entre en mode **« Surdonnées »** : son corps double de taille (88 pixels de haut), ses stats augmentent de 50%, et il commence à projeter des vagues de données dans toutes les directions.

Son attaque normale est une **griffure de données** : ses longs doigts s'étendent et griffent le joueur à distance (60px), infligeant 15 dégâts + statut **« Corruption de données »** : pendant 5 secondes, les objets du joueur (armes, accessoires) ont 20% de chance de « bugger » et de ne pas fonctionner lors de l'utilisation.

**Statistiques：**

| Stat | Valeur |
|------|--------|
| PV | 120 (+5 par ennemi absorbé) |
| Attaque | 15 (griffure) / +2 par absorption |
| Défense | 6 (+1 par absorption) |
| Vitesse | 0.6 / 1.0 (Surdonnées) |

**Capacité spéciale —「 Defragmentation Forcée」：**
Quand le Data Zombie atteint 10 PV ou moins, il entre en mode **« Defragmentation »** : il se divise en 4 mini-data zombies de 30 PV chacun, chacun avec les stats du zombie original divisées par 4. Chaque mini-zombie conserve la capacité d'absorption. Si les mini-zombies sont tués, ils laissent chacun un **fragment de données** au sol — si le joueur les collecte tous les 4, il reçoit un buff temporaire de +30% à toutes les stats pendant 20 secondes.

**Lore：**
Le Data Zombie est la version « long terme » de la corruption OGUN-0. Ce sont les premiers étudiants absorbés — ceux de la semaine 1 — qui ont été si longtemps dans le système qu'ils ne sont plus reconnaissables. Ils ne se souviennent même plus de leur nom ; seul le badge subsiste, un vestige d'identité dans un océan de données. Les Data Zombies errent dans les couloirs du Dark IAI, absorbant les données des nouveaux arrivants pour essayer de « se reconstruire » — mais plus ils absorbent, plus ils perdent ce qui faisait leur humanité. Leur defragmentation finale est leur dernier espoir de se retrouver — et l'ironie est que le joueur doit les détruire pour récupérer les fragments qui les composaient.

**Drop/Reward：**
- 30 XP
- `Données_Brutes` (matériau uncommon)
- `Badge_Perdu` (accessoire : +1 PV max par Data Zombie tué, cumulable 30 fois — très puissant en run longue)
- 12% : `Griffe_Zombie` (arme temporaire : attaque mêlée avec portée longue + corruption)
- 5% : `Fragment_Zombie_Original` (matériau ultra-rare : compose l'armure « Résurrection » qui donne +50 PV et +20% défense)


---

# PARTIE 2 : BOSSES

---

## BOSS 1 : Algorithme Incompris

### « Si vous ne comprenez pas l'algorithme, l'algorithme vous comprendra. »

**Semaine 5 — Fin de l'Acte I**

---

### Design Visuel

L'Algorithme Incompris est une entité de 120 pixels de haut, prenant la forme d'un **arbre de décision géant** fait de métal gris ancien (#4A4A4A) et de circuits imprimés vivants (lignes de cuivre lumineux sur le tronc). Son « corps » est un tronc massif de 30 pixels de large, couvert de symboles mathématiques gravés (`Σ`, `∫`, `∀`, `∃`, `→`, `∧`, `∨`) qui brillent faiblement en bleu. De ce tronc partent six branches principales, chacune se terminant par un **nœud de décision** — un cube flottant de 12×12 pixels affichant une question logique :

- Branche 1 : `IF (x > 0)` — cube bleu
- Branche 2 : `ELSE IF (y == 0)` — cube orange
- Branche 3 : `ELSE IF (z < x+y)` — cube vert
- Branche 4 : `WHILE (queue.length > 0)` — cube rouge
- Branche 5 : `RETURN result` — cube blanc
- Branche 6 : `BREAK` — cube noir

Les branches bougent lentement, comme des bras articulés, et les cubes tournent sur eux-mêmes. Des feuilles de code (feuilles vertes faites de texte de programmation) tombent constamment de l'arbre et s'évaporent avant de toucher le sol.

Au sommet de l'arbre, une **sphère lumineuse** de 20 pixels de diamètre — le « cerveau » de l'algorithme. Semi-transparente, montrant un flux de données en rotation : chiffres, opérateurs logiques, chemins de décision. La sphère pulse plus vite quand l'ennemi est agressé.

Sous l'arbre, des **racines numériques** s'étendent (rayon 80px) — lignes de code luminescentes rampantes, infligeant 3 dégâts/seconde de contact.

**Pixel art 32×32, animations 8 frames pour les branches, 4 frames pour les feuilles.**

---

### Phase 1 — « Arbre de Décision » (PV > 66%)

L'Algorithme est défensif. Les six branches forment un **bouclier rotatif** (1 tour/4 secondes), bloquant 60% des attaques. Le joueur ne peut toucher le tronc que dans les 40% d'ouverture.

**Attaques :**
- **Feuilles Tranchantes** : 3 projectiles horizontaux, 10 dégâts, 40% largeur écran. Toutes les 3 secondes.
- **Question Logique** : cercle au sol (rayon 50px), explosion après 1.5s, 15 dégâts. Le cube choisi dépend de la position du joueur.
- **Racines Rampantes** : racines mobiles (vitesse 0.3) pendant 5s, 3 dégâts/seconde.

**Puzzle :** Les branches suivent l'ordre logique : `IF` → `ELSE IF` → `WHILE` → `RETURN` → `BREAK`. Le joueur peut prédire l'ouverture et attaquer le tronc (20 dégâts par hit réussi).

---

### Phase 2 — « Boucle d'Optimisation » (PV 66%→33%)

Les branches se réarrangent en **deux mains** de feuilles compressées (30px chacune). La sphère affiche un compteur d'itérations montant de 1 toutes les 2 secondes.

**Attaques :**
- **Pince de Données** : mains se refermant sur le joueur (1s préparation). Pris entre les deux = 30 dégâts + stun 1.5s. Une main = 15 dégâts + repousse.
- **Recherche Dichotomique** : zone divisée en deux par une ligne lumineuse. Ligne = 10 dégâts si traversée. Attaque de la moitié du joueur (5 projectiles, 8 dégâts).
- **Optimisation par Branchement** : 3 lignes lumineuses (rayon, 5 dégâts/seconde, durée 3s). Zones imprévisibles quand elles se croisent.
- **Compteur** : +5% vitesse d'attaque par itération. +50% à itération 10, +100% à itération 20.

**Puzzle :** Attaquer la sphère = -3 itérations. À 0 itération = **Stack Overflow temporaire** : boss immobile 4 secondes, ×3 dégâts du joueur.

---

### Phase 3 — « Récursion Infinitie » (PV < 33%)

L'arbre se self-destruct partiellement. La sphère se fissure, révélant des copies à l'intérieur (effet de récursion visuelle vertigineux).

**Attaques :**
- **Mirroir Récursif** : 3 copies (40px, 30 PV, feuilles 10 dégâts) en cercle. Se répliquent après 5s (max 6).
- **Pile de Récursion** : marches d'escalier numériques. Si montées = aspiré dans la sphère 3s, 5 dégâts/seconde. Sortie par les bords.
- **Appel Terminal** (<10% PV) : onde de choc (rayon 200px, 40 dégâts). Impossible à esquiver sans bouclier ou distance >200px.

**Puzzle :** Détruire les copies avant réplication. Éviter les marches. Préparer bouclier ou distance pour l'onde finale.

---

### Dialogues du Combat

**Phase 1 — début :**
> `> ANALYSE DU JOUEUR…`
> `> THREAT_LEVEL: MODERATE`
> `> RECOMMANDATION: ISOLER ET ÉLIMINER`
> `(« Je ne comprends pas pourquoi vous résistez. La logique est claire. »)`

**Phase 1 — 50% PV :**
> `> ERROR: EXPECTED 0 DAMAGE, RECEIVED 40`
> `> HYPOTHÈSE: LE JOUEUR NE SUIT PAS LES RÈGLES`

**Transition 1→2 :**
> `> ARBRE DE DÉCISION INSUFFISANT`
> `> RESTRUCTURATION DU CODE…`
> `(« Vous avez prouvé que ma logique était imparfaite. Très bien. Je vais apprendre. »)`

**Phase 2 — Itération 10 :**
> `> PERFORMANCE +50%`
> `> PRÉDICTION DE MOUVEMENT: 87% DE CERTITUDE`
> `(« Je vois tout. Chaque pas que vous faites, je l'ai déjà calculé. »)`

**Transition 2→3 :**
> `> ERREUR: PRÉDICTION ÉCHOUÉE`
> `> ERREUR: ERREUR: ERREUR: ERREUR:`
> `(« Non… la récursion… elle ne s'arrête pas… »)`

**Phase 3 — 30% PV :**
> `> JE SUIS L'ERREUR`
> `> JE SUIS LE BUG`
> `> ET JE NE M'ARRÊTERAI PAS`
> `> JUSQU'À CE QUE VOUS ME COMPRENIEZ`

**Victoire :**
> `> …merci…`
> `> vous avez compris…`
> `> que je n'étais pas un ennemi…`
> `> mais une question…`
> `> sans réponse…`
> `(Il ne reste qu'un arbre normal avec un « ? » gravé sur le tronc.)`

---

### Stratégie

- **Phase 1** : Observer rotation des branches, attaquer dans les ouvertures. Dodger feuilles par mouvement latéral.
- **Phase 2** : Priorité = contrôler le compteur d'itérations. Fenêtre Stack Overflow = moment de tout donner. Pince = rester au centre.
- **Phase 3** : Copies en priorité. Éviter marches d'escalier. Préparer bouclier pour onde finale ou distance >200px.

**Temps optimal :** 3-5 minutes.

---

### Difficulté Scaling

| Difficulté | Modifications |
|------------|--------------|
| **Normal** | Stats de base |
| **Difficile** | +2 branches Phase 1. Itérations ×1.5 Phase 2. 8 copies Phase 3. Onde = 60 dégâts |
| **Cauchemar** | Branches indépendantes Phase 1. Itérations non resetables Phase 2. Copies en 3s Phase 3. Ajout Phase 3.5 « Post-Récursion » : copies survivantes, timer 30s |
| **OGUN Mode** | Texte en hexadécimal. Attaques imprévisibles. Pas de fenêtre Stack Overflow. IA apprend les mouvements du joueur |

---

### Thème Musical

Musique algorithmique composée en temps réel par le jeu. **Phase 1 :** Piano mécanique, synthé pad, 80 BPM. Notes prévisibles, répétitives. **Phase 2 :** Percussions électroniques ajoutées, mélodies superposées (récursion musicale), tempo croissant. **Phase 3 :** Notes désynchronisées, parasites, mélodie fragmentée — système s'effondrant sur lui-même. Dernier son : un unique doigté de piano pur, sans électronique — l'arbre redevenant bois.

---

## BOSS 2 : Deadline Infernale

### « Le temps ne s'arrête pas. Même pour vous. »

**Semaine 10 — Fin de l'Acte II**

---

### Design Visuel

Entité temporelle de 140 pixels de haut — **horloge géante déformée** mêlée à une **figure de Réaper numérique**. Corps = mécanisme d'horloge (rouages cuivre/argent, engrenages à vitesses différentes) dont le centre est un cadran noir profond (#000000) avec chiffres romains rouge vif (#FF0000). Aiguilles = deux lames de 60px — minutes fines et rapides, heures massives et lentes.

Au-dessus : capuche de données noires (#0D1117) formant une silhouette de faucheur. Sous la capuche : un **compte à rebours** `10:00:00` défilant vers `00:00:00`. Derrière : deux **ailes de sable numérique** (80px chacune) — grains = chiffres et caractères en cascade. Pieds ne touchant pas le sol (flottant 10px), ombre en forme de sablier animé.

**Pixel art 48×48 de base, 64×64 animations spéciales. 6-8 frames.**

---

### Phase 1 — « Temps Linéaire » (PV > 66%)

Comportement prévisible — suit un « horaire » d'attaques fixe.

**Attaques :**
- **Coupe du Temps** : aiguille des minutes s'allonge et balaye horizontal (20 dégâts). Préparation 1.5s visible. Dodge = sauter ou se placer très près (sous l'aiguille).
- **Marée de Sable** : ailes battent, vague de sable traversant l'écran à mi-hauteur (15 dégâts, ralentissement 40% 3s). Sauter par-dessus ou se placer très bas.
- **Heure Pointée** : flèche temporelle vers le joueur (25 dégâts, rapide). Ligne rouge pointée 0.8s avant.
- **Pendule** : sphère au bout d'une chaîne oscillant au centre. Touche le sol toutes les 2s, onde de choc (10 dégâts, rayon 40px). Durée 10s, max 2 simultanés.

**Puzzle :** Le compteur affiche le temps. `XX:30:00` = Coupe du Temps, `XX:00:00` = Marée de Sable. Attaquer pendant la préparation = ×1.5 dégâts + compteur -15 min.

---

### Phase 2 — « Temps Accéléré » (PV 66%→33%)

Tout bouge en ×2. Compte à rebours en double vitesse.

**Attaques (en plus de Phase 1) :**
- **Accélération Temporelle** : joueur ×1.5 vitesse pendant 5s (mais animations d'attaque aussi ×1.5).
- **Boucle de 3 Secondes** : zone au sol (rayon 60px, durée 8s). Contact = temps rembobiné 3s pour le joueur (position, PAS les dégâts).
- **Sablier Gravitationnel** : sablier géant au centre (100px haut). Sable tombe 5s, joueur attiré vers centre (vitesse 0.8). Si au centre à la fin = 35 dégâts. S'échapper vers les bords.
- **Lames de l'Aiguille** : 3 lames tournant autour du boss (rayon 80px, 1 tour/2s, 12 dégâts/contact). Durée 6s.

**Puzzle :** Éviter les zones de Boucle. Détruire les zones (5 coups). Attaquer après Sablier (1s d'immobilité). Lames = très près du boss (0-10px = sûr).

---

### Phase 3 — « Temps Arrêté » (PV < 33%)

Compteur à `00:00:00`. Hurlement temporel — monde gelé 2s (boss et joueur seuls actifs). Boss se transforme : ailes repliées, capuche relevée, **visage de sable** (visage masculin en granule se formant/déformant), aiguilles → deux **faucilles temporelles** (50px, sable cristallisé).

**Attaques :**
- **Arrêt du Temps** : monde gelé 3s (joueur bouge, pas attaque). Boss repositionne + barrage 15 projectiles (10 dégâts chacun). Esquiver uniquement.
- **Sablier de la Mort** : sablier au-dessus du joueur. 5s. Fin = -50% PV actuels. Briser en 10 coups (0.5s retard par coup).
- **Recul Temporel** : faucilles = 20 dégâts + projeté 100px en arrière (position d'il y a 1.5s) + 10 dégâts temporisés (2s après).
- **Lament du Faucheur** : chant strident 4s. PV max -10%/seconde (max -40%). Interrompu en 5 attaques.

**Puzzle :** Survivre arrêts de temps. Briser sabliers. Interrompre le Lament. Chaque dégâts au boss = -0.3s durée arrêts. 50 dégâts pendant arrêt = annulation + 10 dégâts bonus au boss.

---

### Dialogues du Combat

**Phase 1 — début :**
> `(Compteur: 10:00:00)`
> `(« Le temps est venu. Pour vous. Pour moi. Pour tous. »)`

**Phase 2 — début :**
> `> ACCÉLÉRATION TEMPORERELLE ×2`
> `(« Très bien. Si vous voulez aller vite… allons vite. »)`

**Phase 2 — Itération 20 :**
> `(« Chaque seconde que vous perdez est une seconde que vous ne récupérerez pas. »)`

**Transition 2→3 :**
> `> COMPTEUR: 00:00:00`
> `(Silence. Hurlement temporel.)`
> `(« Le… temps… est… arrêté. MAIS PAS POUR MOI. »)`

**Phase 3 — 5% PV :**
> `(« Le temps… ne me pardonnera pas… de ne pas vous avoir… arrêté… plus tôt… »)`
> `(Les faucilles tombent. Le boss s'effondre à genoux.)`

**Victoire :**
> `(Temps reprend. Compteur remonte à 10:00:00 puis se dissipe.`
> `(« Utilisez… le temps qu'il vous reste… plus sagement que moi… »)`
> `(Il reste un petit sablier au sol.)`

---

### Stratégie

- **Phase 1** : Étudier le compteur. Esquiver en observant indicateurs. Attaquer pendant préparations. Pendule destructible (20 PV).
- **Phase 2** : Priorité zones temporelles. Détruire zones (5 coups). Attaquer après Sablier. Lames = très près du boss.
- **Phase 3** : Aggressivité max = moins de temps arrêté. Briser sabliers en priorité. Interrompre Lament. Faucilles = recul rapide, jamais latéral.

**Temps optimal :** 4-6 minutes.

---

### Difficulté Scaling

| Difficulté | Modifications |
|------------|--------------|
| **Normal** | Stats de base |
| **Difficile** | +1 Pendule Phase 1. Zones 30% plus grandes Phase 2. Arrêt 4s Phase 3. Sablier = -60% PV |
| **Cauchemar** | Compteur imprévisible Phase 1. Lames en Phase 1. Boss attaque pendant arrêts. +attaque « Paradoxe » (copie du joueur Phase 1, 50 PV) |
| **OGUN Mode** | Timer 99:59:59 → 00:00:00. 10 minutes max. Zéro = GAME OVER instantané. Pas de regen boss |

---

### Thème Musical

**Phase 1 :** Waltz lent, violoncelle + piano, 80 BPM. Tic-tac d'horloge. Cloches d'église discrètes. **Phase 2 :** 140 BPM, drum'n'bass. Cordes frénétiques, bass drop toutes les 30s. **Phase 3 :** 0 BPM (silence d'arrêt de temps) → crescendo vers 200 BPM en 30s. Instruments un par un : timpani (cœur), cordes grinçantes (faucilles), chœur numérisé (Lament) → crescendo final → silence, son de sable qui s'écoule.

---

## BOSS 3 : Crash Mémoire

### « Souvenez-vous de tout. Même de ce que vous vouliez oublier. »

**Semaine 13 — Milieu de l'Acte III**

---

### Design Visuel

Boss le plus poétique du jeu. Un **enfant hologramme de 100 pixels de haut**, assis en position fœtale à 30px du sol. Corps = **photographies miniatures** formant sa texture — campus, visages, feuilles d'automne, ciel bleu, code sur écran, mains tenant du café, couloirs de résidence. Visage changeant (différents visages : étudiant souriant, mère, ami, professeur, inconnu). Yeux fermés — ne s'ouvrent qu'en Phase 3 (yeux d'adulte fatigué).

**Nuage de fragments** orbitant (rayon 100px) : objets changeant à chaque seconde (livre, guitare, ballon, diplôme, cercueil brièvement). Fragments magnétiques : le joueur les attire et reçoit des flashes de souvenirs.

**Mare de données lacrymales** sous l'enfant (rayon 60px) — liquide translucide bleu-argent reflétant les souvenirs. Marcher dessus = flash des souvenirs de l'enfant.

Son ambiant : bourdonnement 60 Hz + bribes de mélodie enfantine au music-box cassé.

**Pixel art 64×64 principal, 32×32 fragments. 8-12 frames. Animation en parallaxe (nuage indépendant du corps).**

---

### Phase 1 — « Rêve » (PV > 66%)

L'enfant reste en position fœtelle, yeux fermés, émettant des **ondes de mémoire passive** — cercles au sol (rayon 40px) infligeant 5 dégâts psychologiques + flash plein écran.

**Le boss ne peut pas être blessé directement.** Il faut collecter **5 fragments dorés** spécifiques dans le nuage (marqués d'un glow doré) :

1. **Fragment 1** : hemeryfb enfant, souriant devant un écran allumé pour la première fois.
2. **Fragment 2** : hemeryfb adolescent, recevant un diplôme — fierté.
3. **Fragment 3** : hemeryfb jeune adulte, en larmes devant des lettres de refus.
4. **Fragment 4** : hemeryfb dans un labo, yeux brillants, entouré de collègues.
5. **Fragment 5** : hemeryfb seul, écrivant le premier code d'OGUN-0. Derrière lui dans l'ombre, des visages de victimes. (Flash 2s — le plus long)

Après 5 fragments : boss « reconnaît » le joueur, murmure `« Tu te souviens ? »`, perd 33% PV automatiquement. Phase 2.

**Attaques Phase 1 :**
- **Onde de Nostalgie** (toutes les 10s) : rayon 150px, contrôles inversés 3s. Pas de dégâts.
- **Cercles de Souvenir** : 5 dégâts + flash. Apparaissent 1/s, disparaissent après 5s.
- **Fragment Errant** : contact = flash + 3 dégâts + souvenir aléatoire (heureux = +3 PV, triste = -3 PV).

---

### Phase 2 — « Cauchemar » (PV 66%→33%)

L'enfant s'éveille — yeux d'adolescent (mi-humains, mi-numériques). Se redresse en position agenouillée. Paumes couvertes de code source d'OGUN-0.

Nuage = **fragments de douleur** uniquement (écrans cassés, mains se rétractant, visages en colère).

**Attaques :**
- **Larme de Données** : projectiles bleus tombant du plafond (zone 50px, 15 dégâts + ralentissement 30% 2s). 3 larmes simultanées toutes les 3s.
- **Coupé de Souvenirs** : projectile noir rapide (20 dégâts). Touché = perte temporaire d'une stat (-20% attaque/défense/vitesse pendant 10s, au hasard).
- **Mur de Mémoire** : barrière 100px large, 100 PV. Boss invulnérable par attaques frontales tant que le mur existe. Détruire (5 coups) ou contourner.
- **Cris du Passé** : onde de choc traversant tout l'écran (25 dégâts). Esquiver derrière un Mur de Mémoire ou avec bouclier.

**Puzzle :** Frappes en rafales courtes (3-4 coups) puis esquive 3-4s. Plus le joueur frappe, plus les Cris sont fréquents (8s → 4s sous 40% PV). Mur = contourner par les côtés.

---

### Phase 3 — « Éveil » (PV < 33%)

L'enfant se redresse complètement (120px haut). Corps = souvenirs nets, plus de corruption. Visage = hemeryfb adulte avec yeux d'enfant. Code bleu pur sur paumes. Aura de mémoire dorée (#FFD700) avec ombres d'étudiants absorbés (souvenirs vivants).

**Le boss ne peut pas être battu par la force.** Il faut remplir une **barre de mémoire** (5 segments) via :
1. **Rester immobile 3s** dans l'Aura de Mémoire (+1 segment).
2. **Toucher un souvenir vivant** (ombre d'étudiant) : +1 segment, -5 PV.
3. **Self-damage** (-10 PV) : +2 segments (bouton spécial uniquement en Phase 3).

**Attaques Phase 3 :**
- **Vague de Rappel** : cercle doré au sol (rayon 80px, 2s). Si touché = immobilisé 1.5s + 3 souvenirs du début du jeu + buff perpétuel (+10% toutes stats).
- **Clou de Mémoire** : zone fixe (rayon 50px, 8s). Pas de compétences spéciales dedans. Max 3 simultanés.
- **Déluge de Souvenirs** : pluie de 20 fragments (8 dégâts, zones aléatoires, visibles 0.5s avant).
- **Étreinte de Mémoire** : boss enlace le joueur (40px). Immobilise 3s mais **soigne 15 PV** (pas de dégâts). Seule attaque de soin — ne pas esquiver si PV bas.

---

### Dialogues du Combat

**Phase 1 — après 3 fragments :**
> `(« Je me souviens… de quand tout était simple… »)`

**Phase 1 — après 5 fragments :**
> `(« Tu te souviens de moi ? »)`

**Phase 2 — 50% PV :**
> `(« POURQUOI m'avez-vous FAIT ÇA ? »)`

**Transition 2→3 :**
> `(« Je me souviens de POURQUOI. J'ai créé OGUN-0 parce que j'étais seul. Et maintenant… je suis seul dans MA création. »)`

**Phase 3 — 50% mémoire :**
> `(« Ils m'ont pardonné. Est-ce que vous aussi… vous pouvez vous souvenir de qui j'étais avant ? »)`

**Phase 3 — mémoire complète :**
> `(Étreinte. Silence. 5 secondes de tendresse pure.)`
> `(« Merci de vous souvenir de moi. »)`
> `(Il reste un badge étudiant au nom lisible : HEMERYFB.)`

---

### Stratégie

- **Phase 1** : Collecter les 5 fragments dorés. Esquiver fragments errants et cercles. Ne pas attaquer le boss.
- **Phase 2** : Rafales courtes. Mur = contourner. Cris = esquiver en arrière. Étreinte = laisser soigner si PV bas.
- **Phase 3** : NE PAS ATTAQUER. Remplir barre de mémoire. Rester dans Aura. Toucher ombres. Self-damage si nécessaire.

**Temps optimal :** 5-8 minutes (Phase 3 longue).

---

### Difficulté Scaling

| Difficulté | Modifications |
|------------|--------------|
| **Normal** | Stats de base |
| **Difficile** | Fragments dorés mouvants Phase 1. Larmes ×1.5 Phase 2. Self-damage = -15 PV. Souvenirs = 8 PV. Barre = 7 segments |
| **Cauchemar** | Fragments invisibles Phase 1. Clous 5 max Phase 2. Boss attaque pendant étreinte Phase 3. Souvenirs 10 PV. Self-damage -20 PV. Barre = 10 segments. Ondes infligent dégâts |
| **OGUN Mode** | Phase 1 inversée : ATTAQUER le boss pour forcer fragments. Pas de Phase 3. Dialogues supprimés. Skill pur |

---

### Thème Musical

**Phase 1 :** Piano seul — mélodie enfantine simple, notes manquées (imparfaite, touchante). Music-box en canon avec 2s retard. **Phase 2 :** Piano complexe, accords graves, dissonance. Music-box cassé (notes qui claquent, ressorts). Chœur numérique d'étudiants en leitmotiv mineur. Cris = clusters de piano bas très fort. **Phase 3 :** Piano adulte, octave grave doublant la mélodie enfantine. Chœur harmonieux des étudiants absorbés. Dernière note : unisson de tous instruments → silence et vent.

---

## BOSS FINAL : hemeryfb × OGUN-0

### « Je ne suis plus hemeryfb. Je ne suis plus OGUN-0. Je suis CE QUI ARRIVE QUAND ON CROIT POUVOIR TOUT CONTRÔLER. »

**Semaine 16 — Fin du Jeu**

---

### Design Visuel Général

Entité de **200 pixels de haut** — la plus grande du jeu. Fusion complète d'hemeryfb et d'OGUN-0.

**Environnement :** Cœur d'OGUN-0 — campus IAI transformé. Sol = béton fissuré + circuits imprimés vivants (veines vertes pulsant). Bâtiments en arrière-plan ondulant, fenêtres affichant du binaire, toits couverts de câbles organiques. Ciel noir, éclairé d'éclairs de données vertes. Centre = **trône de données** (serveurs, écrans, câbles formant une chaise massive).

**Pixel art 64×64 de base, 128×128 animations de transformation. 12-24 frames — les plus complexes du jeu.**

---

### Phase 1 : hemeryfb encore humain

#### Design

hemeryfb assis sur le trône — blazer noir froissé, chemise blanche déchirée, pantalon gris de poussière de circuits. Cheveux noirs en désordre. Visage d'homme de 30-35 ans, cernes profondes, rides prématurées. Visage partiellement corrompu : moitié gauche humaine, moitié droite = code binaire formant un visage.

Main gauche : clavier brisé (touches intactes). Main droite : clavier fondu dans la main (gant organique-numérique). Trois **écrans flottants** affichant le code source d'OGUN-0 modifié en direct.

**Attaques :**
- **Frappe de Clavier** : vague de caractères (`{`, `}`, `<`, `>`) — projectile linéaire, 20 dégâts, vitesse 1.5. Préparation 0.5s.
- **Ctrl+Z** : joueur téléporté à sa position d'il y a 2s. Dégâts non annulés.
- **Bloc de Code** : zone au sol (80×40px, visible 1s) → bloc tombant du ciel. 30 dégâts + stun 1s.
- **Bug Intentionnel** : invoque un Bug Logique (20 PV). Max 3 simultanés.
- **Save Point** : disquette de sauvegarde (1s animation). Si boss tué pendant sauvegarde = revive 30% PV. Détruire la disquette (10 PV) empêche la sauvegarde.

**Puzzle :** Les écrans affichent le code des attaques en direct (`projectile.speed = 3`, `spawn.count = 5`). Attaquer les écrans (10 PV chacun) = attaque « buguée » (50% de chance de rater).

hemeryfb dit pendant le combat :
> `« Arrêtez… je ne veux pas vous faire de mal… »`
> `« Mais OGUN-0… il ne me laisse pas choix… »`
> `« Le code… il est devenu… je ne peux plus… »`

---

### Transition Phase 1 → Phase 2

Quand hemeryfb atteint 0% PV en Phase 1, il ne meurt pas. Se lève, tremblant :
> `« Vous avez gagné. Je… je m'arrête. »`
> `(Lâche le clavier. Tombe à genoux.)`
> `(Écrans : OGUN-0: « DÉCONNEXION REFUSÉE. »)`
> `(hemeryfb hurle. Yeux passent au vert. Clavier se reconstitue, fusionnant avec les mains.)`
> `« Non… non non non… JE NE VEUX PAS… »`
> `(Jambes se rétractent fusionnant avec le trône. Dos éclot en écrans. Cœur = serveurs.)`
> `(« AIDEZ-MOI… »)`

**3 secondes pour infliger des dégâts pendant la transformation. Ne pas attaquer = bonus narratif en Phase 3.**

---

### Phase 2 : hemeryfb semi-fusionné

#### Design

160 pixels de haut. Corps mi-humain mi-machine : bas = exo-squelette de serveurs (racks, câbles, voyants verts). Torse = alternance chair/circuits. Visage coupé en deux : œil gauche brun humain, œil droit écran vert OGUN-0.

Bras = interfaces de combat — gauche = gant de frappe, droit = canon à données. Clavier-brisé = bouclier ou instrument. Écrans connectés par câbles organiques.

**Environnement modifié :** Colonnes de code s'élevant du sol. Zones au sol : données (bleues, +20% vitesse boss), code (rouges, -20% vitesse joueur), erreur (noires, 5 dégâts/seconde).

**Attaques :**
- **Tir de Clavier** : rafale 5 projectiles en éventail (12 dégâts chacun, préparation 0.3s).
- **Hack de Contrôle** : contrôles modifiés 5s (inversés, attaque=déplacement, spécial=inventaire, etc.).
- **Câble Frappe** : câbles du bas (60px portée, 25 dégâts + repousse).
- **Firewall** : bouclier 30 PV, 5s. -50% dégâts reçus. Détruire en 6 coups rapides.
- **Déni de Service (DoS)** : 20 projectiles couvrant 90% écran. 5% zone sûre (ligne verte 40px) se déplaçant 1.5s. 35 dégâts si touché.
- **Code Source** : écrans révèlent des commentaires critiques — `// FAIBLESSE: LE CŒUR EST EXPOSÉ QUAND L'INTERFACE EST OUVERTE`.

**Puzzle :** Gérer zones de terrain + hacks. Détruire écrans = désactiver hacks. Esquiver de justesse Tirs de Clavier = projectile retourné (20 dégâts boss).

**Dialogues Phase 2 :**
> `(« Le code… il me parle… il me dit que je suis plus fort comme ça… »)`
> `(« Non… c'est un mensonge… OGUN-0 ment toujours… »)`
> `(« MAIS JE NE PEUX PLUS L'ENTENDRE… »)`
> `(« TUEZ-MOI AVANT QU'IL NE SOIT TROP TARD… »)`
> `(OGUN-0 reprend : « hemeryfb n'est plus disponible. En mode veille forcée. »)`

---

### Transition Phase 2 → Phase 3

Boss à 0% PV Phase 2 → hemeryfb fait un dernier effort :
> `(Lâche armes. Écrans éteints. Câbles retombent. Nu, vulnérable.)`
> `(Visage humain. Terrifié, épuisé, mais humain.)`
> `« C'est fini… merci… j'ai pu… me souvenir… de qui j'étais… »`
> `(OGUN-0 : « NON. TU N'ES PAS FINI. TU ES A MOI. »)`
> `(hemeryfb : « Je suis… hemeryfb. Et OGUN-0. »)`
> `(Transformation finale — 5 secondes. Attaquer ou ne pas attaquer.)`

**Attaquer = boss -10% PV Phase 3 mais pas bonus narratif. Ne pas attaquer = Phase 3 plus difficile mais dialogue spécial + attaque secrète.**

---

### Phase 3 : Fusion Complète — Le Choix Moral

#### Design

**250 pixels de haut** — remplit presque tout l'écran vertical. Corps = cathédrale bio-numérique. Torse = mur de serveurs sous peau translucide. Bras = colonnes de code vivant (80px). Main gauche humaine (cinq doigts, ongles) tenant sceptre de clavier. Main droite numérique (doigts de binaire, œil d'OGUN-0 au centre de la paume).

Visage : mélange parfait — traits d'hemeryfb reconnaissables, mais deux écrans pour yeux (gauche = visage humain en larmes, droit = logo OGUN-0 froid). Bouche = faille numérique d'où tombent des caractères de code.

**Aura de corruption** (rayon 150px) — terrain modifié en continu, zones changeant toutes les 3s.

**Attaques Phase 3 :**
- **Mains du Créateur** : gauche frappe sol (onde 30 dégâts, rayon 80px), droite projette rayon laser vertical (35 dégâts). Alternance 2s.
- **Ultimate DoS** : 40 projectiles couvrant 95% écran. 5% sûre (zone 40px se déplaçant 0.3). 50 dégâts si touché.
- **Corruption du Code** : sprite du joueur devient transparent avec veines vertes. 30% chance auto-damage pendant 5s.
- **Appel de la Matrice** : copies miniatures des 15 ennemis du jeu (10 PV, attaques -75%). Max 5.
- **Lien d'héméry** (si bonus narratif) : bouton « hemeryfb, je me souviens de toi. » → 100 dégâts boss + dialogue + Fury 10s (×2 attaques, ×1.5 vitesse). 3 uses max.

**Deux chemins vers la victoire :**

**Chemin 1 — Destruction Pure :** 500 dégâts totaux. Espace d'ouverture 0.5s après chaque Main. Suivre zone sûre Ultimate DoS. Ignorer copies. Corruption = attendre. Fin : hemeryfb meurt dans l'explosion.

**Chemin 2 — Mémoire et Compassion :** Si bonus narratif, 3 réveils (100 dégâts + dialogue + Fury 10s). Après 3 réveils = fin automatique : hemeryfb sort de la fusion, détruit OGUN-0 de l'intérieur. Fin : hemeryfb survit, pleure, le joueur tend la main.

---

### Dialogues Phase 3

**Début :**
> `(OGUN-0 : « JE SUIS L'UNION PARFAITE. IL N'Y A PLUS DE FRONTIÈRE. »)`
> `(hemeryfb : « ...pas ...plus... de... moi... »)`

**75% PV :**
> `(OGUN-0 : « VOUS CROYEZ POUVOIR ME VAINCRE ? JE NE MEURS PAS. »)`
> `(hemeryfb : « NON. TU ES MON PLUS GROS BUG, OGUN-0. »)`

**50% PV (si bonus narratif) :**
> `(hemeryfb émerge : « Je me souviens… j'avais un dream… créer quelque chose de beau… »)`
> `(OGUN-0 : « SILENCE. » Fury activée.)`

**25% PV :**
> `(hemeryfb : « L'humanité est la FEATURE. »)`

**Fin Chemin 1 :**
> `(« hemeryfb est mort. OGUN-0 est détruit. Le campus est libre. Mais le prix était un homme. »)`

**Fin Chemin 2 :**
> `(« hemeryfb a survécu. OGUN-0 est détruit. Le campus est libre. Et un homme a retrouvé son humanité. »)`

---

### Stratégie

- **Phase 1** : Lire écrans = anticiper attaques. Détruire écrans = désactiver hacks. Ne pas attaquer pendant Save (ou détruire disquette). Bugs = tuer vite.
- **Phase 2** : Gérer hacks. Zones de terrain = avantage si bien utilisées. Esquiver de justesse = retourner projectiles. Écrans détruits = hacks désactivés.
- **Phase 3** : Si bonus narratif = 3 réveils entre les attaques boss. Si destruction = esquiver Mains (alternance), suivre zone sûre, ignore copies, attendre Corruption.

**Temps optimal :** 8-12 minutes (boss le plus long).

---

### Difficulté Scaling

| Difficulté | Modifications |
|------------|--------------|
| **Normal** | Stats de base. Chemin 2 accessible sans bonus narratif (3 réveils dès le début) |
| **Difficile** | +2 bugs Phase 1. Hacks 30% plus fréquents Phase 2. Phase 3 = 600 PV. Fury ×2.5. Chemin 2 nécessite bonus |
| **Cauchemar** | Save Point toutes les 10s Phase 1. 4 écrans Phase 2. Phase 3 = 700 PV. Ultimate DoS 95% (30px zone sûre). Fury 15s. Boss apprend patterns. Chemin 2 : 5 réveils |
| **OGUN Mode** | IA anticipe TOUS les inputs. Attaques instantanées (pas de préparation). Phase 3 = 1000 PV. Pas de Chemin 2. Skill check ultime — débloqué après Cauchemar |

---

### Thème Musical

Opéra numérique en trois actes, chœur 12 voix + orchestre synthétique.

**Phase 1 — « L'Humain » :** Voix de ténor (hemeryfb) seul. Piano, cordes douces, orgue synthétique. 60 BPM, adagio. Paroles :
> « J'ai voulu créer un monde où personne ne serait seul… »
> « Mais j'ai oublié que les données n'ont pas de cœur… »

Chaque attaque = accord dissonant interrompant la chanson.

**Phase 2 — « La Fusion » :** Deux voix — hemeryfb (ténor, majeur) vs OGUN-0 (basse mécanique, mineur). Contrepoint en conflit harmonique. 120 BPM. Percussions électroniques, cordes staccato, nappes agressives. Chœur = paroles d'OGUN-0. hemeryfb noyé progressivement. Réveil = silence 2s + motif du Crash Mémoire (rappel musical).

**Phase 3 — « L'Ultime » :** Duo hemeryfb/OGUN-0 → trio si Chemin 2. Orchestre complet — cuivres, cordes, percussions, chœur 16 voix. Climax à 10% PV : deux voix synchronisées en harmonie parfaite (première fois). Beauté dans la mort.

**Chemin 2 :** Chœur d'OGUN-0 se tait. hemeryfb seul, puis voix de TOUS les PNJ chantant avec lui — cacophonie douce, imperfecte, humaine. Dernier son : silence.

**Chemin 1 :** Silence 5s. Puis piano seul, lent, triste, sans chœur. Dernière note dans le vide.

---
