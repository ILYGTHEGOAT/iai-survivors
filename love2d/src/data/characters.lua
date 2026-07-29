local Characters = {
    not_a_genius = {
        name = "not_a_genius",
        title = "Le Logicien",
        hp = 110,
        mp = 80,
        stats = {
            logic = 9,
            creativity = 6,
            endurance = 5,
            social = 3,
            coding = 8,
        },
        skills = {
            "overclock_cerebral", "algorithm_strike", "debug_scan",
            "recursive_heal", "boolean_shield", "syntax_error"
        },
        color = { r = 0.3, g = 0.7, b = 1.0 },
        personality = {
            courage = 60, humor = 80, maturity = 40,
            empathy = 70, ambition = 75
        },
        description = "Surdoué de l'algorithmique, désastre social. 17 ans, a sauté une classe. Cache son insécurité derrière l'humour.",
        portrait = {
            skinColor = { 0.76, 0.6, 0.42 },
            hairColor = { 0.15, 0.1, 0.1 },
            shirtColor = { 0.2, 0.25, 0.4 },
            glasses = true,
        }
    },

    laurencium = {
        name = "laurencium",
        title = "Le Prodige Musical",
        hp = 120,
        mp = 70,
        stats = {
            logic = 5,
            creativity = 9,
            endurance = 7,
            social = 8,
            coding = 6,
        },
        skills = {
            "bass_drop", "harmonic_heal", "rhythm_combo",
            "melody_shield", "treble_strike", "sonic_boom"
        },
        color = { r = 1.0, g = 0.85, b = 0.2 },
        personality = {
            courage = 70, humor = 65, maturity = 60,
            empathy = 85, ambition = 80
        },
        description = "2m, lightskin, charisme magnétique. Hearst les bugs comme des distorsions harmoniques. Fan de Jeune Lion. Grand frère protecteur.",
        portrait = {
            skinColor = { 0.85, 0.72, 0.55 },
            hairColor = { 0.1, 0.08, 0.06 },
            shirtColor = { 0.8, 0.2, 0.3 },
            headphones = true,
        }
    },

    king = {
        name = "king",
        title = "Le Guerrier",
        hp = 130,
        mp = 50,
        stats = {
            logic = 6,
            creativity = 7,
            endurance = 8,
            social = 4,
            coding = 7,
        },
        skills = {
            "stand_void_shell", "rage_quit_burst", "jojo_pose",
            "hollow_slash", "otaku_rage", "manga_shield"
        },
        color = { r = 0.9, g = 0.2, b = 0.4 },
        personality = {
            courage = 55, humor = 75, maturity = 35,
            empathy = 60, ambition = 70
        },
        description = "Otaku hardcore, fan de JoJo et Hollow Knight. Rage-quit légendaire. Techniques de drague piochées dans les animés = catastrophes.",
        portrait = {
            skinColor = { 0.65, 0.5, 0.35 },
            hairColor = { 0.2, 0.15, 0.1 },
            shirtColor = { 0.15, 0.15, 0.2 },
            eyeTired = true,
        }
    },

    arsene = {
        name = "arsene",
        title = "Le Sage",
        hp = 100,
        mp = 90,
        stats = {
            logic = 7,
            creativity = 7,
            endurance = 6,
            social = 7,
            coding = 7,
        },
        skills = {
            "pare_feu_mental", "firewall_wall", "detect_lie",
            "info_theory", "philosophy_shield", "void_gaze"
        },
        color = { r = 0.5, g = 0.8, b = 0.5 },
        personality = {
            courage = 75, humor = 50, maturity = 90,
            empathy = 95, ambition = 50
        },
        description = "Chill, mature, ciment émotionnel du groupe. Dreadlocks, livre de philo toujours sous le bras. Cache un passé douloureux.",
        portrait = {
            skinColor = { 0.55, 0.4, 0.3 },
            hairColor = { 0.1, 0.08, 0.05 },
            shirtColor = { 0.3, 0.35, 0.3 },
            dreads = true,
            book = true,
        }
    },

    hemeryfb = {
        name = "hemeryfb",
        title = "L'Excentrique",
        hp = 115,
        mp = 75,
        stats = {
            logic = 7,
            creativity = 8,
            endurance = 6,
            social = 5,
            coding = 8,
        },
        skills = {
            "corrupted_uplink", "flesh_meld", "data_corruption",
            "bio_hack", "void_merge", "system_override"
        },
        color = { r = 0.7, g = 0.1, b = 0.8 },
        personality = {
            courage = 65, humor = 60, maturity = 50,
            empathy = 70, ambition = 90
        },
        description = "Drôle, curieux, passionné par la convergence vivant/machine. Fan de Cronenberg et Junji Ito. Le futur antagoniste.",
        portrait = {
            skinColor = { 0.7, 0.55, 0.4 },
            hairColor = { 0.05, 0.05, 0.15 },
            shirtColor = { 0.25, 0.05, 0.35 },
            tattoos = true,
        }
    },
}

return Characters
