import 'package:flutter/material.dart';
import 'package:risto_widgets/risto_widgets.dart'; // Adjust path

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
    const double targetInputHeight = 54.0; // The unified height baseline

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(title: const Text('Text Fields & Inputs')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Advanced Search Layouts',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Combine RistoTextField with CustomActionButton for perfectly sized, side-by-side action buttons.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                RistoTextField.search(
                  hint: 'Search users ...',
                  fillColor: Colors.white,
                  borderColor: Colors.blueGrey.shade200,
                  focusedBorderColor: Colors.blue,
                  innerLeading: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.blueGrey,
                  ),
                  margin: const EdgeInsets.only(bottom: 32),

                  validator:
                      (val) =>
                          val == null || val.length < 3
                              ? 'Error: Please enter at least 3 characters'
                              : null,

                  fieldHeight: targetInputHeight,

                  // --- Outer Leading using CustomActionButton ---
                  outerLeading: CustomActionButton.iconOnly(
                    onPressed:
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Back tapped')),
                        ),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    foregroundColor: Colors.blue,
                    backgroundColor: Colors.white,
                    baseType: ButtonType.elevated,
                    size: targetInputHeight,
                    // Exact visual match
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.blueGrey.shade200),
                    ),
                  ),

                  // --- Outer Trailing using CustomActionButton ---
                  outerTrailing: CustomActionButton.iconOnly(
                    onPressed:
                        () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Search Triggered')),
                        ),
                    icon: const Icon(Icons.search),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    baseType: ButtonType.elevated,
                    elevation: 4.0,
                    shadowColor: Colors.blue.shade200,
                    size: targetInputHeight,
                    // Exact visual match
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const Divider(height: 48),

                Text(
                  'Specialized Factories',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Pre-configured setups for standard data inputs.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                // Standard Input
                RistoTextField(
                  title: 'Full Name',
                  hint: 'John Doe',
                  innerLeading: const Icon(Icons.person_outline),
                  margin: const EdgeInsets.only(bottom: 16),
                  fillColor: Colors.white,
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Name is strictly required'
                              : null,
                ),

                // Email Factory
                RistoTextField.email(
                  margin: const EdgeInsets.only(bottom: 16),
                  fillColor: Colors.white,
                  validator:
                      (val) =>
                          val == null || !val.contains('@')
                              ? 'Invalid email address'
                              : null,
                ),

                // Password Factory
                RistoTextField.password(
                  margin: const EdgeInsets.only(bottom: 16),
                  fillColor: Colors.white,
                ),

                // Number Factory
                RistoTextField.number(
                  title: 'Amount (Optional decimals)',
                  hint: '0.00',
                  margin: const EdgeInsets.only(bottom: 16),
                  fillColor: Colors.white,
                  innerLeading: const Icon(Icons.attach_money),
                ),

                const Divider(height: 48),

                Text('Horizontal Forms', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  'Ideal for desktop apps or wide tablet screens.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 24),

                RistoTextField(
                  title: 'Username',
                  hint: '@username',
                  horizontalLayout: true,
                  margin: const EdgeInsets.only(bottom: 16),
                  fillColor: Colors.white,
                ),

                RistoTextField.password(
                  title: 'Confirm',
                  horizontalLayout: true,
                  margin: const EdgeInsets.only(bottom: 32),
                  fillColor: Colors.white,
                ),

                Center(
                  child: CustomActionButton.elevated(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Form Validated!')),
                        );
                      }
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 8),
                        Text('Validate Inputs'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
