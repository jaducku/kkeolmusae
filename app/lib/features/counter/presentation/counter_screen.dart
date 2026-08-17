import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/dashed_line.dart';
import '../../../shared/widgets/receipt_paper.dart';
import '../../../shared/widgets/wordmark.dart';
import '../../condition_select/application/simulation_condition_provider.dart';
import '../../condition_select/domain/investment_target.dart';
import '../../consumption_input/application/consumption_selection_provider.dart';
import '../../result/domain/simulation_result.dart';
import 'widgets/condition_section.dart';
import 'widgets/order_section.dart';
import 'widgets/result_section.dart';
import 'widgets/share_receipt_dialog.dart';

/// docs/demo2.html 전체를 옮긴 화면 — 주문내역 → 정산조건 → 정산결과가
/// 한 장의 영수증 위에서 순서대로 펼쳐진다 (PRD 3장 화면 흐름을
/// 페이지 이동이 아니라 한 스크롤 안의 "발급" 연출로 구현).
class CounterScreen extends ConsumerStatefulWidget {
  const CounterScreen({super.key});

  @override
  ConsumerState<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends ConsumerState<CounterScreen> {
  final _scrollController = ScrollController();
  final _conditionKey = GlobalKey();
  final _resultKey = GlobalKey();

  bool _conditionRevealed = false;
  bool _resultRevealed = false;
  SimulationResult? _result;
  int _resultRevision = 0;

  late final String _receiptNo = (Random().nextInt(9000) + 1000).toString();
  late final String _dateLine = _formatDate(DateTime.now());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '발행 ${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} NO.$_receiptNo';

  void _scrollToKey(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: 0,
        );
      }
    });
  }

  void _openCondition() {
    setState(() => _conditionRevealed = true);
    _scrollToKey(_conditionKey);
  }

  void _runSimulation(InvestmentTarget target) {
    final monthlyTotal = ref.read(monthlyTotalProvider);
    final condition = ref.read(simulationConditionProvider);
    final result = SimulationResult.simulate(
      monthlySpend: monthlyTotal,
      years: condition.period.years,
      target: target,
    );
    setState(() {
      _result = result;
      _resultRevealed = true;
      _resultRevision++;
    });
  }

  void _submitCondition() {
    final condition = ref.read(simulationConditionProvider);
    _runSimulation(condition.target);
    _scrollToKey(_resultKey);
  }

  void _changeAsset(InvestmentTarget target) {
    ref.read(simulationConditionProvider.notifier).selectTarget(target);
    _runSimulation(target);
  }

  void _restart() {
    ref.read(consumptionSelectionProvider.notifier).reset();
    ref.read(simulationConditionProvider.notifier).selectPeriod(SimulationPeriod.threeYears);
    ref.read(simulationConditionProvider.notifier).selectTarget(kDefaultInvestmentTarget);
    setState(() {
      _conditionRevealed = false;
      _resultRevealed = false;
      _result = null;
    });
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  /// 찢는 애니메이션(§_TearAwaySection)이 끝난 뒤 호출되고, 공유 카드가
  /// 닫힐 때까지 대기했다가 종료되어 호출부에서 되돌리기 애니메이션을 이어간다.
  Future<void> _share() async {
    final result = _result;
    if (result == null) return;
    final condition = ref.read(simulationConditionProvider);
    final selection = ref.read(consumptionSelectionProvider);
    final firstPreset = selection.values.isEmpty ? null : selection.values.first.preset;
    await showShareReceipt(
      context,
      result: result,
      target: condition.target,
      objLabel: firstPreset?.label ?? '소비',
    );
  }

  @override
  Widget build(BuildContext context) {
    final condition = ref.watch(simulationConditionProvider);

    return Scaffold(
      body: DeskBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '주식회사 껄무새상회 · 후회정산 전문',
                  style: AppTextStyles.shopLabel,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Center(
                    child: ReceiptPaper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              const Wordmark(width: 112),
                              const SizedBox(height: 2),
                              Text('후회 영수증 발급기 · 24시간 영업', textAlign: TextAlign.center, style: AppTextStyles.subtitle),
                              Text(_dateLine, textAlign: TextAlign.center, style: AppTextStyles.subtitle),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const DashedLine.hr(),
                          const SizedBox(height: 14),
                          OrderSection(onSubmit: _openCondition),
                          if (_conditionRevealed) ...[
                            const SizedBox(height: 6),
                            KeyedSubtree(
                              key: _conditionKey,
                              child: ConditionSection(onSubmit: _submitCondition),
                            ),
                          ],
                          if (_resultRevealed && _result != null) ...[
                            const SizedBox(height: 6),
                            KeyedSubtree(
                              key: _resultKey,
                              child: ResultSection(
                                result: _result!,
                                years: condition.period.years,
                                target: condition.target,
                                revision: _resultRevision,
                                onAssetChanged: _changeAsset,
                                onShare: _share,
                                onRestart: _restart,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
