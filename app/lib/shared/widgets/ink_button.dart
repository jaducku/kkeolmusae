import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// docs/demo2.html `.inkbtn` — 라운드 사각 버튼 + 소프트 섀도.
/// 기본은 잉크(검정), [emphasis] 는 브랜드 그린 — 레드는 도장에만 남겨둔다.
class InkButton extends StatefulWidget {
  const InkButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.emphasis = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool emphasis;

  @override
  State<InkButton> createState() => _InkButtonState();
}

class _InkButtonState extends State<InkButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final bg = widget.emphasis ? AppColors.green : AppColors.ink;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        offset: _pressed ? const Offset(0, 0.02) : Offset.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg.withValues(alpha: enabled ? 1 : 0.22),
            borderRadius: BorderRadius.circular(13),
            boxShadow: enabled && !_pressed
                ? [
                    BoxShadow(color: AppColors.ink.withValues(alpha: 0.08), blurRadius: 3, offset: const Offset(0, 1)),
                    BoxShadow(color: AppColors.ink.withValues(alpha: 0.04), blurRadius: 2, offset: const Offset(0, 1)),
                  ]
                : null,
          ),
          child: Text(widget.label, style: AppTextStyles.buttonLabel),
        ),
      ),
    );
  }
}

/// docs/demo2.html `.txtbtn` — 무테 텍스트 버튼.
class TextLinkButton extends StatelessWidget {
  const TextLinkButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(label, style: AppTextStyles.textLink),
            ),
          ),
        ),
      ),
    );
  }
}
