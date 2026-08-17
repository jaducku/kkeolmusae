/// 소비 빈도의 기준 단위. 월간 합계 계산 시 공통 배수로 환산한다.
enum FrequencyUnit {
  perDay('일', 30, [1, 2, 3]),
  perWeek('주', 4.345, [1, 2, 3, 5, 7]),
  perMonth('월', 1, [1, 2, 4, 8]);

  const FrequencyUnit(this.label, this.timesPerMonth, this.chipChoices);

  final String label;
  final double timesPerMonth;

  /// docs/demo2.html `FREQ_SET` — 빈도를 스테퍼가 아니라 칩으로 고르게 한다.
  final List<int> chipChoices;
}

/// PRD 2.2 프리셋 카드 한 장의 데이터.
class SpendingPreset {
  const SpendingPreset({
    required this.id,
    required this.emoji,
    required this.label,
    required this.defaultAmount,
    required this.defaultCount,
    required this.unit,
    this.isCustom = false,
  });

  final String id;
  final String emoji;
  final String label;
  final int defaultAmount;
  final double defaultCount;
  final FrequencyUnit unit;

  /// 직접 입력 카드 여부 — 이름/금액/빈도를 자유 입력받는다.
  final bool isCustom;

  double monthlyAmount(int amount, double count) =>
      amount * count * unit.timesPerMonth;
}

/// PRD 2.2 기본 프리셋 8종.
const List<SpendingPreset> kSpendingPresets = [
  SpendingPreset(
    id: 'coffee',
    emoji: '☕',
    label: '커피',
    defaultAmount: 4500,
    defaultCount: 5,
    unit: FrequencyUnit.perWeek,
  ),
  SpendingPreset(
    id: 'delivery',
    emoji: '🍔',
    label: '배달',
    defaultAmount: 22000,
    defaultCount: 3,
    unit: FrequencyUnit.perWeek,
  ),
  SpendingPreset(
    id: 'taxi',
    emoji: '🚕',
    label: '택시',
    defaultAmount: 12000,
    defaultCount: 2,
    unit: FrequencyUnit.perWeek,
  ),
  SpendingPreset(
    id: 'cigarette',
    emoji: '🚬',
    label: '담배',
    defaultAmount: 4500,
    defaultCount: 1,
    unit: FrequencyUnit.perDay,
  ),
  SpendingPreset(
    id: 'drinking',
    emoji: '🍺',
    label: '술자리',
    defaultAmount: 40000,
    defaultCount: 1,
    unit: FrequencyUnit.perWeek,
  ),
  SpendingPreset(
    id: 'gaming',
    emoji: '🎮',
    label: '게임/현질',
    defaultAmount: 30000,
    defaultCount: 2,
    unit: FrequencyUnit.perMonth,
  ),
  SpendingPreset(
    id: 'impulse',
    emoji: '🛍️',
    label: '충동구매',
    defaultAmount: 50000,
    defaultCount: 2,
    unit: FrequencyUnit.perMonth,
  ),
  SpendingPreset(
    id: 'custom',
    emoji: '✏️',
    label: '직접 입력',
    defaultAmount: 0,
    defaultCount: 0,
    unit: FrequencyUnit.perMonth,
    isCustom: true,
  ),
];
