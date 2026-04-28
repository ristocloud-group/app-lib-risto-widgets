import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/widgets/layouts/size_reporting_widget.dart';

void main() {
  testWidgets('SizeReportingWidget reports initial size', (WidgetTester tester) async {
    Size? reportedSize;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizeReportingWidget(
            onSizeChange: (size) => reportedSize = size,
            child: const SizedBox(width: 100, height: 50),
          ),
        ),
      ),
    );

    // Initial frame
    await tester.pump();
    
    expect(reportedSize, const Size(100, 50));
  });

  testWidgets('SizeReportingWidget reports size change', (WidgetTester tester) async {
    Size? reportedSize;
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return SizeReportingWidget(
                onSizeChange: (size) => reportedSize = size,
                child: SizedBox(width: reportedSize?.width == 100 ? 200 : 100, height: 50),
              );
            },
          ),
        ),
      ),
    );

    await tester.pump();
    expect(reportedSize, const Size(100, 50));

    // Trigger update
    await tester.tap(find.byType(SizedBox));
    await tester.pump();
    
    // The StatefulBuilder logic I wrote is a bit circular, let's just re-pump with different size
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizeReportingWidget(
            onSizeChange: (size) => reportedSize = size,
            child: const SizedBox(width: 200, height: 50),
          ),
        ),
      ),
    );
    
    await tester.pump();
    expect(reportedSize, const Size(200, 50));
  });
}
