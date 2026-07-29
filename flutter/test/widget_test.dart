import 'package:flutter_test/flutter_test.dart';
import 'package:ia_survivors/state/blocs/game_bloc.dart';
import 'package:ia_survivors/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    final gameBloc = GameBloc();
    await tester.pumpWidget(MyApp(gameBloc: gameBloc));
    await tester.pumpAndSettle();
    expect(find.text('IA SURVIVORS'), findsOneWidget);
    gameBloc.close();
  });
}
