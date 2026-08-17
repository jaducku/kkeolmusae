import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class KkeolmusaeApp extends StatelessWidget {
  const KkeolmusaeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '껄무새',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.receipt,
      darkTheme: AppTheme.receipt,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
