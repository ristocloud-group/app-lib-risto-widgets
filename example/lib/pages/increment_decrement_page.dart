import 'package:flutter/material.dart';
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
  int quantity4 = 16; // Set to 16 to match your screenshot!
  int quantity5 = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Increment / Decrement')),
      body: ListView(
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

          // --- Squared Buttons Style (Matched to Screenshot!) ---
          Text('Squared Outlined Style', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          IncrementDecrementWidget.squared(
            quantity: quantity4,
            alignment: MainAxisAlignment.center,
            onChanged: (newQuantity) {
              setState(() => quantity4 = newQuantity);
            },
            backgroundColor: Colors.white,
            borderColor: Colors.orange.shade400,
            // Matched screenshot
            borderWidth: 1.5,
            // Matched screenshot
            iconColor: Colors.orange.shade800,
            // Matched screenshot
            buttonSize: 48.0,
            borderRadius: 12.0,
            valuePadding: const EdgeInsets.symmetric(horizontal: 20),
            incrementIcon: const Icon(Icons.add, size: 24),
            decrementIcon: const Icon(Icons.remove, size: 24),
            quantityTextStyle: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
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
    );
  }
}
