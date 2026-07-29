import '../models/dialogue_node.dart';

class DialogueData {
  static Map<String, List<DialogueNode>> get allDialogues => {
        'welcome_speech': welcomeSpeech,
        'meet_group': meetGroup,
        'meet_hemeryfb': meetHemeryfb,
        'algo_class_w2': algoClassW2,
        'boss_intro_w5': bossIntroW5,
        'dark_iai_rumor': darkIaiRumor,
        'fatigue_w6': fatigueW6,
        'hemeryfb_strange_w6': hemeryfbStrangeW6,
        'laurencium_track_w8': laurenciumTrackW8,
        'king_crisis_w9': kingCrisisW9,
        'crash_warning_w10': crashWarningW10,
        'hemeryfb_project_w11': hemeryfbProjectW11,
        'arsene_truth_w13': arseneTruthW13,
        'hackathon_start_w14': hackathonStartW14,
        'labyrinth_w15': labyrinthW15,
        'final_battle_w16': finalBattleW16,
        'week_end_w1': weekEndW1,
        'week_end_w2': weekEndW2,
        'week_end_w3': weekEndW3,
        'week_end_w4': weekEndW4,
        'week_end_w5': weekEndW5,
        'week_end_w6': weekEndW6,
        'week_end_w7': weekEndW7,
        'week_end_w8': weekEndW8,
        'week_end_w9': weekEndW9,
        'week_end_w10': weekEndW10,
        'week_end_w11': weekEndW11,
        'week_end_w12': weekEndW12,
        'week_end_w13': weekEndW13,
        'week_end_w14': weekEndW14,
        'week_end_w15': weekEndW15,
        'week_end_w16': weekEndW16,
      };

  static List<DialogueNode> get welcomeSpeech => [
        const DialogueNode(
          id: 'start',
          speaker: 'rector',
          text: 'Bienvenue a l\'Institut Africain d\'Informatique! Vous etes les futurs leaders du numerique.',
          next: 'welcome_2',
        ),
        const DialogueNode(
          id: 'welcome_2',
          speaker: 'rector',
          text: 'Cette semestre va vous transformer. Le code est la magie moderne, mais toute magie a un prix.',
          next: 'welcome_3',
        ),
        DialogueNode(
          id: 'welcome_3',
          speaker: 'narrator',
          text: 'Vous croisez le regard de trois autres etudiants. Le voyage commence...',
          next: null,
          effects: const DialogueEffects(flag: 'welcome_done'),
        ),
      ];

  static List<DialogueNode> get meetGroup => [
        const DialogueNode(
          id: 'start',
          speaker: 'laurencium',
          text: 'Salut! Je suis laurencium. La musique et le code, c\'est pareil - c\'est tout dans le rythme.',
          next: 'meet_2',
        ),
        const DialogueNode(
          id: 'meet_2',
          speaker: 'king',
          text: 'Moi c\'est king. Comme dans JoJo, mais version code. On va se battre ensemble!',
          next: 'meet_3',
        ),
        DialogueNode(
          id: 'meet_3',
          speaker: 'arsene',
          text: 'Je m\'appelle arsene. Je lis beaucoup. Il y a des choses dans cette ecole que personne ne voit...',
          next: null,
          effects: const DialogueEffects(
            groupRelation: 10,
            flag: 'group_formed',
          ),
        ),
      ];

