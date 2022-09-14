import 'package:arcore_flutter_plugin/src/arcore_android_view.dart';
import 'package:arcore_flutter_plugin/src/arcore_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef ArCoreViewCreatedCallback = void Function(ArCoreController controller);

enum ArCoreViewType { AUGMENTEDFACE, STANDARDVIEW, AUGMENTEDIMAGES }

class ArCoreView extends StatefulWidget {

  const ArCoreView(
      {Key? key,
      required this.onArCoreViewCreated,
      this.enableTapRecognizer = false,
      this.enablePlaneRenderer = true,
      this.enableUpdateListener = false,
      this.type = ArCoreViewType.STANDARDVIEW,
      this.debug = false})
      : super(key: key);
  final ArCoreViewCreatedCallback onArCoreViewCreated;


  final bool enableTapRecognizer;
  final bool enablePlaneRenderer;
  final bool enableUpdateListener;
  final bool debug;
  final ArCoreViewType type;

  @override
  _ArCoreViewState createState() => _ArCoreViewState();
}

class _ArCoreViewState extends State<ArCoreView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return ArCoreAndroidView(
        viewType: 'arcore_flutter_plugin',
        onPlatformViewCreated: _onPlatformViewCreated,
        arCoreViewType: widget.type,
        debug: widget.debug,
      );
    }
    return Center(
      child:
          Text('$defaultTargetPlatform is not supported by the ar_view plugin'),
    );
  }

  void _onPlatformViewCreated(int id) {
    widget.onArCoreViewCreated(ArCoreController(
      id: id,
      enableTapRecognizer: widget.enableTapRecognizer,
      enableUpdateListener: widget.enableUpdateListener,
      enablePlaneRenderer: widget.enablePlaneRenderer,
    ));
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}
