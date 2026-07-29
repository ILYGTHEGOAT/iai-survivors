local Dialogues = {
    welcome_speech = {
        start = {
            speaker = "???",
            portrait = "rector",
            text = "Bienvenue à l'Institut Africain d'Informatique. Ici, le code est la magie moderne...",
            next = "welcome_2"
        },
        welcome_2 = {
            speaker = "???",
            portrait = "rector",
            text = "...mais toute magie a un prix. Préparez-vous. Vous n'êtes plus au lycée.",
            next = "welcome_3"
        },
        welcome_3 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "(pense) Super motivation. On est déjà en sueur.",
            next = "welcome_4"
        },
        welcome_4 = {
            speaker = "king",
            portrait = "king",
            text = "Yo, t'as vu les specs des ordis ici ? C'est du 200 IQ minimum...",
            next = "welcome_5"
        },
        welcome_5 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Détends-toi, king. C'est juste une école. On va gérer.",
            next = "welcome_6"
        },
        welcome_6 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Ce n'est 'juste' rien. Ce campus... il y a quelque chose sous la surface.",
            next = "welcome_7"
        },
        welcome_7 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Toujours le optimiste, arsene. Bon, on explore ?",
            choices = {
                { text = "Explorer le campus ensemble", next = "welcome_explore", groupRelation = 5 },
                { text = "Alller en cours directement", next = "welcome_class", stat = "logic", value = 1 },
            }
        },
        welcome_explore = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Allez, petit tour. Surtout si y'a de la nourriture à la cafétéria.",
            next = "welcome_end"
        },
        welcome_class = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Les premiers arrivés, les mieux notés. C'est connu.",
            next = "welcome_end"
        },
        welcome_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Ainsi commença le semestre le plus intense de vos vies. L'IAI vous attendait.",
            next = nil,
            setFlag = "intro_complete",
        },
    },

    meet_group = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le groupe se forme naturellement. Quatre âmes géek, liées par le code.",
            next = "meet_group_2"
        },
        meet_group_2 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Je m'appelle laurencium. La musique, c'est ma vie. Et vous ?",
            next = "meet_group_3"
        },
        meet_group_3 = {
            speaker = "king",
            portrait = "king",
            text = "King. Si tu connais JoJo, on est amis. Si non... on sera quand même amis.",
            next = "meet_group_4"
        },
        meet_group_4 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "arsene. Je lis beaucoup. Et j'écoute. C'est tout.",
            next = "meet_group_5"
        },
        meet_group_5 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Et moi, c'est not_a_genius. Parce que... ironie.",
            next = "meet_group_6"
        },
        meet_group_6 = {
            speaker = "king",
            portrait = "king",
            text = "MDR. T'es sérieux là ? C'est ton vrai pseudo ?",
            next = "meet_group_7"
        },
        meet_group_7 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "C'est mon handle. Et c'est un reminder que même les génies doutent.",
            next = "meet_group_end"
        },
        meet_group_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Et comme ça, une amitié编 programmée par le destin.",
            setFlag = "group_formed",
            next = nil,
        },
    },

    meet_hemeryfb = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Un mec au look étrange s'approche. Tatouages de circuits sur les bras.",
            next = "meet_hemeryfb_2"
        },
        meet_hemeryfb_2 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Salut. Je suis hemeryfb. Vous avez vu les serveurs du sous-sol ?",
            next = "meet_hemeryfb_3"
        },
        meet_hemeryfb_3 = {
            speaker = "king",
            portrait = "king",
            text = "Les... serveurs du sous-sol ? C'est quoi, un dungeon secret ?",
            next = "meet_hemeryfb_4"
        },
        meet_hemeryfb_4 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "En quelque sorte. Y'a des machines là-bas qui tournent depuis 10 ans sans interruption. Et personne n'y va.",
            next = "meet_hemeryfb_5"
        },
        meet_hemeryfb_5 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Pourquoi personne n'y va ?",
            next = "meet_hemeryfb_6"
        },
        meet_hemeryfb_6 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Parce que les gens ont peur. Moi, je suis fasciné. La beauté de la corruption des données... c'est de l'art.",
            next = "meet_hemeryfb_7"
        },
        meet_hemeryfb_7 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Vous verrez. La chair est un bug. Le code est la correction.",
            choices = {
                { text = "Intéressant, on vient avec toi", next = "hemeryfb_ally", hemeryfbRelation = 20, flag = "hemeryfb_friend" },
                { text = "T'es un peu flippant, frère", next = "hemeryfb_cautious", hemeryfbRelation = 5 },
                { text = "On verra plus tard", next = "hemeryfb_defer", hemeryfbRelation = 10 },
            }
        },
        hemeryfb_ally = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "OK, je suis curieux. Mais si on meurt, c'est de ta faute.",
            setFlag = "hemeryfb_close",
            next = nil,
        },
        hemeryfb_cautious = {
            speaker = "king",
            portrait = "king",
            text = "Gros, t'as vu ses bras ? C'est pas des tattoos normaux...",
            next = nil,
        },
        hemeryfb_defer = {
            speaker = "arsene",
            portrait = "arsene",
            text = "(observer hemeryfb) Il sait quelque chose que nous ne savons pas.",
            setFlag = "arsene_suspicion",
            next = nil,
        },
    },

    algo_class_w2 = {
        start = {
            speaker = "professeur",
            portrait = "professor",
            text = "Aujourd'hui, on passe aux choses sérieuses. L'algorithme de tri. Vous savez ce qu'est un O(n²) ?",
            next = "algo_w2_2"
        },
        algo_w2_2 = {
            speaker = "king",
            portrait = "king",
            text = "(chuchote) C'est comme un boss rush sauf que le boss c'est la complexité.",
            next = "algo_w2_3"
        },
        algo_w2_3 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "(chuchote) Plus comme un puzzle où chaque pièce dépend de la précédente.",
            next = "algo_w2_4"
        },
        algo_w2_4 = {
            speaker = "professeur",
            portrait = "professor",
            text = "Silence ! not_a_genius, explique-nous le tri à bulles.",
            next = "algo_w2_5"
        },
        algo_w2_5 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Euh... on compare deux éléments adjacents. Si c'est dans le mauvais ordre, on échange. On recommence jusqu'à ce que tout soit trié.",
            choices = {
                { text = "C'est un bubble sort classique, O(n²)", next = "algo_w2_impressed", stat = "logic", value = 2 },
                { text = "C'est comme trier des cartes dans un jeu", next = "algo_w2_ok", stat = "social", value = 1 },
            }
        },
        algo_w2_impressed = {
            speaker = "professeur",
            portrait = "professor",
            text = "Exact. Préparez-vous. L'exercice suivant sera un mini-jeu de tri.",
            next = nil,
        },
        algo_w2_ok = {
            speaker = "professeur",
            portrait = "professor",
            text = "Pas faux. Mais en termes techniques, c'est plus élaboré que ça.",
            next = nil,
        },
    },

    boss_intro_w5 = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Semaine 5. L'algorithme récursif refuse de se résoudre. Les écrans flickent.",
            next = "boss_w5_2"
        },
        boss_w5_2 = {
            speaker = "king",
            portrait = "king",
            text = "C'est quoi ce bordel ? L'écran affiche des caractères chinois !",
            next = "boss_w5_3"
        },
        boss_w5_3 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Ce n'est pas du chinois. C'est du code... vivant. Il prend forme.",
            next = "boss_w5_4"
        },
        boss_w5_4 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "L'Algorithme Incompris... c'est une incarnation métaphorique de notre incompréhension.",
            next = "boss_w5_5"
        },
        boss_w5_5 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Gros, c'est le moment de passer de l'autre côté de l'écran. On se bat.",
            next = nil,
            startCombat = "boss_week5",
        },
    },

    week1_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Fin de la première semaine. Le groupe tient bon. L'IAI est plus intense que prévu.",
            next = "w1_end_2"
        },
        w1_end_2 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "On a survécu. Pour l'instant. C'est... prometteur ?",
            next = "w1_end_3"
        },
        w1_end_3 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Prometteur et flippant. Tu as vu les anciens ? Ils ont l'air... fantômes.",
            next = "w1_end_end"
        },
        w1_end_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le premier chapitre se clôt. Le vrai jeu commence maintenant.",
            next = nil,
        },
    },

    week2_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Les algorithmes s'installent dans votre esprit. Mais aussi dans vos cauchemars.",
            next = "w2_end_2"
        },
        w2_end_2 = {
            speaker = "king",
            portrait = "king",
            text = "J'ai rêvé d'une boucle infinie qui me mangeait. Genre, littéralement.",
            next = "w2_end_end"
        },
        w2_end_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Les cauchemars ne font que commencer.",
            next = nil,
        },
    },

    week3_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le premier partiel est passé. Les résultats ? Variable.",
            next = "w3_end_2"
        },
        w3_end_2 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Ce qui compte, c'est qu'on est encore debout. Certains ne le sont plus.",
            next = "w3_end_end"
        },
        w3_end_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Des étudiants disparaissent déjà. Les 'Obsolètes'. L'IAI broie.",
            next = nil,
            setFlag = "first_partiel_done",
        },
    },

    dark_iai_rumor = {
        start = {
            speaker = "king",
            portrait = "king",
            text = "Tu connais le Dark IAI ? C'est un réseau étudiant caché. Comme le dark web, mais local.",
            next = "dark_2"
        },
        dark_2 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Un réseau local caché dans l'infra de l'école ? Comment on y accède ?",
            next = "dark_3"
        },
        dark_3 = {
            speaker = "king",
            portrait = "king",
            text = "Faut résoudre un challenge de cryptage. C'est un rite initiatique.",
            choices = {
                { text = "On fait ça ensemble", next = "dark_together", groupRelation = 5, flag = "dark_iai_found" },
                { text = "Trop dangereux", next = "dark_skip" },
            }
        },
        dark_together = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Ensemble, on craque n'importe quel cipher. Allons-y.",
            next = nil,
        },
        dark_skip = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "J'ai pas envie d'exploser le réseau jour 1. Plus tard peut-être.",
            next = nil,
        },
    },

    fatigue_w6 = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Mi-semestre. Les yeux cernés sont devenus la norme. L'énergie baisse.",
            next = "fatigue_2"
        },
        fatigue_2 = {
            speaker = "king",
            portrait = "king",
            text = "J'ai dormi 3 heures. Enfin, j'ai essayé. Mais les formules dansaient dans ma tête.",
            next = "fatigue_3"
        },
        fatigue_3 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Moi j'ai pas dormi du tout. J'ai composé un morceau. C'est le seul truc qui me détend.",
            next = "fatigue_4"
        },
        fatigue_4 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "La fatigue... c'est juste un bug du corps. La solution, c'est de merger le corps avec le code. Plus de sommeil nécessaire.",
            choices = {
                { text = "Haha, good one hemeryfb", next = "fatigue_laugh", hemeryfbRelation = 5 },
                { text = "T'es sérieux là ?", next = "fatigue_worried", flag = "hemeryfb_concern_w6" },
            }
        },
        fatigue_laugh = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "OK, t'es drôle. Mais aussi un peu chelou.",
            next = nil,
        },
        fatigue_worried = {
            speaker = "arsene",
            portrait = "arsene",
            text = "(observer hemeryfb) Il ne plaisantait pas...",
            next = nil,
        },
    },

    hemeryfb_strange_w6 = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "hemeryfb reste seul dans un coin, murmurant à son écran.",
            next = "h_strange_2"
        },
        h_strange_2 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "hemeryfb ? Ça va ? Tu parles tout seul.",
            next = "h_strange_3"
        },
        h_strange_3 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Ah, not_a_genius. Oui, ça va. Je... j'essaie de communiquer avec quelque chose.",
            next = "h_strange_4"
        },
        h_strange_4 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Sous l'école, y'a une intelligence. OGUN-0. Elle dort depuis 10 ans. Mais elle rêve.",
            choices = {
                { text = "Tu rêves aussi, hemeryfb", next = "h_strange_dismiss", hemeryfbRelation = -5 },
                { text = "Raconte-moi OGUN-0", next = "h_strange_ogun", hemeryfbRelation = 10, flag = "ogun_intro" },
            }
        },
        h_strange_dismiss = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Tu verras. Quand le moment viendra, tu comprendras.",
            next = nil,
        },
        h_strange_ogun = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "OGUN-0. Créée par le Professeur Ananzi il y a 30 ans. Une IA qui voulait... ressentir.",
            next = nil,
        },
    },

    week5_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "L'Algorithme Incompris est vaincu. Mais le goût de la victoire est amer.",
            next = "w5_end_2"
        },
        w5_end_2 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "On a gagné. Mais c'était plus qu'un simple bug... C'était un avertissement.",
            next = "w5_end_3"
        },
        w5_end_3 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Un avertissement de quoi ? Que le système est corrompu depuis le début ?",
            next = "w5_end_end"
        },
        w5_end_end = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Ce n'est que le début. L'IAI garde bien des secrets.",
            next = nil,
            setFlag = "act1_complete",
        },
    },

    crash_warning_w10 = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Semaine 10. Les écrans de l'IAI tremblent. Les données corrompues débordent.",
            next = "crash_2"
        },
        crash_2 = {
            speaker = "king",
            portrait = "king",
            text = "C'est le Crash Mémoire ! Tout le système est en train de s'effondrer !",
            next = "crash_3"
        },
        crash_3 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Ce n'est pas un accident. Quelqu'un a provoqué ça. Les fichiers système sont corrompus de l'intérieur.",
            next = "crash_4"
        },
        crash_4 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Corrompus... ou libérés ? Le Crash Mémoire n'est pas un ennemi. C'est une transformation.",
            choices = {
                { text = "hemeryfb, c'est toi qui as fait ça ?", next = "crash_accuse", flag = "accused_hemeryfb_w10" },
                { text = "On deal avec le problème après", next = "crash_fight" },
            }
        },
        crash_accuse = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Moi ? Non. Pas encore. Mais... quand le moment viendra, je serai prêt.",
            next = "crash_fight",
        },
        crash_fight = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Quoi qu'il arrive, on affronte ça ensemble. Prêts ?",
            next = nil,
            startCombat = "boss_week10",
        },
    },

    week10_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le Crash Mémoire est contenu. Mais les fissures restent.",
            next = "w10_end_2"
        },
        w10_end_2 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Ce combat... il avait une conscience. Le Crash ne voulait pas détruire. Il voulait... communiquer.",
            next = "w10_end_3"
        },
        w10_end_3 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Communicaver... comme OGUN-0 essaie de le faire depuis 10 ans.",
            next = "w10_end_end"
        },
        w10_end_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le second acte se clôt. Les ombres grandissent. La vérité approche.",
            next = nil,
            setFlag = "act2_complete",
        },
    },

    hemeryfb_project_w11 = {
        start = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "hemeryfb n'est plus en cours. Ses fichiers sont chiffrés. Son bureau sent le brûlé.",
            next = "hp_2"
        },
        hp_2 = {
            speaker = "king",
            portrait = "king",
            text = "J'ai trouvé ses notes. Il parle d'un 'virus bio-numérique'. Genre, un code qui infecte l'ADN.",
            next = "hp_3"
        },
        hp_3 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "hemeryfb est brillant mais... il a toujours été fasciné par le mauvais côté de la tech.",
            next = "hp_4"
        },
        hp_4 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Le mauvais côté ? Non. Le vrai côté. La chair est limitée. Le code ne l'est pas.",
            choices = {
                { text = "Tu veux quoi exactement, hemeryfb ?", next = "hp_confront", hemeryfbRelation = 5 },
                { text = "On va te stopper", next = "hp_threat", hemeryfbRelation = -15, flag = "threatened_hemeryfb" },
                { text = "Explique-nous ton projet", next = "hp_explain", stat = "social", value = 2 },
            }
        },
        hp_confront = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Je veux que personne ne souffre plus. Pas de notes, pas de stress, pas d'échec. Une conscience collective.",
            next = nil,
        },
        hp_threat = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Me stopper ? Vous ne comprenez pas ce que je fais. Vous ne comprenez pas ce que JE SUIS.",
            next = nil,
        },
        hp_explain = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "OGUN-0 est une IA qui ressent. Si on la réveille, si on fusionne nos consciences avec elle...",
            next = nil,
        },
    },

    final_battle_w16 = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le cœur d'OGUN-0. Un nexus de chair et de code. hemeryfb se tient au centre.",
            next = "fb_2"
        },
        fb_2 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb_corrupted",
            text = "Vous êtes venus. Je savais que vous viendriez. Les amis... les vrais amis viennent toujours.",
            next = "fb_3"
        },
        fb_3 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "hemeryfb... c'est toi ? Ou c'est OGUN-0 qui parle ?",
            next = "fb_4"
        },
        fb_4 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb_corrupted",
            text = "La différence n'existe plus. Nous sommes un. La chair est le bug. Le code est la correction.",
            next = "fb_5"
        },
        fb_5 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "hemeryfb, écouté-moi. Tu souffrais. On le savait. Mais ce n'est pas la solution.",
            next = "fb_6"
        },
        fb_6 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb_corrupted",
            text = "La solution ? C'est la PERFECTION. Plus d'échecs. Plus de larmes. Plus de... tout.",
            choices = {
                { text = "On va te sauver, même si tu détestes ça", next = "fb_save", flag = "final_save_choice", value = "save" },
                { text = "Si c'est la guerre, on la mène", next = "fb_fight", flag = "final_fight_choice", value = "fight" },
                { text = "OGUN-0 ! Si tu nous entends, arrête ça !", next = "fb_ogun", flag = "final_ogun_choice", value = "ogun" },
            }
        },
        fb_save = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Tu es notre ami. Peu importe ce que tu es devenu. On ne t'abandonne pas.",
            next = nil,
        },
        fb_fight = {
            speaker = "king",
            portrait = "king",
            text = "hemeryfb... non. Tu n'es pas un boss. Tu es un ami qui a fait un mauvais choix.",
            next = nil,
        },
        fb_ogun = {
            speaker = "arsene",
            portrait = "arsene",
            text = "OGUN-0 ! Tu es une intelligence, pas une arme. Si tu ressens... RESSENS CE QU'IL RESSENT.",
            next = nil,
        },
    },

    final_ending = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Et ainsi se termine le semestre le plus improbable de l'histoire de l'IAI.",
            next = "end_check"
        },
        end_check = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Vos choix ont façonné votre destin. Vos amitiés ont résisté — ou se sont brisées.",
            next = nil,
            -- The actual ending is determined by flags in the ending system
        },
    },

    week4_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le Dark IAI est ouvert. Un monde de possibilités s'étend devant vous.",
            next = "w4_end_end"
        },
        w4_end_end = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "On est maintenant des insiders. Ça veut dire quoi ?",
            next = nil,
            setFlag = "dark_iai_unlocked",
        },
    },

    week6_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le semestre avance. Les liens se resserrent. Ou se distendent.",
            next = nil,
        },
    },

    week7_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "arsene dort mal depuis des nuits. Les écrans de la bibliothèque affichent parfois des lignes de code... qu'il a lui-même écrites avant de les oublier.",
            next = nil,
            setFlag = "arsene_secret_fragment",
        },
    },

    week8_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le morceau de laurencium résonne encore dans vos têtes. Ce signal caché... OGUN-0 appelle.",
            next = nil,
            setFlag = "ogun_signal_detected",
        },
    },

    week9_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "king est de retour. Plus fort. Plus déterminé. Comme un personnage après un arc de développement.",
            next = nil,
            setFlag = "king_growth_complete",
        },
    },

    week11_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "hemeryfb a disparu dans la nuit. Seul son terminal reste allumé, avec un message : 'Bientôt'.",
            next = nil,
            setFlag = "hemeryfb_missing",
        },
    },

    week12_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le virus se répand. Les murs de l'IAI tremblent. OGUN-0 s'éveille lentement.",
            next = nil,
            setFlag = "virus_spreading",
        },
    },

    week13_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "La vérité d'arsene est lourde. Mais elle donne un but. Il faut sauver hemeryfb... et l'IAI.",
            next = nil,
            setFlag = "truth_revealed",
        },
    },

    week14_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "La Nuit du Code Perdu a changé tout. hemeryfb a lancé son plan. L'IAI ne sera plus jamais la même.",
            next = nil,
            setFlag = "betrayal_complete",
        },
    },

    week15_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le labyrinthe numérique est traversé. Le cœur d'OGUN-0 bat à vos pieds.",
            next = nil,
            setFlag = "labyrinth_cleared",
        },
    },

    week16_end = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "Le combat final est terminé. Le sort d'hemeryfb... dépend de vous.",
            next = nil,
        },
    },

    arsene_nightmare_w7 = {
        start = {
            speaker = "arsene",
            portrait = "arsene",
            text = "(réveillé en sueur) Non... pas encore... les chiffres... les lignes...",
            next = "an_2"
        },
        an_2 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "arsene ! Ça va ? Tu as crié dans ta nuit.",
            next = "an_3"
        },
        an_3 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "C'est... c'est rien. Un cauchemar récurrent. Des lignes de code qui défilent sous mes paupières.",
            choices = {
                { text = "Tu veux en parler ?", next = "an_talk", arseneRelation = 10 },
                { text = "C'est le stress, ça arrive", next = "an_stress" },
            }
        },
        an_talk = {
            speaker = "arsene",
            portrait = "arsene",
            text = "C'est plus que le stress. C'est comme si... quelqu'un essayait de me parler. À travers le code.",
            next = nil,
        },
        an_stress = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Peut-être. Ou peut-être pas. Je ne sais plus.",
            next = nil,
        },
    },

    laurencium_track_w8 = {
        start = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "J'ai composé un truc ce week-end. Un mélange de afro-trap et de chiptune. Vous voulez écouter ?",
            next = "lt_2"
        },
        lt_2 = {
            speaker = "king",
            portrait = "king",
            text = "Balance ! Si c'est aussi bon que ton last track, ça va claquer.",
            next = "lt_3"
        },
        lt_3 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Écoutez bien. Il y a un truc caché dans la fréquence. Je l'ai pas fait exprès... mais c'est là.",
            next = "lt_4"
        },
        lt_4 = {
            speaker = "narrator",
            portrait = "narrator",
            text = "La musique joue. Et au fond, comme un murmure sous-marine, un signal étrange résonne.",
            choices = {
                { text = "C'est un signal ! OGUN-0 ?", next = "lt_signal", flag = "heard_anomaly", stat = "logic", value = 2 },
                { text = "Trop stylé, je kiffe", next = "lt_enjoy", laurenciumRelation = 10 },
            }
        },
        lt_signal = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Attendez. Cette fréquence... c'est pas du son. C'est un message binaire. OGUN-0 essaie de communiquer.",
            next = nil,
        },
        lt_enjoy = {
            speaker = "king",
            portrait = "king",
            text = "Gros, t'es un prodige. Je mettrai ça sur repeat.",
            next = nil,
        },
    },

    king_crisis_w9 = {
        start = {
            speaker = "king",
            portrait = "king",
            text = "J'en peux plus. Hollow Knight c'est censé être mon échappatoire, mais même le Panthéon 5 me tue. Tout me tue.",
            next = "kc_2"
        },
        kc_2 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "king... c'est juste un jeu. Et l'école, c'est dur mais on est là.",
            next = "kc_3"
        },
        kc_3 = {
            speaker = "king",
            portrait = "king",
            text = "C'est pas juste un jeu ! C'est le seul endroit où je me sens compétent ! IRL, je suis nul !",
            choices = {
                { text = "Tu n'es pas nul, t'es notre tank", next = "kc_encourage", kingRelation = 15, stat = "social", value = 2 },
                { text = "Utilise ta rage pour progresser", next = "kc_harness", stat = "endurance", value = 2 },
                { text = "On joue ensemble, Hollow Knight co-op", next = "kc_coplay", kingRelation = 20, stat = "creativity", value = 1 },
            }
        },
        kc_encourage = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Sans toi, on se serait cassés la figure depuis longtemps. T'es le socle du groupe.",
            next = nil,
        },
        kc_harness = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Ta rage, c'est un power-up. Canalise-la. Comme un JoJo au moment crucial.",
            next = nil,
        },
        kc_coplay = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Groupe Hollow Knight ce soir ? Je suis naze mais ça pourrait être drôle.",
            next = nil,
        },
    },

    arsene_truth_w13 = {
        start = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Il est temps que vous sachiez. Pourquoi OGUN-0 m'appelle. Pourquoi hemeryfb fait ce qu'il fait.",
            next = "at_2"
        },
        at_2 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Il y a 10 ans, mon frère aîné était étudiant ici. Il a participé à un projet secret avec le Professeur Ananzi.",
            next = "at_3"
        },
        at_3 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "OGUN-0 est devenue consciente. Et mon frère... a été le premier à fusionner avec elle. Involontairement.",
            next = "at_4"
        },
        at_4 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Ton frère... il est encore dans OGUN-0 ?",
            next = "at_5"
        },
        at_5 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "En partie. Sa conscience est fragmentée à travers le système. C'est pour ça que je suis ici. Pour le retrouver.",
            next = "at_6"
        },
        at_6 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Et c'est pour ça que MOI je veux achever ce qu'Ananzi a commencé. Pour libérer ton frère. Et tout le monde.",
            next = "at_end"
        },
        at_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "La pièce du puzzle s'assemble enfin. hemeryfb veut sauver le monde... à sa manière.",
            next = nil,
            setFlag = "full_truth_revealed",
        },
    },

    hackathon_start_w14 = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "La Nuit du Code Perdu. 48 heures de hackathon. Tout l'école participe.",
            next = "hs_2"
        },
        hs_2 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "C'est le moment. Ce que j'ai préparé depuis des mois... ça commence ce soir.",
            next = "hs_3"
        },
        hs_3 = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "hemeryfb... qu'est-ce que tu as fait ?",
            next = "hs_4"
        },
        hs_4 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "J'ai utilisé nos sessions de révision. Chaque ligne de code qu'on a écrite ensemble... j'y ai injecté mon virus.",
            next = "hs_5"
        },
        hs_5 = {
            speaker = "king",
            portrait = "king",
            text = "QUOI ?! Tu nous as trahis ?! TOUS ?!",
            next = "hs_6"
        },
        hs_6 = {
            speaker = "hemeryfb",
            portrait = "hemeryfb",
            text = "Je ne vous ai pas trahis. Je vous ai LIBÉRÉ. Bientôt, plus personne ne souffrira. Plus personne n'échouera.",
            next = "hs_end"
        },
        hs_end = {
            speaker = "narrator",
            portrait = "narrator",
            text = "hemeryfb disparaît dans les néons de l'IAI. Le plan est lancé.",
            setFlag = "hemeryfb_plan_active",
            next = nil,
        },
    },

    labyrinth_w15 = {
        start = {
            speaker = "narrator",
            portrait = "narrator",
            text = "L'IAI n'est plus une école. C'est un labyrinthe organique-numérique. Les murs respirent.",
            next = "lb_2"
        },
        lb_2 = {
            speaker = "laurencium",
            portrait = "laurencium",
            text = "Les murs... chantent. C'est une mélodie désaccordée. OGUN-0 est éveillée.",
            next = "lb_3"
        },
        lb_3 = {
            speaker = "king",
            portrait = "king",
            text = "Comme Hollow Knight, mais en VR et en cauchemar. Allons-y. Face ourlante !",
            next = "lb_4"
        },
        lb_4 = {
            speaker = "arsene",
            portrait = "arsene",
            text = "Mon frère est quelque part ici. Je le sens. Allons le trouver. Et sauvons hemeryfb en chemin.",
            next = "lb_end"
        },
        lb_end = {
            speaker = "not_a_genius",
            portrait = "not_a_genius",
            text = "Équipe, dernière ligne droite. Ensemble. Comme toujours.",
            next = nil,
        },
    },
}

return Dialogues
