import 'package:flutter/services.dart';

class FlutterFluidMarkdown {
  MethodChannel get _channel => const MethodChannel('flutter_fluid_markdown');

  Future<String?> getPlatformVersion() {
    return _channel.invokeMethod('getPlatformVersion');
  }
}
