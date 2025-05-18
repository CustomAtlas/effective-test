import 'package:effective_test/core/styles/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class ShowMessage {
  static OverlayEntry? _currentOverlay;

  static Future<void> showMessage(
    BuildContext context,
    String msg,
  ) async {
    if (!context.mounted) return;
    FocusScope.of(context).unfocus(); // Unfocused any focused text field
    SystemChannels.textInput.invokeMethod('TextInput.hide'); // Close the keyboard

    // Удаляем предыдущий оверлей, если он существует
    _currentOverlay?.remove();
    _currentOverlay = null;

    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: 16,
          right: 16,
          top: MediaQuery.paddingOf(context).top + 16,
          child: MessageContainer(msg),
        );
      },
    );

    _currentOverlay = overlayEntry;
    overlayState.insert(overlayEntry);

    await Future.delayed(
      const Duration(milliseconds: 5000),
    );

    if (overlayEntry.mounted) {
      overlayEntry.remove();
      _currentOverlay = null;
    }
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: ToastAnimation(
        delay: 5000,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.scaffoldSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Material(
              type: MaterialType.transparency,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(color: context.colors.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToastAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const ToastAnimation({super.key, required this.child, required this.delay});

  @override
  State<ToastAnimation> createState() => _ToastAnimationState();
}

class _ToastAnimationState extends State<ToastAnimation> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();
    final curve = CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(begin: const Offset(0.00, -0.35), end: Offset.zero).animate(curve);

    _timer = Timer(Duration(milliseconds: widget.delay - 1000), () {
      if (mounted) {
        _animController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}
