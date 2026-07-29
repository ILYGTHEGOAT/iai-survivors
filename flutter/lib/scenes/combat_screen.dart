import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_palettes.dart';
import '../../data/models/enemy.dart';
import '../../data/models/party_member.dart';
import '../../data/models/skill.dart';
import '../../data/repositories/game_data.dart';
import '../../rendering/background/backgrounds.dart';
import '../../state/blocs/game_bloc.dart';
import '../../state/events/game_event.dart';
import '../../state/states/game_bloc_state.dart';
import '../../widgets/game_widgets.dart';

class CombatScreen extends StatefulWidget {
  const CombatScreen({super.key});

  @override
  State<CombatScreen> createState() => _CombatScreenState();
}

class _CombatScreenState extends State<CombatScreen> {
  late List<Enemy> enemies;
  late List<PartyMember> party;
  late List<_CombatUnit> turnOrder;
  int currentTurnIndex = 0;
  String mode = 'action';
  int selectedAction = 0;
  int selectedTarget = 0;
  int selectedSkill = 0;
  final List<String> combatLog = [];
  bool combatEnded = false;
  String? resultMessage;
  double _bgTime = 0;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _startBgTimer();
  }

  void _startBgTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() => _bgTime += 0.05);
        return true;
      }
      return false;
    });
  }

  void initCombat(List<Enemy> enemyList, List<PartyMember> partyList) {
    enemies = enemyList.map((e) => Enemy(
      id: e.id, name: e.name, maxHp: e.maxHp, hp: e.hp,
      baseAttack: e.baseAttack, baseDefense: e.baseDefense, baseSpeed: e.baseSpeed,
      isBoss: e.isBoss, phases: e.phases, skills: e.skills,
    )).toList();
    party = partyList;
    _buildTurnOrder();
    combatLog.add('Combat commence!');
  }

  void _buildTurnOrder() {
    turnOrder = [];
    for (final e in enemies.where((e) => e.isAlive)) {
      turnOrder.add(_CombatUnit(enemy: e));
    }
    for (final p in party.where((p) => p.isAlive)) {
      turnOrder.add(_CombatUnit(member: p));
    }
    turnOrder.sort((a, b) => b.speed.compareTo(a.speed));
    currentTurnIndex = 0;
  }

  _CombatUnit? get currentUnit {
    if (currentTurnIndex >= turnOrder.length) return null;
    return turnOrder[currentTurnIndex];
  }

  bool get isPlayerTurn => currentUnit?.member != null;

  void nextTurn() {
    currentTurnIndex++;
    if (currentTurnIndex >= turnOrder.length) {
      _buildTurnOrder();
    }
    _tickBuffs();

    if (enemies.every((e) => !e.isAlive)) {
      combatEnded = true;
      resultMessage = 'Victoire!';
      return;
    }
    if (party.every((p) => !p.isAlive)) {
      combatEnded = true;
      resultMessage = 'Defaite...';
      return;
    }

    if (!isPlayerTurn) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted && !combatEnded) _enemyTurn();
      });
    }
  }

  void _tickBuffs() {
    final unit = currentUnit;
    if (unit?.member != null) {
      unit!.member!.buffs.removeWhere((b) {
        b.tick();
        return !b.isActive;
      });
      unit.member!.debuffs.removeWhere((d) {
        d.tick();
        return !d.isActive;
      });
    }
  }

  void _enemyTurn() {
    final unit = currentUnit;
    if (unit?.enemy == null) return;
    final enemy = unit!.enemy!;

    final aliveParty = party.where((p) => p.isAlive).toList();
    if (aliveParty.isEmpty) return;

    final target = aliveParty[_random.nextInt(aliveParty.length)];
    final damage = max(1, enemy.attack - target.defense + _random.nextInt(7) - 3);
    target.takeDamage(damage);
    combatLog.add('${enemy.name} attaque ${target.name} pour $damage degats!');
    setState(() {});
    nextTurn();
  }

  void _playerAttack(PartyMember member, Enemy target) {
    final damage = max(1, member.attack - target.defense + _random.nextInt(7) - 3);
    target.takeDamage(damage);
    combatLog.add('${member.name} attaque ${target.name} pour $damage degats!');
    setState(() {});
    nextTurn();
  }

  void _playerDefend(PartyMember member) {
    member.buffs.add(Buff(type: BuffType.shield, value: 10, remainingTurns: 1));
    combatLog.add('${member.name} se defend! +10 bouclier');
    setState(() {});
    nextTurn();
  }

  void _playerSkill(PartyMember member, Skill skill, Enemy target) {
    if (member.mp < skill.mpCost) {
      combatLog.add('Pas assez de MP!');
      return;
    }
    member.useMp(skill.mpCost);

    switch (skill.type) {
      case SkillType.attack:
        final damage = max(1, skill.power + member.attack - target.defense + _random.nextInt(7) - 3);
        target.takeDamage(damage);
        combatLog.add('${member.name} utilise ${skill.name}! $damage degats!');
        break;
      case SkillType.heal:
        final ally = party.firstWhere((p) => p.isAlive);
        ally.heal(skill.power);
        combatLog.add('${member.name} utilise ${skill.name}! ${ally.name} soigne ${skill.power} HP!');
        break;
      case SkillType.defense:
        member.buffs.add(Buff(type: BuffType.defenseBoost, value: skill.power, remainingTurns: 3));
        combatLog.add('${member.name} utilise ${skill.name}! Defense boostee!');
        break;
      case SkillType.support:
        combatLog.add('${member.name} utilise ${skill.name}!');
        break;
      case SkillType.debuff:
        target.debuffs.add(Debuff(type: DebuffType.defenseDown, value: 5, remainingTurns: 3));
        combatLog.add('${member.name} utilise ${skill.name}! Defense de ${target.name} reduite!');
        break;
      case SkillType.special:
        combatLog.add('${member.name} utilise ${skill.name}!');
        break;
    }
    setState(() {});
    nextTurn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardListener(
        focusNode: FocusNode()..requestFocus(),
        onKeyEvent: _onKeyDown,
        child: Stack(
          children: [
            CustomPaint(
              painter: ProceduralBackground(scene: 'combat', time: _bgTime),
              size: Size.infinite,
            ),
            if (combatEnded)
              _buildResultOverlay()
            else
              _buildCombatLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildCombatLayout() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildPartyPanel()),
              Expanded(child: _buildEnemyPanel()),
            ],
          ),
        ),
        _buildBottomPanel(),
      ],
    );
  }

  Widget _buildPartyPanel() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Groupe', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: party.length,
              itemBuilder: (context, index) {
                final member = party[index];
                final isCurrentTurn = isPlayerTurn && currentUnit?.member == member;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isCurrentTurn ? ColorPalettes.primary.withOpacity(0.15) : Colors.black.withOpacity(0.3),
                    border: Border.all(
                      color: isCurrentTurn ? ColorPalettes.primary : Colors.white24,
                      width: isCurrentTurn ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            member.isAlive ? Icons.person : Icons.person_off,
                            color: member.isAlive ? Colors.white : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${member.name} Lv.${member.level}',
                            style: TextStyle(
                              color: ColorPalettes.characterColors[member.id] ?? Colors.white,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('HP ', style: TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 10)),
                          HpBar(percent: member.hpPercent, width: 80, height: 8),
                          Text(' ${member.hp}/${member.maxHp}', style: const TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 10)),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('MP ', style: TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 10)),
                          MpBar(percent: member.mpPercent, width: 80, height: 6),
                          Text(' ${member.mp}/${member.maxMp}', style: const TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnemyPanel() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ennemis', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: enemies.length,
              itemBuilder: (context, index) {
                final enemy = enemies[index];
                if (!enemy.isAlive) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            enemy.isBoss ? Icons.warning : Icons.bug_report,
                            color: enemy.isBoss ? Colors.red : Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            enemy.name,
                            style: TextStyle(
                              color: enemy.isBoss ? Colors.red : Colors.orange,
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                          if (enemy.isBoss) ...[
                            const SizedBox(width: 8),
                            Text(
                              'Phase ${enemy.currentPhase + 1}',
                              style: const TextStyle(color: Colors.red, fontFamily: 'monospace', fontSize: 10),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('HP ', style: TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 10)),
                          HpBar(percent: enemy.hpPercent, width: 100, height: 8),
                          Text(' ${enemy.hp}/${enemy.maxHp}', style: const TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Container(
      height: 280,
      color: Colors.black.withOpacity(0.7),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildCombatLog(),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: _buildActionPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildCombatLog() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D1A),
        border: Border.all(color: Colors.white24),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Journal', style: TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 12)),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              itemCount: combatLog.length,
              itemBuilder: (context, index) {
                return Text(
                  combatLog[combatLog.length - 1 - index],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {
    if (!isPlayerTurn) {
      return const Center(
        child: Text('Tour de l\'ennemi...', style: TextStyle(color: Colors.white54, fontFamily: 'monospace')),
      );
    }

    final member = currentUnit!.member!;

    switch (mode) {
      case 'action':
        return _buildActionMenu(member);
      case 'target':
        return _buildTargetMenu(member);
      case 'skill':
        return _buildSkillMenu(member);
      default:
        return _buildActionMenu(member);
    }
  }

  Widget _buildActionMenu(PartyMember member) {
    final actions = ['Attaquer', 'Skill', 'Defendre', 'Fuir'];
    return GamePanel(
      width: 500,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Tour de ${member.name}',
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              children: List.generate(actions.length, (index) {
                return GameButton(
                  text: actions[index],
                  isSelected: selectedAction == index,
                  onPressed: () => _selectAction(index, member),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetMenu(PartyMember member) {
    final aliveEnemies = enemies.where((e) => e.isAlive).toList();
    return GamePanel(
      width: 500,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Choisir une cible', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: aliveEnemies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: GameButton(
                    text: '${aliveEnemies[index].name} (${aliveEnemies[index].hp}/${aliveEnemies[index].maxHp})',
                    isSelected: selectedTarget == index,
                    width: 480,
                    onPressed: () {
                      if (selectedAction == 0) {
                        _playerAttack(member, aliveEnemies[index]);
                      } else {
                        final skill = member.skills[selectedSkill];
                        _playerSkill(member, skill, aliveEnemies[index]);
                      }
                      mode = 'action';
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillMenu(PartyMember member) {
    return GamePanel(
      width: 500,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Choisir une competence', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 14)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: member.skills.length,
              itemBuilder: (context, index) {
                final skill = member.skills[index];
                final canUse = member.mp >= skill.mpCost && member.level >= skill.levelRequired;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: GameButton(
                    text: '${skill.name} (${skill.mpCost} MP)',
                    isDisabled: !canUse,
                    isSelected: selectedSkill == index,
                    width: 480,
                    onPressed: canUse
                        ? () {
                            selectedSkill = index;
                            mode = 'target';
                            setState(() {});
                          }
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultOverlay() {
    return Center(
      child: GamePanel(
        width: 400,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              resultMessage ?? '',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: resultMessage == 'Victoire!' ? ColorPalettes.primary : Colors.red,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            GameButton(
              text: 'Retour au Campus',
              width: 200,
              onPressed: () {
                context.read<GameBloc>().add(const SceneChanged(GameScene.campus));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectAction(int index, PartyMember member) {
    selectedAction = index;
    switch (index) {
      case 0:
        mode = 'target';
        break;
      case 1:
        mode = 'skill';
        break;
      case 2:
        _playerDefend(member);
        break;
      case 3:
        combatLog.add('Impossible de fuir!');
        setState(() {});
        break;
    }
    setState(() {});
  }

  void _onKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent || combatEnded || !isPlayerTurn) return;
    final member = currentUnit?.member;
    if (member == null) return;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.escape:
        if (mode != 'action') {
          setState(() => mode = 'action');
        }
        break;
    }
  }
}

class _CombatUnit {
  final Enemy? enemy;
  final PartyMember? member;

  _CombatUnit({this.enemy, this.member});

  int get speed => member?.speed ?? enemy?.speed ?? 0;
  String get name => member?.name ?? enemy?.name ?? '';
}
