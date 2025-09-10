import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class RistoToastPage extends StatefulWidget {
  const RistoToastPage({super.key});

  @override
  State<RistoToastPage> createState() => _RistoToastPageState();
}

class _RistoToastPageState extends State<RistoToastPage> {
  bool _top = false;
  double _seconds = 2;
  final _controller = TextEditingController(text: 'Hello from RistoToast!');

  Duration get _duration => Duration(milliseconds: (_seconds * 1000).round());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('RistoToast')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Message',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Show at top'),
              const SizedBox(width: 8),
              Switch(value: _top, onChanged: (v) => setState(() => _top = v)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Duration: ${_seconds.toStringAsFixed(1)}s'),
          Slider(
            value: _seconds,
            min: 0.5,
            max: 5,
            divisions: 9,
            label: '${_seconds.toStringAsFixed(1)}s',
            onChanged: (v) => setState(() => _seconds = v),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _btn('Info', () {
                RistoToast.info(
                  context,
                  message: _controller.text,
                  top: _top,
                  duration: _duration,
                );
              }),
              _btn('Success', () {
                RistoToast.success(
                  context,
                  message: _controller.text,
                  top: _top,
                  duration: _duration,
                );
              }),
              _btn('Warning', () {
                RistoToast.warning(
                  context,
                  message: _controller.text,
                  top: _top,
                  duration: _duration,
                );
              }),
              _btn('Error', () {
                RistoToast.error(
                  context,
                  message: _controller.text,
                  top: _top,
                  duration: _duration,
                );
              }),
              _btn('Custom', () {
                RistoToast.show(
                  context,
                  message: _controller.text,
                  top: _top,
                  duration: _duration,
                  backgroundColor: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  icon: Icons.rocket_launch_outlined,
                  radius: 20,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ),
                );
              }),
              _btn('Hide', () => RistoToast.hide()),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Tip: RistoToast uses the root Overlay, so it works in dialogs and sheets too.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _btn(String label, VoidCallback onTap) =>
      ElevatedButton(onPressed: onTap, child: Text(label));
}
