import 'package:flutter/cupertino.dart';
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
        // Elevated Button with Icon Example
        CustomActionButton.elevated(
          onPressed: () {},
          margin: const EdgeInsets.symmetric(vertical: 8),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.save, size: 18),
          child: const Text('Save Changes'),
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

        SizedBox(
          height: 60,
          width: double.infinity,
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomActionButton.rounded(
                  backgroundColor: Colors.transparent,
                  borderColor: Colors.black12,
                  splashColor: Colors.black,
                  minHeight: 40,
                  elevation: 0,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 24,
                  ),
                  onPressed: () {},
                  child: const Text("Test 1"),
                ),
              ),
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
                  child: const Text("Test 2"),
                ),
              ),
            ],
          ),
        ),

        CustomActionButton.rounded(
          onPressed: () {
            setState(() {
              counter++;
            });
          },
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
          onPressed: () {
            setState(() {
              counter++;
            });
          },
          minHeight: 35,
          elevation: 0,
          borderColor: Colors.orange,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          icon: const Icon(CupertinoIcons.arrow_down_doc, size: 18),
          child: const Text("Rounded Button Icon"),
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

        // Big rounded “Send” with a blue sweep
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
          child: const Text('Submit'),
        ),

        // Compact “Plan Absence” tile with icon, same gradient
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
          child: const Text('Plan Absence'),
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
          icon: const Icon(Icons.calendar_today, size: 16),
          child: const Text('Plan Absence'),
        ),

        const SizedBox(height: 16),

        RoundedContainer(
          backgroundColor: Colors.blueGrey,
          padding: const EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            children: [
              Text(
                'Icon Only Action Button',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              // Filled & elevated circular icon button
              CustomActionButton.iconOnly(
                onPressed: () {},
                icon: const Icon(Icons.add),
                size: 48,
                backgroundColor: Colors.blue,
                elevation: 2,
                foregroundColor: Colors.white,
              ),

              // Flat square icon button with gradient
              CustomActionButton.iconOnly(
                onPressed: () {},
                icon: const Icon(Icons.favorite),
                foregroundColor: Colors.white,
                baseType: ButtonType.flat,
                splashColor: Colors.black,
                size: 44,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundGradient: const LinearGradient(
                  colors: [Colors.pinkAccent, Colors.red],
                ),
              ),

              // Minimal (transparent) icon button
              CustomActionButton.iconOnly(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
                baseType: ButtonType.minimal,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                elevation: 0,
                size: 40,
              ),

              CustomActionButton.iconOnly(
                onPressed: () {},
                baseType: ButtonType.flat,
                foregroundColor: Colors.white,
                icon: const Icon(CupertinoIcons.trash),
                size: 25,
              ),
            ],
          ),
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
