import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/counter/presentation/counter_screen.dart';

/// 온보딩 → 카운터(주문·조건·결과 통합 영수증) 2단계 라우팅.
/// docs/demo.html 을 따라 3개 화면을 하나의 스크롤 영수증으로 합쳤다.
abstract final class AppRoutes {
  static const onboarding = '/';
  static const counter = '/counter';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.counter,
      builder: (context, state) => const CounterScreen(),
    ),
  ],
);
