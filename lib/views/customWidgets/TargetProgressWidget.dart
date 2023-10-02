import 'package:flutter/material.dart';
import 'package:yaquby/config.dart';

class TargetsProgressWidget extends StatelessWidget {
  final double dailyProgress;
  final double monthlyProgress;
  final double quarterlyProgress;
  final int dailyTarget;
  final int dailyCompleted;
  final int monthlyTarget;
  final int monthlyCompleted;
  final int quarterlyTarget;
  final int quarterlyCompleted;

  const TargetsProgressWidget({
    Key? key,
    required this.dailyProgress,
    required this.monthlyProgress,
    required this.quarterlyProgress,
    required this.dailyTarget,
    required this.dailyCompleted,
    required this.monthlyTarget,
    required this.monthlyCompleted,
    required this.quarterlyTarget,
    required this.quarterlyCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.colorSmokeWhite, // Replace 'Colors.blue' with the desired background color
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.grey, // Replace 'Colors.blue' with the desired background color
                ),
                child: SizedBox(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Sales targets",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _buildProgressIndicator(
                  'Daily', dailyProgress, dailyTarget, dailyCompleted, Colors.blue, Colors.grey, AppColors.colorSmokeWhite // Color for daily progress
                  ),
              _buildProgressIndicator('Monthly', monthlyProgress, monthlyTarget, monthlyCompleted, Colors.green, Colors.grey, AppColors.white
                  // Color for monthly progress
                  ),
              _buildProgressIndicator(
                  'Quarterly', quarterlyProgress, quarterlyTarget, quarterlyCompleted, Colors.orange, Colors.grey, AppColors.colorSmokeWhite
                  // Color for quarterly progress
                  ),
              const SizedBox(
                height: 10,
              ),
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.grey, // Replace 'Colors.blue' with the desired background color
                ),
                child: SizedBox(
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(
    String label,
    double progress,
    int target,
    int completed,
    Color completedColor,
    Color remainingColor,
    Color background,
  ) {
    final double completedProgress = completed / target;
    final double remainingProgress = (target - completed) / target;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(color: background),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: completedProgress,
              valueColor: AlwaysStoppedAnimation<Color>(completedColor),
              backgroundColor: remainingColor,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Completed: $completed',
                  style: TextStyle(
                    fontSize: 12,
                    color: completedColor,
                  ),
                ),
                Text(
                  'Target: $target',
                  style: TextStyle(
                    fontSize: 12,
                    color: remainingColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