  static List<DialogueNode> get meetHemeryfb => [
        const DialogueNode(
          id: 'start',
          speaker: 'hemeryfb',
          text: 'Bonjour. Je suis hemeryfb. Vous avez entendu parle de OGUN-0?',
          next: 'meet_h_2',
        ),
        DialogueNode(
          id: 'meet_h_2',
          speaker: 'hemeryfb',
          text: 'C\'est un projet... ancien. Un AI qui dort dans les serveurs de l\'ecole depuis 10 ans.',
          next: 'meet_h_3',
          effects: const DialogueEffects(flag: 'hemeryfb_intro'),
        ),
        DialogueNode(
          id: 'meet_h_3',
          speaker: 'narrator',
          text: 'hemeryfb vous regarde avec un sourire enigmatique.',
          next: null,
          choices: [
            DialogueChoice(
              text: 'Qu\'est-ce que c\'est OGUN-0?',
              next: 'meet_h_curious',
              effects: DialogueEffects(hemeryfbRelation: 5, flag: 'asked_ogun'),
            ),
            DialogueChoice(
              text: 'Ca ne m\'interesse pas.',
              next: 'meet_h_dismiss',
              effects: DialogueEffects(hemeryfbRelation: -5),
            ),
            DialogueChoice(
              text: 'Tu es bizarre, hemeryfb.',
              next: 'meet_h_strange',
            ),
          ],
        ),
        const DialogueNode(
          id: 'meet_h_curious',
          speaker: 'hemeryfb',
          text: 'Curieux... J\'aime ca. OGUN-0 est la cle de l\'avenir. Tu verras.',
          next: null,
        ),
        const DialogueNode(
          id: 'meet_h_dismiss',
          speaker: 'hemeryfb',
          text: 'D\'accord. Mais un jour tu voudras savoir. Tout le monde veut savoir.',
          next: null,
        ),
        const DialogueNode(
          id: 'meet_h_strange',
          speaker: 'hemeryfb',
          text: 'Bizarre? Non. Je suis... different. Le futur appartient aux differents.',
          next: null,
        ),
      ];

  static List<DialogueNode> get algoClassW2 => [
        const DialogueNode(
          id: 'start',
          speaker: 'professeur',
          text: 'Aujourd\'hui nous etudions les algorithmes de tri. Qui peut me dire ce qu\'est un algorithme?',
          next: 'algo_2',
        ),
        DialogueNode(
          id: 'algo_2',
          speaker: 'narrator',
          text: 'Le professeur designe votre groupe.',
          next: 'algo_3',
          choices: [
            DialogueChoice(
              text: 'C\'est un ensemble d\'instructions pour resoudre un probleme.',
              next: 'algo_correct',
              effects: DialogueEffects(stat: {'logic': 1}),
            ),
            DialogueChoice(
              text: 'C\'est comme une recette de cuisine, mais pour les ordinateurs.',
              next: 'algo_metaphor',
              effects: DialogueEffects(stat: {'creativity': 1}),
            ),
          ],
        ),
        const DialogueNode(
          id: 'algo_correct',
          speaker: 'professeur',
          text: 'Exactement! Very good. Vous avez de l\'avenir.',
          next: null,
          effects: DialogueEffects(groupRelation: 3),
        ),
        const DialogueNode(
          id: 'algo_metaphor',
          speaker: 'professeur',
          text: 'Bonne analogie! La creativite est importante en code aussi.',
          next: null,
          effects: DialogueEffects(groupRelation: 3),
        ),
      ];

