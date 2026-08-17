import '../../../shared/widgets/parrot_figure.dart';

/// PRD 4.3 껄무새 리액션 단계.
class MascotReaction {
  const MascotReaction({required this.mood, required this.stampLabel, required this.say});

  final ParrotMood mood;
  final String stampLabel;
  final String say;
}

MascotReaction reactionFor(double gap) {
  if (gap < 0) {
    return const MascotReaction(mood: ParrotMood.relief, stampLabel: '휴', say: '휴… 안 사길 잘했다. 이건 칭찬해 🦜');
  }
  if (gap < 1000000) {
    return const MascotReaction(mood: ParrotMood.lv1, stampLabel: '껄', say: '음? 살 껄 그랬나? 🦜');
  }
  if (gap < 5000000) {
    return const MascotReaction(mood: ParrotMood.lv2, stampLabel: '껄', say: '아… 아… 살 껄…');
  }
  if (gap < 20000000) {
    return const MascotReaction(mood: ParrotMood.lv3, stampLabel: '껄', say: '껄!!! 껄!!!! 왜 안 샀어!!!');
  }
  return const MascotReaction(mood: ParrotMood.lv4, stampLabel: '껄', say: '…나 먼저 간다… 껄…');
}

/// PRD 4.2 체감 환산 카피 DB.
String conversionCopyFor(double gap) {
  final v = gap.abs();
  if (v < 500000) return '에어팟 맥스 하나가 커피로 증발했네';
  if (v < 2000000) return '제주도 한 달 살기 비용을 마셨습니다';
  if (v < 5000000) return '이 돈이면 유럽 왕복 3번인데요';
  if (v < 15000000) return '아반떼 옵션 풀로 넣을 돈이었다';
  if (v < 50000000) return '전세 보증금 올려줄 돈을 배달비로…';
  return '이쯤 되면 껄무새가 아니라 껄공룡 🦖';
}
