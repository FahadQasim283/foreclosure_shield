import 'package:flutter/material.dart';
import 'package:foreclosure_shield/core/constants/string_consts.dart';
import 'core/routes/route_generator.dart';

class AIForeClosureShield extends StatefulWidget {
  const AIForeClosureShield({super.key});

  @override
  State<AIForeClosureShield> createState() => _AIForeClosureShieldState();
}

class _AIForeClosureShieldState extends State<AIForeClosureShield> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      routerConfig: RouteGenerator.router,
    );
  }
}
