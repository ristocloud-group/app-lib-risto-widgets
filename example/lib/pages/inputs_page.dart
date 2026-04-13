import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart';

class InputsPage extends StatefulWidget {
  const InputsPage({super.key});

  @override
  State<InputsPage> createState() => _InputsPageState();
}

class _InputsPageState extends State<InputsPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Risto Text Fields & Decorator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Standalone RistoDecorator',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'The new universal decoration wrapper. You can wrap ANY widget in this to apply standardized Risto backgrounds, borders, and shadows.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),

              RistoDecorator(
                elevation: 6,
                borderRadius: BorderRadius.circular(16),
                // Fixed to use BorderRadius
                backgroundColor: Colors.white,
                shadowColor: Colors.deepPurple,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.palette, color: Colors.deepPurple),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'I am a completely standard Flutter Row, but I look like a beautiful card because I am wrapped in a RistoDecorator!',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 24),

              Text(
                'Advanced Outer Layouts (Decorated)',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'By combining RistoTextField with RistoDecorator, we can create incredibly custom, perfectly aligned search bars.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              RistoTextField.search(
                hint: 'Search users ...',
                fillColor: Colors.white,
                borderColor: Colors.blueGrey.shade200,
                focusedBorderColor: Colors.blue,
                prefixIcon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.blueGrey,
                ),
                margin: const EdgeInsets.only(bottom: 32),
                fieldHeight: 54,
                // Locks the row height perfectly

                // --- Outer Leading using RistoDecorator ---
                outerLeading: RistoDecorator(
                  backgroundColor: Colors.white,
                  borderColor: Colors.blueGrey.shade200,
                  borderRadius: BorderRadius.circular(15),
                  // Fixed to use BorderRadius
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.blue,
                    ),
                    onPressed:
                        () =>
                            RistoToast.info(context, message: 'Go back tapped'),
                  ),
                ),

                // --- Outer Trailing using RistoDecorator with Shadow ---
                outerTrailing: RistoDecorator(
                  backgroundColor: Colors.blue,
                  shadowColor: Colors.blue,
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(15),
                  // Fixed to use BorderRadius
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed:
                        () => RistoToast.success(
                          context,
                          message: 'Search Triggered',
                        ),
                  ),
                ),

                onSubmitted:
                    (value) => RistoToast.success(
                      context,
                      message: 'Submitted: $value',
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
