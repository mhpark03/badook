import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/board_game_strings.dart';
import 'models/car_escape_models.dart';
import 'car_escape_generator.dart';
import 'widgets/car_escape_board.dart';

class CarEscapeScreen extends StatefulWidget {
  final CarEscapeDifficulty difficulty;

  const CarEscapeScreen({super.key, required this.difficulty});

  @override
  State<CarEscapeScreen> createState() => _CarEscapeScreenState();
}

class _CarEscapeScreenState extends State<CarEscapeScreen> {
  CarJamPuzzle? _puzzle;
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

    final puzzle = await CarEscapeGenerator.generate(widget.difficulty);

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

  void _onCarTap(GridCar car) {}

  void _onCarExited(GridCar car) {
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
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'dialog.hintTitle'.tr(),
          style: const TextStyle(color: Colors.green),
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
              'common.watchAd'.tr(),
              style: const TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  void _showHint() {
    if (_puzzle == null || _puzzle!.activeCars.isEmpty) return;

    for (var car in _puzzle!.activeCars) {
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'common.congratulations'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'games.carEscape.cleared'.tr(),
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Text(
              'games.carEscape.carsCount'.tr().replaceAll('{count}', '$_totalCars'),
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              '${'games.carEscape.time'.tr()}: $_elapsedTime',
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
            child: Text('app.close'.tr(), style: const TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _generatePuzzle();
            },
            child: Text('app.newGame'.tr(), style: const TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'app.rules'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRuleSection('games.carEscape.rulesObjective'.tr(), 'games.carEscape.rulesObjectiveDesc'.tr()),
              const SizedBox(height: 16),
              _buildRuleSection('games.carEscape.rulesControls'.tr(), 'games.carEscape.rulesControlsDesc'.tr()),
              const SizedBox(height: 16),
              _buildRuleSection('games.carEscape.rulesTips'.tr(), 'games.carEscape.rulesTipsDesc'.tr()),
              const SizedBox(height: 16),
              _buildTurnIcons(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.confirm'.tr(), style: const TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnIcons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'games.carEscape.turnTypes'.tr(),
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTurnIcon(Icons.arrow_upward, 'games.carEscape.straight'.tr()),
            _buildTurnIcon(Icons.turn_left, 'games.carEscape.left'.tr()),
            _buildTurnIcon(Icons.turn_right, 'games.carEscape.right'.tr()),
            _buildTurnIcon(Icons.u_turn_left, 'games.carEscape.uturn'.tr()),
          ],
        ),
      ],
    );
  }

  Widget _buildTurnIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildRuleSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.green,
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
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[800],
        title: Text(
          'games.carEscape.name'.tr(),
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
                    const CircularProgressIndicator(color: Colors.green),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCompactInfoCard(
                          icon: Icons.directions_car,
                          label: 'games.carEscape.carsLabel'.tr(),
                          value: '$_clearedCars / $_totalCars',
                        ),
                        _buildCompactInfoCard(
                          icon: Icons.timer,
                          label: 'games.carEscape.time'.tr(),
                          value: _elapsedTime,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _puzzle != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CarEscapeBoard(
                              puzzle: _puzzle!,
                              onCarTap: _onCarTap,
                              onCarExited: _onCarExited,
                              hintCarId: _hintCarId,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'games.carEscape.instruction'.tr(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCompactInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.green, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
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
