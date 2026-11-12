import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/styva_wordmark.dart';

/// Shown while the stored session is checked: the reversed (ivory on
/// charcoal) wordmark, matching the brand's splash direction.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.charcoal,
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: StyvaWordmark.light(size: 40)),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xxl + AppSpacing.lg),
                child: SizedBox(
                  width: 72,
                  child: LinearProgressIndicator(
                    minHeight: 1.5,
                    color: AppColors.sand,
                    backgroundColor: Color(0x33F6F3EE),
                    semanticsLabel: 'Loading',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
