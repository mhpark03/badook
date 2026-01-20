import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/board_game_strings.dart';
import '../../../services/web_ad_helper.dart';
import 'models/parking_models.dart';
import 'parking_generator.dart';
import 'widgets/parking_board.dart';

class ParkingScreen extends StatefulWidget {
  final ParkingDifficulty difficulty;

  const ParkingScreen({super.key, required this.difficulty});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  ParkingPuzzle? _puzzle;
  bool _isLoading = true;
  int _totalCars = 0;
  int _clearedCars = 0;
  int _hintCount = 0;
  int? _hintCarId;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  String _elapsedTime = '00:00';

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> _generatePuzzle() async {
    setState(() {
      _isLoading = true;
    });

    final puzzle = await ParkingGenerator.generate(widget.difficulty);

    setState(() {
      _puzzle = puzzle;
      _totalCars = puzzle.cars.length;
      _clearedCars = 0;
      _hintCount = 0;
      _hintCarId = null;
      _isLoading = false;
    });

    _startTimer();
  }

  void _startTimer() {
    _stopwatch.reset();
    _stopwatch.start();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedTime = _formatTime(_stopwatch.elapsed);
        });
      }
    });
  }

  String _formatTime(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onCarTap(Car car) {}

  void _onCarExited(Car car) {
    if (_puzzle == null) return;

    setState(() {
      _puzzle!.removeCar(car.id);
      _clearedCars++;
      _hintCarId = null;
    });

    if (_puzzle!.isComplete) {
      _stopwatch.stop();
      _timer?.cancel();
      _showWinDialog();
    }
  }

  void _showHintConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'dialog.hintTitle'.tr(),
          style: const TextStyle(color: Colors.orange),
        ),
        content: Text(
          'common.hintWatchAdFull'.tr(),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'common.cancel'.tr(),
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showHint();
            },
            child: Text(
              'common.confirm'.tr(),
              style: const TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  void _showHint() {
    if (_puzzle == null || _puzzle!.cars.isEmpty) return;

    for (var car in _puzzle!.cars) {
      if (_puzzle!.canCarExit(car)) {
        setState(() {
          _hintCarId = car.id;
          _hintCount++;
        });
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _hintCarId == car.id) {
            setState(() {
              _hintCarId = null;
            });
          }
        });
        return;
      }
    }
  }

  void _showWinDialog() {
    WebAdHelper.showAd();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        title: Text(
          'common.congratulations'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'games.parking.cleared'.tr(),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'games.parking.carsCount'.tr().replaceAll('{count}', '$_totalCars'),
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '${'games.parking.time'.tr()}: $_elapsedTime',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '${'common.hint'.tr()}: $_hintCount',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('app.close'.tr(), style: const TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generatePuzzle();
            },
            child: Text('app.newGame'.tr(), style: const TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        title: Text(
          'app.rules'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRuleSection('games.parking.rulesObjective'.tr(), 'games.parking.rulesObjectiveDesc'.tr()),
              const SizedBox(height: 16),
              _buildRuleSection('games.parking.rulesControls'.tr(), 'games.parking.rulesControlsDesc'.tr()),
              const SizedBox(height: 16),
              _buildRuleSection('games.parking.rulesTips'.tr(), 'games.parking.rulesTipsDesc'.tr()),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.confirm'.tr(), style: const TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D44),
        title: Text(
          'games.parking.name'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white70),
            onPressed: _showRulesDialog,
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline, color: Colors.white70),
            onPressed: _showHintConfirmDialog,
            tooltip: 'common.hint'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: _generatePuzzle,
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      'common.generatingPuzzle'.tr(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildInfoCard(
                          icon: Icons.directions_car,
                          label: 'games.parking.carsLabel'.tr(),
                          value: '$_clearedCars / $_totalCars',
                        ),
                        _buildInfoCard(
                          icon: Icons.timer,
                          label: 'games.parking.time'.tr(),
                          value: _elapsedTime,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _puzzle != null
                        ? ParkingBoard(
                            puzzle: _puzzle!,
                            onCarTap: _onCarTap,
                            onCarExited: _onCarExited,
                            hintCarId: _hintCarId,
                          )
                        : const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'games.parking.instruction'.tr(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D44),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
