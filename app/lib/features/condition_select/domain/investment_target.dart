/// 시뮬레이션 기간 (PRD 2.3, 기본값 3년)
enum SimulationPeriod {
  oneYear('1년', 1),
  threeYears('3년', 3),
  fiveYears('5년', 5),
  tenYears('10년', 10);

  const SimulationPeriod(this.label, this.years);

  final String label;
  final int years;
}

/// PRD 2.3 투자 대상 9개 고정 리스트.
///
/// [cagr]/[volatility] 는 실제 월별 종가 데이터(PRD 6.1)가 번들되기 전까지
/// 결과 화면 배선을 검증하기 위한 자리표시자 값이다 — 실데이터 연동 시
/// 이 두 필드만 교체하면 나머지 계산 로직은 그대로 쓸 수 있다.
class InvestmentTarget {
  const InvestmentTarget({
    required this.id,
    required this.name,
    required this.category,
    required this.cagr,
    required this.volatility,
  });

  final String id;
  final String name;
  final String category;
  final double cagr;
  final double volatility;
}

/// PRD 6.2 — 기본값은 반드시 지수(S&P500)로 고정한다.
const InvestmentTarget kDefaultInvestmentTarget = InvestmentTarget(
  id: 'sp500',
  name: 'S&P500',
  category: '지수',
  cagr: 0.12,
  volatility: 0.05,
);

const List<InvestmentTarget> kInvestmentTargets = [
  kDefaultInvestmentTarget,
  InvestmentTarget(id: 'nasdaq100', name: '나스닥100', category: '지수', cagr: 0.17, volatility: 0.08),
  InvestmentTarget(id: 'samsung', name: '삼성전자', category: '국내', cagr: 0.04, volatility: 0.09),
  InvestmentTarget(id: 'kodex200', name: 'KODEX 200', category: '국내', cagr: 0.06, volatility: 0.06),
  InvestmentTarget(id: 'apple', name: '애플', category: '해외 개별주', cagr: 0.20, volatility: 0.10),
  InvestmentTarget(id: 'tesla', name: '테슬라', category: '해외 개별주', cagr: 0.30, volatility: 0.22),
  InvestmentTarget(id: 'nvidia', name: '엔비디아', category: '해외 개별주', cagr: 0.55, volatility: 0.25),
  InvestmentTarget(id: 'bitcoin', name: '비트코인', category: '기타', cagr: 0.45, volatility: 0.38),
  InvestmentTarget(id: 'gold', name: '금', category: '기타', cagr: 0.10, volatility: 0.04),
];
