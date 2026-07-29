local Weeks = {
    [1] = {
        id = 1,
        title = "Rentrée — Bienvenue à l'IAI",
        act = 1,
        theme = "Découverte",
        description = "Premier jour à l'IAI. Le groupe se forme. Les premières impressions comptent.",
        objectives = {
            "Explorer le campus",
            "Rencontrer les membres du groupe",
            "Assister au discours de bienvenue",
        },
        energyCost = 0,
        sanityEffect = 0,
        events = {
            {
                id = "welcome_speech",
                type = "dialogue",
                title = "Discours de Bienvenue",
                trigger = "start",
                dialogue = "welcome_speech",
            },
            {
                id = "meet_group",
                type = "dialogue",
                title = "Rencontre du Groupe",
                trigger = "exploration",
                dialogue = "meet_group",
            },
            {
                id = "campus_tour",
                type = "exploration",
                title = "Visite du Campus",
                trigger = "choice",
                locations = {"salle_de_cours", "bibliotheque", "cafeteria", "cour"},
            },
        },
        miniGame = nil,
        boss = nil,
        choices = {
            {
                id = "where_to_sit",
                text = "Où s'asseoir en cours ?",
                options = {
                    { text = "Devant (montrer ta valeur)", stat = "logic", value = 2, socialEffect = {player=5} },
                    { text = "Au milieu (rester discret)", stat = "endurance", value = 1, socialEffect = {} },
                    { text = "Avec le groupe (tisser des liens)", stat = "social", value = 3, socialEffect = {group=10} },
                },
            },
        },
        weekEnd = {
            dialogue = "week1_end",
            choices = nil,
        },
    },

    [2] = {
        id = 2,
        title = "Les Bases — Cours Intensifs",
        act = 1,
        theme = "Apprentissage",
        description = "Les cours commencent pour de vrai. Algorithmique, structures de données, le premier vrai défi.",
        objectives = {
            "Terminer les exercices d'algo",
            "Comprendre les listes chaînées",
            "Survivre au premier partiel",
        },
        energyCost = 10,
        sanityEffect = -5,
        events = {
            {
                id = "algo_class",
                type = "dialogue",
                title = "Cours d'Algorithmique",
                trigger = "start",
                dialogue = "algo_class_w2",
            },
            {
                id = "first_exercise",
                type = "minigame",
                title = "Exercice : Tri à Bulles",
                trigger = "choice",
                miniGame = "bubble_sort",
            },
            {
                id = "hemeryfb_intro",
                type = "dialogue",
                title = "Rencontre avec hemeryfb",
                trigger = "exploration",
                dialogue = "meet_hemeryfb",
            },
        },
        miniGame = "bubble_sort",
        boss = nil,
        choices = {
            {
                id = "study_approach",
                text = "Comment réviser ?",
                options = {
                    { text = "Toute la nuit (grind)", stat = "coding", value = 3, energyEffect = -30, sanityEffect = -10 },
                    { text = "Avec le groupe (ensemble)", stat = "social", value = 2, groupRelation = 8 },
                    { text = "Avec hemeryfb (méthode bizarre)", stat = "creativity", value = 2, hemeryfbRelation = 15, flag = "hemeryfb_study_w2" },
                },
            },
        },
        weekEnd = {
            dialogue = "week2_end",
            choices = nil,
        },
    },

    [3] = {
        id = 3,
        title = "Premier Partiel — Le Baptême du Feu",
        act = 1,
        theme = "Pression",
        description = "Le premier vrai examen. La peur, le stress, et la détermination.",
        objectives = {
            "Se préparer au partiel",
            "Ne pas craquer",
            "Obtenir une note correcte",
        },
        energyCost = 20,
        sanityEffect = -15,
        events = {
            {
                id = "exam_prep",
                type = "dialogue",
                title = "Préparation Intensive",
                trigger = "start",
                dialogue = "exam_prep_w3",
            },
            {
                id = "first_exam",
                type = "minigame",
                title = "Examen : Debug Marathon",
                trigger = "choice",
                miniGame = "debug_marathon",
            },
        },
        miniGame = "debug_marathon",
        boss = {
            id = "deadline_wraith",
            name = "Fantôme de Deadline",
            trigger = "after_minigame",
        },
        choices = {
            {
                id = "exam_mindset",
                text = "Ton état d'esprit avant l'examen",
                options = {
                    { text = "Confiance (j'ai bossé)", stat = "logic", value = 1, sanityEffect = 5 },
                    { text = "Panique (je suis mort)", stat = "endurance", value = 2, sanityEffect = -10 },
                    { text = "Zen (flow state)", stat = "creativity", value = 2, sanityEffect = 3 },
                },
            },
        },
        weekEnd = {
            dialogue = "week3_end",
        },
    },

    [4] = {
        id = 4,
        title = "Le Dark IAI — Portes Cachées",
        act = 1,
        theme = "Exploration",
        description = "Des rumeurs sur un réseau étudiant secret. Le Dark IAI appelle.",
        objectives = {
            "Découvrir le Dark IAI",
            "Résoudre le premier challenge de hack",
            "Établir une réputation",
        },
        energyCost = 10,
        sanityEffect = -5,
        events = {
            {
                id = "dark_iai_rumor",
                type = "dialogue",
                title = "Rumeur du Dark IAI",
                trigger = "start",
                dialogue = "dark_iai_rumor",
            },
            {
                id = "dark_iai_access",
                type = "choice",
                title = "Accéder au Dark IAI",
                trigger = "choice",
                requires = { flag = "dark_iai_found", value = true },
            },
            {
                id = "hack_challenge",
                type = "minigame",
                title = "Challenge de Hack",
                trigger = "exploration",
                miniGame = "hack_puzzle",
            },
        },
        miniGame = "hack_puzzle",
        boss = nil,
        choices = {
            {
                id = "dark_iai_choice",
                text = "Comment accéder au Dark IAI ?",
                options = {
                    { text = "Seuls (parcours solo)", stat = "coding", value = 3, flag = "dark_iai_alone" },
                    { text = "En équipe (force du groupe)", stat = "social", value = 2, groupRelation = 10, flag = "dark_iai_group" },
                    { text = "Avec hemeryfb (il connaît un chemin)", stat = "creativity", value = 1, hemeryfbRelation = 20, flag = "dark_iai_hemeryfb", hemeryfbTrust = 10 },
                },
            },
        },
        weekEnd = {
            dialogue = "week4_end",
        },
    },

    [5] = {
        id = 5,
        title = "Le Premier Boss — Algorithme Incompris",
        act = 1,
        theme = "Confrontation",
        description = "L'algorithme qu'on n'a pas compris prend forme. Premier vrai combat.",
        objectives = {
            "Comprendre l'algorithme récursif",
            "Affronter la manifestation",
            "Vivre pour en parler",
        },
        energyCost = 15,
        sanityEffect = -10,
        events = {
            {
                id = "boss_intro",
                type = "dialogue",
                title = "L'Énigme Finale",
                trigger = "start",
                dialogue = "boss_intro_w5",
            },
        },
        miniGame = "algo_puzzle",
        boss = "boss_week5",
        choices = {
            {
                id = "boss_strategy",
                text = "Comment affronter le boss ?",
                options = {
                    { text = "Stratégie pure (logic)", stat = "logic", value = 2, combatBuff = { attack = 5 } },
                    { text = "Intuition créative", stat = "creativity", value = 2, combatBuff = { magic = 5 } },
                    { text = "Force brute (ensemble)", stat = "social", value = 2, combatBuff = { defense = 5 } },
                },
            },
        },
        weekEnd = {
            dialogue = "week5_end",
        },
    },

    [6] = {
        id = 6,
        title = "Mi-Semestre — La Fatigue s'Installe",
        act = 2,
        theme = "Dégradation",
        description = "La fatigue est là. Les premiers doutes. hemeryfb commence à s'isoler.",
        objectives = {
            "Tenir le coup",
            "Maintenir les liens du groupe",
            "Remarquer les changements chez hemeryfb",
        },
        energyCost = 15,
        sanityEffect = -10,
        events = {
            {
                id = "fatigue_lecture",
                type = "dialogue",
                title = "Cours de fatigue",
                trigger = "start",
                dialogue = "fatigue_w6",
            },
            {
                id = "hemeryfb_strange",
                type = "dialogue",
                title = "hemeryfb étrange",
                trigger = "exploration",
                dialogue = "hemeryfb_strange_w6",
            },
        },
        boss = {
            id = "memory_leak",
            name = "Fuite Mémoire",
            trigger = "event",
        },
        choices = {
            {
                id = "group_check",
                text = "Comment gérer la fatigue ?",
                options = {
                    { text = "Soirée pizza (divertissement)", sanityEffect = 15, energyEffect = 10, groupRelation = 5 },
                    { text = "Rattrapage intensif", stat = "coding", value = 2, energyEffect = -15 },
                    { text = "Parler à arsene (il comprend)", arseneRelation = 15, sanityEffect = 10 },
                },
            },
        },
        weekEnd = {
            dialogue = "week6_end",
        },
    },

    [7] = {
        id = 7,
        title = "Le Secret d'arsene",
        act = 2,
        theme = "Révélation",
        description = "arsene commence à montrer des signes de trouble. Quelque chose le hante.",
        objectives = {
            "Approfondir le lien avec arsene",
            "Découvrir un fragment de son passé",
            "Décoder un message caché",
        },
        energyCost = 10,
        sanityEffect = -5,
        events = {
            {
                id = "arsene_nightmare",
                type = "dialogue",
                title = "Cauchemar d'arsene",
                trigger = "start",
                dialogue = "arsene_nightmare_w7",
            },
            {
                id = "encrypted_message",
                type = "minigame",
                title = "Message Crypté",
                trigger = "exploration",
                miniGame = "decode_puzzle",
            },
        },
        miniGame = "decode_puzzle",
        boss = nil,
        choices = {
            {
                id = "arsene_approach",
                text = "Comment approcher arsene ?",
                options = {
                    { text = "Lui parler directement", stat = "social", value = 3, arseneRelation = 10 },
                    { text = "Observer de loin", stat = "creativity", value = 2, flag = "observed_arsene" },
                    { text = "Consulte hemeryfb à ce sujet", hemeryfbRelation = 10, flag = "asked_hemeryfb_arsene" },
                },
            },
        },
        weekEnd = {
            dialogue = "week7_end",
        },
    },

    [8] = {
        id = 8,
        title = "La Musique de Laurencium",
        act = 2,
        theme = "Expression",
        description = "laurencium produit un morceau spécial. Un signal caché s'y cache.",
        objectives = {
            "Écouter le morceau de laurencium",
            "Détecter l'anomalie dans l'audio",
            "Comprendre le lien avec OGUN-0",
        },
        energyCost = 10,
        sanityEffect = 0,
        events = {
            {
                id = "laurencium_track",
                type = "dialogue",
                title = "Nouveau Track",
                trigger = "start",
                dialogue = "laurencium_track_w8",
            },
            {
                id = "audio_anomaly",
                type = "minigame",
                title = "Analyse Audio",
                trigger = "choice",
                miniGame = "audio_analysis",
            },
        },
        miniGame = "audio_analysis",
        boss = nil,
        choices = {
            {
                id = "track_response",
                text = "Réaction au morceau",
                options = {
                    { text = "C'est incroyable !", stat = "social", value = 2, laurenciumRelation = 15 },
                    { text = "Il y a quelque chose d'étrange...", stat = "logic", value = 2, flag = "heard_anomaly" },
                    { text = "hemeryfb aurait aimé ça", hemeryfbRelation = 10, flag = "linked_to_hemeryfb" },
                },
            },
        },
        weekEnd = {
            dialogue = "week8_end",
        },
    },

    [9] = {
        id = 9,
        title = "King — Le Mur de Rage",
        act = 2,
        theme = "Crise",
        description = "King craque sous la pression. Hollow Knight n'est plus une échappatoire.",
        objectives = {
            "Aider king à surmonter sa crise",
            "Résoudre un défi technique ensemble",
            "Éviter qu'il n'abandonne",
        },
        energyCost = 10,
        sanityEffect = -10,
        events = {
            {
                id = "king_crisis",
                type = "dialogue",
                title = "Crise de King",
                trigger = "start",
                dialogue = "king_crisis_w9",
            },
            {
                id = "rage_quit",
                type = "dialogue",
                title = "Rage Quit IRL",
                trigger = "event",
                dialogue = "king_rage_quit",
            },
        },
        miniGame = "boss_rush",
        boss = {
            id = "senior_bully",
            name = "Sénior Bizutageur",
            trigger = "event",
        },
        choices = {
            {
                id = "king_support",
                text = "Comment aider king ?",
                options = {
                    { text = "JoJo reference (parle son langage)", stat = "social", value = 2, kingRelation = 20 },
                    { text = "Jouer ensemble (Hollow Knight)", stat = "creativity", value = 1, kingRelation = 15, sanityEffect = 10 },
                    { text = "Lui parler sérieusement", stat = "endurance", value = 2, kingRelation = 10, flag = "serious_talk_king" },
                },
            },
        },
        weekEnd = {
            dialogue = "week9_end",
        },
    },

    [10] = {
        id = 10,
        title = "Crash Mémoire — Le Deuxième Boss",
        act = 2,
        theme = "Effondrement",
        description = "Le système entier plie. Le Crash Mémoire se matérialise.",
        objectives = {
            "Préparer la défense",
            "Coordonner l'équipe",
            "Survivre au Crash",
        },
        energyCost = 20,
        sanityEffect = -15,
        events = {
            {
                id = "crash_warning",
                type = "dialogue",
                title = "Alerte Système",
                trigger = "start",
                dialogue = "crash_warning_w10",
            },
        },
        miniGame = "data_flow",
        boss = "boss_week10",
        choices = {
            {
                id = "crash_strategy",
                text = "Stratégie face au Crash",
                options = {
                    { text = "Pare-feu (défense)", stat = "logic", value = 2, combatBuff = { defense = 8 } },
                    { text = "Contre-attaque (offense)", stat = "creativity", value = 2, combatBuff = { attack = 8 } },
                    { text = "Résilience (ensemble)", stat = "social", value = 3, combatBuff = { all = 4 } },
                },
            },
        },
        weekEnd = {
            dialogue = "week10_end",
        },
    },

    [11] = {
        id = 11,
        title = "Les Fissures — hemeryfb S'Isole",
        act = 3,
        theme = "Paranoïa",
        description = "hemeryfb disparait de plus en plus. Ses projets deviennent étranges.",
        objectives = {
            "Retracer les pas de hemeryfb",
            "Comprendre ses recherches",
            "Découvrir le lien avec OGUN-0",
        },
        energyCost = 15,
        sanityEffect = -10,
        events = {
            {
                id = "hemeryfb_project",
                type = "dialogue",
                title = "Le Projet Secret",
                trigger = "start",
                dialogue = "hemeryfb_project_w11",
            },
            {
                id = "ogun_clue",
                type = "dialogue",
                title = "Indices sur OGUN-0",
                trigger = "exploration",
                dialogue = "ogun_clue_w11",
            },
        },
        boss = {
            id = "corrupted_student",
            name = "Étudiant Corrompu",
            trigger = "exploration",
        },
        choices = {
            {
                id = "investigation",
                text = "Comment enquêter ?",
                options = {
                    { text = "Hacker ses fichiers", stat = "coding", value = 3, flag = "hacked_hemeryfb_files" },
                    { text = "Lui parler directement", stat = "social", value = 2, hemeryfbRelation = 5 },
                    { text = "Suivre arsene (il sait quelque chose)", arseneRelation = 10, flag = "followed_arsene" },
                },
            },
        },
        weekEnd = {
            dialogue = "week11_end",
        },
    },

    [12] = {
        id = 12,
        title = "Le Virus se Répand",
        act = 3,
        theme = "Infection",
        description = "Des étudiants deviennent étranges. Le virus bio-numérique d'hemeryfb se propage.",
        objectives = {
            "Identifier les étudiants infectés",
            "Développer un antidote partiel",
            "Protéger le groupe",
        },
        energyCost = 20,
        sanityEffect = -15,
        events = {
            {
                id = "virus_spread",
                type = "dialogue",
                title = "Propagation",
                trigger = "start",
                dialogue = "virus_spread_w12",
            },
            {
                id = "antidote_research",
                type = "minigame",
                title = "Recherche Antidote",
                trigger = "choice",
                miniGame = "antidote_code",
            },
        },
        miniGame = "antidote_code",
        boss = {
            id = "corrupted_student",
            name = "Étudiants Corrompus",
            trigger = "event",
            count = 3,
        },
        choices = {
            {
                id = "virus_response",
                text = "Face à la propagation",
                options = {
                    { text = "Isolement sanitaire", stat = "logic", value = 2, sanityEffect = 5 },
                    { text = "Confronter hemeryfb", stat = "social", value = 2, flag = "confronted_hemeryfb", hemeryfbRelation = -10 },
                    { text = "Chercher OGUN-0 (la source)", flag = "seeking_ogun", arseneRelation = 15 },
                },
            },
        },
        weekEnd = {
            dialogue = "week12_end",
        },
    },

    [13] = {
        id = 13,
        title = "La Vérité d'arsene",
        act = 3,
        theme = "Révélation Finale",
        description = "arsene dévoile son secret. Tout s'éclaire.",
        objectives = {
            "Écouter arsene",
            "Comprendre le passé d'OGUN-0",
            "Préparer le affrontement final",
        },
        energyCost = 10,
        sanityEffect = -5,
        events = {
            {
                id = "arsene_truth",
                type = "dialogue",
                title = "La Vérité",
                trigger = "start",
                dialogue = "arsene_truth_w13",
            },
        },
        boss = nil,
        choices = {
            {
                id = "final_prep",
                text = "Préparation finale",
                options = {
                    { text = "Réunir toutes les forces", stat = "social", value = 3, groupRelation = 20 },
                    { text = "Maîtriser ses pouvoirs", stat = "coding", value = 3, combatBuff = { all = 6 } },
                    { text = "Comprendre hemeryfb", stat = "empathy", value = 3, flag = "empathy_path" },
                },
            },
        },
        weekEnd = {
            dialogue = "week13_end",
        },
    },

    [14] = {
        id = 14,
        title = "La Nuit du Code Perdu",
        act = 3,
        theme = "Hackathon Fatal",
        description = "Le hackathon légendaire. hemeryfb lance son plan.",
        objectives = {
            "Participer au hackathon",
            "Découvrir le piège",
            "Survivre à la Nuit du Code Perdu",
        },
        energyCost = 30,
        sanityEffect = -20,
        events = {
            {
                id = "hackathon_start",
                type = "dialogue",
                title = "La Nuit Commence",
                trigger = "start",
                dialogue = "hackathon_start_w14",
            },
            {
                id = "hackathon_challenges",
                type = "minigame",
                title = "Défis Cryptés",
                trigger = "event",
                miniGame = "code_marathon",
            },
            {
                id = "hemeryfb_reveal",
                type = "dialogue",
                title = "La Révélation",
                trigger = "midpoint",
                dialogue = "hemeryfb_reveal_w14",
            },
        },
        miniGame = "code_marathon",
        boss = {
            id = "senior_bully",
            name = "Sénior Corrompus",
            trigger = "event",
            count = 2,
        },
        choices = {
            {
                id = "hemeryfb_betrayal",
                text = "hemeryfb trahit. Que faire ?",
                options = {
                    { text = "Le combattre", flag = "fight_hemeryfb", combatBuff = { attack = 10 } },
                    { text = "Essayer de le sauver", flag = "save_hemeryfb", socialEffect = {hemeryfb=20} },
                    { text = "Fuir et préparer un plan", flag = "retreat_plan", stat = "logic", value = 3 },
                },
            },
        },
        weekEnd = {
            dialogue = "week14_end",
        },
    },

    [15] = {
        id = 15,
        title = "Le Labyrinthe Numérique",
        act = 3,
        theme = "Conversion",
        description = "L'IAI se transforme. Les murs deviennent du code. La chair fusionne avec le métal.",
        objectives = {
            "Naviguer dans le labyrinthe",
            "Libérer les étudiants piégés",
            "Atteindre le cœur d'OGUN-0",
        },
        energyCost = 25,
        sanityEffect = -20,
        events = {
            {
                id = "labyrinth_start",
                type = "dialogue",
                title = "Bienvenue dans le Labyrinthe",
                trigger = "start",
                dialogue = "labyrinth_w15",
            },
            {
                id = "labyrinth_puzzle",
                type = "minigame",
                title = "Enigme du Labyrinthe",
                trigger = "event",
                miniGame = "labyrinth_puzzle",
            },
        },
        miniGame = "labyrinth_puzzle",
        boss = {
            id = "corrupted_student",
            name = "Gardiens du Labyrinthe",
            trigger = "event",
            count = 2,
        },
        choices = {
            {
                id = "labyrinth_path",
                text = "Quel chemin prendre ?",
                options = {
                    { text = "Chemin de la logique", stat = "logic", value = 3, flag = "logic_path" },
                    { text = "Chemin de la créativité", stat = "creativity", value = 3, flag = "creativity_path" },
                    { text = "Chemin du cœur (ensemble)", stat = "social", value = 3, groupRelation = 15, flag = "heart_path" },
                },
            },
        },
        weekEnd = {
            dialogue = "week15_end",
        },
    },

    [16] = {
        id = 16,
        title = "OGUN-0 Éveillée",
        act = 3,
        theme = "Confrontation",
        description = "L'IA est éveillée. hemeryfb la guide. La dernière chance de sauver tout le monde.",
        objectives = {
            "Affronter OGUN-0 // hemeryfb",
            "Décider le sort de l'IA",
            "Sauver hemeryfb (si possible)",
        },
        energyCost = 0,
        sanityEffect = -25,
        events = {
            {
                id = "final_battle_start",
                type = "dialogue",
                title = "Le Dernier Combat",
                trigger = "start",
                dialogue = "final_battle_w16",
            },
        },
        boss = "boss_week17",
        choices = {},
        weekEnd = {
            dialogue = "week16_end",
        },
    },

    [17] = {
        id = 17,
        title = "Examen Final — Résolution",
        act = 3,
        theme = "Épilogue",
        description = "Après la tempête. Les fins se dessinent.",
        objectives = {
            "Vivre les conséquences de tes choix",
        },
        energyCost = 0,
        sanityEffect = 0,
        events = {
            {
                id = "ending_scene",
                type = "dialogue",
                title = "Épilogue",
                trigger = "start",
                dialogue = "ending_scene",
            },
        },
        boss = nil,
        miniGame = nil,
        choices = {},
        weekEnd = {
            dialogue = "final_ending",
            isEnding = true,
        },
    },
}

return Weeks
