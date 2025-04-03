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
  int quantity4 = 2;
  int quantity5 = 3; // For asynchronous callback example

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Increment/Decrement Examples'),
      ),
      body: PaddedChildrenList(
        children: [
          // Flat Example with synchronous callback returning int?
          IncrementDecrementWidget.flat(
            quantity: quantity1,
            maxQuantity: 10,
            minValue: 1,
            onChanged: (newQuantity) {
              setState(() {
                quantity1 = newQuantity;
              });
              return newQuantity; // Returning int? is acceptable
            },
            backgroundColor: Colors.grey[200],
            iconColor: Colors.blue,
          ),

          const SizedBox(height: 16),

          // Raised Example with synchronous callback returning int?
          IncrementDecrementWidget.raised(
            quantity: quantity2,
            maxQuantity: 15,
            minValue: 0,
            onChanged: (newQuantity) {
              setState(() {
                quantity2 = newQuantity;
              });
              return newQuantity; // Returning int? is acceptable
            },
            backgroundColor: Colors.lightGreen[100],
            iconColor: Colors.green,
          ),

          const SizedBox(height: 16),

          // Minimal Example with synchronous callback returning int?
          IncrementDecrementWidget.minimal(
            quantity: quantity3,
            maxQuantity: 20,
            minValue: 5,
            onChanged: (newQuantity) {
              setState(() {
                quantity3 = newQuantity;
              });
              return newQuantity; // Returning int? is acceptable
            },
            iconColor: Colors.red,
          ),

          const SizedBox(height: 16),

          // Squared Buttons Example with synchronous callback returning void
          IncrementDecrementWidget.squared(
            quantity: quantity4,
            alignment: MainAxisAlignment.center,
            onChanged: (newQuantity) {
              setState(() {
                quantity4 = newQuantity;
              });
              // No return statement, implicitly returns null (void)
            },
            backgroundColor: Colors.orange[100],
            iconColor: Colors.orange,
            buttonSize: 60.0,
            borderRadius: 8.0,
            incrementIcon: const Icon(Icons.add),
            decrementIcon: const Icon(Icons.remove),
          ),

          const SizedBox(height: 16),

          // Asynchronous Callback Example
          IncrementDecrementWidget.raised(
            quantity: quantity5,
            maxQuantity: 10,
            minValue: 1,
            onChanged: (newQuantity) async {
              // Simulate an asynchronous operation, e.g., server validation
              await Future.delayed(const Duration(milliseconds: 100));
              // Optionally modify the quantity
              int updatedQuantity = newQuantity; // Example modification
              // Ensure that the updated quantity does not exceed maxQuantity
              if (updatedQuantity > 10) {
                updatedQuantity = 10;
              }
              setState(() {
                quantity5 = updatedQuantity;
              });
              return updatedQuantity; // Returning Future<int?>
            },
            backgroundColor: Colors.purple[100],
            iconColor: Colors.purple,
            elevation: 4.0,
            buttonHeight: 50.0,
            borderRadius: 12.0,
            incrementIcon: const Icon(Icons.add),
            decrementIcon: const Icon(Icons.remove),
          ),

          const SizedBox(height: 16),

          // Displaying current quantities for clarity
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Quantity1 (Flat): $quantity1'),
              Text('Quantity2 (Raised): $quantity2'),
              Text('Quantity3 (Minimal): $quantity3'),
              Text('Quantity4 (Squared): $quantity4'),
              Text('Quantity5 (Async Raised): $quantity5'),
            ],
          ),
        ],
      ),
    );
  }
}
