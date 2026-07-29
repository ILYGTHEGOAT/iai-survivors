import '../models/party_member.dart';
import '../models/enemy.dart';
import '../models/skill.dart';
import '../models/dialogue_node.dart';
import '../models/week_data.dart';

class GameData {
  static List<PartyMember> get defaultParty => [
        PartyMember(
          id: 'not_a_genius',
          name: 'not_a_genius',
          title: 'Le Logicien',
          maxHp: 110,
          maxMp: 80,
          colorHex: '#00CCCC',
          stats: {
            'logic': 7,
            'creativity': 5,
            'endurance': 4,
            'social': 5,
            'coding': 6,
          },
          skills: _notAGeniusSkills,
        ),
        PartyMember(
          id: 'laurencium',
          name: 'laurencium',
          title: 'Le Prodige Musical',
          maxHp: 120,
          maxMp: 70,
          colorHex: '#CCAA00',
          stats: {
            'logic': 4,
            'creativity': 7,
            'endurance': 5,
            'social': 6,
            'coding': 4,
          },
          skills: _laurenciumSkills,
        ),
        PartyMember(
          id: 'king',
          name: 'king',
          title: 'Le Guerrier',
          maxHp: 130,
          maxMp: 50,
          colorHex: '#CC2222',
          stats: {
            'logic': 3,
            'creativity': 4,
            'endurance': 8,
            'social': 5,
            'coding': 3,
          },
          skills: _kingSkills,
        ),
        PartyMember(
          id: 'arsene',
          name: 'arsene',
          title: 'Le Sage',
          maxHp: 100,
          maxMp: 90,
          colorHex: '#22CC22',
          stats: {
            'logic': 6,
            'creativity': 5,
            'endurance': 5,
            'social': 4,
            'coding': 5,
          },
          skills: _arseneSkills,
        ),
      ];

  static List<Enemy> get enemies => [
        Enemy(id: 'bug_simple', name: 'Bug Simple', maxHp: 40, baseAttack: 8, baseDefense: 3, baseSpeed: 5),
        Enemy(id: 'gobelin_syntaxique', name: 'Gobelin Syntaxique', maxHp: 55, baseAttack: 12, baseDefense: 5, baseSpeed: 7),
        Enemy(id: 'fuite_memoire', name: 'Fuite Memoire', maxHp: 50, baseAttack: 10, baseDefense: 4, baseSpeed: 9),
        Enemy(id: 'goule_null_pointer', name: 'Goule Null Pointer', maxHp: 65, baseAttack: 14, baseDefense: 6, baseSpeed: 6),
        Enemy(id: 'fantome_deadline', name: 'Fantome de Deadline', maxHp: 80, baseAttack: 16, baseDefense: 7, baseSpeed: 8),
        Enemy(id: 'etudiant_corrompu', name: 'Etudiant Corrompu', maxHp: 90, baseAttack: 18, baseDefense: 8, baseSpeed: 7),
        Enemy(id: 'senior_bizutageur', name: 'Senior Bizutageur', maxHp: 100, baseAttack: 20, baseDefense: 10, baseSpeed: 6),
      ];

  static List<Enemy> get bosses => [
        Enemy(
          id: 'algo_incompris',
          name: 'Algorithme Incompris',
          maxHp: 200,
          baseAttack: 22,
          baseDefense: 12,
          baseSpeed: 8,
          isBoss: true,
          phases: [
            BossPhase(hpThreshold: 0.7, attackBonus: 5),
            BossPhase(hpThreshold: 0.4, attackBonus: 10, defenseBonus: 5),
          ],
        ),
        Enemy(
          id: 'crash_memoire',
          name: 'Crash Memoire',
          maxHp: 350,
          baseAttack: 28,
          baseDefense: 15,
          baseSpeed: 10,
          isBoss: true,
          phases: [
            BossPhase(hpThreshold: 0.7, attackBonus: 8),
            BossPhase(hpThreshold: 0.4, attackBonus: 15, defenseBonus: 8),
            BossPhase(hpThreshold: 0.15, attackBonus: 20, defenseBonus: 12, speedBonus: 5),
          ],
        ),
        Enemy(
          id: 'ogun0_hemeryfb',
          name: 'OGUN-0 // hemeryfb',
          maxHp: 500,
          baseAttack: 35,
          baseDefense: 20,
          baseSpeed: 12,
          isBoss: true,
          phases: [
            BossPhase(hpThreshold: 0.7, attackBonus: 10, defenseBonus: 5),
            BossPhase(hpThreshold: 0.4, attackBonus: 20, defenseBonus: 10, speedBonus: 5),
            BossPhase(hpThreshold: 0.15, attackBonus: 30, defenseBonus: 15, speedBonus: 10),
          ],
        ),
      ];

