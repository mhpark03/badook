import 'dart:async';
import 'package:flutter/material.dart';
import '../../l10n/board_game_strings.dart';
import 'models/tap_master_models.dart';
import 'tap_master_generator.dart';
import 'widgets/tap_master_board.dart';

class TapMasterScreen extends StatefulWidget {
  final TapMasterDifficulty difficulty;

  const TapMasterScreen({super.key, required this.difficulty});

  @override
  State<TapMasterScreen> createState() => _TapMasterScreenState();
}

class _TapMasterScreenState extends State<TapMasterScreen> {
  TapMasterPuzzle? _puzzle;
  bool _isLoading = true;
  int _tapCount = 0;
  int _hintCount = 0;
  Timer? _timer;
  Timer? _hintTimer;
  final Stopwatch _stopwatch = Stopwatch();
  String _elapsedTime = '00:00';
  Set<TapBlock> _tappableBlocks = {};
  TapBlock? _hintBlock;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hintTimer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  Future<void> _generatePuzzle() async {
    setState(() => _isLoading = true);
    _stopwatch.reset();
    _timer?.cancel();

    final puzzle = await TapMasterGenerator.generate(widget.difficulty);

    setState(() {
      _puzzle = puzzle;
      _isLoading = false;
      _tapCount = 0;
      _hintCount = 0;
      _elapsedTime = '00:00';
      _updateTappableBlocks();
    });

    _startTimer();
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          final seconds = _stopwatch.elapsed.inSeconds;
          final mins = (seconds ~/ 60).toString().padLeft(2, '0');
          final secs = (seconds % 60).toString().padLeft(2, '0');
          _elapsedTime = '$mins:$secs';
        });
      }
    });
  }

  void _updateTappableBlocks() {
    if (_puzzle == null) return;
    _tappableBlocks = _puzzle!.getTappableBlocks().toSet();
  }

  void _onBlockTap(TapBlock block) {
    if (_puzzle == null) return;

    // Clear hint when block is tapped
    _hintTimer?.cancel();

    setState(() {
      _puzzle!.removeBlock(block);
      _tapCount++;
      _hintBlock = null;
      _updateTappableBlocks();
    });

    if (_puzzle!.isComplete()) {
      _stopwatch.stop();
      _timer?.cancel();
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'common.congratulations'.tr(),
          style: const TextStyle(color: Colors.amber),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 48),
            const SizedBox(height: 16),
            Text(
              '${'games.tapMaster.taps'.tr()}: $_tapCount',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '${'common.elapsedTime'.tr().replaceAll('{time}', '')}: $_elapsedTime',
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            if (_hintCount > 0) ...[
              const SizedBox(height: 8),
              Text(
                '${'common.hint'.tr()}: $_hintCount',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('common.back'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _generatePuzzle();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: Text('app.newGame'.tr()),
          ),
        ],
      ),
    );
  }

  void _showHintConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'dialog.hintTitle'.tr(),
          style: const TextStyle(color: Color(0xFFFF6B6B)),
        ),
        content: Text(
          'common.hintWatchAdFull'.tr(),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showHint();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B6B),
            ),
            child: Text('common.watchAd'.tr()),
          ),
        ],
      ),
    );
  }

  void _showHint() {
    if (_puzzle == null || _tappableBlocks.isEmpty) return;

    // Cancel any existing hint timer
    _hintTimer?.cancel();

    // Select a random tappable block as hint
    final tappableList = _tappableBlocks.toList();
    final hintBlock = tappableList[DateTime.now().millisecondsSinceEpoch % tappableList.length];

    setState(() {
      _hintCount++;
      _hintBlock = hintBlock;
    });

    // Show a snackbar indicating which block to tap
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('games.tapMaster.tapHighlighted'.tr()),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFFFF6B6B),
      ),
    );

    // Clear hint after 5 seconds
    _hintTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _hintBlock = null;
        });
      }
    });
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'app.rules'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Text(
            'games.tapMaster.rules'.tr(),
            style: const TextStyle(color: Colors.white70, height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.confirm'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D44),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFFF6B6B), size: 18),
          const SizedBox(width: 6),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D44),
        title: Text(
          'games.tapMaster.name'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showRulesDialog,
            tooltip: 'app.rules'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _isLoading ? null : _showHintConfirmDialog,
            tooltip: 'common.hint'.tr(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _generatePuzzle,
            tooltip: 'app.newGame'.tr(),
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF6B6B),
                ),
              )
            : Column(
                children: [
                  // Stats row
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCompactInfoCard(
                          Icons.timer,
                          'games.tapMaster.time'.tr(),
                          _elapsedTime,
                        ),
                        _buildCompactInfoCard(
                          Icons.touch_app,
                          'games.tapMaster.taps'.tr(),
                          '$_tapCount',
                        ),
                        _buildCompactInfoCard(
                          Icons.grid_view,
                          'games.tapMaster.remaining'.tr(),
                          '${_puzzle!.remainingBlocks}/${_puzzle!.totalBlocks}',
                        ),
                      ],
                    ),
                  ),
                  // Game board
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TapMasterBoard(
                        puzzle: _puzzle!,
                        onBlockTap: _onBlockTap,
                        tappableBlocks: _tappableBlocks,
                        hintBlock: _hintBlock,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
