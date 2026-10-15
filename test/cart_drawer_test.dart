import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/features/cart/data/providers/cart_data_providers.dart';
import 'package:food_delivery_app/features/cart/presentation/widgets/cart_drawer.dart';

import 'helpers/fake_cart_local_data_source.dart';

void main() {
  testWidgets('shows the empty-cart state and browse action', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          cartLocalDataSourceProvider.overrideWithValue(
            FakeCartLocalDataSource(),
          ),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      CartDrawer.show(
                        context,
                        onCheckout: () {},
                        onBrowseMenu: () {},
                      );
                    },
                    child: const Text('Open cart'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open cart'));
    await tester.pumpAndSettle();

    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Browse Menu'), findsOneWidget);
  });
}
