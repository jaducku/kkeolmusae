import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/barcode.dart';
import '../../../../shared/widgets/dashed_line.dart';
import '../../../../shared/widgets/ink_button.dart';
import '../../../../shared/widgets/ink_line_chart.dart';
import '../../../../shared/widgets/option_chip.dart';
import '../../../../shared/widgets/parrot_figure.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/stamp_badge.dart';
import '../../../../shared/widgets/rip_down.dart';
import '../../../condition_select/domain/investment_target.dart';
import '../../../result/domain/reaction_copy.dart';
import '../../../result/domain/simulation_result.dart';

String _won(double n) {
  final s = n.round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '$buf원';
}

/// docs/demo.html `#secResult` — 정 산 결 과. 프린트되듯 순서대로 나타난다.
class ResultSection extends StatelessWidget {
  const ResultSection({
    super.key,
    required this.result,
    required this.years,
    required this.target,
    required this.revision,
    required this.onAssetChanged,
    required this.onShare,
    required this.onRestart,
  });

  final SimulationResult result;
  final int years;
  final InvestmentTarget target;
  final int revision;
  final ValueChanged<InvestmentTarget> onAssetChanged;
  final Future<void> Function() onShare;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final reaction = reactionFor(result.gap);
    final gain = !result.isLoss;
    final stampColor = gain ? AppColors.stamp : AppColors.relief;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DashedLine.hr(),
        const SizedBox(height: 14),
        _Printed(index: 0, revision: revision, child: const SectionHeader('정 산 결 과')),
        const SizedBox(height: 14),
        _Printed(
          index: 1,
          revision: revision,
          child: Column(
            children: [
              _KvRow(k: '쓴 돈 합계', v: _won(result.totalSpent)),
              _KvRow(k: '회한 기간', v: '$years년'),
              _KvRow(k: '환생 종목', v: target.name),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Printed(
          index: 2,
          revision: revision,
          child: Column(
            children: [
              Text('만 약 에 잔 고', textAlign: TextAlign.center, style: AppTextStyles.bigLabel),
              const SizedBox(height: 2),
              _CountUpNumber(revision: revision, target: result.investedValue),
              const SizedBox(height: 6),
              Text(
                gain ? '(${_won(result.gap)} 놓침)' : '(안 사길 잘함)',
                textAlign: TextAlign.center,
                style: gain ? AppTextStyles.diffGain : AppTextStyles.diffLoss,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _Printed(
          index: 3,
          revision: revision,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StampBadge(label: reaction.stampLabel, color: stampColor, revision: revision),
              const SizedBox(width: 14),
              ParrotFigure(mood: reaction.mood, size: 46),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reaction.say, style: AppTextStyles.mascotSay),
                    const SizedBox(height: 6),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: '* '),
                          TextSpan(
                            text: conversionCopyFor(result.gap),
                            style: const TextStyle(color: AppColors.stamp, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: AppTextStyles.mascotConv,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Printed(
          index: 4,
          revision: revision,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
            decoration: BoxDecoration(
              color: AppColors.chartBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                InkLineChart(spentPoints: result.spentPoints, valuePoints: result.valuePoints),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('┈┈ 그냥 쓴 돈', style: AppTextStyles.fine),
                    Text('── 투자했다면', style: AppTextStyles.fine),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _Printed(
          index: 5,
          revision: revision,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DashedLine.thin(color: AppColors.border),
              const SizedBox(height: 10),
              Text('다른 종목으로 재정산', style: AppTextStyles.fine),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kInvestmentTargets.map((t) {
                  return OptionChip(
                    label: t.name,
                    selected: t.id == target.id,
                    emphasisWhenSelected: true,
                    onTap: () => onAssetChanged(t),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        _Printed(
          index: 6,
          revision: revision,
          child: _TearAwaySection(gap: result.gap, onShare: onShare, onRestart: onRestart),
        ),
      ],
    );
  }
}

/// "영수증 자랑하기"를 누르면 이 아래 묶음(버튼·바코드·문구)이 종이처럼
/// 찢겨나간 뒤 공유 카드가 뜬다. 카드가 닫히면 다시 붙는다.
class _TearAwaySection extends StatefulWidget {
  const _TearAwaySection({required this.gap, required this.onShare, required this.onRestart});

  final double gap;
  final Future<void> Function() onShare;
  final VoidCallback onRestart;

  @override
  State<_TearAwaySection> createState() => _TearAwaySectionState();
}

class _TearAwaySectionState extends State<_TearAwaySection> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 620),
  );
  bool _busy = false;

  Future<void> _handleShare() async {
    if (_busy) return;
    setState(() => _busy = true);
    HapticFeedback.mediumImpact();
    await _controller.forward();
    await widget.onShare();
    if (!mounted) return;
    await _controller.reverse();
    if (mounted) setState(() => _busy = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RipDown(progress: _controller.value, child: child!);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkButton(
            label: '이 영수증 자랑하기',
            emphasis: true,
            onPressed: _busy ? null : _handleShare,
          ),
          TextLinkButton(label: '전표 취소하고 처음부터', onPressed: widget.onRestart),
          const SizedBox(height: 8),
          Barcode(digits: _barcodeDigits(widget.gap)),
          const SizedBox(height: 8),
          DashedLine.thin(color: AppColors.border),
          const SizedBox(height: 8),
          Text(
            '교환·환불 불가 (지나간 소비는 원래 그렇습니다)\n'
            '본 결과는 과거 데이터 기반 가상 시뮬레이션이며, 투자 권유가 아닙니다.\n'
            '과거 수익률은 미래를 보장하지 않습니다.',
            textAlign: TextAlign.center,
            style: AppTextStyles.fine,
          ),
          const SizedBox(height: 8),
          Text('고객센터: 껄무새에게 직접 문의 🦜', textAlign: TextAlign.center, style: AppTextStyles.fine),
        ],
      ),
    );
  }
}

String _barcodeDigits(double gap) {
  final digits = gap.abs().round().toString().replaceAll(RegExp(r'[^0-9]'), '');
  final padded = digits.padLeft(10, '8');
  return padded.substring(padded.length - 10);
}

class _KvRow extends StatelessWidget {
  const _KvRow({required this.k, required this.v});

  final String k;
  final String v;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(k, style: AppTextStyles.qtyLabel),
          DottedLeader(color: AppColors.border),
          Text(v, style: AppTextStyles.kvValue),
        ],
      ),
    );
  }
}

class _CountUpNumber extends StatelessWidget {
  const _CountUpNumber({required this.revision, required this.target});

  final int revision;
  final double target;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(revision),
      tween: Tween(begin: 0, end: target),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOut,
      builder: (context, value, _) {
        return Text(_won(value), textAlign: TextAlign.center, style: AppTextStyles.bigNumber);
      },
    );
  }
}

/// docs/demo.html `.pline` 프린트 스태거 애니메이션.
class _Printed extends StatefulWidget {
  const _Printed({required this.index, required this.revision, required this.child});

  final int index;
  final int revision;
  final Widget child;

  @override
  State<_Printed> createState() => _PrintedState();
}

class _PrintedState extends State<_Printed> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _schedule();
  }

  @override
  void didUpdateWidget(covariant _Printed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision) {
      _visible = false;
      _schedule();
    }
  }

  void _schedule() {
    Future.delayed(Duration(milliseconds: 130 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 340),
      curve: Curves.easeOut,
      offset: _visible ? Offset.zero : const Offset(0, -0.08),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 340),
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}
