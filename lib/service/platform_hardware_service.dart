abstract interface class PlatformHardwareService {
  Future<void> copyToClipboard(String text);

  Future<void> vibrateClick();

  Future<void> vibrateError();

  Future<void> setWindowTitle(String title);

  bool get isMobile;
}
