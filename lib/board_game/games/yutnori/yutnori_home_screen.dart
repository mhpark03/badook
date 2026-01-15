import 'package:flutter/material.dart';
import '../../l10n/board_game_strings.dart';
import 'yutnori_screen.dart';

class YutnoriHomeScreen extends StatefulWidget {
  const YutnoriHomeScreen({super.key});

  @override
  State<YutnoriHomeScreen> createState() => _YutnoriHomeScreenState();
}

class _YutnoriHomeScreenState extends State<YutnoriHomeScreen> {
  bool _hasSavedGame = false;
  int? _savedPlayerCount;

  @override
  void initState() {
    super.initState();
    _checkSavedGame();
  }

  Future<void> _checkSavedGame() async {
    final hasSaved = await YutnoriScreen.hasSavedGame();
    final savedCount = await YutnoriScreen.getSavedPlayerCount();
    if (mounted) {
      setState(() {
        _hasSavedGame = hasSaved;
        _savedPlayerCount = savedCount;
      });
    }
  }

  void _startGame(int playerCount, {bool resume = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YutnoriScreen(
          playerCount: playerCount,
          resumeGame: resume,
        ),
      ),
    ).then((_) => _checkSavedGame());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('games.yutnori.name'.tr()),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.brown.shade100,
              Colors.brown.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 게임 아이콘
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.brown.shade600,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.shade300,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.sports_esports,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 게임 제목
                  Text(
                    'games.yutnori.name'.tr(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'games.yutnori.description'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.brown.shade600,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 이어하기 버튼 (저장된 게임이 있을 때)
                  if (_hasSavedGame && _savedPlayerCount != null) ...[
                    _buildContinueButton(),
                    const SizedBox(height: 24),
                    Divider(color: Colors.brown.shade300),
                    const SizedBox(height: 24),
                  ],

                  // 인원 선택 제목
                  Text(
                    'games.yutnori.selectPlayers'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 인원 선택 버튼들
                  _buildPlayerButton(2, 'games.yutnori.players2'.tr()),
                  const SizedBox(height: 12),
                  _buildPlayerButton(3, 'games.yutnori.players3'.tr()),
                  const SizedBox(height: 12),
                  _buildPlayerButton(4, 'games.yutnori.players4'.tr()),

                  const SizedBox(height: 32),

                  // 게임 규칙 버튼
                  TextButton.icon(
                    onPressed: _showRulesDialog,
                    icon: Icon(Icons.help_outline, color: Colors.brown.shade600),
                    label: Text(
                      'app.rules'.tr(),
                      style: TextStyle(color: Colors.brown.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _startGame(_savedPlayerCount!, resume: true),
        icon: const Icon(Icons.play_arrow, size: 28),
        label: Text(
          '${'games.yutnori.continueGame'.tr()} ($_savedPlayerCount${'games.yutnori.players'.tr()})',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerButton(int playerCount, String label) {
    final colors = {
      2: Colors.blue,
      3: Colors.orange,
      4: Colors.purple,
    };
    final color = colors[playerCount] ?? Colors.brown;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _startGame(playerCount),
        icon: Icon(
          playerCount == 2 ? Icons.people : Icons.groups,
          size: 24,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.shade100,
          foregroundColor: color.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: color.shade300, width: 2),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.brown.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'games.yutnori.rulesTitle'.tr(),
          style: TextStyle(color: Colors.brown.shade800),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRuleSection(
                'games.yutnori.rulesObjective'.tr(),
                'games.yutnori.rulesObjectiveDesc'.tr(),
              ),
              const SizedBox(height: 16),
              _buildRuleSection(
                'games.yutnori.rulesYutResults'.tr(),
                'games.yutnori.rulesYutResultsDesc'.tr(),
              ),
              const SizedBox(height: 16),
              _buildRuleSection(
                'games.yutnori.rulesSpecial'.tr(),
                'games.yutnori.rulesSpecialDesc'.tr(),
              ),
              const SizedBox(height: 16),
              _buildRuleSection(
                'games.yutnori.rulesTips'.tr(),
                'games.yutnori.rulesTipsDesc'.tr(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'app.confirm'.tr(),
              style: TextStyle(color: Colors.brown.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            color: Colors.brown.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
