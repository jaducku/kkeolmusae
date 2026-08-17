import 'dart:math' as math;
import '../../condition_select/domain/investment_target.dart';

/// 결과 화면(PRD 2.4)에 필요한 계산 결과 + 잉크 차트용 시계열.
///
/// 실제 월별 종가 기반 적립식 매수 계산(PRD 2.3 "월 적립식 매수 가정")은
/// 시세 데이터 번들이 준비되는 다음 단계에서 [InvestmentTarget.cagr]/
/// [InvestmentTarget.volatility] 을 실데이터 기반 월별 수익률로 교체하면
/// 된다. 지금은 docs/demo.html 의 데모 계산식을 그대로 Dart로 옮겼다 —
/// 월 복리 + 사인파 변동성으로 "그럴듯한" 흔들리는 차트를 만든다.
class SimulationResult {
  const SimulationResult({
    required this.totalSpent,
    required this.investedValue,
    required this.spentPoints,
    required this.valuePoints,
  });

  final double totalSpent;
  final double investedValue;
  final List<double> spentPoints;
  final List<double> valuePoints;

  double get gap => investedValue - totalSpent;

  /// PRD 2.4: 손실(투자 가치 < 소비 총액)도 콘텐츠로 다룬다 — 레드 대신 그레이.
  bool get isLoss => gap < 0;

  factory SimulationResult.simulate({
    required double monthlySpend,
    required int years,
    required InvestmentTarget target,
  }) {
    final months = years * 12;
    final monthlyRate = math.pow(1 + target.cagr, 1 / 12) - 1;
    final idSeed = target.id.length.toDouble();
    final charSeed = target.id.codeUnitAt(0).toDouble();

    var value = 0.0;
    final spentPoints = <double>[];
    final valuePoints = <double>[];
    for (var m = 1; m <= months; m++) {
      final wiggle = math.sin(m * 1.7 + idSeed) * target.volatility +
          math.sin(m * 0.6 + charSeed) * target.volatility * 0.5;
      value = (value + monthlySpend) * (1 + monthlyRate + wiggle / 12);
      spentPoints.add(monthlySpend * m);
      valuePoints.add(math.max(value, monthlySpend * 0.2));
    }

    return SimulationResult(
      totalSpent: monthlySpend * months,
      investedValue: value,
      spentPoints: spentPoints,
      valuePoints: valuePoints,
    );
  }
}
