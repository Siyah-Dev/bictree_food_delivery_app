import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/app/app.dart';

void main() {
  testWidgets('FoodDeliveryApp builds successfully', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FoodDeliveryApp()));

    await tester.pumpAndSettle();

    expect(find.byType(FoodDeliveryApp), findsOneWidget);
  });
}
