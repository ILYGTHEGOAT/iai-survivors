import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/color_palettes.dart';
import '../../core/constants/game_constants.dart';
import '../../data/repositories/game_data.dart';
import '../../rendering/background/backgrounds.dart';
import '../../state/blocs/game_bloc.dart';
import '../../state/events/game_event.dart';
import '../../state/states/game_bloc_state.dart';
import '../../widgets/game_widgets.dart';

class CampusScreen extends StatefulWidget {
  const CampusScreen({super.key});

  @override
  State<CampusScreen> createState() => _CampusScreenState();
}

class _CampusScreenState extends State<CampusScreen> {
  int _selectedAction = 0;
  double _bgTime = 0;

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameBlocState>(
      builder: (context, state) {
        final gs = state.gameState;
        final weekData = GameData.weeks.firstWhere(
          (w) => w.week == gs.week,
          orElse: () => GameData.weeks.first,
        );

        final actions = _buildActions(gs);

        return Scaffold(
          backgroundColor: Colors.black,
          body: KeyboardListener(
            focusNode: FocusNode()..requestFocus(),
            onKeyEvent: _onKeyDown,
            child: Stack(
              children: [
                CustomPaint(
                  painter: ProceduralBackground(scene: weekData.bgScene ?? 'campus_day', time: _bgTime),
                  size: Size.infinite,
                ),
                Column(
                  children: [
                    _buildHeader(weekData, gs),
                    Expanded(
                      child: Row(
                        children: [
                          _buildActionsPanel(actions, gs),
                          const SizedBox(width: 10),
                          _buildCenterPanels(gs),
                          const SizedBox(width: 10),
                          _buildInfoPanel(weekData),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _buildActions(gs) {
    final actions = <Map<String, dynamic>>[];

    if (!gs.completedActions.contains('study_${gs.week}')) {
      actions.add({
        'id': 'study_${gs.week}',
        'text': 'Etudier (Matin)',
        'desc': '+1 Logique, +1 Code, -10 Energie',
        'statGains': {'logic': 1, 'coding': 1},
        'energyCost': 10,
      });
    }
    if (!gs.completedActions.contains('code_${gs.week}')) {
      actions.add({
        'id': 'code_${gs.week}',
        'text': 'Coder (Apres-midi)',
        'desc': '+2 Code, +1 Creativite, -15 Energie',
        'statGains': {'coding': 2, 'creativity': 1},
        'energyCost': 15,
      });
    }
    if (!gs.completedActions.contains('social_${gs.week}')) {
      actions.add({
        'id': 'social_${gs.week}',
        'text': 'Socialiser (Soiree)',
        'desc': '+2 Social, +5 relation, -5 Energie',
        'statGains': {'social': 2},
        'energyCost': 5,
        'relationshipGain': 5,
      });
    }
    if (!gs.completedActions.contains('explore_${gs.week}')) {
      actions.add({
        'id': 'explore_${gs.week}',
        'text': 'Explorer (Nuit)',
        'desc': 'Decouvrir des indices, -20 Energie, -5 Sante',
        'statGains': {},
        'energyCost': 20,
        'sanityCost': 5,
      });
    }

    actions.add({
      'id': 'end_week_${gs.week}',
      'text': 'Terminer la Semaine',
      'desc': 'Passer a la semaine suivante',
      'isEndWeek': true,
    });

    return actions;
  }

  Widget _buildHeader(weekData, gs) {
    final actColor = gs.act == 1
        ? ColorPalettes.act1
        : gs.act == 2
            ? ColorPalettes.act2
            : ColorPalettes.act3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.black.withOpacity(0.7),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: actColor.withOpacity(0.2),
              border: Border.all(color: actColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Acte ${gs.act}',
              style: TextStyle(color: actColor, fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Semaine ${gs.week}/17 - ${weekData.title}',
            style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 16),
          ),
          const Spacer(),
          _buildResourceIndicator('Energie', gs.energy, ColorPalettes.energyYellow),
          const SizedBox(width: 12),
          _buildResourceIndicator('Sante', gs.sanity, ColorPalettes.sanityPurple),
          const SizedBox(width: 12),
          _buildResourceIndicator('Or', gs.gold, ColorPalettes.act2),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => context.read<GameBloc>().add(const GameSaved()),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorPalettes.primary.withOpacity(0.2),
                border: Border.all(color: ColorPalettes.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Sauver',
                style: TextStyle(color: ColorPalettes.primary, fontFamily: 'monospace', fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceIndicator(String label, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 12)),
        Text('$value', style: TextStyle(color: color, fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionsPanel(List<Map<String, dynamic>> actions, gs) {
    return GamePanel(
      width: 350,
      height: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Actions Disponibles',
              style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                final isSelected = _selectedAction == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GameButton(
                    text: action['text'],
                    isSelected: isSelected,
                    width: 326,
                    height: 50,
                    onPressed: () => _executeAction(action, gs),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPanels(gs) {
    return Expanded(
      child: Column(
        children: [
          GamePanel(
            width: 520,
            height: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Statut du Groupe',
                    style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: gs.party.map<Widget>((member) {
                      return _buildCharacterCard(member);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GamePanel(
            width: 520,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatBar(label: 'Energie', percent: gs.energy / 100, value: gs.energy, color: ColorPalettes.energyYellow),
                  const SizedBox(height: 8),
                  StatBar(label: 'Sante', percent: gs.sanity / 100, value: gs.sanity, color: ColorPalettes.sanityPurple),
                  const SizedBox(height: 8),
                  StatBar(label: 'Or', percent: (gs.gold / 500).clamp(0.0, 1.0), value: gs.gold, color: ColorPalettes.act2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterCard(member) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Icon(Icons.person, color: Colors.white38, size: 40),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          member.name,
          style: TextStyle(
            color: ColorPalettes.characterColors[member.id] ?? Colors.white,
            fontFamily: 'monospace',
            fontSize: 10,
          ),
        ),
        Text(
          'Lv.${member.level}',
          style: const TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 9),
        ),
        HpBar(percent: member.hpPercent, width: 70, height: 6),
        MpBar(percent: member.mpPercent, width: 70, height: 5),
      ],
    );
  }

  Widget _buildInfoPanel(weekData) {
    return GamePanel(
      width: 350,
      height: 640,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Objectifs',
              style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              weekData.description,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontFamily: 'monospace', fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: weekData.objectives.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('- ', style: TextStyle(color: ColorPalettes.primary, fontFamily: 'monospace')),
                      Expanded(
                        child: Text(
                          weekData.objectives[index],
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontFamily: 'monospace', fontSize: 12),
                        ),
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

  void _onKeyDown(KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) return;
    final bloc = context.read<GameBloc>();
    final gs = bloc.state.gameState;
    final actions = _buildActions(gs);

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
      case LogicalKeyboardKey.keyW:
        setState(() => _selectedAction = (_selectedAction - 1).clamp(0, actions.length - 1));
        break;
      case LogicalKeyboardKey.arrowDown:
      case LogicalKeyboardKey.keyS:
        setState(() => _selectedAction = (_selectedAction + 1).clamp(0, actions.length - 1));
        break;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.space:
        if (_selectedAction < actions.length) {
          _executeAction(actions[_selectedAction], gs);
        }
        break;
    }
  }

  void _executeAction(Map<String, dynamic> action, gs) {
    final bloc = context.read<GameBloc>();

    if (action['isEndWeek'] == true) {
      bloc.add(const WeekAdvanced());
      return;
    }

    if (gs.energy < (action['energyCost'] ?? 0)) {
      bloc.add(const NotificationShown('Pas assez d\'energie!', type: 'warning'));
      return;
    }

    bloc.add(ActionCompleted(
      actionId: action['id'],
      statGains: Map<String, int>.from(action['statGains'] ?? {}),
      energyCost: action['energyCost'] ?? 0,
      sanityCost: action['sanityCost'],
    ));

    if (action['relationshipGain'] != null) {
      for (final id in GameConstants.partyIds.where((id) => id != 'not_a_genius')) {
        bloc.add(RelationshipModified(id, action['relationshipGain']));
      }
    }

    bloc.add(NotificationShown('Action completee!', type: 'success'));
  }
}
