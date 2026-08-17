import 'package:flutter/material.dart';

/// docs/demo.html 는 손그림체 플랫 라인 아이콘을 쓰지만, 여기서는
/// 같은 "심플 라인" 무드를 Material 아이콘으로 근사한다.
IconData presetIconFor(String presetId) => switch (presetId) {
      'coffee' => Icons.coffee_outlined,
      'delivery' => Icons.delivery_dining_outlined,
      'taxi' => Icons.local_taxi_outlined,
      'cigarette' => Icons.smoking_rooms_outlined,
      'drinking' => Icons.sports_bar_outlined,
      'gaming' => Icons.sports_esports_outlined,
      'impulse' => Icons.shopping_bag_outlined,
      _ => Icons.edit_outlined,
    };
