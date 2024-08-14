import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NativeViewPage(),
    );
  }
}

const _kDefaultTitle = 'Flutter text';

class NativeViewPage extends StatefulWidget {
  const NativeViewPage({super.key});

  @override
  State<NativeViewPage> createState() => _NativeViewPageState();
}

class _NativeViewPageState extends State<NativeViewPage> {
  NativeViewController? _controller;
  String title = _kDefaultTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: NativeViewWidget(onPlatformViewCreated: (controller) {
        _controller = controller;
        _controller?.setOnRecieveFromNative((message) {
          setState(() {
            title = message;
          });
        });
      }),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              _controller?.sendToNative('Flutter Text');
            },
            child: const Text('Set Native Text'),
          ),
          TextButton(
            onPressed: () {
              _controller?.sendToNative('Native Text');
            },
            child: const Text('Reset Native Text'),
          ),
        ],
      ),
    );
  }
}

class NativeViewWidget extends StatelessWidget {
  static const StandardMessageCodec _codec = StandardMessageCodec();
  final ValueChanged<NativeViewController> onPlatformViewCreated;
  const NativeViewWidget({super.key, required this.onPlatformViewCreated});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'native_view',
        onPlatformViewCreated: (id) {
          onPlatformViewCreated(NativeViewController(id));
        },
        creationParamsCodec: _codec,
      );
    }
    return const Text('Android is not supported yet');
  }
}

class NativeViewController {
  late MethodChannel _channel;
  ValueChanged<String>? onFromNative;

  NativeViewController(int id) {
    _channel = MethodChannel('native_view_$id');
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  void setOnRecieveFromNative(ValueChanged<String> onFromNative) {
    this.onFromNative = onFromNative;
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onFromNative':
        onFromNative?.call(call.arguments as String);
        break;
      default:
        throw MissingPluginException();
    }
  }

  Future<String?> sendToNative(String message) async {
    try {
      final result = await _channel.invokeMethod('toNative', message) as String?;
      return result;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