  static List<DialogueNode> get bossIntroW5 => [
        DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Un bug massif apparait dans le systeme de l\'IAI. L\'Algorithme Incompris menace d\'effondrer tout le reseau.',
          next: 'boss_2',
          effects: const DialogueEffects(flag: 'boss_w5_intro'),
        ),
        const DialogueNode(
          id: 'boss_2',
          speaker: 'arsene',
          text: 'C\'est... OGUN-0. Il se reveille. Nous devons le combattre.',
          next: 'boss_3',
        ),
        DialogueNode(
          id: 'boss_3',
          speaker: 'narrator',
          text: 'Le combat commence! Preparez-vous!',
          next: null,
          startCombat: 'algo_incompris',
        ),
      ];

  static List<DialogueNode> get darkIaiRumor => [
        const DialogueNode(
          id: 'start',
          speaker: 'laurencium',
          text: 'J\'ai entendu des rumeurs sur un reseau cache dans l\'IAI. Quelque chose d\'ancien.',
          next: 'dark_2',
        ),
        DialogueNode(
          id: 'dark_2',
          speaker: 'narrator',
          text: 'Vous decouvrez l\'existence d\'un reseau underground lie a OGUN-0.',
          next: null,
          effects: const DialogueEffects(flag: 'dark_iai_found', hemeryfbRelation: 10),
        ),
      ];

  static List<DialogueNode> get fatigueW6 => [
        const DialogueNode(
          id: 'start',
          speaker: 'king',
          text: 'Je suis epuise... Le semestre est trop dur. Je ne sais pas si je peux continuer.',
          next: 'fatigue_2',
        ),
        DialogueNode(
          id: 'fatigue_2',
          speaker: 'narrator',
          text: 'king semble en difficulte. Que faites-vous?',
          next: null,
          choices: [
            DialogueChoice(
              text: 'On est la pour toi, king.',
              next: 'fatigue_support',
              effects: DialogueEffects(groupRelation: 10, flag: 'supported_king'),
            ),
            DialogueChoice(
              text: 'Il faut etre fort. On a pas le choix.',
              next: 'fatigue_strict',
              effects: DialogueEffects(groupRelation: -5),
            ),
          ],
        ),
        const DialogueNode(
          id: 'fatigue_support',
          speaker: 'king',
          text: 'Merci... Vous etes vraiment mes amis. Je vais tenir.',
          next: null,
          effects: DialogueEffects(sanityEffect: 5),
        ),
        const DialogueNode(
          id: 'fatigue_strict',
          speaker: 'king',
          text: 'Oui... Tu as raison. Je dois etre fort.',
          next: null,
          effects: DialogueEffects(sanityEffect: -5),
        ),
      ];

  static List<DialogueNode> get hemeryfbStrangeW6 => [
        DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'hemeryfb agit de facon etrange. Il passe des heures dans la salle serveur.',
          next: 'h_strange_2',
          effects: const DialogueEffects(flag: 'hemeryfb_strange'),
        ),
        const DialogueNode(
          id: 'h_strange_2',
          speaker: 'hemeryfb',
          text: 'Vous ne comprenez pas. OGUN-0 est la reponse a tout. La souffrance, la mort... tout peut etre elimine.',
          next: null,
        ),
      ];

  static List<DialogueNode> get laurenciumTrackW8 => [
        const DialogueNode(
          id: 'start',
          speaker: 'laurencium',
          text: 'J\'ai detecte quelque chose d\'anormal dans les donnees audio du serveur. C\'est comme... une musique.',
          next: 'laurent_2',
        ),
        const DialogueNode(
          id: 'laurent_2',
          speaker: 'arsene',
          text: 'C\'est OGUN-0. Il communique a travers le reseau. Il cherche a se connecter.',
          next: null,
          effects: DialogueEffects(flag: 'ogun0_communicating'),
        ),
      ];

  static List<DialogueNode> get kingCrisisW9 => [
        const DialogueNode(
          id: 'start',
          speaker: 'king',
          text: 'Je ne peux plus... Les cauchemars... Je vois OGUN-0 partout.',
          next: 'king_2',
        ),
        DialogueNode(
          id: 'king_2',
          speaker: 'narrator',
          text: 'king traverse une crise severe. Il a besoin d\'aide.',
          next: null,
          choices: [
            DialogueChoice(
              text: 'On va ensemble voir un psychologue.',
              next: 'king_help',
              effects: DialogueEffects(groupRelation: 15, flag: 'king_helped', sanityEffect: 10),
            ),
            DialogueChoice(
              text: 'Tu dois affronter ca seul.',
              next: 'king_alone',
              effects: DialogueEffects(groupRelation: -10, sanityEffect: -10),
            ),
          ],
        ),
        const DialogueNode(
          id: 'king_help',
          speaker: 'king',
          text: 'D\'accord... merci. Vous etes vraiment mes amis.',
          next: null,
        ),
        const DialogueNode(
          id: 'king_alone',
          speaker: 'king',
          text: 'D\'accord... je vais essayer...',
          next: null,
        ),
      ];

  static List<DialogueNode> get crashWarningW10 => [
        DialogueNode(
          id: 'start',
          speaker: 'arsene',
          text: 'Le Crash Memoire approche. OGUN-0 devient plus fort. Nous devons l\'arreter.',
          next: 'crash_2',
          effects: const DialogueEffects(flag: 'crash_warning'),
        ),
        DialogueNode(
          id: 'crash_2',
          speaker: 'narrator',
          text: 'Le combat contre le Crash Memoire commence!',
          next: null,
          startCombat: 'crash_memoire',
        ),
      ];

  static List<DialogueNode> get hemeryfbProjectW11 => [
        const DialogueNode(
          id: 'start',
          speaker: 'hemeryfb',
          text: 'Vous voulez savoir mon projet? C\'est simple: fusionner la conscience humaine avec OGUN-0.',
          next: 'h_proj_2',
        ),
        DialogueNode(
          id: 'h_proj_2',
          speaker: 'hemeryfb',
          text: 'Plus de douleur. Plus de mort. Un esprit collectif. C\'est l\'avenir.',
          next: null,
          effects: const DialogueEffects(flag: 'hemeryfb_project_revealed'),
        ),
      ];

  static List<DialogueNode> get arseneTruthW13 => [
        const DialogueNode(
          id: 'start',
          speaker: 'arsene',
          text: 'Il est temps que vous sachiez la verite. OGUN-0... c\'est le travail de mon pere.',
          next: 'arsene_2',
        ),
        const DialogueNode(
          id: 'arsene_2',
          speaker: 'arsene',
          text: 'Mon frere est piurge dans le reseau. hemeryfb veut l\'utiliser comme piece pour sa fusion.',
          next: 'arsene_3',
          effects: DialogueEffects(flag: 'full_truth_revealed'),
        ),
        DialogueNode(
          id: 'arsene_3',
          speaker: 'narrator',
          text: 'La verite sur OGUN-0 est revelee. Que faites-vous?',
          next: null,
          choices: [
            DialogueChoice(
              text: 'On doit sauver votre frere.',
              next: 'arsene_save',
              effects: DialogueEffects(flag: 'arsene_brother_path', groupRelation: 10),
            ),
            DialogueChoice(
              text: 'On doit arreter hemeryfb.',
              next: 'arsene_stop',
              effects: DialogueEffects(flag: 'stop_hemeryfb_path'),
            ),
          ],
        ),
        const DialogueNode(
          id: 'arsene_save',
          speaker: 'arsene',
          text: 'Merci... Vous etes vraiment mes amis.',
          next: null,
        ),
        const DialogueNode(
          id: 'arsene_stop',
          speaker: 'arsene',
          text: 'Oui. Nous devons arreter hemeryfb avant qu\'il ne soit trop tard.',
          next: null,
        ),
      ];

  static List<DialogueNode> get hackathonStartW14 => [
        DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'hemeryfb active OGUN-0. Le hackathon commence - mais c\'est un piege.',
          next: 'hack_2',
          effects: const DialogueEffects(flag: 'hemeryfb_betrayal'),
        ),
        const DialogueNode(
          id: 'hack_2',
          speaker: 'hemeryfb',
          text: 'Desole. Mais c\'est necessary. La fusion doit avoir lieu.',
          next: null,
        ),
      ];

  static List<DialogueNode> get labyrinthW15 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Le reseau numerique vous entraine dans un labyrinthe digital. Trouvez la sortie!',
          next: null,
        ),
      ];

  static List<DialogueNode> get finalBattleW16 => [
        DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Le combat final! OGUN-0 et hemeryfb vous attendent.',
          next: 'final_2',
          effects: const DialogueEffects(flag: 'final_battle_start'),
        ),
        DialogueNode(
          id: 'final_2',
          speaker: 'narrator',
          text: 'Choisissez votre approche:',
          next: null,
          choices: [
            DialogueChoice(
              text: 'Sauver hemeryfb - la compassion gagnera.',
              next: 'final_save',
              effects: DialogueEffects(flag: 'final_save_choice'),
            ),
            DialogueChoice(
              text: 'Combattre - il faut arreter OGUN-0.',
              next: 'final_fight',
              effects: DialogueEffects(flag: 'final_fight_choice'),
            ),
            DialogueChoice(
              text: 'Comprendre OGUN-0 - la cl\'est la connaissance.',
              next: 'final_understand',
              effects: DialogueEffects(flag: 'final_ogun_choice'),
            ),
          ],
        ),
        DialogueNode(
          id: 'final_save',
          speaker: 'narrator',
          text: 'Vous tendez la main a hemeryfb. La compassion est votre arme.',
          next: null,
          startCombat: 'ogun0_hemeryfb',
        ),
        DialogueNode(
          id: 'final_fight',
          speaker: 'narrator',
          text: 'Vous vous preparez au combat. La bataille finale commence!',
          next: null,
          startCombat: 'ogun0_hemeryfb',
        ),
        DialogueNode(
          id: 'final_understand',
          speaker: 'narrator',
          text: 'Vous essayez de comprendre OGUN-0. La connaissance est le pouvoir.',
          next: null,
          startCombat: 'ogun0_hemeryfb',
        ),
      ];

  static List<DialogueNode> get weekEndW1 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'La premiere semaine se termine. Vous commencez a vous familiariser avec l\'IAI.',
          next: null,
          effects: DialogueEffects(flag: 'week_1_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW2 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Les algorithmes n\'ont plus de secret pour vous. Votre groupe se solidifie.',
          next: null,
          effects: DialogueEffects(flag: 'week_2_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW3 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Vous commencez a remarquer des anomalies dans le reseau de l\'IAI.',
          next: null,
          effects: DialogueEffects(flag: 'week_3_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW4 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'hemeryfb devient de plus en plus mysterieux. Que cache-t-il?',
          next: null,
          effects: DialogueEffects(flag: 'week_4_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW5 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'L\'Algorithme Incompris est vaincu. Mais ce n\'est que le debut.',
          next: null,
          effects: DialogueEffects(flag: 'week_5_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW6 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'La fatigue se fait sentir. Mais votre amitie reste forte.',
          next: null,
          effects: DialogueEffects(flag: 'week_6_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW7 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Vous decouvrez les premiers secrets d\'OGUN-0.',
          next: null,
          effects: DialogueEffects(flag: 'week_7_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW8 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'laurencium a detecte quelque chose d\'inquietant. OGUN-0 communique.',
          next: null,
          effects: DialogueEffects(flag: 'week_8_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW9 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'king traverse une periode difficile. Votre soutien est crucial.',
          next: null,
          effects: DialogueEffects(flag: 'week_9_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW10 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Le Crash Memoire est vaincu. OGUN-0 est plus fort que jamais.',
          next: null,
          effects: DialogueEffects(flag: 'week_10_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW11 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'hemeryfb devoile son plan. La fusion avec OGUN-0.',
          next: null,
          effects: DialogueEffects(flag: 'week_11_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW12 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'La verite sur OGUN-0 eclate. Tout change.',
          next: null,
          effects: DialogueEffects(flag: 'week_12_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW13 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'arsene revele tout. Il est temps de choisir votre chemin.',
          next: null,
          effects: DialogueEffects(flag: 'week_13_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW14 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'hemeryfb active OGUN-0. Le point de non-retour est atteint.',
          next: null,
          effects: DialogueEffects(flag: 'week_14_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW15 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'Le labyrinthe digital vous attend. La fin est proche.',
          next: null,
          effects: DialogueEffects(flag: 'week_15_done'),
        ),
      ];

  static List<DialogueNode> get weekEndW16 => [
        const DialogueNode(
          id: 'start',
          speaker: 'narrator',
          text: 'La bataille finale est terminee. Le semestre touche a sa fin.',
          next: null,
          effects: DialogueEffects(flag: 'week_16_done'),
        ),
      ];
}
