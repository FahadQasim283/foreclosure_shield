import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/theme/theme.dart';

class CountdownTimerCard extends StatefulWidget {
  final DateTime auctionDate;

  const CountdownTimerCard({super.key, required this.auctionDate});

  @override
  State<CountdownTimerCard> createState() => _CountdownTimerCardState();
}

class _CountdownTimerCardState extends State<CountdownTimerCard> {
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _calculateTimeRemaining();
    });
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    final difference = widget.auctionDate.difference(now);
    if (mounted) {
      setState(() {
        _timeRemaining = difference.isNegative ? Duration.zero : difference;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _timeRemaining.inDays;
    final hours = _timeRemaining.inHours % 24;
    final minutes = _timeRemaining.inMinutes % 60;
    final seconds = _timeRemaining.inSeconds % 60;

    return Container(
      decoration: AppWidgetStyles.countdownDecoration,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.white, size: 24),
              const SizedBox(width: 8),
              Text('Auction Countdown', style: AppTypography.h4.copyWith(color: AppColors.white)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeUnit(days.toString(), 'Days'),
              _buildDivider(),
              _buildTimeUnit(hours.toString().padLeft(2, '0'), 'Hours'),
              _buildDivider(),
              _buildTimeUnit(minutes.toString().padLeft(2, '0'), 'Minutes'),
              _buildDivider(),
              _buildTimeUnit(seconds.toString().padLeft(2, '0'), 'Seconds'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.riskScoreMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(color: AppColors.white.withOpacity(0.9)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Text(':', style: AppTypography.h2.copyWith(color: AppColors.white));
  }
}
