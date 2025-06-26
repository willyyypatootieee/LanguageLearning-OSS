import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'core/core.dart';
import 'router/router_exports.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BeLingApp());
}

class BeLingApp extends StatelessWidget {
  static const double _appWidth = AppConstants.appWidth;
  static const double _appHeight = AppConstants.appHeight;

  const BeLingApp({super.key});

  bool _isDesktopOrWeb() {
    if (kIsWeb) return true;

    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appContent = MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BeLing App',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter.router,
    );

    if (_isDesktopOrWeb()) {
      return Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black12,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          width: _appWidth,
          height: _appHeight,
          child: appContent,
        ),
      );
    }
    return appContent;
  }
}
