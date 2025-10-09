import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'fluid_markdown_controller.dart';

class FluidMarkdownView extends StatelessWidget {
  final String markdownText;
  final FluidMarkdownController? controller;

  void Function(int id)? onPlatformViewCreated;


  FluidMarkdownView({
    super.key, 
    required this.markdownText, 
    this.controller,
    this.onPlatformViewCreated,});

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
      onPlatformViewCreated: _onPlatformViewCreatedFunc,
      creationParams: {
        'markdownText': markdownText,
      },
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  Widget _buildAndroidMarkdownView() {
    return AndroidView(
        viewType: viewType,
        onPlatformViewCreated: _onPlatformViewCreatedFunc,
        creationParams: {
          'markdownText': markdownText,
        },
        creationParamsCodec: const StandardMessageCodec());
  }

  void _onPlatformViewCreatedFunc(int id) {
    controller?.setViewId(id);
    if (onPlatformViewCreated != null) {
      onPlatformViewCreated!(id);
    }
  }

  Widget _buildUnsupportedPlatformView() {
    return const Center(
      child: Text('Unsupported platform'),
    );
  }
}
