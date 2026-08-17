import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/investment_target.dart';

class SimulationCondition {
  const SimulationCondition({
    this.period = SimulationPeriod.threeYears,
    this.target = kDefaultInvestmentTarget,
  });

  final SimulationPeriod period;
  final InvestmentTarget target;

  SimulationCondition copyWith({
    SimulationPeriod? period,
    InvestmentTarget? target,
  }) {
    return SimulationCondition(
      period: period ?? this.period,
      target: target ?? this.target,
    );
  }
}

/// 기간 + 종목 선택 상태 (PRD 2.3). 기본값은 3년 / S&P500.
class SimulationConditionNotifier extends Notifier<SimulationCondition> {
  @override
  SimulationCondition build() => const SimulationCondition();

  void selectPeriod(SimulationPeriod period) {
    state = state.copyWith(period: period);
  }

  void selectTarget(InvestmentTarget target) {
    state = state.copyWith(target: target);
  }
}

final simulationConditionProvider =
    NotifierProvider<SimulationConditionNotifier, SimulationCondition>(
  SimulationConditionNotifier.new,
);
