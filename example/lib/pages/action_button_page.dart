import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class ActionButtonPage extends StatefulWidget {
  const ActionButtonPage({super.key});

  @override
  State<ActionButtonPage> createState() => _ActionButtonPageState();
}

class _ActionButtonPageState extends State<ActionButtonPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Action Buttons')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Core Button Types', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          CustomActionButton.elevated(
            onPressed: () {},
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.save, size: 18),
            child: const Text('Save Changes'),
          ),

          CustomActionButton.elevated(
            onPressed: () => setState(() => counter++),
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 4.0,
            borderRadius: 8.0,
            child: Text('Elevated Button ($counter)'),
          ),

          CustomActionButton.flat(
            onPressed: () => setState(() => counter++),
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: Colors.green,
            splashColor: Colors.white.withCustomOpacity(0.2),
            borderRadius: 8.0,
            child: Text(
              'Flat Button ($counter)',
              style: const TextStyle(color: Colors.white),
            ),
          ),

          CustomActionButton.minimal(
            onPressed: () => setState(() => counter++),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Minimal Button ($counter)',
              style: const TextStyle(color: Colors.black),
            ),
          ),

          // Notice how we just omit 'onPressed' completely now!
          CustomActionButton.minimal(
            shadowColor: Colors.transparent,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Disabled Minimal Button ($counter)',
              style: const TextStyle(color: Colors.black),
            ),
          ),

          CustomActionButton.longPress(
            onPressed: () => setState(() => counter++),
            onLongPress: () => setState(() => counter += 2),
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 4.0,
            borderRadius: 8.0,
            child: Text('Long Press Button ($counter)'),
          ),

          const SizedBox(height: 24),
          Text('Rounded & Advanced Layouts', style: theme.textTheme.titleLarge),
          const SizedBox(height: 16),

          CustomActionButton.rounded(
            onPressed: () => setState(() => counter++),
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            splashColor: Colors.deepOrangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text('Rounded Button ($counter)'),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: CustomActionButton.rounded(
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.black12,
                      borderWidth: 2.0,
                      splashColor: Colors.black,
                      minHeight: 40,
                      elevation: 0,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 24,
                      ),
                      onPressed: () {},
                      child: const Text("Outlined 1"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomActionButton.rounded(
                      minHeight: 40,
                      width: double.infinity,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 24,
                      ),
                      backgroundColor: Colors.red.shade600,
                      borderColor: Colors.red.shade600,
                      splashColor: Colors.black,
                      onPressed: () {},
                      child: const Text(
                        "Solid 2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          CustomActionButton.rounded(
            onPressed: () => setState(() => counter++),
            margin: const EdgeInsets.symmetric(vertical: 8),
            borderColor: Colors.orange,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            shadowColor: Colors.transparent,
            minHeight: 50,
            elevation: 0,
            splashColor: Colors.deepOrangeAccent.withCustomOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text('Rounded Button ($counter)'),
          ),

          CustomActionButton.rounded(
            onPressed: () => setState(() => counter++),
            minHeight: 35,
            elevation: 0,
            borderColor: Colors.orange,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            icon: const Icon(CupertinoIcons.arrow_down_doc, size: 18),
            child: const Text("Rounded Button Icon"),
          ),

          // Implicitly disabled because onPressed is missing
          CustomActionButton.rounded(
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            splashColor: Colors.deepOrangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Text('Disabled Rounded Button ($counter)'),
          ),

          CustomActionButton.rounded(
            onPressed: () {},
            minHeight: 64,
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundGradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF0E5480), Color(0xFF0C6DA0)],
            ),
            foregroundColor: Colors.white,
            child: const Text('Gradient Submit'),
          ),

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
            icon: const Icon(Icons.calendar_today, size: 16),
            child: const Text('Gradient Flat Button'),
          ),

          // Explicitly disabled via boolean parameter
          CustomActionButton.flat(
            disabled: true,
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
            icon: const Icon(Icons.calendar_today, size: 16),
            child: const Text('Disabled Gradient'),
          ),

          const SizedBox(height: 24),

          RistoDecorator(
            backgroundColor: Colors.blueGrey,
            padding: const EdgeInsets.all(20),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Text(
                  'Icon Only Action Buttons',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomActionButton.iconOnly(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      size: 48,
                      backgroundColor: Colors.blue,
                      elevation: 2,
                      foregroundColor: Colors.white,
                    ),

                    CustomActionButton.iconOnly(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite),
                      foregroundColor: Colors.white,
                      baseType: ButtonType.flat,
                      splashColor: Colors.black,
                      size: 48,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundGradient: const LinearGradient(
                        colors: [Colors.pinkAccent, Colors.red],
                      ),
                    ),

                    CustomActionButton.iconOnly(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                      baseType: ButtonType.minimal,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      size: 48,
                    ),

                    CustomActionButton.iconOnly(
                      onPressed: () {},
                      baseType: ButtonType.flat,
                      foregroundColor: Colors.white,
                      icon: const Icon(CupertinoIcons.trash),
                      size: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Single Press Button (Stateful Wrapper)',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'These buttons automatically handle async futures and show loaders without polluting your page state!',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),

          SinglePressButton(
            onPressed: () async {
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) setState(() => counter++);
            },
            margin: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            borderRadius: 8.0,
            elevation: 4.0,
            showLoadingIndicator: true,
            child: Text('Async Press Button ($counter)'),
          ),

          SinglePressButton.rounded(
            onPressed: () async {
              await Future.delayed(const Duration(seconds: 2));
              if (mounted) setState(() => counter++);
            },
            margin: const EdgeInsets.symmetric(vertical: 8),
            foregroundColor: Colors.white,
            backgroundGradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF410E80), Color(0xFF5F17B7)],
            ),
            elevation: 4.0,
            showLoadingIndicator: true,
            child: Text('Stateful Gradient Button ($counter)'),
          ),
        ],
      ),
    );
  }
}
