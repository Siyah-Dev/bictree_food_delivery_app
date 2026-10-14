import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery_app/core/providers/core_providers.dart';
import 'package:food_delivery_app/features/auth/presentation/providers/auth_providers.dart';

class AuthController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await ref.read(tokenStorageProvider).getAccessToken();

    return token != null && token.isNotEmpty;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      await ref
          .read(authRepositoryProvider)
          .login(username: username, password: password);

      state = const AsyncData(true);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(false);
  }
}
