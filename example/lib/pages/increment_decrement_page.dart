import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:risto_widgets/risto_widgets.dart';

class IncrementDecrementPage extends StatefulWidget {
  const IncrementDecrementPage({super.key});

  @override
  State<IncrementDecrementPage> createState() => _IncrementDecrementPageState();
}

class _IncrementDecrementPageState extends State<IncrementDecrementPage> {
  int quantity1 = 1;
  int quantity2 = 5;
  int quantity3 = 8;
  int quantity4 = 1; // Connected TextField example
  int quantity5 = 3;

  // Controllers for the TextField example
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: quantity4.toString());
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Increment / Decrement')),
      // Use TapRegion at the page level so tapping outside unfocuses globally
      body: TapRegion(
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text('Quantity Selectors', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Highly customizable number steppers. Try holding down the buttons to see the rapid-fire long-press action.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // --- Flat Style ---
            Text('Flat Style', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            IncrementDecrementWidget.flat(
              quantity: quantity1,
              maxQuantity: 10,
              minValue: 1,
              onChanged: (newQuantity) {
                setState(() => quantity1 = newQuantity);
                return newQuantity;
              },
              backgroundColor: Colors.grey.shade200,
              iconColor: Colors.blue,
              buttonPadding: const EdgeInsets.all(12),
            ),
            const SizedBox(height: 32),

            // --- Raised Style ---
            Text('Raised Style', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            IncrementDecrementWidget.raised(
              quantity: quantity2,
              maxQuantity: 15,
              minValue: 0,
              onChanged: (newQuantity) {
                setState(() => quantity2 = newQuantity);
                return newQuantity;
              },
              backgroundColor: Colors.lightGreen.shade100,
              iconColor: Colors.green.shade800,
              elevation: 4.0,
              buttonPadding: const EdgeInsets.all(12),
              borderRadius: 12.0,
            ),
            const SizedBox(height: 32),

            // --- Minimal Style ---
            Text('Minimal Style', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            IncrementDecrementWidget.minimal(
              quantity: quantity3,
              maxQuantity: 20,
              minValue: 5,
              onChanged: (newQuantity) {
                setState(() => quantity3 = newQuantity);
                return newQuantity;
              },
              iconColor: Colors.red,
              quantityTextStyle: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // --- Connected Pill Style with TextField (Snapped) ---
            Text(
              'Connected Pill Style (with TextField Snapping)',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try emptying the field or typing "-5" and tap outside to see it snap safely.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            IncrementDecrementWidget.connected(
              quantity: quantity4,
              minValue: 1,
              maxQuantity: 100,
              alignment: MainAxisAlignment.center,
              onChanged: (newQuantity) {
                setState(() => quantity4 = newQuantity);
                return newQuantity;
              },
              buttonsBackgroundColor: const Color(0xFF457AB0),
              middleBackgroundColor: const Color(0xFFF3F3F3),
              borderColor: const Color(0xFF7CB1D8),
              borderWidth: 1.5,
              borderRadius: 7.0,
              iconColor: Colors.white,
              buttonSize: 44.0,
              valueWidth: 60.0,
              incrementIcon: const Icon(Icons.add, size: 22),
              decrementIcon: const Icon(Icons.remove, size: 22),
              valueBuilder: (context, value, updateValue) {
                // Sync external controller if the bounds update the value
                if (!_focusNode.hasFocus &&
                    _textController.text != value.toString()) {
                  _textController.text = value.toString();
                }

                return TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                  ],
                  style: const TextStyle(
                    color: Color(0xFF457AB0),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    counterText: "",
                  ),
                  // Look how clean this is now:
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    updateValue(int.tryParse(_textController.text));
                  },
                  onSubmitted: (val) {
                    updateValue(int.tryParse(val));
                  },
                );
              },
            ),
            const SizedBox(height: 32),

            // --- Asynchronous Validator ---
            Text('Asynchronous Validation', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'This counter fakes a 300ms network delay before applying the change.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            IncrementDecrementWidget.raised(
              quantity: quantity5,
              maxQuantity: 10,
              minValue: 1,
              onChanged: (newQuantity) async {
                await Future.delayed(const Duration(milliseconds: 300));

                int updatedQuantity = newQuantity;
                if (updatedQuantity > 10) updatedQuantity = 10;

                setState(() => quantity5 = updatedQuantity);
                return updatedQuantity;
              },
              backgroundColor: Colors.purple.shade100,
              iconColor: Colors.purple.shade800,
              elevation: 4.0,
              buttonHeight: 50.0,
              borderRadius: 16.0,
              incrementIcon: const Icon(Icons.add),
              decrementIcon: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}
