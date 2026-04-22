import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risto_widgets/risto_widgets.dart';

void main() {
  group('RistoStatusSwitcher Tests', () {
    Widget buildTestableSwitcher(
      RistoUiState state, {
      VoidCallback? onRetry,
      WidgetBuilder? emptyBuilder,
      WidgetBuilder? errorBuilder,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: RistoStatusSwitcher(
            state: state,
            onRetry: onRetry,
            emptyBuilder: emptyBuilder,
            errorBuilder: errorBuilder,
            defaultEmptyTitle: 'Empty Title Default',
            defaultErrorTitle: 'Error Title Default',
            contentBuilder: (context) => const Text('Content Rendered'),
          ),
        ),
      );
    }

    testWidgets('renders content state correctly', (tester) async {
      await tester.pumpWidget(buildTestableSwitcher(RistoUiState.content));

      expect(find.text('Content Rendered'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders loading state correctly', (tester) async {
      await tester.pumpWidget(buildTestableSwitcher(RistoUiState.loading));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Content Rendered'), findsNothing);
    });

    testWidgets('renders default empty state correctly', (tester) async {
      await tester.pumpWidget(buildTestableSwitcher(RistoUiState.empty));

      expect(find.text('Empty Title Default'), findsOneWidget);
      expect(find.byType(RistoNoticeCard), findsOneWidget);
    });

    testWidgets('renders custom empty state correctly', (tester) async {
      await tester.pumpWidget(
        buildTestableSwitcher(
          RistoUiState.empty,
          emptyBuilder: (context) => const Text('Custom Empty Widget'),
        ),
      );

      expect(find.text('Custom Empty Widget'), findsOneWidget);
      expect(find.text('Empty Title Default'), findsNothing);
    });

    testWidgets('renders default error state and triggers onRetry', (
      tester,
    ) async {
      bool retryTriggered = false;

      await tester.pumpWidget(
        buildTestableSwitcher(
          RistoUiState.error,
          onRetry: () {
            retryTriggered = true;
          },
        ),
      );

      expect(find.text('Error Title Default'), findsOneWidget);
      expect(find.byType(RistoNoticeCard), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(retryTriggered, isTrue);
    });

    testWidgets(
      'RistoStatusSwitcher.computed logic handles priorities correctly',
      (tester) async {
        Widget buildComputed({
          bool isLoading = false,
          bool hasError = false,
          bool isEmpty = false,
        }) {
          return MaterialApp(
            home: Scaffold(
              body: RistoStatusSwitcher.computed(
                isLoading: isLoading,
                hasError: hasError,
                isEmpty: isEmpty,
                contentBuilder: (context) => const Text('Computed Content'),
                defaultEmptyTitle: 'Computed Empty',
                defaultErrorTitle: 'Computed Error',
              ),
            ),
          );
        }

        await tester.pumpWidget(
          buildComputed(isLoading: true, hasError: true, isEmpty: true),
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpWidget(
          buildComputed(isLoading: false, hasError: true, isEmpty: true),
        );
        expect(find.text('Computed Error'), findsOneWidget);

        await tester.pumpWidget(
          buildComputed(isLoading: false, hasError: false, isEmpty: true),
        );
        expect(find.text('Computed Empty'), findsOneWidget);

        await tester.pumpWidget(
          buildComputed(isLoading: false, hasError: false, isEmpty: false),
        );
        expect(find.text('Computed Content'), findsOneWidget);
      },
    );
  });
}
