import 'package:flutter/material.dart';

/// docs/demo2.html `.stamp` — 회전된 원형 도장. 결과가 새로 찍힐 때마다
/// [revision] 을 올려주면 "쾅" 하고 튀어 들어오는 슬램 애니메이션을 재생한다.
class StampBadge extends StatefulWidget {
  const StampBadge({
    super.key,
    required this.label,
    required this.color,
    required this.revision,
  });

  final String label;
  final Color color;
  final int revision;

  @override
  State<StampBadge> createState() => _StampBadgeState();
}

class _StampBadgeState extends State<StampBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  @override
  void initState() {
    super.initState();
    _play();
  }

  @override
  void didUpdateWidget(covariant StampBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.revision != widget.revision) _play();
  }

  void _play() {
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        final scale = 0.4 + curved.value * 0.6;
        return Opacity(
          opacity: (curved.value * 0.88).clamp(0, 0.88),
          child: Transform.rotate(
            angle: -0.19, // -11deg
            child: Transform.scale(scale: scale.clamp(0.0, 1.4), child: child),
          ),
        );
      },
      child: Container(
        width: 72,
        height: 72,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: widget.color, width: 3.5),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'DungGeunMo',
            fontSize: 28,
            color: widget.color,
          ),
        ),
      ),
    );
  }
}
