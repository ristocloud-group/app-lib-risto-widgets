import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class PercentIndicatorsPage extends StatefulWidget {
  const PercentIndicatorsPage({super.key});

  @override
  State<PercentIndicatorsPage> createState() => _PercentIndicatorsPageState();
}

class _PercentIndicatorsPageState extends State<PercentIndicatorsPage> {
  double _percent = 0.62;
  bool _animateLinear = true;
  bool _animateCircular = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Percent Indicators')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Value: ${(_percent * 100).toStringAsFixed(0)}%',
            style: theme.textTheme.titleMedium,
          ),
          Slider(
            value: _percent,
            min: 0,
            max: 1,
            divisions: 100,
            onChanged: (v) => setState(() => _percent = v),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Switch(
                value: _animateLinear,
                onChanged: (v) => setState(() => _animateLinear = v),
              ),
              const Text('Animate linear'),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: LinearPercentIndicator(
              percent: _percent,
              lineHeight: 10,
              animation: _animateLinear,
              animationDuration: 600,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              progressColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),

          const Divider(height: 32),

          Row(
            children: [
              Switch(
                value: _animateCircular,
                onChanged: (v) => setState(() => _animateCircular = v),
              ),
              const Text('Animate circular'),
            ],
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              CircularPercentIndicator(
                percent: _percent,
                radius: 40,
                lineWidth: 8,
                animation: _animateCircular,
                animationDuration: 700,
                center: Text('${(_percent * 100).round()}%'),
                backgroundColor: theme.dividerColor.withCustomOpacity(.25),
                progressColor: theme.colorScheme.primary,
              ),
              CircularPercentIndicator(
                percent: _percent,
                radius: 32,
                lineWidth: 6,
                animation: _animateCircular,
                center: Icon(
                  _percent >= .5
                      ? Icons.thumb_up_alt_outlined
                      : Icons.thumb_down_alt_outlined,
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
