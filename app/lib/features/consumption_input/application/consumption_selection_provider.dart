import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/spending_preset.dart';

/// 유저가 선택한 프리셋 한 장의 현재 값.
class SelectedSpending {
  const SelectedSpending({
    required this.preset,
    required this.amount,
    required this.count,
    this.customLabel,
  });

  final SpendingPreset preset;
  final int amount;
  final double count;

  /// [SpendingPreset.isCustom] 인 경우에만 사용하는 자유 입력 이름.
  final String? customLabel;

  double get monthlyAmount => preset.monthlyAmount(amount, count);

  SelectedSpending copyWith({int? amount, double? count, String? customLabel}) {
    return SelectedSpending(
      preset: preset,
      amount: amount ?? this.amount,
      count: count ?? this.count,
      customLabel: customLabel ?? this.customLabel,
    );
  }
}

/// 선택된 프리셋들을 presetId 기준으로 들고 있는다.
/// 카드 탭 = 추가/제거, 스테퍼 = 금액/빈도 조절 (PRD 2.2).
class ConsumptionSelectionNotifier
    extends Notifier<Map<String, SelectedSpending>> {
  @override
  Map<String, SelectedSpending> build() => {};

  void toggle(SpendingPreset preset) {
    final next = {...state};
    if (next.containsKey(preset.id)) {
      next.remove(preset.id);
    } else {
      next[preset.id] = SelectedSpending(
        preset: preset,
        amount: preset.defaultAmount,
        count: preset.defaultCount,
      );
    }
    state = next;
  }

  void updateAmount(String presetId, int amount) {
    final current = state[presetId];
    if (current == null) return;
    state = {...state, presetId: current.copyWith(amount: amount)};
  }

  void updateCount(String presetId, double count) {
    final current = state[presetId];
    if (current == null) return;
    state = {...state, presetId: current.copyWith(count: count)};
  }

  void updateCustomLabel(String presetId, String label) {
    final current = state[presetId];
    if (current == null) return;
    state = {...state, presetId: current.copyWith(customLabel: label)};
  }

  void reset() => state = {};
}

final consumptionSelectionProvider = NotifierProvider<
    ConsumptionSelectionNotifier, Map<String, SelectedSpending>>(
  ConsumptionSelectionNotifier.new,
);

/// 하단에 실시간으로 보여줄 월 소비 합계 (PRD 2.2).
final monthlyTotalProvider = Provider<double>((ref) {
  final selection = ref.watch(consumptionSelectionProvider);
  return selection.values.fold<double>(
    0,
    (sum, item) => sum + item.monthlyAmount,
  );
});
