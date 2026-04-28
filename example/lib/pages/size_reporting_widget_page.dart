import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class SizeReportingWidgetPage extends StatefulWidget {
  const SizeReportingWidgetPage({super.key});

  @override
  State<SizeReportingWidgetPage> createState() => _SizeReportingWidgetPageState();
}

class _SizeReportingWidgetPageState extends State<SizeReportingWidgetPage> {
  Size _reportedSize = Size.zero;
  double _sliderValue = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Size Reporting Widget')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This utility widget detects its child\'s size in real-time.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            
            Center(
              child: SizeReportingWidget(
                onSizeChange: (size) {
                  setState(() => _reportedSize = size);
                },
                child: Container(
                  width: _sliderValue,
                  height: _sliderValue / 1.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Resize Me!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            RistoDecorator(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Reported Width: ${_reportedSize.width.toStringAsFixed(1)} px'),
                  Text('Reported Height: ${_reportedSize.height.toStringAsFixed(1)} px'),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            const Text('Adjust size manually:'),
            Slider(
              value: _sliderValue,
              min: 50.0,
              max: 300.0,
              onChanged: (val) => setState(() => _sliderValue = val),
            ),
          ],
        ),
      ),
    );
  }
}
