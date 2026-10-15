
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/connectivity_providers.dart';
import '../theme/app_colors.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityAsync = ref.watch(connectivityStatusProvider);

    final isOffline = connectivityAsync.maybeWhen(
      data: (results) =>
          results.isEmpty ||
          results.contains(ConnectivityResult.none),
      orElse: () => false,
    );

    if (!isOffline) {
      return const SizedBox.shrink();
    }

    return Container(
      key: const ValueKey('offline-banner'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: AppColors.white,
            size: 17,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              "You're offline. Showing saved recipes when available.",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
