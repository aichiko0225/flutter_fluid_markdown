import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FluidMarkdownView extends StatelessWidget {
  final String markdownText;

  const FluidMarkdownView({super.key, required this.markdownText});

  static const viewType = 'fluid_markdown_view';

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return _buildAndroidMarkdownView();
    } else if (Platform.isIOS) {
      return _buildUiKitMarkdownView();
    } else {
      return _buildUnsupportedPlatformView();
    }
  }

  Widget _buildUiKitMarkdownView() {
    return UiKitView(
      viewType: viewType,
      creationParams: {
        'markdownText': markdownText,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Widget _buildAndroidMarkdownView() {
    return AndroidView(
        viewType: viewType,
        creationParams: {
          'markdownText': markdownText,
        },
        creationParamsCodec: const StandardMessageCodec());
  }

  Widget _buildUnsupportedPlatformView() {
    return const Center(
      child: Text('Unsupported platform'),
    );
  }
}
