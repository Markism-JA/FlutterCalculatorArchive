import 'dart:io' show Platform;
import 'package:advmobprog_prefinals_tp01_amarille/service/platform_hardware_service.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:window_manager/window_manager.dart';

@LazySingleton(as: PlatformHardwareService)
class PlatformHardwareServiceImpl implements PlatformHardwareService {
  @override
  bool get isMobile {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  bool get isDesktop {
    try {
      return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> copyToClipboard(String text) async {
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Future<void> vibrateClick() async {
    if (isMobile) {
      await HapticFeedback.lightImpact();
    }
  }

  @override
  Future<void> vibrateError() async {
    if (isMobile) {
      await HapticFeedback.vibrate();
    }
  }

  @override
  Future<void> setWindowTitle(String title) async {
    if (isDesktop) {
      await windowManager.setTitle(title);
    }
  }
}
