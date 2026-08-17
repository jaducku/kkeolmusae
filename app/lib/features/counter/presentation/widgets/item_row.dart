import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../consumption_input/application/consumption_selection_provider.dart';
import '../../../consumption_input/domain/spending_preset.dart';
import 'preset_icons.dart';

/// docs/demo2.html `.item` + `.qty` — 주문 내역 한 줄. 탭하면 라운드 체크박스가
/// 그린으로 채워지고, 아래로 카드형 금액/빈도 패널이 펼쳐진다.
class ItemRow extends StatelessWidget {
  const ItemRow({
    super.key,
    required this.preset,
    required this.selected,
    required this.selection,
    required this.showTopDivider,
    required this.onTap,
    required this.onAmountChanged,
    required this.onCountChanged,
    required this.onCustomLabelChanged,
  });

  final SpendingPreset preset;
  final bool selected;
  final SelectedSpending? selection;
  final bool showTopDivider;
  final VoidCallback onTap;
  final ValueChanged<int> onAmountChanged;
  final ValueChanged<double> onCountChanged;
  final ValueChanged<String> onCustomLabelChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showTopDivider)
            const DecoratedBox(
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
              child: SizedBox(height: 1),
            ),
          _ItemTapRow(preset: preset, selected: selected, selection: selection, onTap: onTap),
          if (selected && selection != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              child: preset.isCustom
                  ? _CustomPanel(selection: selection!, onAmountChanged: onAmountChanged, onLabelChanged: onCustomLabelChanged)
                  : _QtyPanel(
                      preset: preset,
                      selection: selection!,
                      onAmountChanged: onAmountChanged,
                      onCountChanged: onCountChanged,
                    ),
            ),
        ],
      ),
    );
  }
}

class _ItemTapRow extends StatefulWidget {
  const _ItemTapRow({required this.preset, required this.selected, required this.selection, required this.onTap});

  final SpendingPreset preset;
  final bool selected;
  final SelectedSpending? selection;
  final VoidCallback onTap;

  @override
  State<_ItemTapRow> createState() => _ItemTapRowState();
}

class _ItemTapRowState extends State<_ItemTapRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final preset = widget.preset;
    final selected = widget.selected;
    final label = preset.isCustom && widget.selection?.customLabel?.isNotEmpty == true
        ? widget.selection!.customLabel!
        : preset.label;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        decoration: BoxDecoration(
          color: _pressed ? const Color(0xFFEFEDE6) : AppColors.hoverBg.withValues(alpha: 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Icon(
                presetIconFor(preset.id),
                size: 20,
                color: selected ? AppColors.greenDark : AppColors.ink.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: selected ? AppTextStyles.itemNameSelected : AppTextStyles.itemName),
            ),
            if (!preset.isCustom)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text('${preset.defaultAmount}원/회', style: AppTextStyles.itemPrice),
              ),
            _Checkbox(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? AppColors.green : AppColors.paper,
        border: Border.all(color: selected ? AppColors.green : const Color(0xFFD6D3CB), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 13, color: Colors.white)
          : null,
    );
  }
}

class _QtyPanel extends StatelessWidget {
  const _QtyPanel({
    required this.preset,
    required this.selection,
    required this.onAmountChanged,
    required this.onCountChanged,
  });

  final SpendingPreset preset;
  final SelectedSpending selection;
  final ValueChanged<int> onAmountChanged;
  final ValueChanged<double> onCountChanged;

  @override
  Widget build(BuildContext context) {
    final monthly = selection.monthlyAmount;
    return _PanelCard(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 52, child: Padding(padding: const EdgeInsets.only(top: 7), child: Text('${preset.unit.label} 횟수', style: AppTextStyles.qtyLabel))),
            Expanded(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: preset.unit.chipChoices.map((n) {
                  final on = n == selection.count.round();
                  return _FreqChip(label: '$n회', selected: on, onTap: () => onCountChanged(n.toDouble()));
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const SizedBox(width: 44, child: Text('1회', style: AppTextStyles.qtyLabel)),
            _KeyButton(label: '−', onTap: () => onAmountChanged((selection.amount - 500).clamp(0, 1000000))),
            SizedBox(
              width: 62,
              child: Text('${selection.amount}원', textAlign: TextAlign.center, style: AppTextStyles.qtyValue),
            ),
            _KeyButton(label: '＋', onTap: () => onAmountChanged(selection.amount + 500)),
            const Spacer(),
            Flexible(
              child: Text.rich(
                TextSpan(children: [
                  const TextSpan(text: '월 ', style: AppTextStyles.qtySub),
                  TextSpan(text: '${monthly.toStringAsFixed(0)}원', style: AppTextStyles.qtySubStrong),
                ]),
                textAlign: TextAlign.right,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CustomPanel extends StatelessWidget {
  const _CustomPanel({
    required this.selection,
    required this.onAmountChanged,
    required this.onLabelChanged,
  });

  final SelectedSpending selection;
  final ValueChanged<int> onAmountChanged;
  final ValueChanged<String> onLabelChanged;

  @override
  Widget build(BuildContext context) {
    return _PanelCard(
      children: [
        TextField(
          style: AppTextStyles.label,
          decoration: const InputDecoration(
            isDense: true,
            hintText: '항목 이름',
            hintStyle: AppTextStyles.qtySub,
            border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.green)),
          ),
          onChanged: onLabelChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const SizedBox(width: 52, child: Text('금액', style: AppTextStyles.qtyLabel)),
            _KeyButton(label: '−', onTap: () => onAmountChanged((selection.amount - 1000).clamp(0, 5000000))),
            SizedBox(
              width: 84,
              child: Text('${selection.amount}원', textAlign: TextAlign.center, style: AppTextStyles.qtyValue),
            ),
            _KeyButton(label: '＋', onTap: () => onAmountChanged(selection.amount + 1000)),
          ],
        ),
      ],
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.panelBg,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }
}

class _FreqChip extends StatelessWidget {
  const _FreqChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        constraints: const BoxConstraints(minWidth: 42, minHeight: 34),
        padding: const EdgeInsets.symmetric(horizontal: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.paper,
          border: Border.all(color: selected ? AppColors.ink : AppColors.border),
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? null
              : [BoxShadow(color: AppColors.ink.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))],
        ),
        child: Text(label, style: selected ? AppTextStyles.chipSelected : AppTextStyles.chip),
      ),
    );
  }
}

class _KeyButton extends StatefulWidget {
  const _KeyButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends State<_KeyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _pressed ? 0.94 : 1,
        child: Container(
          width: 38,
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _pressed ? AppColors.hoverBg : AppColors.paper,
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))],
          ),
          child: Text(widget.label, style: AppTextStyles.label.copyWith(fontSize: 18)),
        ),
      ),
    );
  }
}
