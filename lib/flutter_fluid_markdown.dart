// Copyright 2025 The Flutter Authors. All rights reserved.

// platform views
export 'src/fluid_markdown_view.dart';
export 'src/fluid_markdown_controller.dart';

// --- FlutterFluidMarkdown ---
import 'package:flutter/services.dart';

class FlutterFluidMarkdown {
  MethodChannel get _channel => const MethodChannel('flutter_fluid_markdown');

  Future<String?> getPlatformVersion() {
    return _channel.invokeMethod('getPlatformVersion');
  }
}
