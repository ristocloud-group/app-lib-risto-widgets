import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart'; // Ensure correct path

class ActionButtonPage extends StatefulWidget {
  const ActionButtonPage({super.key});

  @override
  State<ActionButtonPage> createState() => _ActionButtonPageState();
}

class _ActionButtonPageState extends State<ActionButtonPage> {
  int counter = 0;

  /// Simulates an asynchronous operation, such as a network request.
  Future<void> _incrementCounterAsync() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PaddedChildrenList(
      children: [
        Text(
          'Custom Action Buttons',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        // Elevated Button Example
        CustomActionButton.elevated(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 4.0,
          borderRadius: 8.0,
          child: Text('Elevated Button ($counter)'),
        ),
        // Flat Button Example
        CustomActionButton.flat(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.green,
          splashColor: Colors.white.withCustomOpacity(0.2),
          borderRadius: 8.0,
          child: Text(
            'Flat Button ($counter)',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        // Minimal Button Example
        CustomActionButton.minimal(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Minimal Button ($counter)',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        CustomActionButton.minimal(
          onPressed: null,
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Disabled Minimal Button ($counter)',
            style: const TextStyle(color: Colors.black),
          ),
        ),
        // Long Press Button Example
        CustomActionButton.longPress(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          onLongPress: () {
            setState(() {
              counter += 2;
            });
          },
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 4.0,
          borderRadius: 8.0,
          child: Text('Long Press Button ($counter)'),
        ),

        CustomActionButton.rounded(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          splashColor: Colors.deepOrangeAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Text('Rounded Button ($counter)'),
        ),
        CustomActionButton.rounded(
          onPressed: null,
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          splashColor: Colors.deepOrangeAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Text('Disabled Rounded Button ($counter)'),
        ),

        // Disabled Press Button Example
        CustomActionButton(
          elevation: 4.0,
          onPressed: null,
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.indigo,
          borderRadius: 8.0,
          // Disabled
          child: Text(
            'Disabled Press Button ($counter)',
            style: const TextStyle(color: Colors.white),
          ),
        ),

        // Big rounded “Invia” with a blue sweep
        CustomActionButton.rounded(
          onPressed: () {},
          height: 64,
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundGradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF0E5480), Color(0xFF0C6DA0)],
          ),
          foregroundColor: Colors.white,
          child: const Text('Invia'),
        ),

        // Compact “Pianifica assenza” tile with icon, same gradient
        CustomActionButton.flat(
          onPressed: () {},
          borderRadius: 16,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shadowColor: Colors.black.withCustomOpacity(0.2),
          backgroundGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E5480), Color(0xFF108ED0)],
          ),
          foregroundColor: Colors.white,
          child: Text('Pianifica assenza'),
        ),
        CustomActionButton.flat(
          onPressed: null,
          borderRadius: 16,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shadowColor: Colors.black.withCustomOpacity(0.2),
          backgroundGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E5480), Color(0xFF108ED0)],
          ),
          foregroundColor: Colors.white,
          child: Text('Pianifica assenza'),
        ),

        const SizedBox(height: 16),

        Text(
          'Icon Action Button',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        // Filled & elevated circular icon button
        CustomActionButton.icon(
          onPressed: () {},
          icon: Icons.add,
          baseType: ButtonType.rounded,
          size: 48,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          iconColor: Colors.black,
        ),

        // Flat square icon button with gradient
        CustomActionButton.icon(
          onPressed: () {},
          icon: Icons.favorite,
          iconColor: Colors.white,
          baseType: ButtonType.flat,
          splashColor: Colors.black,
          size: 44,
          backgroundGradient: LinearGradient(
            colors: [Colors.pinkAccent, Colors.red],
          ),
        ),

        // Minimal (transparent) icon button
        CustomActionButton.icon(
          onPressed: () {},
          icon: Icons.more_vert,
          baseType: ButtonType.rounded,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black38,
          iconColor: Colors.black,
          size: 40,
        ),

        const SizedBox(height: 16),
        Text(
          'Single Press Button',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        // SinglePressButton Example
        SinglePressButton(
          onPressed: _incrementCounterAsync,
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          borderRadius: 8.0,
          elevation: 4.0,
          showLoadingIndicator: true,
          loadingIndicatorColor: Colors.black,
          child: Text('Single Press Button ($counter)'),
        ),

        SinglePressButton(
          onPressed: _incrementCounterAsync,
          margin: const EdgeInsets.symmetric(vertical: 8),
          foregroundColor: Colors.white,
          backgroundGradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF410E80), Color(0xFF5F17B7)],
          ),
          borderRadius: 8.0,
          elevation: 4.0,
          showLoadingIndicator: true,
          loadingIndicatorColor: Colors.black,
          child: Text('Single Press Button ($counter)'),
        ),
      ],
    );
  }
}
