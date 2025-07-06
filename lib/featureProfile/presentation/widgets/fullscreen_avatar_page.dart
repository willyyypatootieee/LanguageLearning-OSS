import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/constants/app_constants.dart';

/// Fullscreen avatar page widget
class FullscreenAvatarPage extends StatefulWidget {
  final bool interactive;
  const FullscreenAvatarPage({super.key, this.interactive = false});

  @override
  State<FullscreenAvatarPage> createState() => _FullscreenAvatarPageState();
}

class _FullscreenAvatarPageState extends State<FullscreenAvatarPage> {
  rive.Artboard? _artboard;
  rive.StateMachineController? _controller;
  List<rive.SMIInput<dynamic>>? _inputs;

  @override
  void initState() {
    super.initState();
    _loadRive();
  }

  void _loadRive() async {
    final data = await rootBundle.load('assets/animation/chooseAvatar.riv');
    final file = rive.RiveFile.import(data);
    final artboard = file.mainArtboard;
    rive.StateMachineController? controller;
    if (artboard.stateMachines.isNotEmpty) {
      controller = rive.StateMachineController.fromArtboard(
        artboard,
        artboard.stateMachines.first.name,
      );
      if (controller != null) {
        artboard.addController(controller);
        // Only activate if interactive
        controller.isActive = widget.interactive;
      }
    }
    if (mounted) {
      setState(() {
        _artboard = artboard;
        _controller = controller;
        _inputs = controller?.inputs.toList();
      });
    }
  }

  void _onTap() {
    if (_inputs != null) {
      for (final input in _inputs!) {
        if (input is rive.SMIBool) {
          input.value = !input.value;
        } else if (input is rive.SMITrigger) {
          input.fire();
        }
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child:
                _artboard == null
                    ? const CircularProgressIndicator()
                    : GestureDetector(
                      onTap: widget.interactive ? _onTap : null,
                      child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.7,
                        alignment: Alignment.center,
                        child: rive.Rive(
                          artboard: _artboard!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
