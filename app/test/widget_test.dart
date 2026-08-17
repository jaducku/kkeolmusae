import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kkeolmusae/app.dart';

void main() {
  testWidgets('온보딩 화면이 시작 화면으로 뜬다', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: KkeolmusaeApp()),
    );
    // 껄무새 마스코트가 무한 루프 애니메이션을 돌기 때문에 pumpAndSettle 대신
    // 고정 프레임만 진행한다.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('발급기 시작'), findsOneWidget);
    expect(find.text('건너뛰기'), findsOneWidget);
  });
}