  static List<WeekData> get weeks => [
        const WeekData(
          week: 1,
          act: 1,
          title: 'Decouverte',
          description: 'Votre premier pas a l\'IAI. Tout est nouveau.',
          dialogueId: 'welcome_speech',
          objectives: ['Rencontrer votre groupe', 'Apprendre les bases'],
          bgScene: 'campus_day',
        ),
        const WeekData(
          week: 2,
          act: 1,
          title: 'Premiers Pas',
          description: 'Les cours commencent. L\'algorithme est votre arme.',
          dialogueId: 'meet_group',
          objectives: ['Etudier les algorithmes de base', 'Commencer a coder'],
          bgScene: 'classroom',
        ),
        const WeekData(
          week: 3,
          act: 1,
          title: 'L\'Appel du Code',
          description: 'Vous decouvrez votre talent pour la programmation.',
          objectives: ['Ameliorer vos competences', 'Explorer le campus'],
          bgScene: 'campus_day',
        ),
        const WeekData(
          week: 4,
          act: 1,
          title: 'L\'Ombre',
          description: 'Quelque chose cloche a l\'IAI. hemeryfb agit bizarrement.',
          objectives: ['Observer hemeryfb', 'Collecter des indices'],
          bgScene: 'campus_night',
        ),
        const WeekData(
          week: 5,
          act: 1,
          title: 'Le Premier Defi',
          description: 'Un algorithme corrompu menace l\'ecole.',
          bossId: 'algo_incompris',
          objectives: ['Vaincre l\'Algorithme Incompris'],
          bgScene: 'combat',
        ),
        const WeekData(
          week: 6,
          act: 2,
          title: 'La Fatigue',
          description: 'La pression monte. La fatigue se fait sentir.',
          objectives: ['Gerer votre energie', 'Reposer votre esprit'],
          bgScene: 'campus_night',
          energyCost: 20,
          sanityCost: 5,
        ),
        const WeekData(
          week: 7,
          act: 2,
          title: 'Le Secret de hemeryfb',
          description: 'hemeryfb travaille sur un projet cache.',
          objectives: ['Decouvrir le projet OGUN-0'],
          bgScene: 'server_room',
        ),
        const WeekData(
          week: 8,
          act: 2,
          title: 'L\'Anomalie',
          description: 'laurencium detecte une anomalie dans les donnees musicales.',
          objectives: ['Analyser l\'anomalie'],
          bgScene: 'classroom',
        ),
        const WeekData(
          week: 9,
          act: 2,
          title: 'La Crise',
          description: 'king traverse une periode difficile.',
          objectives: ['Soutenir king'],
          bgScene: 'campus_day',
        ),
        const WeekData(
          week: 10,
          act: 2,
          title: 'Le Crash',
          description: 'Un crash memoire massive frappe l\'IAI.',
          bossId: 'crash_memoire',
          objectives: ['Vaincre le Crash Memoire'],
          bgScene: 'combat',
        ),
        const WeekData(
          week: 11,
          act: 3,
          title: 'Le Projet',
          description: 'hemeryfb devoile son veritable projet.',
          objectives: ['Investiguer OGUN-0'],
          bgScene: 'server_room',
        ),
        const WeekData(
          week: 12,
          act: 3,
          title: 'La Revelation',
          description: 'La verite sur OGUN-0 eclate.',
          objectives: ['Comprendre l\'histoire d\'arsene'],
          bgScene: 'dark_iai',
        ),
        const WeekData(
          week: 13,
          act: 3,
          title: 'Le Choix',
          description: 'arsene revele tout. Il est temps de choisir.',
          objectives: ['Prendre une decision'],
          bgScene: 'server_room',
        ),
        const WeekData(
          week: 14,
          act: 3,
          title: 'La Trahison',
          description: 'hemeryfb active OGUN-0.',
          objectives: ['Arreter hemeryfb'],
          bgScene: 'dark_iai',
        ),
        const WeekData(
          week: 15,
          act: 3,
          title: 'Le Labyrinthe',
          description: 'Le reseau numerique vous entraine dans un labyrinthe.',
          minigameId: 'labyrinth_puzzle',
          objectives: ['Sortir du labyrinthe'],
          bgScene: 'labyrinth',
        ),
        const WeekData(
          week: 16,
          act: 3,
          title: 'La Bataille Finale',
          description: 'Le combat final contre OGUN-0 et hemeryfb.',
          objectives: ['Vaincre OGUN-0', 'Sauver hemeryfb'],
          bgScene: 'combat',
        ),
        const WeekData(
          week: 17,
          act: 3,
          title: 'L\'Aube',
          description: 'Le semestre touche a sa fin. Vos choix definissent l\'avenir.',
          objectives: ['Voir les consequences de vos choix'],
          bgScene: 'campus_day',
        ),
      ];

