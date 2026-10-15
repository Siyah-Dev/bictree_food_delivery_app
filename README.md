# Food Delivery App

A Flutter food-delivery application built as a practical development assessment. The UI follows the supplied Figma designs and uses DummyJSON Recipes as the food catalogue API.

## Features

- Login screen with the project's authentication flow.
- Home screen with food categories, Best Seller and Recommended sections.
- Menu screen with category selection and sorting.
- Search and Filter screen with category and price filters.
- Food Details screen with quantity selection, local add-ons, and Add to Cart.
- Right-side Cart drawer with item quantities, subtotal, tax and fees, delivery, total, and Checkout.
- Confirm Order screen with editable shipping address, order summary, and local Place Order confirmation.
- Hive storage for cart contents and recipe-page caching, including cached recipe fallback when the remote request fails with a Dio network error.

## Requirements

- Flutter **3.47.1 stable** (Dart **3.13.1**), as reported by `flutter --version` during verification.
- Android emulator or a physical device for running the app.
- Internet access for initial authentication and recipe downloads.

## Setup and Run

From the repository root:

```bash
flutter --version
flutter doctor
flutter pub get
flutter run
```

To run the automated test suite:

```bash
flutter test
```

To run static analysis:

```bash
flutter analyze
```

### Local storage

The app opens these Hive boxes before `runApp`:

- `recipe_cache` — cached recipe pages.
- `cart` — persisted cart items, quantities, and add-ons.

Recipe caching is network-first: the repository requests the remote API, saves successful results in Hive, and falls back to cached data when a recipe-list request fails with a `DioException`. Cache keys include the requested page size and offset, with a first-page fallback for different page sizes.

> Offline-support check: the reviewed `master` snapshot contains Hive caching and repository fallback. Verify that the connectivity provider and visible offline banner are also present in the branch submitted for assessment, because they were not present in the reviewed `master` snapshot.

## API and Demo Data

The app uses [DummyJSON](https://dummyjson.com) endpoints configured in `lib/core/constants/api_end_points.dart`, including:

- `GET /recipes` — recipe list.
- `GET /recipes/search?q=...` — recipe search.
- `GET /recipes/{id}` — recipe details.
- `/auth/login` and `/auth/me` — authentication endpoints configured by the app.

The API does not provide delivery prices for these UI designs. `FoodModel` therefore derives a deterministic mock price from the recipe ID using:

```dart
149.0 + ((id * 37) % 351)
```

This keeps demo prices stable between API calls and cache reads. The supplied Figma design uses dollar formatting. Add-on prices are local sample data, while tax and fees (`$5.00`) and delivery (`$3.00`) are fixed demonstration values in `CartPricing`; they are not calculated by a backend.

### Category mapping

The Recipes API does not expose the five Figma categories as a single canonical category field. The app maps API values heuristically:

- **Snacks:** tags containing `snack`, `appetizer`, or `starter`.
- **Meal:** meal types containing `breakfast`, `lunch`, or `dinner`.
- **Vegan:** tags containing `vegan` or `plant-based`.
- **Dessert:** dessert/sweet tags or a dessert meal type.
- **Drinks:** drink/beverage tags or meal types.

Because this is a heuristic mapping, some categories may have fewer results or be empty depending on the records returned by the API.

## Architecture

The project uses a feature-first structure with data, domain, and presentation responsibilities separated where appropriate:

```text
lib/
├── app/                 # App entry widget, GoRouter, route names
├── core/                # API endpoints, Dio/network, providers, storage,
│                        # theme, colors, common widgets and utilities
├── shared/              # Widgets shared by more than one feature
└── features/
    ├── auth/            # Authentication
    ├── food/            # Food entity, API/local data sources, model,
    │                    # repository contract and implementation
    ├── home/            # Home controller/state, screen and widgets
    ├── menu/            # Menu controller/state, sorting and food list
    ├── search_filter/   # Search and filter flow
    ├── food_details/    # Food details controller/state and widgets
    ├── cart/            # Cart domain item, controller/state, Hive storage
    └── confirm_order/   # Address, order summary and local order confirmation
```

### State management: why Riverpod

Riverpod was selected instead of Bloc because it is used consistently throughout this project and supports dependency injection, provider overrides in tests, and explicit asynchronous state handling without introducing additional event or Cubit classes.

- `AsyncNotifier` is used for features that load data asynchronously, such as Home and Menu.
- `Notifier` is used for synchronous local state such as cart edits and the Confirm Order form state.
- State classes keep screen state explicit, while controllers hold state transitions and operations.
- Repository abstractions keep the controllers independent of Dio and Hive implementation details.
- GoRouter centralizes route names and navigation.

## Testing

Run the complete suite from the repository root:

```bash
flutter test
```

Run individual test files while debugging:

```bash
flutter test test/home_controller_test.dart
flutter test test/menu_controller_test.dart
flutter test test/widget_test.dart
flutter test test/cart_controller_test.dart
flutter test test/food_repository_impl_test.dart
flutter test test/cart_drawer_test.dart
```

The test suite covers Home and Menu controller behavior, Cart state logic, Food repository caching/fallback, the Cart drawer, and a basic app widget test. The Cart/repository/widget tests were run individually and as part of the full test suite on the development machine.

### Verification results

Verified locally on Flutter 3.47.1 stable / Dart 3.13.1 on the development machine.

| Check | Command | Result |
|---|---|---|
| Formatting | `dart format test` | Completed. |
| Static analysis | `flutter analyze` | Passed — no issues found. |
| Cart controller tests | `flutter test test/cart_controller_test.dart` | Passed. |
| Food repository tests | `flutter test test/food_repository_impl_test.dart` | Passed. |
| Cart drawer widget tests | `flutter test test/cart_drawer_test.dart` | Passed. |
| Full automated test suite | `flutter test` | Passed — 16 tests. |
| Manual offline check | Disable internet after recipes have been cached, then relaunch the app | Not recorded in the provided verification output; perform this manual check before submission. |

## Decisions, Trade-offs, and Scope

- **Local-first cart persistence:** Hive stores cart items, quantities, and selected add-ons so the cart survives an app restart.
- **No order API:** Place Order is a local confirmation flow as required by the assessment; it does not process a payment or create a backend order.
- **Demo address:** The shipping address is sample data edited in local application state; it is not validated or saved to a user account on a server.
- **Mock prices and add-ons:** Prices and restaurant-style add-ons are local demo values because the Recipes API does not provide the price data shown in Figma.
- **Category mapping:** Figma categories are inferred from tags and meal types rather than backed by server-provided category IDs.
- **Out of scope:** Backend payments, order history, delivery tracking, profile management, and persistent server-side favorites are not implemented.

## What I Would Improve With More Time

1. Add and verify a network-aware offline banner on Home and Menu, including the case where Wi-Fi is connected but internet access is unavailable.
2. Add pagination and a more explicit cache policy with timestamps and cache-expiry handling.
3. Replace mock prices/add-ons and fixed fees with catalogue and pricing data from a backend.
4. Persist shipping addresses and favorites per user, with appropriate validation.
5. Add more widget, repository, and edge-case tests, including offline startup and corrupt-cache recovery.
6. Refine accessibility, semantic labels, responsive layouts, and user-facing handling of storage errors.

## Time Spent

Approximately **2 days**, as estimated for this practical assessment.
