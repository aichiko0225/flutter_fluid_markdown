import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';

class FluidMarkdownController extends ChangeNotifier {
  MethodChannel? _channel;
  int _viewId = -1;

  // 用于从原生端接收事件，例如打印完成
  EventChannel? _eventChannel;

  /// 打印开始时的回调
  VoidCallback? onPrintStart;

  /// 打印停止时的回调
  /// [isCompleted] - 如果是正常打印完成则为 true，否则为 false
  void Function(bool isCompleted)? onPrintStop;

  /// 打印暂停时的回调
  /// [index] - 暂停时打印到的字符索引
  void Function(int index)? onPrintPaused;

  /// 打印恢复时的回调
  VoidCallback? onPrintResumed;

  void Function(double width, double height)? onContentSizeChanged;

  bool _isPrinting = false;
  bool get isPrinting => _isPrinting;

  void setViewId(int id) {
    if (_viewId == id) return;
    _viewId = id;
    _channel = MethodChannel('fluid_markdown_view_$_viewId');
    _setupEventChannel();
  }

  _setupEventChannel() {
    if (_viewId == -1) return;
    _eventChannel = EventChannel('fluid_markdown_view_event_$_viewId');
    _eventChannel?.receiveBroadcastStream().listen(_onEvent, onError: _onError);
  }

  /// 处理来自原生端的所有事件
  void _onEvent(dynamic event) {
    if (event is! Map) return;
    final String eventName = event['eventName'];
    print("FluidMarkdownController Event: $eventName, data: $event");
    switch (eventName) {
      case 'onPrintStart':
        _isPrinting = true;
        notifyListeners();
        onPrintStart?.call();
        break;
      case 'onPrintStop':
        _isPrinting = false;
        final bool isCompleted = event['isCompleted'] ?? false;
        notifyListeners();
        onPrintStop?.call(isCompleted);
        break;
      case 'onPrintPaused':
        _isPrinting = false;
        final int index = event['index'] ?? 0;
        notifyListeners();
        onPrintPaused?.call(index);
        break;
      case 'onPrintResumed':
        _isPrinting = true;
        notifyListeners();
        onPrintResumed?.call();
        break;
      case 'onContentSizeChanged':
        final int width = event['width'] ?? 0;
        final int height = event['height'] ?? 0;
        notifyListeners();
        onContentSizeChanged?.call(width.toDouble(), height.toDouble());
    }
  }

  /// 处理事件流中的错误
  void _onError(dynamic error) {
    // 你可以在这里添加错误处理逻辑，例如打印日志
    debugPrint("FluidMarkdownController EventChannel Error: $error");
  }

  /// 设置打字机效果的参数
  /// [interval] - 每个字符打印的间隔时间（毫秒）
  /// [chunkSize] - 每次打印的字符数
  Future<void> setPrintParams({int interval = 25, int chunkSize = 1}) async {
    if (_channel == null) return;
    await _channel!.invokeMethod('setPrintParams', {
      'interval': interval,
      'chunkSize': chunkSize,
    });
  }

  /// 以打字机效果开始打印 Markdown 文本
  Future<void> startPrinting(String markdown) async {
    if (_channel == null) return;
    await _channel!.invokeMethod('startPrinting', {'markdown': markdown});
    _isPrinting = true;
    notifyListeners();
  }

  /// 停止打印
  /// [endMessage] - 停止后追加的文本，例如 "(已停止)"
  Future<void> stopPrinting({String? endMessage}) async {
    if (_channel == null) return;
    await _channel!.invokeMethod('stopPrinting', {'endMessage': endMessage});
    _isPrinting = false;
    notifyListeners();
  }

  /// 暂停打印
  Future<void> pause() async {
    if (_channel == null) return;
    await _channel!.invokeMethod('pause');
    _isPrinting = false;
    notifyListeners();
  }

  /// 恢复打印
  Future<void> resume() async {
    if (_channel == null) return;
    await _channel!.invokeMethod('resume');
    _isPrinting = true;
    notifyListeners();
  }

  /// 追加打印内容
  Future<void> appendPrinting(String content) async {
    if (_channel == null) return;
    await _channel!.invokeMethod('appendPrinting', {'content': content});
    _isPrinting = true;
    notifyListeners();
  }

  /// 获取当前打印的字符索引
  Future<int?> getPrintIndex() async {
    if (_channel == null) return null;
    return await _channel!.invokeMethod<int>('getPrintIndex');
  }

  @override
  void dispose() {
    _channel = null;
    _eventChannel = null;
    super.dispose();
  }
}