  static List<Skill> get _notAGeniusSkills => [
        const Skill(id: 'logic_blast', name: 'Logic Blast', description: 'Attaque basee sur la logique pure', mpCost: 10, type: SkillType.attack, power: 20, levelRequired: 1),
        const Skill(id: 'code_strike', name: 'Code Strike', description: 'Frappe de code compilé', mpCost: 15, type: SkillType.attack, power: 30, levelRequired: 3),
        const Skill(id: 'algo_shield', name: 'Algo Shield', description: 'Bouclier algorithmique', mpCost: 12, type: SkillType.defense, power: 15, targetType: 'self', levelRequired: 2),
        const Skill(id: 'recursion', name: 'Recursion', description: 'Attaque recursive qui frappe 3 fois', mpCost: 25, type: SkillType.attack, power: 12, levelRequired: 5),
        const Skill(id: 'optimize', name: 'Optimize', description: 'Booste l\'attaque du groupe', mpCost: 20, type: SkillType.support, targetType: 'party', levelRequired: 4),
        const Skill(id: 'debug', name: 'Debug', description: 'Supprime tous les debuffs', mpCost: 15, type: SkillType.special, targetType: 'party', levelRequired: 6),
      ];

  static List<Skill> get _laurenciumSkills => [
        const Skill(id: 'melody_strike', name: 'Melody Strike', description: 'Attaque musicale', mpCost: 10, type: SkillType.attack, power: 18, levelRequired: 1),
        const Skill(id: 'harmony_heal', name: 'Harmony Heal', description: 'Soin par la musique', mpCost: 15, type: SkillType.heal, power: 25, targetType: 'ally', levelRequired: 2),
        const Skill(id: 'rhythm_boost', name: 'Rhythm Boost', description: 'Booste la vitesse du groupe', mpCost: 18, type: SkillType.support, targetType: 'party', levelRequired: 3),
        const Skill(id: 'symphony', name: 'Symphony', description: 'Attaque de zone', mpCost: 22, type: SkillType.attack, power: 22, targetType: 'all_enemies', levelRequired: 5),
        const Skill(id: 'lullaby', name: 'Lullaby', description: 'Endort un ennemi', mpCost: 20, type: SkillType.debuff, targetType: 'enemy', levelRequired: 4),
        const Skill(id: 'grand_finale', name: 'Grand Finale', description: 'Soin massif du groupe', mpCost: 30, type: SkillType.heal, power: 40, targetType: 'party', levelRequired: 6),
      ];

  static List<Skill> get _kingSkills => [
        const Skill(id: 'slash', name: 'Slash', description: 'Coup d\'epee tranchant', mpCost: 8, type: SkillType.attack, power: 22, levelRequired: 1),
        const Skill(id: 'iron_wall', name: 'Iron Wall', description: 'Mur de fer - boost defense', mpCost: 12, type: SkillType.defense, power: 20, targetType: 'self', levelRequired: 2),
        const Skill(id: 'berserker', name: 'Berserker', description: 'Attaque puissante mais affaiblit la defense', mpCost: 15, type: SkillType.attack, power: 35, levelRequired: 3),
        const Skill(id: 'taunt', name: 'Taunt', description: 'Attire les attaques sur soi', mpCost: 10, type: SkillType.support, targetType: 'self', levelRequired: 4),
        const Skill(id: 'battle_cry', name: 'Battle Cry', description: 'Booste l\'attaque du groupe', mpCost: 20, type: SkillType.support, targetType: 'party', levelRequired: 5),
        const Skill(id: 'ultimate_slash', name: 'Ultimate Slash', description: 'Coup final dévastateur', mpCost: 28, type: SkillType.attack, power: 50, levelRequired: 6),
      ];

  static List<Skill> get _arseneSkills => [
        const Skill(id: 'firewall', name: 'Firewall', description: 'Bouclier pare-feu', mpCost: 10, type: SkillType.defense, power: 18, targetType: 'self', levelRequired: 1),
        const Skill(id: 'analyze', name: 'Analyze', description: 'Analyse l\'ennemi - reduit sa defense', mpCost: 12, type: SkillType.debuff, targetType: 'enemy', levelRequired: 2),
        const Skill(id: 'shield_protocol', name: 'Shield Protocol', description: 'Protège un allié', mpCost: 15, type: SkillType.defense, power: 15, targetType: 'ally', levelRequired: 3),
        const Skill(id: 'data_drain', name: 'Data Drain', description: 'Vole la vie d\'un ennemi', mpCost: 18, type: SkillType.attack, power: 20, levelRequired: 4),
        const Skill(id: 'system_restore', name: 'System Restore', description: 'Restaure HP et MP d\'un allié', mpCost: 25, type: SkillType.heal, power: 30, targetType: 'ally', levelRequired: 5),
        const Skill(id: 'zero_day', name: 'Zero Day', description: 'Exploit zero-day - ignore la defense', mpCost: 30, type: SkillType.attack, power: 40, levelRequired: 6),
      ];

  static Enemy getEnemy(String id) => enemies.firstWhere(
        (e) => e.id == id,
        orElse: () => bosses.firstWhere((b) => b.id == id),
      );

  static PartyMember createDefaultPartyMember(String id) => defaultParty.firstWhere(
        (p) => p.id == id,
      );
}
