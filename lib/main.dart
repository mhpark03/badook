import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'dart:collection';
import 'dart:math';
import 'dart:convert';
import 'dart:async';

// 카드게임 import
import 'card_game/screens/game_selection_screen.dart' as card_game;
import 'card_game/screens/home_screen.dart' as mighty_home;
import 'card_game/screens/hearts/hearts_home_screen.dart';
import 'card_game/screens/hula/hula_home_screen.dart';
import 'card_game/screens/onecard/onecard_home_screen.dart';
import 'card_game/screens/hi_lo/hi_lo_home_screen.dart';
import 'card_game/screens/seven_card/seven_card_home_screen.dart';
import 'card_game/widgets/card_game_provider.dart';

// 보드게임 import
import 'board_game/screens/board_game_selection_screen.dart';
import 'board_game/games/tetris/tetris_screen.dart';
import 'board_game/games/minesweeper/minesweeper_screen.dart';
import 'board_game/games/maze/maze_screen.dart';
import 'board_game/games/bubble/bubble_screen.dart';
import 'board_game/games/mole/mole_screen.dart';
import 'board_game/games/gomoku/gomoku_screen.dart';
import 'board_game/games/othello/othello_screen.dart';
import 'board_game/games/solitaire/solitaire_screen.dart';
import 'board_game/games/baseball/baseball_screen.dart';

// 스도쿠 import
import 'board_game/screens/sudoku_selection_screen.dart';
import 'board_game/games/sudoku/screens/game_screen.dart' as sudoku_classic;
import 'board_game/games/sudoku/screens/samurai_game_screen.dart';
import 'board_game/games/sudoku/screens/killer_game_screen.dart';
import 'board_game/games/sudoku/models/game_state.dart' as sudoku_state;
import 'board_game/games/sudoku/models/samurai_game_state.dart';
import 'board_game/games/sudoku/models/killer_sudoku_generator.dart';
import 'board_game/games/number_sums/screens/number_sums_game_screen.dart';
import 'board_game/games/number_sums/models/number_sums_generator.dart';

// 윷놀이 import
import 'board_game/games/yutnori/yutnori_home_screen.dart';
import 'yutnori/yutnori_screen.dart';

// 장기 import
import 'janggi/janggi_selection_screen.dart';

// 보드게임 번역
import 'board_game/l10n/board_game_strings.dart';

// 카드게임 번역
import 'card_game/l10n/generated/app_localizations.dart';

// 언어 상태 관리 Provider
class LanguageProvider extends ChangeNotifier {
  GameLanguage _language = GameLanguage.korean;

  GameLanguage get language => _language;

  // GameLanguage를 Flutter Locale로 변환
  Locale get locale {
    switch (_language) {
      case GameLanguage.korean:
        return const Locale('ko');
      case GameLanguage.english:
        return const Locale('en');
      case GameLanguage.japanese:
        return const Locale('ja');
      case GameLanguage.chinese:
        return const Locale('zh');
    }
  }

  void setLanguage(GameLanguage lang) {
    if (_language != lang) {
      _language = lang;
      // BoardGameStrings도 함께 업데이트
      BoardGameStrings.currentLanguage = lang;
      notifyListeners();
    }
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const BadukApp(),
    ),
  );
}

// 디바이스 성능 등급
enum DevicePerformance { low, medium, high }

// 디바이스 성능 측정 클래스
class DeviceBenchmark {
  static DevicePerformance? _cachedPerformance;
  static double? _benchmarkScore;

  // 벤치마크 실행 (앱 시작 시 한 번만)
  static Future<DevicePerformance> measurePerformance() async {
    if (_cachedPerformance != null) return _cachedPerformance!;

    final stopwatch = Stopwatch()..start();
    final random = Random();

    // 간단한 계산 벤치마크 (MCTS와 유사한 연산)
    int iterations = 10000;
    double sum = 0;
    for (int i = 0; i < iterations; i++) {
      sum += random.nextDouble() * random.nextDouble();
      sum = sum % 1000;
    }

    stopwatch.stop();
    _benchmarkScore = stopwatch.elapsedMicroseconds / 1000.0; // ms

    // 성능 등급 판정
    // < 20ms: 고성능, 20-50ms: 중간, > 50ms: 저성능
    if (_benchmarkScore! < 20) {
      _cachedPerformance = DevicePerformance.high;
    } else if (_benchmarkScore! < 50) {
      _cachedPerformance = DevicePerformance.medium;
    } else {
      _cachedPerformance = DevicePerformance.low;
    }

    debugPrint('Device benchmark: ${_benchmarkScore!.toStringAsFixed(2)}ms -> $_cachedPerformance');
    return _cachedPerformance!;
  }

  static DevicePerformance get performance => _cachedPerformance ?? DevicePerformance.medium;
  static double? get score => _benchmarkScore;

  // 성능에 따른 배율 반환
  static double get multiplier {
    switch (performance) {
      case DevicePerformance.high:
        return 1.5;  // 고성능: 150%
      case DevicePerformance.medium:
        return 1.0;  // 중간: 100%
      case DevicePerformance.low:
        return 0.5;  // 저성능: 50%
    }
  }
}

// AI 난이도 설정
enum AIDifficulty { advanced, expert }

// 언어 설정
enum GameLanguage { korean, english, japanese, chinese }

class L10n {
  static final Map<GameLanguage, Map<String, String>> _strings = {
    GameLanguage.korean: {
      'appTitle': '바둑',
      'vsAI': 'AI 대국',
      'vsAIDesc': 'AI와 대국하기',
      'twoPlayer': '바둑 - 2인 대국',
      'twoPlayerModeDesc': '같이 대국하기',
      'playAsBlack': '컴퓨터와 대국 (흑)',
      'playAsWhite': '컴퓨터와 대국 (백)',
      'twoPlayerMode': '2인 대국',
      'boardSize': '보드 크기',
      'newGame': '새 게임',
      'pass': '패스',
      'black': '흑',
      'white': '백',
      'blackTurn': '흑의 차례입니다',
      'whiteTurn': '백의 차례입니다',
      'yourTurn': '당신의 차례입니다',
      'aiThinking': 'AI가 생각 중...',
      'aiThinkingTime': 'AI가 생각 중... ({time}초)',
      'aiPass': 'AI 패스',
      'blackPass': '흑 패스',
      'whitePass': '백 패스',
      'congratsWin': '축하합니다! 승리!',
      'aiWin': 'AI 승리!',
      'blackWin': '흑 승리!',
      'whiteWin': '백 승리!',
      'draw': '무승부!',
      'me': '나',
      'ai': 'AI',
      'captures': '따낸 돌',
      'koViolation': '패 규칙 위반입니다!',
      'beginner': '입문',
      'intermediate': '중급',
      'expert': '정식',
      'language': '언어',
      'aiLevel': 'AI 레벨',
      'aiEasy': '쉬움',
      'aiNormal': '보통',
      'aiHard': '어려움',
      'aiExpert': '최강',
      'hint': '힌트',
      'hintOn': '힌트 ON',
      'hintOff': '힌트 OFF',
      'hintMessage': '추천 위치가 표시되었습니다',
      'noHint': '추천할 수 없습니다',
      'enableHintTitle': '힌트',
      'enableHintMessage': '힌트를 활성화하시겠습니까?',
      'hintEnabled': '힌트가 활성화되었습니다!',
      'cancel': '취소',
      'confirm': '확인',
      'close': '닫기',
      'newGameConfirm': '새 게임을 시작하시겠습니까?',
      'endGameConfirm': '현재 게임을 종료하고 새 게임을 시작하시겠습니까?',
      'continue': '이어하기',
      'save': '저장',
      'load': '불러오기',
      'restart': '다시 시작',
      'selectGame': '게임 선택',
      'viewResult': '결과 확인',
      'initializing': '초기화 중...',
      // 포커 베팅
      'betPing': '삥',
      'betCall': '콜',
      'betDdadang': '따당',
      'betDie': '다이',
      'betCheck': '체크',
      'betQuarter': '쿼터',
      'betHalf': '하프',
      'betFull': '풀',
      // 훌라 게임
      'register': '등록',
      'discard': '버리기',
      'stop': '스톱',
      // 테이블 헤더
      'player': '플레이어',
      'thisGame': '이번 게임',
      'winLoss': '승/패',
      'cumulative': '누적',
      'hand': '손패',
      'score': '점수',
      // 스도쿠
      'quick': '빠른',
      'memo': '메모',
      'allMemo': '모든 메모',
      'selectCellFirst': '셀을 먼저 선택하세요',
      'cellAlreadyFilled': '이미 채워진 칸입니다',
      'noSavedGame': '저장된 게임이 없습니다',
      'gameSaved': '게임이 저장되었습니다',
      'gameLoaded': '게임을 불러왔습니다',
      'savedGameInfo': '저장된 게임',
      'saveDate': '저장 시간',
      'moveCount': '수',
      'selectDifficulty': '난이도 선택',
      'selectColor': '돌 색상 선택',
      'firstMove': '선공',
      'secondMove': '후공',
      'startGame': '게임 시작',
      'aiEasyDesc': '바둑을 처음 배우는 분께 추천',
      'aiNormalDesc': '기본적인 전략을 사용',
      'aiHardDesc': '고급 전략과 정석 사용',
      'aiExpertDesc': '최고 수준의 AI',
      // 사활 배우기
      'lifeDeathProblems': '사활 문제',
      'lifeDeathProblemsDesc': '문제 풀기',
      'problemList': '문제 목록',
      'problem': '문제',
      'problemType': '유형',
      'progress': '진행',
      'video': '영상',
      'solveProblem': '문제 풀기',
      'difficulty': '난이도',
      'beginner': '입문',
      'intermediate': '중급',
      'advanced': '고급',
      'blackToPlay': '흑 선',
      'whiteToPlay': '백 선',
      'killWhite': '백을 잡아라',
      'killBlack': '흑을 잡아라',
      'cutWhite': '백을 끊어라',
      'cutBlack': '흑을 끊어라',
      'liveWithBlack': '흑으로 살아라',
      'liveWithWhite': '백으로 살아라',
      'correct': '정답입니다!',
      'incorrect': '틀렸습니다. 다시 시도해보세요.',
      'showAnswer': '정답 보기',
      'nextProblem': '다음 문제',
      'prevProblem': '이전 문제',
      'retry': '다시 시도',
      'problemSolved': '문제 풀이 완료!',
      'solvedCount': '해결한 문제',
      'totalProblems': '전체 문제',
      'backToList': '목록으로',
      // 카드게임
      'baduk': '바둑',
      'cardGame': '카드게임',
      'janggi': '장기',
      'boardGame': '보드게임',
      'sudoku': '스도쿠',
      'yutnori': '윷놀이',
      // 게임별 도움말
      'help_baduk': '[게임 방법]\n흑과 백이 번갈아 빈 교차점에 돌을 놓습니다.\n상대 돌을 완전히 둘러싸면 잡을 수 있습니다.\n게임 종료 시 더 많은 영역을 차지한 쪽이 승리합니다.\n\n[기본 규칙]\n- 흑이 먼저 시작합니다\n- 백은 6.5점의 덤을 받습니다\n- 패(Ko): 직전 상태와 동일한 국면을 만드는 착수는 금지\n\n[게임 모드]\n- AI 대국: AI와 1:1 대결\n- 2인 대국: 친구와 함께 플레이\n- 사활 문제: 실전 감각을 키우는 문제 풀이',
      'help_janggi': '[게임 방법]\n각 플레이어는 16개의 기물을 움직여 상대의 왕(장/將)을 잡는 것이 목표입니다.\n\n[기물 이동]\n- 장(將): 궁 안에서 한 칸 이동\n- 차(車): 직선으로 무제한 이동\n- 포(包): 다른 기물 하나를 뛰어넘어 이동/공격 (포는 넘을 수 없음)\n- 마(馬): 날(日)자로 이동\n- 상(象): 직선 한 칸 + 대각선 두 칸 이동 (用자로 이동)\n- 사(士): 궁 안에서 대각선 한 칸 이동\n- 졸/병: 앞, 좌우로 한 칸 이동\n\n[기물 잡기]\n- 이동한 자리에 상대방 기물이 있으면 잡을 수 있습니다\n- 이동 경로에 다른 기물이 있으면 이동할 수 없습니다 (포 제외)\n\n[게임 모드]\n- AI 대국: AI와 1:1 대결\n- 2인 대국: 친구와 함께 플레이',
      'help_cardGame': '[마이티]\n5인용 트릭테이킹 게임. 주공이 되어 선언한 점수를 획득하면 승리합니다.\n여당(주공+파트너) vs 야당(나머지 3명)으로 나뉘어 플레이합니다.\n\n[하트]\n하트 카드와 스페이드Q를 피하며 최저 점수를 노리는 게임입니다.\n하트 1장당 1점, 스페이드Q는 13점입니다.\n\n[훌라]\n같은 숫자나 연속된 숫자 조합을 만들어 먼저 패를 버리면 승리합니다.\n\n[원카드]\nUNO와 유사한 게임. 같은 숫자나 무늬의 카드를 내며 먼저 패를 없애면 승리합니다.\n\n[하이로우]\n다음 카드가 현재 카드보다 높을지 낮을지 맞추는 게임입니다.\n\n[세븐포커]\n7장의 카드로 족보를 만들어 겨루는 포커 게임입니다.',
      'help_boardGame': '[오목]\n흑과 백이 번갈아 돌을 놓아 먼저 5개를 연속으로 놓으면 승리합니다.\n가로, 세로, 대각선 모두 가능합니다.\n\n[오델로]\n상대 돌을 자신의 돌로 양쪽에서 감싸면 뒤집을 수 있습니다.\n게임 종료 시 더 많은 돌을 가진 쪽이 승리합니다.\n\n[테트리스]\n떨어지는 블록을 쌓아 가로줄을 완성하면 사라집니다.\n블록이 맨 위까지 쌓이면 게임 오버입니다.\n\n[지뢰찾기]\n숫자 힌트를 이용해 지뢰 위치를 추리합니다.\n지뢰가 아닌 모든 칸을 열면 승리합니다.\n\n[솔리테어]\n카드를 규칙에 맞게 정리하여 4개의 기초 더미를 완성하는 게임입니다.\n\n[미로]\n출구를 찾아 미로를 탈출하는 게임입니다.\n\n[버블]\n같은 색 버블 3개 이상을 맞춰 터뜨리는 게임입니다.',
      'help_sudoku': '[게임 방법]\n9x9 칸에 1~9 숫자를 중복 없이 채우는 논리 퍼즐입니다.\n각 가로줄, 세로줄, 3x3 박스에 같은 숫자가 없어야 합니다.\n\n[게임 모드]\n- 클래식: 기본 스도쿠\n- 사무라이: 5개의 스도쿠가 겹쳐진 대형 퍼즐\n- 킬러: 점선 영역 내 숫자 합이 주어진 숫자와 일치해야 함\n- 숫자합: 인접한 칸의 합이 힌트로 주어지는 변형\n\n[난이도]\n초급 / 중급 / 고급 / 전문가',
      'help_yutnori': '[게임 방법]\n윷을 던져 나온 결과에 따라 말을 이동시킵니다.\n모든 말을 먼저 도착점에 들여보내면 승리합니다.\n\n[윷 결과]\n- 도: 1칸 이동\n- 개: 2칸 이동\n- 걸: 3칸 이동\n- 윷: 4칸 이동 + 한 번 더 던지기\n- 모: 5칸 이동 + 한 번 더 던지기\n\n[특수 규칙]\n- 상대 말을 잡으면 한 번 더 던질 수 있습니다\n- 같은 위치의 내 말은 업어서 함께 이동할 수 있습니다\n- 지름길을 활용하면 더 빨리 도착할 수 있습니다',
      // 하위 게임 이름
      'mighty': '마이티',
      'mightyDesc': '5인 트럼프',
      'hearts': '하트',
      'heartsDesc': '패스 게임',
      'hula': '훌라',
      'hulaDesc': '3장 카드',
      'onecard': '원카드',
      'onecardDesc': '4인 대전',
      'highlow': '하이로우',
      'highlowDesc': '숫자 맞추기',
      'sevenpoker': '세븐포커',
      'sevenpokerDesc': '포커 게임',
      'gomoku': '오목',
      'othello': '오델로',
      'tetris': '테트리스',
      'minesweeper': '지뢰찾기',
      'solitaire': '솔리테어',
      'maze': '미로',
      'bubble': '버블',
      'whackamole': '두더지 잡기',
      'baseball': '숫자야구',
      'sudoku_classic': '클래식',
      'sudoku_samurai': '사무라이',
      'sudoku_killer': '킬러',
      'sudoku_sum': '숫자합',
      // 하위 게임 도움말
      'help_mighty': '[게임 방법]\n5인용 트릭테이킹 게임입니다. 주공이 되어 선언한 점수를 획득하면 승리합니다.\n\n[게임 진행]\n1. 카드 분배: 각 플레이어에게 10장씩 배분\n2. 비딩: 가장 높은 점수를 선언한 사람이 주공\n3. 기루다 선언: 주공이 으뜸패(기루다) 무늬 선택\n4. 프렌드 콜: 주공이 파트너를 지정\n5. 트릭 진행: 10번의 트릭으로 점수 획득\n\n[트릭 규칙]\n- 선이 낸 무늬를 따라가야 합니다\n- 해당 무늬가 없으면 다른 무늬를 낼 수 있습니다\n- 기루다 무늬가 나오면 기루다가 이깁니다\n\n[특수 카드]\n- 마이티: 가장 강한 카드 (기본 스페이드A, 기루다가 스페이드면 다이아A)\n- 조커: 두 번째로 강한 카드\n- 조커콜: 조커를 강제로 내게 하는 카드 (기본 클로버3)\n\n[점수 계산]\n- 점수카드: A, K, Q, J, 10 (각 1점, 총 20점)\n- 여당 승리: 선언 점수 이상 획득 시\n- 야당 승리: 여당이 선언 점수 미달 시',
      'help_hearts': '[게임 방법]\n하트 카드와 스페이드Q를 피하며 최저 점수를 노리는 게임입니다.\n\n[점수]\n- 하트 1장당 1점 (총 13점)\n- 스페이드Q: 13점\n- 총 26점 가능\n\n[게임 진행]\n1. 각 플레이어에게 13장 배분\n2. 매 게임 시작 전 3장씩 교환\n3. 클로버2를 가진 사람이 선\n4. 13번의 라운드 진행\n\n[라운드 규칙]\n- 선이 낸 무늬를 따라가야 합니다\n- 해당 무늬가 없으면 다른 무늬를 낼 수 있습니다\n\n[특수 규칙]\n- 첫 라운드에 점수카드 선 불가\n- 하트가 브레이크되기 전엔 하트로 선 불가\n- 슈팅 더 문: 26점 모두 획득 시 0점 (다른 사람 +26점)',
      'help_hula': '[게임 방법]\n같은 숫자나 연속된 숫자 조합을 만들어 먼저 패를 버리면 승리합니다.\n\n[카드 조합]\n- 트리플: 같은 숫자 3장\n- 스트레이트: 연속된 숫자 3장 이상 (같은 무늬)\n- 7: 단독으로 등록 가능\n\n[게임 진행]\n1. 각 플레이어에게 7장 배분\n2. 차례대로 덱에서 1장 뽑기\n3. 조합이 완성되면 내려놓기\n4. 손패 1장 버리기\n5. 먼저 패를 다 버리면 승리\n\n[추가 규칙]\n- 카드를 등록한 후에는 기존 조합에 카드를 붙여놓을 수 있습니다\n- 스톱을 불러 게임을 종료할 수 있습니다\n\n[득점]\n- 승자 제외 나머지 손패 점수 합산\n- 숫자카드 (2-10): 액면가\n- A: 1점, J: 10점, Q: 11점, K: 12점\n- 등록을 못했거나 7을 가지고 있으면 2배',
      'help_onecard': '[게임 방법]\nUNO와 유사한 게임입니다. 같은 숫자나 무늬의 카드를 내며 먼저 패를 없애면 승리합니다.\n\n[카드 규칙]\n- 같은 숫자 또는 같은 무늬만 낼 수 있음\n- 낼 카드가 없으면 덱에서 뽑기\n- 카드가 1장 남으면 5초 내에 원카드를 외쳐야 함 (안 외치면 벌칙 1장)\n\n[공격 카드]\n- 2: +2장 공격\n- A: +3장 공격 (♠A는 +5장)\n- 조커: +5장 (컬러 조커는 +7장)\n- 공격 방어: 2는 2/같은무늬A/조커, A는 A/조커, 조커는 조커로만 방어\n- 방어 못하면 누적된 장수만큼 뽑기\n\n[특수 카드]\n- 7: 무늬 변경\n- J: 다음 턴 건너뛰기\n- Q: 방향 반전 (2인은 건너뛰기)\n- K: 2턴 건너뛰기',
      'help_sevenpoker': '[게임 방법]\n7장의 카드로 족보를 만들어 겨루는 포커 게임입니다.\n\n[게임 진행]\n1. 처음 3장 받음 (2장 비공개 + 1장 공개)\n2. 공개된 카드 기준 높은 사람이 보스\n3. 1장씩 공개하며 4번의 베팅 라운드\n4. 마지막 7번째 카드는 비공개\n5. 7장 중 5장으로 최고 족보 완성\n\n[베팅 종류]\n- 삥: 기본 베팅 / 체크: 패스 (보스만)\n- 콜: 현재 베팅액 맞추기\n- 따당: 현재 베팅액의 2배\n- 쿼터/하프/풀: 판돈의 25%/50%/100%\n- 다이: 포기\n\n[족보 순위 (높은순)]\n- 로열 스트레이트 플러시: 같은 무늬 10-J-Q-K-A\n- 스트레이트 플러시: 같은 무늬 연속 5장\n- 포카드: 같은 숫자 4장\n- 풀하우스: 트리플 + 원페어\n- 플러시: 같은 무늬 5장\n- 스트레이트: 연속된 숫자 5장\n- 트리플: 같은 숫자 3장\n- 투페어: 페어 2개\n- 원페어: 같은 숫자 2장\n- 탑(하이카드): 족보 없음',
      'help_highlow': '[게임 방법]\n7장의 카드로 하이(포커 족보)와 로우(낮은 패)를 겨루는 포커 게임입니다.\n팟을 하이와 로우 승자가 나눠 가집니다.\n\n[게임 진행]\n1. 처음 3장 받고 1장을 선택하여 공개\n2. 4장째부터 1장씩 공개하며 베팅\n3. 7번째 카드는 비공개\n4. 마지막에 하이/로우/스윙 선택\n5. 하이와 로우 승자가 팟을 반씩 나눔\n\n[하이/로우/스윙]\n- 하이: 높은 족보로 승부\n- 로우: 낮은 패로 승부\n- 스윙: 둘 다 참여 (둘 다 이겨야 전체 획득)\n\n[로우 규칙]\n- 페어, 스트레이트, 플러시가 없어야 자격\n- A-2-3-4-6이 최강 로우 (A-2-3-4-5는 스트레이트)\n- 낮을수록 좋음\n\n[베팅 종류]\n- 삥/체크: 보스만 (기본 베팅/패스)\n- 콜: 베팅액 맞추기\n- 따당: 2배 / 쿼터/하프/풀: 판돈의 25%/50%/100%\n- 다이: 포기\n\n[보너스]\n- 포카드 이상: 다른 플레이어에게 보너스 징수\n- 로스플: 500, 백스플: 300, 스플: 200, 포카드: 100',
      'help_gomoku': '[게임 방법]\n흑과 백이 번갈아 돌을 놓아 먼저 5개를 연속으로 놓으면 승리합니다.\n\n[기본 규칙]\n- 흑이 먼저 시작\n- 가로, 세로, 대각선 모두 가능\n- 정확히 5개 연속 (6개 이상은 무효)\n\n[게임 모드]\n- AI 대전: 컴퓨터와 대결\n- 2인 대전: 친구와 함께\n\n[전략 팁]\n- 양쪽이 열린 4개 연속(열린 4)은 막기 어려움\n- 동시에 두 방향으로 4를 만드는 것이 유리\n- 상대의 3연속을 미리 차단',
      'help_othello': '[게임 방법]\n상대 돌을 자신의 돌로 양쪽에서 감싸면 뒤집을 수 있습니다.\n게임 종료 시 더 많은 돌을 가진 쪽이 승리합니다.\n\n[기본 규칙]\n- 8x8 판에서 진행\n- 흑이 먼저 시작\n- 반드시 상대 돌을 뒤집을 수 있는 곳에만 착수 가능\n- 둘 수 없으면 패스\n\n[게임 종료]\n- 판이 가득 차거나\n- 양쪽 모두 둘 곳이 없을 때\n\n[전략 팁]\n- 코너를 차지하면 유리\n- 가장자리도 중요한 위치\n- 초반에 돌이 적은 것이 오히려 유리할 수 있음',
      'help_tetris': '[게임 방법]\n떨어지는 블록을 쌓아 가로줄을 완성하면 사라집니다.\n블록이 맨 위까지 쌓이면 게임 오버입니다.\n\n[조작법]\n- 좌우: 블록 이동\n- 위: 회전\n- 아래: 빠르게 내리기\n- 스페이스: 즉시 낙하\n\n[블록 종류]\n- I, O, T, S, Z, J, L 총 7종류\n\n[점수]\n- 1줄: 100점\n- 2줄: 300점\n- 3줄: 500점\n- 4줄(테트리스): 800점\n\n[레벨]\n- 줄을 지울수록 레벨 상승\n- 레벨이 오르면 낙하 속도 증가',
      'help_minesweeper': '[게임 방법]\n숫자 힌트를 이용해 지뢰 위치를 추리합니다.\n지뢰가 아닌 모든 칸을 열면 승리합니다.\n\n[숫자의 의미]\n- 숫자는 주변 8칸에 있는 지뢰 개수\n- 0이면 주변에 지뢰 없음 (자동 확장)\n\n[조작법]\n- 클릭: 칸 열기\n- 오른쪽 클릭/길게 누르기: 깃발 표시\n\n[난이도]\n- 초급: 9x9, 지뢰 10개\n- 중급: 16x16, 지뢰 40개\n- 고급: 30x16, 지뢰 99개\n\n[전략 팁]\n- 모서리부터 시작하면 안전\n- 1-2-1 패턴 등 자주 나오는 패턴 익히기',
      'help_solitaire': '[게임 방법]\n카드를 규칙에 맞게 정리하여 4개의 기초 더미를 완성하는 게임입니다.\n\n[목표]\n- 4개의 기초 더미에 A부터 K까지 같은 무늬로 쌓기\n\n[규칙]\n- 테이블 카드: 빨강-검정 번갈아, 내림차순으로 쌓기\n- 기초 더미: 같은 무늬, 오름차순(A-K)으로 쌓기\n- 덱에서 카드를 뽑아 사용 가능\n\n[조작법]\n- 카드 드래그: 이동\n- 카드 더블클릭: 자동으로 기초 더미로 이동\n- 덱 클릭: 새 카드 뽑기',
      'help_maze': '[게임 방법]\n출구를 찾아 미로를 탈출하는 게임입니다.\n\n[조작법]\n- 화살표/스와이프: 이동\n- 벽은 통과 불가\n\n[게임 모드]\n- 다양한 크기의 미로\n- 시간 제한 모드\n\n[전략 팁]\n- 한쪽 벽을 계속 따라가면 출구 도달 가능\n- 분기점에서 방문한 곳 기억하기\n- 막다른 길에서는 되돌아가기',
      'help_bubble': '[게임 방법]\n같은 색 버블 3개 이상을 맞춰 터뜨리는 게임입니다.\n\n[조작법]\n- 조준: 마우스/터치로 방향 설정\n- 발사: 클릭/터치\n\n[규칙]\n- 같은 색 버블 3개 이상 연결 시 터짐\n- 터진 버블 아래 매달린 버블도 함께 떨어짐\n- 모든 버블을 제거하면 클리어\n\n[점수]\n- 한 번에 많이 터뜨릴수록 고득점\n- 연쇄로 떨어지는 버블 보너스\n\n[게임 오버]\n- 버블이 바닥 선까지 내려오면 종료',
      'help_whackamole': '[게임 방법]\n구멍에서 올라오는 두더지를 빠르게 잡는 게임입니다.\n\n[조작법]\n- 클릭/터치: 두더지 잡기\n\n[규칙]\n- 두더지가 올라오면 빠르게 터치\n- 제한 시간 내에 최대한 많이 잡기\n- 폭탄을 잡으면 감점\n\n[점수]\n- 일반 두더지: +10점\n- 황금 두더지: +50점\n- 폭탄: -30점\n\n[레벨]\n- 레벨이 오르면 두더지가 더 빨리 숨음',
      'help_baseball': '[게임 방법]\n상대가 정한 3자리 숫자를 추리하는 게임입니다.\n\n[용어]\n- 스트라이크(S): 숫자와 위치 모두 일치\n- 볼(B): 숫자는 있지만 위치가 다름\n- 아웃: 숫자가 없음\n\n[예시]\n정답이 123일 때:\n- 123 입력 → 3S (정답!)\n- 132 입력 → 1S 2B\n- 456 입력 → 0S 0B (아웃)\n\n[규칙]\n- 각 자리 숫자는 중복 불가 (0~9)\n- 제한된 시도 횟수 내에 맞추기\n\n[전략]\n- 처음에 0, 1, 2로 시작해 숫자 범위 좁히기',
      'help_sudoku_classic': '[클래식 스도쿠]\n기본 스도쿠 규칙을 따릅니다.\n\n[규칙]\n- 9x9 칸에 1~9 숫자 배치\n- 각 가로줄에 1~9 한 번씩\n- 각 세로줄에 1~9 한 번씩\n- 각 3x3 박스에 1~9 한 번씩\n\n[난이도]\n- 초급: 빈 칸 적음, 논리적 추론만으로 해결\n- 중급: 약간의 가정 필요\n- 고급: 고급 기법 필요\n- 전문가: 복잡한 체인 기법 필요\n\n[팁]\n- 확실한 숫자부터 채우기\n- 후보 숫자 메모 기능 활용',
      'help_sudoku_samurai': '[사무라이 스도쿠]\n5개의 스도쿠가 겹쳐진 대형 퍼즐입니다.\n\n[구조]\n- 중앙 1개 + 모서리 4개 = 총 5개 스도쿠\n- 모서리 스도쿠는 중앙과 3x3 박스를 공유\n\n[규칙]\n- 각 스도쿠는 기본 규칙 적용\n- 겹치는 영역은 두 스도쿠 규칙 모두 만족\n\n[전략]\n- 겹치는 영역부터 해결하면 효율적\n- 한 스도쿠의 답이 다른 스도쿠에 영향',
      'help_sudoku_killer': '[킬러 스도쿠]\n점선 영역(케이지) 내 숫자 합이 조건입니다.\n\n[규칙]\n- 기본 스도쿠 규칙 적용\n- 점선 영역 내 숫자 합 = 표시된 숫자\n- 같은 영역 내 숫자 중복 불가\n\n[예시]\n- 2칸 합 3 = 1+2\n- 2칸 합 17 = 8+9\n- 3칸 합 6 = 1+2+3\n\n[전략]\n- 합이 정해진 조합이 하나뿐인 케이지 먼저\n- 큰 케이지는 가능한 조합 좁히기',
      'help_sudoku_sum': '[숫자합 스도쿠]\n인접한 칸의 합이 힌트로 주어집니다.\n\n[규칙]\n- 기본 스도쿠 규칙 적용\n- 칸 사이 숫자 = 두 칸의 합\n\n[예시]\n- 칸 사이 5 표시 = 두 칸이 1+4 또는 2+3\n- 칸 사이 17 표시 = 두 칸이 8+9\n\n[전략]\n- 합이 작거나 큰 경우 경우의 수가 적음\n- 여러 힌트가 만나는 지점 활용',
      // 정보 페이지
      'about': '앱 소개',
      'help': '도움말',
      'privacyPolicy': '개인정보처리방침',
      'termsOfService': '이용약관',
      'info': '정보',
      'aboutTitle': '게임 앱 소개',
      'aboutContent': '다양한 게임을 즐길 수 있는 무료 게임 모음 앱입니다.\n\n[바둑]\n약 4,000년 역사의 전략 보드게임. 흑과 백이 번갈아 돌을 놓아 더 많은 영역을 차지하는 것이 목표입니다.\n- AI 대국, 2인 대국, 사활 문제\n\n[장기]\n한국의 전통 전략 보드게임. 각 16개의 기물을 움직여 상대편의 왕(장)을 잡는 것이 목표입니다.\n- AI 대국, 2인 대국\n\n[카드게임]\n- 마이티: 5인용 트릭테이킹 게임. 여당과 야당으로 나뉘어 점수를 겨룹니다.\n- 하트: 하트 카드와 스페이드Q를 피하며 최저 점수를 노리는 게임.\n- 훌라: 같은 숫자나 연속된 숫자 조합을 만들어 먼저 패를 버리면 승리.\n- 원카드: UNO와 유사한 게임. 같은 숫자나 무늬의 카드를 내며 먼저 패를 없애면 승리.\n- 하이로우: 다음 카드가 높을지 낮을지 맞추는 게임.\n- 세븐포커: 7장의 카드로 족보를 만들어 겨루는 포커 게임.\n\n[보드게임]\n- 오목: 먼저 5개를 연속으로 놓으면 승리.\n- 오델로: 상대 돌을 뒤집어 더 많은 돌을 확보하는 게임.\n- 테트리스: 떨어지는 블록을 쌓아 줄을 완성하면 사라지는 퍼즐 게임.\n- 지뢰찾기: 숫자 힌트로 지뢰 위치를 추리하는 게임.\n- 솔리테어: 카드를 규칙에 맞게 정리하는 1인용 카드 게임.\n- 미로: 출구를 찾아 미로를 탈출하는 게임.\n- 버블: 같은 색 버블 3개 이상을 맞춰 터뜨리는 게임.\n- 두더지 잡기: 구멍에서 올라오는 두더지를 빠르게 잡는 게임.\n- 숫자야구: 3자리 숫자를 추리하는 논리 게임.\n\n[스도쿠]\n9x9 칸에 1~9 숫자를 중복 없이 채우는 논리 퍼즐.\n- 클래식: 기본 스도쿠. 가로, 세로, 3x3 박스에 같은 숫자 금지.\n- 사무라이: 5개의 스도쿠가 겹쳐진 대형 퍼즐.\n- 킬러: 점선 영역 내 숫자 합이 주어진 숫자와 일치해야 함.\n- 숫자합: 인접한 칸의 합이 힌트로 주어지는 변형.\n\n[전통게임]\n- 윷놀이: 윷을 던져 도/개/걸/윷/모에 따라 말을 이동시켜 먼저 나오면 승리.\n\n모든 게임은 오프라인에서 무료로 즐길 수 있습니다.',
      'helpTitle': '게임 방법',
      'helpRules': '기본 규칙',
      'helpRulesContent': '• 흑이 먼저 시작합니다\n• 빈 교차점에 돌을 놓습니다\n• 상대 돌을 완전히 둘러싸면 잡을 수 있습니다\n• 더 많은 영역을 차지한 쪽이 승리합니다\n• 백은 6.5점의 덤을 받습니다',
      'helpCapture': '돌 잡기',
      'helpCaptureContent': '돌의 활로(빈 인접점)가 모두 막히면 잡힙니다. 연결된 돌은 하나의 그룹으로 취급됩니다.',
      'helpKo': '패 규칙',
      'helpKoContent': '직전 상태와 동일한 국면을 만드는 착수는 금지됩니다.',
      'helpTerritory': '영역 계산',
      'helpTerritoryContent': '게임 종료 시 자신의 돌로 둘러싼 빈 점이 영역이 됩니다. 영역 + 잡은 돌 수로 승부를 결정합니다.',
      'helpContent': '게임 방법\n\n기본 규칙\n• 흑이 먼저 시작합니다\n• 빈 교차점에 돌을 놓습니다\n• 상대 돌을 완전히 둘러싸면 잡을 수 있습니다\n• 더 많은 영역을 차지한 쪽이 승리합니다\n• 백은 6.5점의 덤을 받습니다\n\n돌 잡기\n돌의 활로(빈 인접점)가 모두 막히면 잡힙니다. 연결된 돌은 하나의 그룹으로 취급됩니다.\n\n패 규칙\n직전 상태와 동일한 국면을 만드는 착수는 금지됩니다.\n\n영역 계산\n게임 종료 시 자신의 돌로 둘러싼 빈 점이 영역이 됩니다. 영역 + 잡은 돌 수로 승부를 결정합니다.',
      'privacyPolicyTitle': '개인정보처리방침',
      'privacyPolicyContent': '1. 수집하는 개인정보\n이 앱은 개인정보를 수집하지 않습니다. 모든 게임 데이터는 사용자의 기기에만 저장됩니다.\n\n2. 데이터 저장\n게임 진행 상황과 설정은 로컬 저장소에만 저장되며, 외부 서버로 전송되지 않습니다.\n\n3. 광고\n이 앱은 Google AdSense를 통해 광고를 표시할 수 있습니다. 광고 제공업체는 자체 개인정보처리방침에 따라 데이터를 수집할 수 있습니다.\n\n4. 문의\n개인정보 관련 문의사항이 있으시면 앱 개발자에게 연락해 주세요.',
      'termsOfServiceTitle': '이용약관',
      'termsOfServiceContent': '1. 서비스 이용\n이 앱은 무료로 제공되며, 누구나 자유롭게 사용할 수 있습니다.\n\n2. 면책조항\n이 앱은 "있는 그대로" 제공됩니다. 개발자는 앱 사용으로 인한 어떠한 손해에 대해서도 책임지지 않습니다.\n\n3. 지적재산권\n이 앱의 모든 콘텐츠와 코드는 저작권법의 보호를 받습니다.\n\n4. 약관 변경\n이 약관은 사전 통지 없이 변경될 수 있습니다.\n\n5. 문의\n서비스 관련 문의사항이 있으시면 앱 개발자에게 연락해 주세요.',
      'version': '버전',
      'developer': '개발자',
      'contact': '문의',
      // 유튜브 관련
      'watchYoutube': '유튜브로 배우기',
      'selectProblemType': '배우고 싶은 유형을 선택하세요',
      'youtubeBasics': '바둑 입문',
      'youtubeCapture': '돌 잡기 기초',
      'youtubeLifeDeath': '사활 기초',
      'youtube3Space': '3궁도 (직삼궁/곡삼궁)',
      'youtube4Space': '4궁도 (직사궁/곡사궁/꽃사궁)',
      'youtube5Space': '5궁도 (오궁도화)',
      'youtubeCorner': '귀 사활 (귀곡사)',
      'youtubeThrowIn': '환격 (던져넣기)',
      'youtubeCapturingRace': '수상전 (활로싸움)',
    },
    GameLanguage.english: {
      'appTitle': 'Go',
      'vsAI': 'AI Game',
      'vsAIDesc': 'Play vs AI',
      'twoPlayer': 'Go - 2 Players',
      'twoPlayerModeDesc': 'Local play',
      'playAsBlack': 'Play as Black',
      'playAsWhite': 'Play as White',
      'twoPlayerMode': '2 Players',
      'boardSize': 'Board Size',
      'newGame': 'New Game',
      'pass': 'Pass',
      'black': 'Black',
      'white': 'White',
      'blackTurn': "Black's turn",
      'whiteTurn': "White's turn",
      'yourTurn': 'Your turn',
      'aiThinking': 'AI thinking...',
      'aiThinkingTime': 'AI thinking... ({time}s)',
      'aiPass': 'AI passed',
      'blackPass': 'Black passed',
      'whitePass': 'White passed',
      'congratsWin': 'Congratulations! You win!',
      'aiWin': 'AI wins!',
      'blackWin': 'Black wins!',
      'whiteWin': 'White wins!',
      'draw': 'Draw!',
      'me': 'Me',
      'ai': 'AI',
      'captures': 'Captures',
      'koViolation': 'Ko rule violation!',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'expert': 'Expert',
      'language': 'Language',
      'aiLevel': 'AI Level',
      'aiEasy': 'Easy',
      'aiNormal': 'Normal',
      'aiHard': 'Hard',
      'aiExpert': 'Expert',
      'hint': 'Hint',
      'hintOn': 'Hint ON',
      'hintOff': 'Hint OFF',
      'hintMessage': 'Recommended move shown',
      'noHint': 'No suggestion available',
      'enableHintTitle': 'Hint',
      'enableHintMessage': 'Do you want to enable hints?',
      'hintEnabled': 'Hints enabled!',
      'cancel': 'Cancel',
      'confirm': 'OK',
      'close': 'Close',
      'newGameConfirm': 'Do you want to start a new game?',
      'endGameConfirm': 'End current game and start a new one?',
      'continue': 'Continue',
      'save': 'Save',
      'load': 'Load',
      'restart': 'Restart',
      'selectGame': 'Select Game',
      'viewResult': 'View Result',
      'initializing': 'Initializing...',
      // Poker betting
      'betPing': 'Ante',
      'betCall': 'Call',
      'betDdadang': 'Raise',
      'betDie': 'Fold',
      'betCheck': 'Check',
      'betQuarter': 'Quarter',
      'betHalf': 'Half',
      'betFull': 'Full',
      // Hula game
      'register': 'Meld',
      'discard': 'Discard',
      'stop': 'Stop',
      // Table headers
      'player': 'Player',
      'thisGame': 'This Game',
      'winLoss': 'W/L',
      'cumulative': 'Total',
      'hand': 'Hand',
      'score': 'Score',
      // Sudoku
      'quick': 'Quick',
      'memo': 'Memo',
      'allMemo': 'All Memo',
      'selectCellFirst': 'Select a cell first',
      'cellAlreadyFilled': 'Cell already filled',
      'noSavedGame': 'No saved game',
      'gameSaved': 'Game saved',
      'gameLoaded': 'Game loaded',
      'savedGameInfo': 'Saved Game',
      'saveDate': 'Save Time',
      'moveCount': 'Moves',
      'selectDifficulty': 'Select Difficulty',
      'selectColor': 'Select Color',
      'firstMove': 'First',
      'secondMove': 'Second',
      'startGame': 'Start Game',
      'aiEasyDesc': 'Recommended for beginners',
      'aiNormalDesc': 'Uses basic strategies',
      'aiHardDesc': 'Advanced strategies and joseki',
      'aiExpertDesc': 'Strongest AI level',
      // Life and Death Learning
      'lifeDeathProblems': 'Life & Death',
      'lifeDeathProblemsDesc': 'Solve problems',
      'problemList': 'Problem List',
      'problem': 'Problem',
      'problemType': 'Type',
      'progress': 'Progress',
      'video': 'Video',
      'solveProblem': 'Solve Problems',
      'difficulty': 'Difficulty',
      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',
      'blackToPlay': 'Black to play',
      'whiteToPlay': 'White to play',
      'killWhite': 'Kill White',
      'killBlack': 'Kill Black',
      'cutWhite': 'Cut White',
      'cutBlack': 'Cut Black',
      'liveWithBlack': 'Live with Black',
      'liveWithWhite': 'Live with White',
      'correct': 'Correct!',
      'incorrect': 'Incorrect. Try again.',
      'showAnswer': 'Show Answer',
      'nextProblem': 'Next',
      'prevProblem': 'Previous',
      'retry': 'Retry',
      'problemSolved': 'Problem Solved!',
      'solvedCount': 'Solved',
      'totalProblems': 'Total',
      'backToList': 'Back to List',
      // Card game
      'baduk': 'Go (Baduk)',
      'cardGame': 'Card Game',
      'janggi': 'Janggi',
      'boardGame': 'Board Game',
      'sudoku': 'Sudoku',
      'yutnori': 'Yut Nori',
      // Game help
      'help_baduk': '[How to Play]\nBlack and white take turns placing stones on empty intersections.\nSurround opponent stones to capture them.\nThe player with more territory at the end wins.\n\n[Basic Rules]\n- Black plays first\n- White receives 6.5 points komi\n- Ko: Cannot recreate previous board position\n\n[Game Modes]\n- AI Match: Play against AI\n- 2-Player: Play with a friend\n- Life & Death: Improve skills with problems',
      'help_janggi': '[How to Play]\nEach player moves 16 pieces to capture the opponent\'s king (Jang).\n\n[Piece Movement]\n- Jang (King): Moves one space within palace\n- Cha (Chariot): Moves any distance straight\n- Po (Cannon): Jumps over one piece to move/attack (cannot jump over another cannon)\n- Ma (Horse): Moves in L-shape\n- Sang (Elephant): Moves one straight + two diagonal steps\n- Sa (Guard): Moves one space diagonally in palace\n- Jol/Byung (Pawn): Moves forward or sideways\n\n[Capturing]\n- Capture opponent pieces by moving to their position\n- Cannot move if pieces block the path (except Cannon)\n\n[Game Modes]\n- AI Match: Play against AI\n- 2-Player: Play with a friend',
      'help_cardGame': '[Mighty]\n5-player trick-taking game. Declare points and win as the ruling party.\nRuling party (declarer + partner) vs Opposition (3 others).\n\n[Hearts]\nAvoid hearts and Queen of Spades for lowest score.\n1 point per heart, 13 points for Queen of Spades.\n\n[Hula]\nMake sets of same numbers or sequences. First to discard all cards wins.\n\n[OneCard]\nSimilar to UNO. Match numbers or suits. First to empty hand wins.\n\n[HiLo]\nGuess if the next card is higher or lower than current card.\n\n[Seven Poker]\nCreate poker hands with 7 cards to compete.',
      'help_boardGame': '[Gomoku]\nPlace stones alternately. First to get 5 in a row wins.\nHorizontal, vertical, and diagonal lines all count.\n\n[Othello]\nFlip opponent pieces by sandwiching them with your pieces.\nPlayer with more pieces at the end wins.\n\n[Tetris]\nStack falling blocks to complete horizontal lines.\nGame over when blocks reach the top.\n\n[Minesweeper]\nUse number hints to find mines.\nOpen all non-mine cells to win.\n\n[Solitaire]\nArrange cards by rules to build 4 foundation piles.\n\n[Maze]\nFind the exit to escape the maze.\n\n[Bubble]\nMatch 3 or more same-colored bubbles to pop them.',
      'help_sudoku': '[How to Play]\nFill a 9x9 grid with numbers 1-9 without repetition.\nNo duplicates in any row, column, or 3x3 box.\n\n[Game Modes]\n- Classic: Standard sudoku\n- Samurai: 5 overlapping sudoku grids\n- Killer: Numbers in cages must sum to given total\n- Sum: Adjacent cell sums given as hints\n\n[Difficulty]\nEasy / Medium / Hard / Expert',
      'help_yutnori': '[How to Play]\nThrow yut sticks and move pieces based on results.\nFirst to bring all pieces to the finish wins.\n\n[Yut Results]\n- Do: Move 1 space\n- Gae: Move 2 spaces\n- Geol: Move 3 spaces\n- Yut: Move 4 spaces + throw again\n- Mo: Move 5 spaces + throw again\n\n[Special Rules]\n- Capture opponent piece = throw again\n- Stack your pieces on same spot to move together\n- Use shortcuts to reach finish faster',
      // Sub-game names
      'mighty': 'Mighty',
      'mightyDesc': '5-Player Trump',
      'hearts': 'Hearts',
      'heartsDesc': 'Pass Game',
      'hula': 'Hula',
      'hulaDesc': '3-Card Game',
      'onecard': 'One Card',
      'onecardDesc': '4-Player Battle',
      'highlow': 'Hi-Lo',
      'highlowDesc': 'Number Guessing',
      'sevenpoker': 'Seven Poker',
      'sevenpokerDesc': 'Poker Game',
      'gomoku': 'Gomoku',
      'othello': 'Othello',
      'tetris': 'Tetris',
      'minesweeper': 'Minesweeper',
      'solitaire': 'Solitaire',
      'maze': 'Maze',
      'bubble': 'Bubble',
      'whackamole': 'Whack-a-Mole',
      'baseball': 'Number Baseball',
      'sudoku_classic': 'Classic',
      'sudoku_samurai': 'Samurai',
      'sudoku_killer': 'Killer',
      'sudoku_sum': 'Sum',
      // Sub-game help
      'help_mighty': '[How to Play]\nA 5-player trick-taking game.\nDeclarer and partner form the ruling party against 3 opposition players.\n\n[Rules]\n- Bidding: Declare minimum points to win\n- Declarer picks partner by calling a card\n- Win tricks with highest card of led suit or trump\n- Ruling party must reach declared points to win\n\n[Trick Rules]\n- Must follow the led suit\n- If you don\'t have the suit, you may play any card\n- Trump suit beats all other suits\n\n[Special Cards]\n- Mighty: Strongest card (Spade A, or Diamond A if trump is Spade)\n- Joker: Second strongest card\n- Joker Call: Forces Joker to be played (default: Club 3)',
      'help_hearts': '[How to Play]\nAvoid collecting hearts and the Queen of Spades.\n\n[Scoring]\n- Each heart: 1 point\n- Queen of Spades: 13 points\n- Lowest total score wins\n\n[Round Rules]\n- Must follow the led suit\n- If you don\'t have the suit, you may play any card\n\n[Special Rules]\n- Cannot lead with point cards in the first round\n- Cannot lead with hearts until hearts are broken\n- Shooting the Moon: Collect all hearts + Queen of Spades to give 26 points to others',
      'help_hula': '[How to Play]\nCreate sets of same numbers or sequences to discard cards.\nFirst player to empty their hand wins.\n\n[Card Combinations]\n- Triple: 3 cards of same number\n- Sequence: 3+ consecutive cards of same suit\n- Seven: Can be registered alone\n\n[Additional Rules]\n- After registering cards, you can add cards to existing combinations\n- You can call "Stop" to end the game\n\n[Scoring]\n- Number cards (2-10): Face value\n- A: 1, J: 10, Q: 11, K: 12\n- 2x penalty if not registered or holding a 7',
      'help_onecard': '[How to Play]\nSimilar to UNO. Match the top card by number or suit.\nFirst to discard all cards wins.\n\n[Rules]\n- Must call "One Card" within 5 sec when 1 card left (penalty: draw 1)\n\n[Attack Cards]\n- 2: +2 cards\n- A: +3 cards (♠A: +5)\n- Joker: +5 cards (Color Joker: +7)\n- Defense: 2→2/same suit A/Joker, A→A/Joker, Joker→Joker only\n\n[Special Cards]\n- 7: Change suit\n- J: Skip next turn\n- Q: Reverse (skip in 2P)\n- K: Skip next 2 turns',
      'help_sevenpoker': '[How to Play]\nCreate the best poker hand using 7 cards.\n\n[Game Flow]\n1. Deal 3 cards (2 hidden + 1 face up)\n2. Highest face-up card is boss\n3. Deal 1 card per round with 4 betting rounds\n4. 7th card is hidden\n5. Best 5 of 7 cards wins\n\n[Betting]\n- Bing: Open bet / Check: Pass (boss only)\n- Call: Match bet / Ddadang: Double bet\n- Quarter/Half/Full: 25%/50%/100% of pot\n- Die: Fold\n\n[Hand Rankings]\n- Royal Straight Flush: 10-J-Q-K-A same suit\n- Straight Flush: 5 consecutive same suit\n- Four of a Kind: 4 same rank\n- Full House: Triple + Pair\n- Flush: 5 same suit\n- Straight: 5 consecutive\n- Three of a Kind: 3 same rank\n- Two Pair: 2 pairs\n- One Pair: 2 same rank\n- High Card: No hand',
      'help_highlow': '[How to Play]\n7-card poker with Hi (poker hand) and Lo (low hand) pots.\nPot is split between Hi and Lo winners.\n\n[Game Flow]\n1. Deal 3 cards, select 1 to reveal\n2. Deal cards one at a time with betting rounds\n3. 7th card is hidden\n4. Choose Hi/Lo/Swing at the end\n5. Hi and Lo winners split the pot\n\n[Hi/Lo/Swing]\n- Hi: Compete with poker hand\n- Lo: Compete with lowest hand\n- Swing: Compete for both (win both to take all)\n\n[Lo Rules]\n- No pairs, straights, or flushes allowed\n- A-2-3-4-6 is best Lo (A-2-3-4-5 is a straight)\n- Lower is better\n\n[Betting]\n- Bing/Check: Boss only (open/pass)\n- Call/Ddadang: Match/Double\n- Quarter/Half/Full: 25%/50%/100% of pot\n\n[Bonus]\n- Four of a Kind+: Collect bonus from all players\n- RSF: 500, BSF: 300, SF: 200, 4Kind: 100',
      'help_gomoku': '[How to Play]\nBlack and white take turns placing stones.\nFirst to get 5 stones in a row wins.\n\n[Rules]\n- Horizontal, vertical, and diagonal all count\n- Cannot place on occupied spots\n\n[Strategy]\nBlock opponent while building your own line!',
      'help_othello': '[How to Play]\nFlip opponent pieces by sandwiching them between your pieces.\nPlayer with more pieces at the end wins.\n\n[Rules]\n- Must flip at least one piece each turn\n- Pass if no valid moves\n\n[Strategy]\nCorners are valuable - they cannot be flipped!',
      'help_tetris': '[How to Play]\nRotate and place falling blocks to complete horizontal lines.\nCompleted lines disappear for points.\n\n[Controls]\n- Move: Left/Right arrows\n- Rotate: Up arrow\n- Drop: Down arrow\n\n[Tip]\nKeep the stack low and flat!',
      'help_minesweeper': '[How to Play]\nFind all mines without clicking on them.\nNumbers show how many adjacent mines there are.\n\n[Controls]\n- Click: Open cell\n- Long press: Flag mine\n\n[Tip]\nUse number patterns to deduce mine locations!',
      'help_solitaire': '[How to Play]\nArrange cards to build 4 foundation piles by suit (A to K).\n\n[Rules]\n- Tableau: Stack cards in descending order, alternating colors\n- Foundation: Build up by suit from Ace\n\n[Tip]\nReveal face-down cards as priority!',
      'help_maze': '[How to Play]\nFind the path from start to exit.\n\n[Controls]\n- Swipe or use arrows to move\n- Find the shortest path for best score\n\n[Tip]\nFollow one wall to eventually find the exit!',
      'help_bubble': '[How to Play]\nShoot bubbles to match 3 or more of the same color.\nMatched bubbles pop and disappear.\n\n[Rules]\n- Aim and shoot to attach bubbles\n- Clear all bubbles to win\n\n[Tip]\nAim for clusters and use bounces off walls!',
      'help_whackamole': '[How to Play]\nQuickly tap moles as they pop up from holes.\n\n[Controls]\n- Tap/Click: Hit the mole\n\n[Rules]\n- Hit moles as fast as possible\n- Get as many as you can before time runs out\n- Avoid hitting bombs\n\n[Scoring]\n- Regular mole: +10 points\n- Golden mole: +50 points\n- Bomb: -30 points\n\n[Levels]\nMoles hide faster as levels increase!',
      'help_baseball': '[How to Play]\nGuess the secret 3-digit number.\n\n[Terms]\n- Strike (S): Correct digit in correct position\n- Ball (B): Correct digit in wrong position\n- Out: Digit not in the number\n\n[Example]\nIf answer is 123:\n- Input 123 -> 3S (Correct!)\n- Input 132 -> 1S 2B\n- Input 456 -> 0S 0B (Out)\n\n[Rules]\n- Each digit is unique (0-9)\n- Guess within limited attempts\n\n[Strategy]\nStart with 0, 1, 2 to narrow down digits!',
      'help_sudoku_classic': '[How to Play]\nFill a 9x9 grid with numbers 1-9.\n\n[Rules]\n- No duplicate numbers in any row\n- No duplicate numbers in any column\n- No duplicate numbers in any 3x3 box\n\n[Tip]\nStart with rows/columns that have the most numbers!',
      'help_sudoku_samurai': '[How to Play]\n5 overlapping sudoku grids in one large puzzle.\n\n[Rules]\n- Each 9x9 grid follows standard sudoku rules\n- Overlapping regions must satisfy both grids\n\n[Tip]\nUse overlapping areas to find cross-references!',
      'help_sudoku_killer': '[How to Play]\nSudoku with cages. Numbers in each cage must sum to the given total.\n\n[Rules]\n- Standard sudoku rules apply\n- Cage numbers cannot repeat\n- Cage sum must equal the clue\n\n[Tip]\nSmall cages with high sums reveal limited possibilities!',
      'help_sudoku_sum': '[How to Play]\nSudoku with adjacent cell sum hints.\n\n[Rules]\n- Standard sudoku rules apply\n- Numbers between cells show their sum\n\n[Tip]\nUse sums to narrow down possibilities!',
      // Info pages
      'about': 'About',
      'help': 'Help',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'info': 'Info',
      'aboutTitle': 'About This App',
      'aboutContent': 'A free game collection app with various games.\n\n[Go (Baduk)]\nA strategic board game with 4,000 years of history. Players take turns placing stones to control more territory.\n- AI match, 2-player, Life & Death problems\n\n[Janggi]\nKorean traditional strategy board game. Move 16 pieces to capture the opponent\'s king.\n- AI match, 2-player mode\n\n[Card Games]\n- Mighty: 5-player trick-taking game with government vs opposition teams.\n- Hearts: Avoid hearts and Queen of Spades to get the lowest score.\n- Hula: Make sets of same numbers or sequences to discard all cards first.\n- OneCard: Similar to UNO. Match numbers or suits to empty your hand first.\n- HiLo: Guess if the next card will be higher or lower.\n- Seven Poker: Create poker hands with 7 cards.\n\n[Board Games]\n- Gomoku: First to place 5 stones in a row wins.\n- Othello: Flip opponent\'s pieces to control the board.\n- Tetris: Stack falling blocks to complete and clear lines.\n- Minesweeper: Use number hints to find hidden mines.\n- Solitaire: Single-player card game to arrange cards by rules.\n- Maze: Find the exit and escape the maze.\n- Bubble: Match 3 or more same-colored bubbles to pop them.\n- Whack-a-Mole: Quickly hit moles as they pop up from holes.\n- Number Baseball: Logic game to guess a 3-digit number.\n\n[Sudoku]\nFill a 9x9 grid with numbers 1-9 without repetition.\n- Classic: Standard sudoku. No duplicates in rows, columns, or 3x3 boxes.\n- Samurai: 5 overlapping sudoku grids in one large puzzle.\n- Killer: Numbers in dotted cages must sum to the given total.\n- Sum: Adjacent cells have sum hints as clues.\n\n[Traditional Games]\n- Yut Nori: Throw yut sticks and move pieces based on results (Do/Gae/Geol/Yut/Mo).\n\nAll games are free to play offline.',
      'helpTitle': 'How to Play',
      'helpRules': 'Basic Rules',
      'helpRulesContent': '• Black plays first\n• Place stones on empty intersections\n• Surround opponent stones to capture them\n• Control more territory to win\n• White receives 6.5 points komi',
      'helpCapture': 'Capturing Stones',
      'helpCaptureContent': 'Stones are captured when all their liberties (empty adjacent points) are filled. Connected stones form a group.',
      'helpKo': 'Ko Rule',
      'helpKoContent': 'You cannot make a move that recreates the previous board position.',
      'helpTerritory': 'Scoring',
      'helpTerritoryContent': 'At the end of the game, empty points surrounded by your stones are your territory. Score = Territory + Captured stones.',
      'helpContent': 'How to Play\n\nBasic Rules\n• Black plays first\n• Place stones on empty intersections\n• Surround opponent stones to capture them\n• Control more territory to win\n• White receives 6.5 points komi\n\nCapturing Stones\nStones are captured when all their liberties (empty adjacent points) are filled. Connected stones form a group.\n\nKo Rule\nYou cannot make a move that recreates the previous board position.\n\nScoring\nAt the end of the game, empty points surrounded by your stones are your territory. Score = Territory + Captured stones.',
      'privacyPolicyTitle': 'Privacy Policy',
      'privacyPolicyContent': '1. Information We Collect\nThis app does not collect personal information. All game data is stored only on your device.\n\n2. Data Storage\nGame progress and settings are stored locally and are not transmitted to external servers.\n\n3. Advertising\nThis app may display ads through Google AdSense. Ad providers may collect data according to their own privacy policies.\n\n4. Contact\nFor privacy-related inquiries, please contact the app developer.',
      'termsOfServiceTitle': 'Terms of Service',
      'termsOfServiceContent': '1. Use of Service\nThis app is provided free of charge and can be used by anyone.\n\n2. Disclaimer\nThis app is provided "as is". The developer is not responsible for any damages resulting from use of the app.\n\n3. Intellectual Property\nAll content and code of this app is protected by copyright law.\n\n4. Changes to Terms\nThese terms may be changed without prior notice.\n\n5. Contact\nFor service-related inquiries, please contact the app developer.',
      'version': 'Version',
      'developer': 'Developer',
      'contact': 'Contact',
      // YouTube
      'watchYoutube': 'Learn on YouTube',
      'selectProblemType': 'Select a topic to learn',
      'youtubeBasics': 'Go Basics',
      'youtubeCapture': 'Capturing Stones',
      'youtubeLifeDeath': 'Life & Death Basics',
      'youtube3Space': '3-Space (Straight/Bent Three)',
      'youtube4Space': '4-Space (Four in a Row)',
      'youtube5Space': '5-Space Eye',
      'youtubeCorner': 'Corner Life & Death',
      'youtubeThrowIn': 'Throw-in Technique',
      'youtubeCapturingRace': 'Capturing Race',
    },
    GameLanguage.japanese: {
      'appTitle': '囲碁',
      'vsAI': 'AI対局',
      'vsAIDesc': 'AIと対局',
      'twoPlayer': '囲碁 - 対人戦',
      'twoPlayerModeDesc': '二人で対局',
      'playAsBlack': '黒で対局',
      'playAsWhite': '白で対局',
      'twoPlayerMode': '対人戦',
      'boardSize': '盤面サイズ',
      'newGame': '新規対局',
      'pass': 'パス',
      'black': '黒',
      'white': '白',
      'blackTurn': '黒の番です',
      'whiteTurn': '白の番です',
      'yourTurn': 'あなたの番です',
      'aiThinking': 'AI思考中...',
      'aiThinkingTime': 'AI思考中... ({time}秒)',
      'aiPass': 'AIパス',
      'blackPass': '黒パス',
      'whitePass': '白パス',
      'congratsWin': 'おめでとう！勝利！',
      'aiWin': 'AI勝利！',
      'blackWin': '黒勝利！',
      'whiteWin': '白勝利！',
      'draw': '引き分け！',
      'me': '自分',
      'ai': 'AI',
      'captures': 'アゲハマ',
      'koViolation': 'コウ違反です！',
      'beginner': '入門',
      'intermediate': '中級',
      'expert': '上級',
      'language': '言語',
      'aiLevel': 'AIレベル',
      'aiEasy': '簡単',
      'aiNormal': '普通',
      'aiHard': '難しい',
      'aiExpert': '最強',
      'hint': 'ヒント',
      'hintOn': 'ヒント ON',
      'hintOff': 'ヒント OFF',
      'hintMessage': 'おすすめの手を表示しました',
      'noHint': '提案できません',
      'enableHintTitle': 'ヒント',
      'enableHintMessage': 'ヒントを有効にしますか？',
      'hintEnabled': 'ヒントが有効になりました！',
      'cancel': 'キャンセル',
      'confirm': '確認',
      'close': '閉じる',
      'newGameConfirm': '新しいゲームを始めますか？',
      'endGameConfirm': '現在のゲームを終了して新しいゲームを始めますか？',
      'continue': '続きから',
      'save': '保存',
      'load': '読込',
      'restart': 'やり直し',
      'selectGame': 'ゲーム選択',
      'viewResult': '結果を見る',
      'initializing': '初期化中...',
      // ポーカーベッティング
      'betPing': 'ビン',
      'betCall': 'コール',
      'betDdadang': 'タダン',
      'betDie': 'ダイ',
      'betCheck': 'チェック',
      'betQuarter': 'クォーター',
      'betHalf': 'ハーフ',
      'betFull': 'フル',
      // フラゲーム
      'register': '登録',
      'discard': '捨てる',
      'stop': 'ストップ',
      // テーブルヘッダー
      'player': 'プレイヤー',
      'thisGame': '今回',
      'winLoss': '勝/敗',
      'cumulative': '累計',
      'hand': '手札',
      'score': 'スコア',
      // 数独
      'quick': 'クイック',
      'memo': 'メモ',
      'allMemo': '全メモ',
      'selectCellFirst': '先にセルを選択してください',
      'cellAlreadyFilled': '既に埋まっているセルです',
      'noSavedGame': '保存されたゲームがありません',
      'gameSaved': 'ゲームを保存しました',
      'gameLoaded': 'ゲームを読み込みました',
      'savedGameInfo': '保存されたゲーム',
      'saveDate': '保存時間',
      'moveCount': '手数',
      'selectDifficulty': '難易度を選択',
      'selectColor': '石の色を選択',
      'firstMove': '先手',
      'secondMove': '後手',
      'startGame': 'ゲーム開始',
      'aiEasyDesc': '初心者向け',
      'aiNormalDesc': '基本的な戦略を使用',
      'aiHardDesc': '高度な戦略と定石を使用',
      'aiExpertDesc': '最強レベルのAI',
      // 詰碁学習
      'lifeDeathProblems': '詰碁',
      'lifeDeathProblemsDesc': '問題を解く',
      'problemList': '問題一覧',
      'problem': '問題',
      'problemType': '種類',
      'progress': '進行',
      'video': '動画',
      'solveProblem': '問題を解く',
      'difficulty': '難易度',
      'beginner': '入門',
      'intermediate': '中級',
      'advanced': '上級',
      'blackToPlay': '黒先',
      'whiteToPlay': '白先',
      'killWhite': '白を取れ',
      'killBlack': '黒を取れ',
      'cutWhite': '白を切れ',
      'cutBlack': '黒を切れ',
      'liveWithBlack': '黒で生きよ',
      'liveWithWhite': '白で生きよ',
      'correct': '正解！',
      'incorrect': '不正解。もう一度。',
      'showAnswer': '答えを見る',
      'nextProblem': '次へ',
      'prevProblem': '前へ',
      'retry': 'やり直し',
      'problemSolved': '問題クリア！',
      'solvedCount': '正解数',
      'totalProblems': '全問題',
      'backToList': '一覧に戻る',
      // カードゲーム
      'baduk': '囲碁',
      'cardGame': 'カードゲーム',
      'janggi': '将棋',
      'boardGame': 'ボードゲーム',
      'sudoku': '数独',
      'yutnori': 'ユンノリ',
      // ゲームヘルプ
      'help_baduk': '[遊び方]\n黒と白が交互に空いている交点に石を置きます。\n相手の石を完全に囲むと取れます。\n終局時、より多くの領域を確保した方が勝ちです。\n\n[基本ルール]\n- 黒が先手です\n- 白には6.5目のコミがあります\n- コウ：直前と同じ局面を作る着手は禁止\n\n[ゲームモード]\n- AI対局：AIと対戦\n- 二人対局：友達と対戦\n- 詰碁問題：問題を解いて実力アップ',
      'help_janggi': '[遊び方]\n各プレイヤーは16個の駒を動かして相手の王（将）を取ります。\n\n[駒の動き]\n- 将：宮内で一マス移動\n- 車：直線で何マスでも移動\n- 包：他の駒を一つ飛び越えて移動/攻撃（包は飛び越えられない）\n- 馬：日の字型に移動\n- 象：直線一マス＋斜め二マス移動（用の字型）\n- 士：宮内で斜め一マス移動\n- 卒/兵：前または横に一マス移動\n\n[駒を取る]\n- 移動先に相手の駒があれば取ることができます\n- 移動経路に他の駒があると移動できません（包を除く）\n\n[ゲームモード]\n- AI対局：AIと対戦\n- 二人対局：友達と対戦',
      'help_cardGame': '[マイティ]\n5人用トリックテイキングゲーム。宣言した点数を獲得すれば勝利。\n与党（主公+パートナー）vs 野党（残り3人）。\n\n[ハーツ]\nハートとスペードQを避けて最低点を目指すゲーム。\nハート1枚1点、スペードQ13点。\n\n[フラ]\n同じ数字や連続した数字の組み合わせを作り、先に手札をなくせば勝ち。\n\n[ワンカード]\nUNOに似たゲーム。同じ数字か柄のカードを出して先に手札をなくす。\n\n[ハイロー]\n次のカードが今のカードより高いか低いかを当てるゲーム。\n\n[セブンポーカー]\n7枚のカードで役を作って勝負するポーカー。',
      'help_boardGame': '[五目並べ]\n黒と白が交互に石を置き、先に5つ並べれば勝ち。\n縦、横、斜めすべて有効。\n\n[オセロ]\n相手の石を自分の石で挟むとひっくり返せます。\n終局時、より多くの石を持つ方が勝ち。\n\n[テトリス]\n落ちてくるブロックを積み、横列を揃えて消すゲーム。\nブロックが一番上まで積まれるとゲームオーバー。\n\n[マインスイーパー]\n数字のヒントで地雷の位置を推理します。\n地雷以外のすべてのマスを開ければ勝ち。\n\n[ソリティア]\nルールに従ってカードを並べ、4つの基礎の山を完成させるゲーム。\n\n[迷路]\n出口を見つけて脱出するゲーム。\n\n[バブル]\n同じ色のバブルを3つ以上揃えて消すゲーム。',
      'help_sudoku': '[遊び方]\n9x9マスに1~9の数字を重複なく埋めるパズル。\n縦、横、3x3ボックスに同じ数字は入れません。\n\n[ゲームモード]\n- クラシック：基本の数独\n- サムライ：5つの数独が重なった大型パズル\n- キラー：点線内の数字の合計が指定された数になる\n- 数字合計：隣接するマスの合計がヒント\n\n[難易度]\n初級 / 中級 / 上級 / エキスパート',
      'help_yutnori': '[遊び方]\nユッを投げて結果に従って駒を動かします。\nすべての駒を先にゴールさせれば勝ち。\n\n[ユッの結果]\n- ド：1マス移動\n- ゲ：2マス移動\n- ゴル：3マス移動\n- ユッ：4マス移動＋もう一回投げる\n- モ：5マス移動＋もう一回投げる\n\n[特殊ルール]\n- 相手の駒を取るともう一回投げられる\n- 同じ位置の自分の駒は一緒に動かせる\n- 近道を使うとより早くゴールできる',
      // サブゲーム名
      'mighty': 'マイティ',
      'mightyDesc': '5人トランプ',
      'hearts': 'ハーツ',
      'heartsDesc': 'パスゲーム',
      'hula': 'フラ',
      'hulaDesc': '3枚カード',
      'onecard': 'ワンカード',
      'onecardDesc': '4人対戦',
      'highlow': 'ハイロー',
      'highlowDesc': '数字当て',
      'sevenpoker': 'セブンポーカー',
      'sevenpokerDesc': 'ポーカーゲーム',
      'gomoku': '五目並べ',
      'othello': 'オセロ',
      'tetris': 'テトリス',
      'minesweeper': 'マインスイーパー',
      'solitaire': 'ソリティア',
      'maze': '迷路',
      'bubble': 'バブル',
      'whackamole': 'モグラたたき',
      'baseball': 'ナンバーベースボール',
      'sudoku_classic': 'クラシック',
      'sudoku_samurai': 'サムライ',
      'sudoku_killer': 'キラー',
      'sudoku_sum': '数字合計',
      // サブゲームヘルプ
      'help_mighty': '[遊び方]\n5人用トリックテイキングゲーム。\n主公とパートナーが与党となり、野党3人と対戦します。\n\n[ルール]\n- ビディング：獲得する最低点数を宣言\n- 主公はカードを指定してパートナーを選ぶ\n- リードされたスートか切り札の最高カードで勝つ\n- 与党は宣言した点数以上を獲得すれば勝利\n\n[トリックルール]\n- リードされたスートを出さなければならない\n- そのスートがなければ他のスートを出せる\n- 切り札は他のスートより強い\n\n[特殊カード]\n- マイティ：最強のカード（スペードA、切り札がスペードならダイヤA）\n- ジョーカー：2番目に強いカード\n- ジョーカーコール：ジョーカーを強制的に出させるカード（デフォルト：クラブ3）',
      'help_hearts': '[遊び方]\nハートとスペードQを集めないようにするゲーム。\n\n[スコア]\n- ハート1枚：1点\n- スペードQ：13点\n- 合計点が最も低いプレイヤーが勝利\n\n[ラウンドルール]\n- リードされたスートを出さなければならない\n- そのスートがなければ他のスートを出せる\n\n[特殊ルール]\n- 最初のラウンドでは点数カードでリードできない\n- ハートがブレイクされる前はハートでリードできない\n- シュート・ザ・ムーン：ハート全部＋スペードQを集めると他プレイヤーに26点を与える',
      'help_hula': '[遊び方]\n同じ数字や連続した数字の組み合わせを作ってカードを捨てます。\n先に手札をなくした人が勝ち。\n\n[カード組み合わせ]\n- トリプル：同じ数字3枚\n- シーケンス：同じスート3枚以上の連番\n- 7：単独で登録可能\n\n[追加ルール]\n- カードを登録した後、既存の組み合わせにカードを追加できます\n- ストップを宣言してゲームを終了できます\n\n[得点]\n- 数字カード (2-10)：額面通り\n- A: 1点, J: 10点, Q: 11点, K: 12点\n- 未登録または7を持っていると2倍',
      'help_onecard': '[遊び方]\nUNOに似たゲーム。数字かスートを合わせてカードを出します。\n先に手札をなくした人が勝ち。\n\n[ルール]\n- 残り1枚で5秒以内に「ワンカード」を宣言（しないと1枚ペナルティ）\n\n[攻撃カード]\n- 2: +2枚\n- A: +3枚（♠Aは+5枚）\n- ジョーカー: +5枚（カラージョーカーは+7枚）\n- 防御: 2→2/同スートA/ジョーカー, A→A/ジョーカー, ジョーカー→ジョーカーのみ\n\n[特殊カード]\n- 7: スート変更\n- J: 次のターンスキップ\n- Q: 方向反転（2人時はスキップ）\n- K: 2ターンスキップ',
      'help_sevenpoker': '[遊び方]\n7枚のカードで最高のポーカーハンドを作ります。\n\n[ゲーム進行]\n1. 最初に3枚配布（2枚非公開＋1枚公開）\n2. 公開カードが一番高い人がボス\n3. 1枚ずつ公開しながら4回のベッティング\n4. 7枚目は非公開\n5. 7枚中5枚で最高役を作る\n\n[ベッティング]\n- ビン: 基本ベット / チェック: パス（ボスのみ）\n- コール: 同額 / タダン: 2倍\n- クォーター/ハーフ/フル: ポットの25%/50%/100%\n- ダイ: フォールド\n\n[役ランキング]\n- ロイヤルストレートフラッシュ: 同スート10-J-Q-K-A\n- ストレートフラッシュ: 同スート5枚連番\n- フォーカード: 同数字4枚\n- フルハウス: スリーカード＋ワンペア\n- フラッシュ: 同スート5枚\n- ストレート: 連番5枚\n- スリーカード: 同数字3枚\n- ツーペア: ペア2組\n- ワンペア: 同数字2枚\n- ハイカード: 役なし',
      'help_highlow': '[遊び方]\n7枚のカードでハイ（ポーカー役）とロー（最低手）を競うポーカーゲーム。\nポットはハイとロー勝者で分けます。\n\n[ゲーム進行]\n1. 3枚配布し1枚を選んで公開\n2. 1枚ずつ公開しながらベッティング\n3. 7枚目は非公開\n4. 最後にハイ/ロー/スイング選択\n5. ハイとロー勝者がポットを半分ずつ獲得\n\n[ハイ/ロー/スイング]\n- ハイ：高い役で勝負\n- ロー：最低手で勝負\n- スイング：両方参加（両方勝てば全額獲得）\n\n[ローのルール]\n- ペア、ストレート、フラッシュがないこと\n- A-2-3-4-6が最強ロー（A-2-3-4-5はストレート）\n- 低いほど強い\n\n[ベッティング]\n- ビン/チェック: ボスのみ（開始/パス）\n- コール/タダン: 同額/2倍\n- クォーター/ハーフ/フル: ポットの25%/50%/100%\n\n[ボーナス]\n- フォーカード以上：他プレイヤーからボーナス徴収\n- ロスフラ: 500, バクスフラ: 300, スフラ: 200, フォーカード: 100',
      'help_gomoku': '[遊び方]\n黒と白が交互に石を置きます。\n先に5つ並べた方が勝ち。\n\n[ルール]\n- 縦、横、斜めすべて有効\n- 既に石がある場所には置けない\n\n[戦略]\n相手を止めながら自分のラインを作ろう！',
      'help_othello': '[遊び方]\n相手の石を自分の石で挟むとひっくり返せます。\n終局時、より多くの石を持つ方が勝ち。\n\n[ルール]\n- 毎ターン最低1つ石をひっくり返す必要がある\n- 有効な手がない場合はパス\n\n[戦略]\n角は価値が高い - ひっくり返されない！',
      'help_tetris': '[遊び方]\n落ちてくるブロックを回転させて積み、横列を揃えます。\n揃った列は消えてポイントになります。\n\n[操作]\n- 移動：左右矢印\n- 回転：上矢印\n- ドロップ：下矢印\n\n[コツ]\n低く平らに積もう！',
      'help_minesweeper': '[遊び方]\n地雷をクリックせずにすべて見つけるゲーム。\n数字は隣接する地雷の数を示します。\n\n[操作]\n- クリック：マスを開く\n- 長押し：地雷にフラグを立てる\n\n[コツ]\n数字のパターンで地雷の位置を推理しよう！',
      'help_solitaire': '[遊び方]\nカードを並べて4つの基礎の山（AからK）を作ります。\n\n[ルール]\n- 場札：色を交互に降順で積む\n- 基礎：スートごとにAから昇順で積む\n\n[コツ]\n裏返しのカードを優先的に表にしよう！',
      'help_maze': '[遊び方]\nスタートから出口までの道を見つけます。\n\n[操作]\n- スワイプか矢印キーで移動\n- 最短経路で最高スコア\n\n[コツ]\n壁に沿って進めば必ず出口に辿り着く！',
      'help_bubble': '[遊び方]\nバブルを発射して同じ色を3つ以上揃えます。\n揃ったバブルは弾けて消えます。\n\n[ルール]\n- 狙いを定めてバブルを発射\n- すべてのバブルを消せばクリア\n\n[コツ]\nまとまりを狙い、壁で跳ね返そう！',
      'help_whackamole': '[遊び方]\n穴から出てくるモグラを素早く叩くゲームです。\n\n[操作]\n- タップ/クリック：モグラを叩く\n\n[ルール]\n- モグラが出たら素早くタップ\n- 制限時間内にできるだけ多く叩く\n- 爆弾を叩くと減点\n\n[得点]\n- 通常モグラ：+10点\n- 金モグラ：+50点\n- 爆弾：-30点\n\n[レベル]\nレベルが上がるとモグラがより早く隠れる！',
      'help_baseball': '[遊び方]\n相手が決めた3桁の数字を推理するゲームです。\n\n[用語]\n- ストライク(S)：数字と位置が両方一致\n- ボール(B)：数字はあるが位置が違う\n- アウト：数字がない\n\n[例]\n正解が123の場合：\n- 123入力 → 3S（正解！）\n- 132入力 → 1S 2B\n- 456入力 → 0S 0B（アウト）\n\n[ルール]\n- 各桁の数字は重複不可（0~9）\n- 制限回数内に当てる\n\n[戦略]\n最初に0、1、2で始めて数字の範囲を絞ろう！',
      'help_sudoku_classic': '[遊び方]\n9x9マスに1~9の数字を埋めます。\n\n[ルール]\n- 横一列に同じ数字は入れない\n- 縦一列に同じ数字は入れない\n- 3x3ボックスに同じ数字は入れない\n\n[コツ]\n数字が多い行や列から始めよう！',
      'help_sudoku_samurai': '[遊び方]\n5つの数独が重なった大型パズル。\n\n[ルール]\n- 各9x9グリッドは標準の数独ルールに従う\n- 重なる部分は両方のグリッドを満たす必要がある\n\n[コツ]\n重なる部分を使って相互参照しよう！',
      'help_sudoku_killer': '[遊び方]\nケージ付きの数独。各ケージの数字の合計が指定された数になる必要があります。\n\n[ルール]\n- 標準の数独ルールが適用\n- ケージ内の数字は重複できない\n- ケージの合計は手がかりと一致する必要がある\n\n[コツ]\n合計が高い小さなケージは可能性が限られる！',
      'help_sudoku_sum': '[遊び方]\n隣接するマスの合計がヒントとして与えられる数独。\n\n[ルール]\n- 標準の数独ルールが適用\n- マスの間の数字はその合計を示す\n\n[コツ]\n合計を使って可能性を絞ろう！',
      // 情報ページ
      'about': 'アプリについて',
      'help': 'ヘルプ',
      'privacyPolicy': 'プライバシーポリシー',
      'termsOfService': '利用規約',
      'info': '情報',
      'aboutTitle': 'アプリ紹介',
      'aboutContent': '様々なゲームを楽しめる無料ゲームコレクションアプリです。\n\n[囲碁]\n約4,000年の歴史を持つ戦略ボードゲーム。黒と白が交互に石を置き、より多くの領域を確保します。\n- AI対局、二人対局、詰碁問題\n\n[将棋]\n韓国の伝統的な戦略ボードゲーム。16個の駒を動かして相手の王を取ります。\n- AI対局、二人対局\n\n[カードゲーム]\n- マイティ: 5人用トリックテイキングゲーム。与党と野党に分かれて得点を競います。\n- ハーツ: ハートとスペードQを避けて最低点を目指すゲーム。\n- フラ: 同じ数字や連続した数字の組み合わせを作り、先に手札をなくせば勝ち。\n- ワンカード: UNOに似たゲーム。同じ数字か柄のカードを出して先に手札をなくす。\n- ハイロー: 次のカードが高いか低いかを当てるゲーム。\n- セブンポーカー: 7枚のカードで役を作って勝負するポーカー。\n\n[ボードゲーム]\n- 五目並べ: 先に5つ並べれば勝ち。\n- オセロ: 相手の石をひっくり返して多くの石を確保するゲーム。\n- テトリス: 落ちてくるブロックを積み、列を揃えて消すパズルゲーム。\n- マインスイーパー: 数字のヒントで地雷の位置を推理するゲーム。\n- ソリティア: ルールに従ってカードを並べる一人用カードゲーム。\n- 迷路: 出口を見つけて脱出するゲーム。\n- バブル: 同じ色のバブルを3つ以上揃えて消すゲーム。\n- モグラたたき: 穴から出てくるモグラを素早く叩くゲーム。\n- ナンバーベースボール: 3桁の数字を推理するロジックゲーム。\n\n[数独]\n9x9マスに1~9の数字を重複なく埋めるパズル。\n- クラシック: 基本の数独。縦、横、3x3ボックスに同じ数字は入れません。\n- サムライ: 5つの数独が重なった大型パズル。\n- キラー: 点線の領域内の数字の合計が指定された数になる必要があります。\n- 数字合計: 隣接するマスの合計がヒントとして与えられます。\n\n[伝統ゲーム]\n- ユンノリ: ユッを投げてド/ゲ/ゴル/ユッ/モに従って駒を動かし、先に出れば勝ち。\n\nすべてのゲームはオフラインで無料でプレイできます。',
      'helpTitle': '遊び方',
      'helpRules': '基本ルール',
      'helpRulesContent': '• 黒が先手です\n• 空いている交点に石を置きます\n• 相手の石を完全に囲むと取れます\n• より多くの領域を確保した方が勝ちです\n• 白には6.5目のコミがあります',
      'helpCapture': '石を取る',
      'helpCaptureContent': '石の呼吸点（隣接する空点）がすべて塞がれると取られます。連結した石は一つのグループとして扱われます。',
      'helpKo': 'コウ',
      'helpKoContent': '直前と同じ局面を作る着手は禁止されています。',
      'helpTerritory': '地の計算',
      'helpTerritoryContent': '終局時、自分の石で囲んだ空点が地になります。地＋取った石数で勝敗を決めます。',
      'helpContent': '遊び方\n\n基本ルール\n• 黒が先手です\n• 空いている交点に石を置きます\n• 相手の石を完全に囲むと取れます\n• より多くの領域を確保した方が勝ちです\n• 白には6.5目のコミがあります\n\n石を取る\n石の呼吸点（隣接する空点）がすべて塞がれると取られます。連結した石は一つのグループとして扱われます。\n\nコウ\n直前と同じ局面を作る着手は禁止されています。\n\n地の計算\n終局時、自分の石で囲んだ空点が地になります。地＋取った石数で勝敗を決めます。',
      'privacyPolicyTitle': 'プライバシーポリシー',
      'privacyPolicyContent': '1. 収集する個人情報\nこのアプリは個人情報を収集しません。すべてのゲームデータはユーザーのデバイスにのみ保存されます。\n\n2. データ保存\nゲームの進行状況と設定はローカルストレージにのみ保存され、外部サーバーには送信されません。\n\n3. 広告\nこのアプリはGoogle AdSenseを通じて広告を表示する場合があります。広告プロバイダーは独自のプライバシーポリシーに従ってデータを収集する場合があります。\n\n4. お問い合わせ\nプライバシーに関するお問い合わせは、アプリ開発者にご連絡ください。',
      'termsOfServiceTitle': '利用規約',
      'termsOfServiceContent': '1. サービスの利用\nこのアプリは無料で提供され、誰でも自由に使用できます。\n\n2. 免責事項\nこのアプリは「現状のまま」提供されます。開発者はアプリの使用による損害について責任を負いません。\n\n3. 知的財産権\nこのアプリのすべてのコンテンツとコードは著作権法によって保護されています。\n\n4. 規約の変更\nこの規約は予告なく変更される場合があります。\n\n5. お問い合わせ\nサービスに関するお問い合わせは、アプリ開発者にご連絡ください。',
      'version': 'バージョン',
      'developer': '開発者',
      'contact': 'お問い合わせ',
      // YouTube
      'watchYoutube': 'YouTubeで学ぶ',
      'selectProblemType': '学びたいテーマを選んでください',
      'youtubeBasics': '囲碁入門',
      'youtubeCapture': '石の取り方',
      'youtubeLifeDeath': '詰碁の基礎',
      'youtube3Space': '三目型（直三/曲三）',
      'youtube4Space': '四目型（直四/曲四）',
      'youtube5Space': '五目型',
      'youtubeCorner': '隅の死活',
      'youtubeThrowIn': 'ホウリコミ',
      'youtubeCapturingRace': '攻め合い',
    },
    GameLanguage.chinese: {
      'appTitle': '围棋',
      'vsAI': 'AI对战',
      'vsAIDesc': '与AI对弈',
      'twoPlayer': '围棋 - 双人对战',
      'twoPlayerModeDesc': '双人对弈',
      'playAsBlack': '执黑对局',
      'playAsWhite': '执白对局',
      'twoPlayerMode': '双人对战',
      'boardSize': '棋盘大小',
      'newGame': '新对局',
      'pass': '跳过',
      'black': '黑',
      'white': '白',
      'blackTurn': '黑方回合',
      'whiteTurn': '白方回合',
      'yourTurn': '你的回合',
      'aiThinking': 'AI思考中...',
      'aiThinkingTime': 'AI思考中... ({time}秒)',
      'aiPass': 'AI跳过',
      'blackPass': '黑方跳过',
      'whitePass': '白方跳过',
      'congratsWin': '恭喜！你赢了！',
      'aiWin': 'AI获胜！',
      'blackWin': '黑方获胜！',
      'whiteWin': '白方获胜！',
      'draw': '平局！',
      'me': '我',
      'ai': 'AI',
      'captures': '提子',
      'koViolation': '违反劫争规则！',
      'beginner': '入门',
      'intermediate': '中级',
      'expert': '高级',
      'language': '语言',
      'aiLevel': 'AI等级',
      'aiEasy': '简单',
      'aiNormal': '普通',
      'aiHard': '困难',
      'aiExpert': '最强',
      'hint': '提示',
      'hintOn': '提示 ON',
      'hintOff': '提示 OFF',
      'hintMessage': '已显示推荐位置',
      'noHint': '无法提供建议',
      'enableHintTitle': '提示',
      'enableHintMessage': '是否启用提示？',
      'hintEnabled': '提示已启用！',
      'cancel': '取消',
      'confirm': '确认',
      'close': '关闭',
      'newGameConfirm': '是否开始新游戏？',
      'endGameConfirm': '是否结束当前游戏并开始新游戏？',
      'continue': '继续游戏',
      'save': '保存',
      'load': '读取',
      'restart': '重新开始',
      'selectGame': '选择游戏',
      'viewResult': '查看结果',
      'initializing': '初始化中...',
      // 扑克下注
      'betPing': '底注',
      'betCall': '跟注',
      'betDdadang': '加倍',
      'betDie': '弃牌',
      'betCheck': '过牌',
      'betQuarter': '四分之一',
      'betHalf': '一半',
      'betFull': '全押',
      // Hula游戏
      'register': '登记',
      'discard': '弃牌',
      'stop': '停止',
      // 表格标题
      'player': '玩家',
      'thisGame': '本局',
      'winLoss': '胜/负',
      'cumulative': '累计',
      'hand': '手牌',
      'score': '分数',
      // 数独
      'quick': '快速',
      'memo': '备注',
      'allMemo': '全部备注',
      'selectCellFirst': '请先选择一个格子',
      'cellAlreadyFilled': '该格子已填写',
      'noSavedGame': '没有保存的游戏',
      'gameSaved': '游戏已保存',
      'gameLoaded': '游戏已读取',
      'savedGameInfo': '已保存的游戏',
      'saveDate': '保存时间',
      'moveCount': '手数',
      'selectDifficulty': '选择难度',
      'selectColor': '选择棋子颜色',
      'firstMove': '先手',
      'secondMove': '后手',
      'startGame': '开始游戏',
      'aiEasyDesc': '推荐给初学者',
      'aiNormalDesc': '使用基本策略',
      'aiHardDesc': '使用高级策略和定式',
      'aiExpertDesc': '最强AI级别',
      // 死活学习
      'lifeDeathProblems': '死活题',
      'lifeDeathProblemsDesc': '做题',
      'problemList': '题目列表',
      'problem': '题目',
      'problemType': '类型',
      'progress': '进度',
      'video': '视频',
      'solveProblem': '做题',
      'difficulty': '难度',
      'beginner': '入门',
      'intermediate': '中级',
      'advanced': '高级',
      'blackToPlay': '黑先',
      'whiteToPlay': '白先',
      'killWhite': '杀死白棋',
      'killBlack': '杀死黑棋',
      'cutWhite': '切断白棋',
      'cutBlack': '切断黑棋',
      'liveWithBlack': '黑棋做活',
      'liveWithWhite': '白棋做活',
      'correct': '正确！',
      'incorrect': '错误，请再试一次。',
      'showAnswer': '查看答案',
      'nextProblem': '下一题',
      'prevProblem': '上一题',
      'retry': '重试',
      'problemSolved': '解题成功！',
      'solvedCount': '已解决',
      'totalProblems': '总题数',
      'backToList': '返回列表',
      // 卡牌游戏
      'baduk': '围棋',
      'cardGame': '卡牌游戏',
      'janggi': '象棋',
      'boardGame': '桌游',
      'sudoku': '数独',
      'yutnori': '掷柶游戏',
      // 游戏帮助
      'help_baduk': '[游戏方法]\n黑白双方交替在空的交叉点上落子。\n完全包围对方的棋子可以提子。\n终局时占领更多领地者获胜。\n\n[基本规则]\n- 黑棋先行\n- 白棋有6.5目的贴目\n- 打劫：不能立即提回刚被提走的一子\n\n[游戏模式]\n- AI对弈：与AI对战\n- 双人对弈：与朋友对战\n- 死活题：通过解题提升实力',
      'help_janggi': '[游戏方法]\n每位玩家移动16个棋子，目标是将死对方的王（将）。\n\n[棋子走法]\n- 将：在宫内移动一格\n- 车：直线无限移动\n- 炮：跳过一个棋子移动/攻击（不能跳过另一个炮）\n- 马：走日字\n- 象：直线一格+斜线两格移动（走用字）\n- 士：在宫内斜走一格\n- 卒/兵：向前或横向移动一格\n\n[吃子规则]\n- 移动到对方棋子的位置可以吃掉该棋子\n- 移动路径上有其他棋子时无法移动（炮除外）\n\n[游戏模式]\n- AI对弈：与AI对战\n- 双人对弈：与朋友对战',
      'help_cardGame': '[Mighty]\n5人墩牌游戏。宣告分数并作为执政党获胜。\n执政党（主公+搭档）vs 在野党（其他3人）。\n\n[红心大战]\n避开红心和黑桃Q争取最低分。\n每张红心1分，黑桃Q13分。\n\n[Hula]\n组成相同数字或连续数字的组合，先出完手牌者获胜。\n\n[UNO]\n出相同数字或花色的牌，先出完手牌者获胜。\n\n[高低]\n猜测下一张牌比当前牌高还是低。\n\n[七张扑克]\n用7张牌组成牌型进行比拼。',
      'help_boardGame': '[五子棋]\n黑白双方交替落子，先连成5子者获胜。\n横、竖、斜线均可。\n\n[黑白棋]\n用自己的棋子夹住对方棋子可以翻转。\n终局时棋子多者获胜。\n\n[俄罗斯方块]\n堆叠下落的方块，完成一行即可消除。\n方块堆到顶部则游戏结束。\n\n[扫雷]\n根据数字提示推理地雷位置。\n打开所有非地雷格子即可获胜。\n\n[纸牌接龙]\n按规则整理纸牌，完成4个基础牌堆。\n\n[迷宫]\n找到出口逃离迷宫。\n\n[泡泡]\n将3个以上相同颜色的泡泡连在一起消除。',
      'help_sudoku': '[游戏方法]\n在9x9格子中填入1-9数字，不能重复。\n每行、每列、每个3x3宫格内数字不能相同。\n\n[游戏模式]\n- 经典：基本数独\n- 武士：5个数独重叠的大型拼图\n- 杀手：虚线区域内数字之和等于指定数字\n- 数字和：相邻格子的和作为提示\n\n[难度]\n简单 / 中等 / 困难 / 专家',
      'help_yutnori': '[游戏方法]\n投掷木棒，根据结果移动棋子。\n先将所有棋子移到终点者获胜。\n\n[投掷结果]\n- 道：移动1格\n- 盖：移动2格\n- 葛：移动3格\n- 柶：移动4格+再投一次\n- 模：移动5格+再投一次\n\n[特殊规则]\n- 吃掉对方棋子可以再投一次\n- 同一位置的己方棋子可以一起移动\n- 利用捷径可以更快到达终点',
      // 子游戏名称
      'mighty': 'Mighty',
      'mightyDesc': '5人扑克',
      'hearts': '红心大战',
      'heartsDesc': '传牌游戏',
      'hula': 'Hula',
      'hulaDesc': '3张牌',
      'onecard': 'UNO',
      'onecardDesc': '4人对战',
      'highlow': '高低',
      'highlowDesc': '猜数字',
      'sevenpoker': '七张扑克',
      'sevenpokerDesc': '扑克游戏',
      'gomoku': '五子棋',
      'othello': '黑白棋',
      'tetris': '俄罗斯方块',
      'minesweeper': '扫雷',
      'solitaire': '纸牌接龙',
      'maze': '迷宫',
      'bubble': '泡泡',
      'whackamole': '打地鼠',
      'baseball': '数字棒球',
      'sudoku_classic': '经典',
      'sudoku_samurai': '武士',
      'sudoku_killer': '杀手',
      'sudoku_sum': '数字和',
      // 子游戏帮助
      'help_mighty': '[游戏方法]\n5人墩牌游戏。\n主公和搭档组成执政党，对抗3名在野党玩家。\n\n[规则]\n- 叫牌：宣告要获得的最低分数\n- 主公通过指定一张牌选择搭档\n- 用最大的跟牌或王牌赢得一墩\n- 执政党必须达到宣告的分数才能获胜\n\n[出牌规则]\n- 必须跟随首家出的花色\n- 如果没有该花色，可以出其他花色\n- 王牌花色胜过其他花色\n\n[特殊牌]\n- Mighty：最强牌（黑桃A，若王牌是黑桃则为方块A）\n- 小丑：第二强牌\n- 小丑召唤：强制小丑出牌的牌（默认：梅花3）',
      'help_hearts': '[游戏方法]\n避免收集红心和黑桃Q的游戏。\n\n[计分]\n- 每张红心：1分\n- 黑桃Q：13分\n- 总分最低者获胜\n\n[回合规则]\n- 必须跟随首家出的花色\n- 如果没有该花色，可以出其他花色\n\n[特殊规则]\n- 第一回合不能用分数牌首出\n- 红心未破前不能用红心首出\n- 全收：收集所有红心+黑桃Q，给其他玩家26分',
      'help_hula': '[游戏方法]\n组成相同数字或连续数字的组合来出牌。\n先出完手牌者获胜。\n\n[牌型组合]\n- 三条：3张相同数字\n- 顺子：3张以上同花连续牌\n- 7：可以单独登记\n\n[额外规则]\n- 登记牌后，可以在现有组合上添加牌\n- 可以喊"停"来结束游戏\n\n[计分]\n- 数字牌 (2-10)：面值\n- A: 1分, J: 10分, Q: 11分, K: 12分\n- 未登记或持有7则2倍',
      'help_onecard': '[游戏方法]\n类似UNO。用相同数字或花色的牌跟牌。\n先出完手牌者获胜。\n\n[规则]\n- 剩1张牌时须在5秒内喊"One Card"（否则罚抽1张）\n\n[攻击牌]\n- 2: +2张\n- A: +3张（♠A为+5张）\n- 小丑: +5张（彩色小丑+7张）\n- 防御: 2→2/同花A/小丑, A→A/小丑, 小丑→仅小丑\n\n[特殊牌]\n- 7: 换花色\n- J: 跳过下一回合\n- Q: 反转方向（2人时为跳过）\n- K: 跳过下2回合',
      'help_sevenpoker': '[游戏方法]\n用7张牌组成最佳牌型。\n\n[游戏流程]\n1. 先发3张（2张暗牌+1张明牌）\n2. 明牌最大者为庄家\n3. 每轮发1张明牌并进行4轮下注\n4. 第7张为暗牌\n5. 7张中选5张组成最佳牌型\n\n[下注类型]\n- 빙: 基本下注 / 过牌: 跳过（仅庄家）\n- 跟注: 跟进 / 加倍: 双倍下注\n- 1/4注/半注/全注: 底池的25%/50%/100%\n- 弃牌: 放弃\n\n[牌型排名]\n- 皇家同花顺: 同花10-J-Q-K-A\n- 同花顺: 同花5张连续\n- 四条: 4张相同\n- 葫芦: 三条+一对\n- 同花: 5张同花\n- 顺子: 5张连续\n- 三条: 3张相同\n- 两对: 2组对子\n- 一对: 2张相同\n- 高牌: 无牌型',
      'help_highlow': '[游戏方法]\n用7张牌进行高手（扑克牌型）和低手（最低牌）的对决。\n底池由高手和低手胜者分享。\n\n[游戏流程]\n1. 发3张牌，选择1张公开\n2. 逐张公开并进行下注\n3. 第7张为暗牌\n4. 最后选择高/低/摇摆\n5. 高手和低手胜者各得一半底池\n\n[高/低/摇摆]\n- 高：用高牌型胜负\n- 低：用最低牌胜负\n- 摇摆：两边都参与（两边都赢才能全拿）\n\n[低手规则]\n- 不能有对子、顺子、同花\n- A-2-3-4-6是最强低手（A-2-3-4-5是顺子）\n- 越低越强\n\n[下注类型]\n- 빙/过牌: 仅庄家（开始/跳过）\n- 跟注/加倍: 跟进/双倍\n- 1/4注/半注/全注: 底池的25%/50%/100%\n\n[奖金]\n- 四条以上：从其他玩家收取奖金\n- 皇同顺: 500, 后同顺: 300, 同顺: 200, 四条: 100',
      'help_gomoku': '[游戏方法]\n黑白双方交替落子。\n先连成5子者获胜。\n\n[规则]\n- 横、竖、斜线均可\n- 不能落在已有棋子的位置\n\n[策略]\n阻挡对手的同时构建自己的连线！',
      'help_othello': '[游戏方法]\n用己方棋子夹住对方棋子可以翻转。\n终局时棋子多者获胜。\n\n[规则]\n- 每回合必须翻转至少一个棋子\n- 无有效走法时跳过\n\n[策略]\n角落很有价值 - 无法被翻转！',
      'help_tetris': '[游戏方法]\n旋转下落的方块并堆叠，完成水平线。\n完成的行消除得分。\n\n[控制]\n- 移动：左右箭头\n- 旋转：上箭头\n- 下落：下箭头\n\n[提示]\n保持低而平整！',
      'help_minesweeper': '[游戏方法]\n在不点击地雷的情况下找出所有地雷。\n数字表示相邻地雷的数量。\n\n[控制]\n- 点击：打开格子\n- 长按：标记地雷\n\n[提示]\n利用数字规律推断地雷位置！',
      'help_solitaire': '[游戏方法]\n整理纸牌，按花色建立4个基础牌堆（A到K）。\n\n[规则]\n- 列牌：红黑交替降序堆叠\n- 基础：按花色从A升序堆叠\n\n[提示]\n优先翻开朝下的牌！',
      'help_maze': '[游戏方法]\n找到从起点到出口的路径。\n\n[控制]\n- 滑动或使用箭头移动\n- 找到最短路径获得最高分\n\n[提示]\n沿着墙壁走最终能找到出口！',
      'help_bubble': '[游戏方法]\n发射泡泡，连接3个以上相同颜色的泡泡。\n相连的泡泡会消除。\n\n[规则]\n- 瞄准后发射泡泡\n- 消除所有泡泡获胜\n\n[提示]\n瞄准泡泡群，利用墙壁反弹！',
      'help_whackamole': '[游戏方法]\n快速敲打从洞里冒出的地鼠。\n\n[控制]\n- 点击/触摸：敲打地鼠\n\n[规则]\n- 地鼠出现时快速点击\n- 在限定时间内尽可能多地敲打\n- 敲打炸弹会扣分\n\n[得分]\n- 普通地鼠：+10分\n- 金色地鼠：+50分\n- 炸弹：-30分\n\n[等级]\n等级越高，地鼠躲得越快！',
      'help_baseball': '[游戏方法]\n猜测对方设定的3位数字。\n\n[术语]\n- 好球(S)：数字和位置都正确\n- 坏球(B)：数字正确但位置错误\n- 出局：数字不存在\n\n[示例]\n答案为123时：\n- 输入123 → 3S（正确！）\n- 输入132 → 1S 2B\n- 输入456 → 0S 0B（出局）\n\n[规则]\n- 每位数字不能重复（0~9）\n- 在限定次数内猜中\n\n[策略]\n先用0、1、2开始缩小数字范围！',
      'help_sudoku_classic': '[游戏方法]\n在9x9格子中填入1-9数字。\n\n[规则]\n- 每行不能有重复数字\n- 每列不能有重复数字\n- 每个3x3宫格不能有重复数字\n\n[提示]\n从数字最多的行/列开始！',
      'help_sudoku_samurai': '[游戏方法]\n5个数独重叠的大型拼图。\n\n[规则]\n- 每个9x9格子遵循标准数独规则\n- 重叠区域必须同时满足两个格子\n\n[提示]\n利用重叠区域进行交叉验证！',
      'help_sudoku_killer': '[游戏方法]\n带笼子的数独。每个笼子内的数字之和必须等于指定数字。\n\n[规则]\n- 标准数独规则适用\n- 笼子内数字不能重复\n- 笼子之和必须等于提示\n\n[提示]\n高数值的小笼子可能性有限！',
      'help_sudoku_sum': '[游戏方法]\n相邻格子的和作为提示的数独。\n\n[规则]\n- 标准数独规则适用\n- 格子之间的数字表示它们的和\n\n[提示]\n利用和来缩小可能性！',
      // 信息页面
      'about': '关于',
      'help': '帮助',
      'privacyPolicy': '隐私政策',
      'termsOfService': '服务条款',
      'info': '信息',
      'aboutTitle': '应用介绍',
      'aboutContent': '一款包含多种游戏的免费游戏合集应用。\n\n[围棋]\n拥有约4000年历史的策略棋盘游戏。黑白双方交替落子，目标是占领更多领地。\n- AI对弈、双人对弈、死活题\n\n[象棋]\n韩国传统策略棋盘游戏。移动16个棋子，目标是将死对方的王。\n- AI对弈、双人对弈\n\n[纸牌游戏]\n- Mighty: 5人墩牌游戏，分为执政党和在野党进行得分竞争。\n- 红心大战: 避开红心和黑桃Q，争取最低分的游戏。\n- Hula: 组成相同数字或连续数字的组合，先出完手牌者获胜。\n- UNO: 出相同数字或花色的牌，先出完手牌者获胜。\n- 高低: 猜测下一张牌是高还是低的游戏。\n- 七张扑克: 用7张牌组成牌型进行比拼。\n\n[棋盘游戏]\n- 五子棋: 先连成5子者获胜。\n- 黑白棋: 翻转对方棋子，占据更多棋盘。\n- 俄罗斯方块: 堆叠下落的方块，完成一行即可消除。\n- 扫雷: 根据数字提示推理地雷位置。\n- 纸牌接龙: 按规则整理纸牌的单人游戏。\n- 迷宫: 找到出口逃离迷宫。\n- 泡泡: 将3个以上相同颜色的泡泡连在一起消除。\n- 打地鼠: 快速敲打从洞里冒出的地鼠。\n- 数字棒球: 猜测3位数字的逻辑游戏。\n\n[数独]\n在9x9格子中填入1-9数字，不能重复。\n- 经典: 基本数独。每行、每列、每个3x3宫格内数字不能相同。\n- 武士: 5个数独重叠的大型拼图。\n- 杀手: 虚线区域内数字之和必须等于指定数字。\n- 数字和: 相邻格子的和作为提示。\n\n[传统游戏]\n- 掷柶游戏: 投掷木棒，根据结果(道/盖/葛/柶/模)移动棋子，先出者获胜。\n\n所有游戏均可离线免费游玩。',
      'helpTitle': '游戏方法',
      'helpRules': '基本规则',
      'helpRulesContent': '• 黑棋先行\n• 在空的交叉点上落子\n• 完全包围对方的棋子可以提子\n• 占领更多领地者获胜\n• 白棋有6.5目的贴目',
      'helpCapture': '提子',
      'helpCaptureContent': '当棋子的所有气（相邻的空点）都被堵住时，棋子被提走。相连的棋子作为一个整体。',
      'helpKo': '打劫',
      'helpKoContent': '不能立即提回刚被对方提走的一子，形成无限循环。',
      'helpTerritory': '计算地盘',
      'helpTerritoryContent': '终局时，被己方棋子围住的空点是地盘。得分=地盘+提子数。',
      'helpContent': '游戏方法\n\n基本规则\n• 黑棋先行\n• 在空的交叉点上落子\n• 完全包围对方的棋子可以提子\n• 占领更多领地者获胜\n• 白棋有6.5目的贴目\n\n提子\n当棋子的所有气（相邻的空点）都被堵住时，棋子被提走。相连的棋子作为一个整体。\n\n打劫\n不能立即提回刚被对方提走的一子，形成无限循环。\n\n计算地盘\n终局时，被己方棋子围住的空点是地盘。得分=地盘+提子数。',
      'privacyPolicyTitle': '隐私政策',
      'privacyPolicyContent': '1. 收集的个人信息\n本应用不收集个人信息。所有游戏数据仅存储在用户设备上。\n\n2. 数据存储\n游戏进度和设置仅存储在本地，不会传输到外部服务器。\n\n3. 广告\n本应用可能通过Google AdSense展示广告。广告提供商可能根据其隐私政策收集数据。\n\n4. 联系方式\n如有隐私相关问题，请联系应用开发者。',
      'termsOfServiceTitle': '服务条款',
      'termsOfServiceContent': '1. 服务使用\n本应用免费提供，任何人都可以自由使用。\n\n2. 免责声明\n本应用按"现状"提供。开发者不对因使用本应用造成的任何损害负责。\n\n3. 知识产权\n本应用的所有内容和代码受版权法保护。\n\n4. 条款变更\n本条款可能在不事先通知的情况下进行更改。\n\n5. 联系方式\n如有服务相关问题，请联系应用开发者。',
      'version': '版本',
      'developer': '开发者',
      'contact': '联系方式',
      // YouTube
      'watchYoutube': '在YouTube上学习',
      'selectProblemType': '选择想学习的主题',
      'youtubeBasics': '围棋入门',
      'youtubeCapture': '吃子基础',
      'youtubeLifeDeath': '死活基础',
      'youtube3Space': '三目型（直三/曲三）',
      'youtube4Space': '四目型（直四/曲四）',
      'youtube5Space': '五目型',
      'youtubeCorner': '角部死活',
      'youtubeThrowIn': '投入技巧',
      'youtubeCapturingRace': '对杀',
    },
  };

  static String get(GameLanguage lang, String key) {
    return _strings[lang]?[key] ?? key;
  }

  static String getLanguageName(GameLanguage lang) {
    switch (lang) {
      case GameLanguage.korean:
        return '한국어';
      case GameLanguage.english:
        return 'English';
      case GameLanguage.japanese:
        return '日本語';
      case GameLanguage.chinese:
        return '中文';
    }
  }
}

// 공통 앱바 빌더 - Provider를 사용하여 언어 상태 관리
AppBar buildCommonAppBar({
  required BuildContext context,
  required String title,
  required GameLanguage language,
  required Function(GameLanguage) onLanguageChanged,
}) {
  // Provider에서 언어 상태 읽기 (화면 전체에서 일관된 상태 유지)
  final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
  final currentLanguage = languageProvider.language;

  return AppBar(
    title: Text(title),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    automaticallyImplyLeading: false,
    actions: [
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutPage(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'about'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => GameModeSelector(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
            (route) => route.isFirst,
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'appTitle'),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JanggiSelectionScreen(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'janggi'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => card_game.GameSelectionScreen(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'cardGame'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BoardGameSelectionScreen(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'boardGame'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SudokuSelectionScreen(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'sudoku'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const YutnoriHomeScreen()),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'yutnori'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HelpPage(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'help'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivacyPolicyPage(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'privacyPolicy'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TermsOfServicePage(
                language: currentLanguage,
                onLanguageChanged: languageProvider.setLanguage,
              ),
            ),
          );
        },
        child: Text(
          L10n.get(currentLanguage, 'termsOfService'),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      PopupMenuButton<GameLanguage>(
        icon: const Icon(Icons.language),
        tooltip: L10n.get(currentLanguage, 'language'),
        onSelected: languageProvider.setLanguage,
        itemBuilder: (context) => GameLanguage.values.map((lang) {
          return PopupMenuItem(
            value: lang,
            child: Row(
              children: [
                if (lang == currentLanguage)
                  const Icon(Icons.check, size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(L10n.getLanguageName(lang)),
              ],
            ),
          );
        }).toList(),
      ),
    ],
  );
}

class BadukApp extends StatefulWidget {
  const BadukApp({super.key});

  @override
  State<BadukApp> createState() => _BadukAppState();
}

class _BadukAppState extends State<BadukApp> {
  bool _benchmarkDone = false;

  @override
  void initState() {
    super.initState();
    _runBenchmark();
  }

  Future<void> _runBenchmark() async {
    await DeviceBenchmark.measurePerformance();
    if (mounted) {
      setState(() {
        _benchmarkDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();
    final language = languageProvider.language;

    return MaterialApp(
      title: L10n.get(language, 'appTitle'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      // 카드게임 다국어 지원
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: languageProvider.locale,
      home: _benchmarkDone
          ? AboutPage(
              language: language,
              onLanguageChanged: languageProvider.setLanguage,
            )
          : const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('초기화 중...'),
                  ],
                ),
              ),
            ),
    );
  }
}

class GameModeSelector extends StatefulWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const GameModeSelector({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<GameModeSelector> createState() => _GameModeSelectorState();
}

class _GameModeSelectorState extends State<GameModeSelector> {
  Map<String, dynamic>? _savedGameInfo;

  @override
  void initState() {
    super.initState();
    _checkSavedGame();
  }

  Future<void> _checkSavedGame() async {
    final info = await _BadukGameState.getSavedGameInfo();
    if (mounted) {
      setState(() {
        _savedGameInfo = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 언어 상태 읽기
    final languageProvider = context.watch<LanguageProvider>();
    final language = languageProvider.language;

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom;
    final isSmallScreen = screenHeight < 600;

    // 반응형: 화면 너비에 따라 최대 너비와 폰트 크기 결정
    final double maxContentWidth;
    final double iconSize;
    final double titleSize;
    final double subtitleSize;

    if (screenWidth >= 900) {
      maxContentWidth = 800;
      iconSize = 48;
      titleSize = 20;
      subtitleSize = 14;
    } else if (screenWidth >= 600) {
      maxContentWidth = 600;
      iconSize = 40;
      titleSize = 18;
      subtitleSize = 13;
    } else {
      maxContentWidth = double.infinity;
      iconSize = isSmallScreen ? 28 : 36;
      titleSize = isSmallScreen ? 14.0 : 17.0;
      subtitleSize = isSmallScreen ? 10.0 : 12.0;
    }

    final double tileWidth;
    final double tileHeight;
    if (screenWidth >= 900) {
      tileWidth = 200;
      tileHeight = 160;
    } else if (screenWidth >= 600) {
      tileWidth = 160;
      tileHeight = 130;
    } else {
      tileWidth = (screenWidth - 48) / 2;
      tileHeight = isSmallScreen ? 100 : 120;
    }

    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: L10n.get(language, 'appTitle'),
        language: language,
        onLanguageChanged: languageProvider.setLanguage,
      ),
      backgroundColor: Colors.brown[800],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                children: [
                  Wrap(
                    spacing: isSmallScreen ? 10 : 16,
                    runSpacing: isSmallScreen ? 10 : 16,
                    alignment: WrapAlignment.center,
                    children: [
                      // AI 대국
                      SizedBox(
                        width: tileWidth,
                        height: tileHeight,
                        child: _buildGameTile(
                          context: context,
                          title: L10n.get(language, 'vsAI'),
                          subtitle: L10n.get(language, 'vsAIDesc'),
                          icon: Icons.smart_toy,
                          color: Colors.brown[600]!,
                          iconSize: iconSize,
                          titleSize: titleSize,
                          subtitleSize: subtitleSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AIDifficultySelector(
                                  language: language,
                                ),
                              ),
                            ).then((_) => _checkSavedGame());
                          },
                        ),
                      ),
                      // 2인 대국
                      SizedBox(
                        width: tileWidth,
                        height: tileHeight,
                        child: _buildGameTile(
                          context: context,
                          title: L10n.get(language, 'twoPlayerMode'),
                          subtitle: L10n.get(language, 'twoPlayerModeDesc'),
                          icon: Icons.people,
                          color: Colors.blueGrey[600]!,
                          iconSize: iconSize,
                          titleSize: titleSize,
                          subtitleSize: subtitleSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BadukGame(
                                  vsAI: false,
                                  language: language,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // 사활 문제
                      SizedBox(
                        width: tileWidth,
                        height: tileHeight,
                        child: _buildGameTile(
                          context: context,
                          title: L10n.get(language, 'lifeDeathProblems'),
                          subtitle: L10n.get(language, 'lifeDeathProblemsDesc'),
                          icon: Icons.extension,
                          color: Colors.green[700]!,
                          iconSize: iconSize,
                          titleSize: titleSize,
                          subtitleSize: subtitleSize,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LifeDeathProblemSelector(
                                  language: language,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      // 이어하기 (저장된 게임이 있을 때만)
                      if (_savedGameInfo != null)
                        SizedBox(
                          width: tileWidth,
                          height: tileHeight,
                          child: _buildContinueTile(
                            context: context,
                            iconSize: iconSize,
                            titleSize: titleSize,
                            subtitleSize: subtitleSize,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight;
            final availableWidth = constraints.maxWidth;
            final padding = availableHeight * 0.06;
            final dynamicIconSize = (availableHeight * 0.28).clamp(18.0, iconSize);
            final iconPadding = dynamicIconSize * 0.25;
            final dynamicTitleSize = (availableHeight * 0.11).clamp(11.0, titleSize);
            final dynamicSubtitleSize = (availableHeight * 0.08).clamp(8.0, subtitleSize);
            final spacing = availableHeight * 0.04;

            return Container(
              padding: EdgeInsets.all(padding),
              width: availableWidth,
              height: availableHeight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  width: availableWidth - padding * 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(iconPadding),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: dynamicIconSize,
                        ),
                      ),
                      SizedBox(height: spacing),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: dynamicTitleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: spacing * 0.3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: dynamicSubtitleSize,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContinueTile({
    required BuildContext context,
    required double iconSize,
    required double titleSize,
    required double subtitleSize,
  }) {
    if (_savedGameInfo == null) return const SizedBox();

    final boardSize = _savedGameInfo!['boardSize'] ?? 19;
    final moveCount = (_savedGameInfo!['moveHistory'] as List?)?.length ?? 0;
    final vsAI = _savedGameInfo!['vsAI'] ?? true;
    final playerColorIndex = _savedGameInfo!['playerColor'] ?? 1;
    final aiDifficultyIndex = _savedGameInfo!['aiDifficulty'] ?? 1;

    return _buildGameTile(
      context: context,
      title: L10n.get(widget.language, 'continue'),
      subtitle: '$boardSize×$boardSize · ${L10n.get(widget.language, 'moveCount')}: $moveCount',
      icon: Icons.play_arrow,
      color: Colors.blue[700]!,
      iconSize: iconSize,
      titleSize: titleSize,
      subtitleSize: subtitleSize,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BadukGame(
              vsAI: vsAI,
              playerColor: Stone.values[playerColorIndex],
              language: widget.language,
              aiDifficulty: AIDifficulty.values[aiDifficultyIndex],
              loadSavedGame: true,
            ),
          ),
        ).then((_) => _checkSavedGame());
      },
    );
  }
}

// AI 난이도 선택 화면
class AIDifficultySelector extends StatefulWidget {
  final GameLanguage language;

  const AIDifficultySelector({
    super.key,
    required this.language,
  });

  @override
  State<AIDifficultySelector> createState() => _AIDifficultySelectorState();
}

class _AIDifficultySelectorState extends State<AIDifficultySelector> {
  AIDifficulty _selectedDifficulty = AIDifficulty.advanced;
  Stone _selectedColor = Stone.black;

  String _getDifficultyName(AIDifficulty difficulty) {
    switch (difficulty) {
      case AIDifficulty.advanced:
        return L10n.get(widget.language, 'aiHard');
      case AIDifficulty.expert:
        return L10n.get(widget.language, 'aiExpert');
    }
  }

  String _getDifficultyDescription(AIDifficulty difficulty) {
    switch (difficulty) {
      case AIDifficulty.advanced:
        return L10n.get(widget.language, 'aiHardDesc');
      case AIDifficulty.expert:
        return L10n.get(widget.language, 'aiExpertDesc');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(widget.language, 'vsAI')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 난이도 선택
              Text(
                L10n.get(widget.language, 'selectDifficulty'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              // 난이도 버튼들
              ...AIDifficulty.values.map((difficulty) {
                bool isSelected = difficulty == _selectedDifficulty;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: 280,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedDifficulty = difficulty;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        backgroundColor: isSelected ? Colors.brown.shade200 : null,
                        side: isSelected ? BorderSide(color: Colors.brown.shade600, width: 2) : null,
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getDifficultyName(difficulty),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getDifficultyDescription(difficulty),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 32),
              // 돌 색상 선택
              Text(
                L10n.get(widget.language, 'selectColor'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 흑돌 선택
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = Stone.black;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedColor == Stone.black ? Colors.brown.shade100 : null,
                        borderRadius: BorderRadius.circular(12),
                        border: _selectedColor == Stone.black
                            ? Border.all(color: Colors.brown.shade600, width: 2)
                            : Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            L10n.get(widget.language, 'black'),
                            style: TextStyle(
                              fontWeight: _selectedColor == Stone.black ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          Text(
                            L10n.get(widget.language, 'firstMove'),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // 백돌 선택
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = Stone.white;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedColor == Stone.white ? Colors.brown.shade100 : null,
                        borderRadius: BorderRadius.circular(12),
                        border: _selectedColor == Stone.white
                            ? Border.all(color: Colors.brown.shade600, width: 2)
                            : Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.grey, width: 2),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            L10n.get(widget.language, 'white'),
                            style: TextStyle(
                              fontWeight: _selectedColor == Stone.white ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          Text(
                            L10n.get(widget.language, 'secondMove'),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              // 게임 시작 버튼
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BadukGame(
                        vsAI: true,
                        playerColor: _selectedColor,
                        language: widget.language,
                        aiDifficulty: _selectedDifficulty,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                  backgroundColor: Colors.brown,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  L10n.get(widget.language, 'startGame'),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Stone { none, black, white }

// 사활 문제 난이도
enum ProblemDifficulty { beginner, intermediate, advanced }

// 문제 유형
enum ProblemType { kill, live, cut }

// 사활 문제 클래스
class LifeDeathProblem {
  final int id;
  final String name;
  final ProblemDifficulty difficulty;
  final ProblemType type;
  final Stone playerColor;
  final int boardSize;
  final List<List<int>> blackStones;
  final List<List<int>> whiteStones;
  final List<List<int>> correctMoves; // 정답 수순 (한 수 문제용)
  final List<List<int>>? alternativeMoves; // 대안 정답
  final String? explanation; // 정답 설명
  // 다수 문제용: [사용자1, AI응수1, 사용자2, AI응수2, ...] 형태
  final List<List<int>>? moveSequence;
  // 오답시 AI 응수 (틀린 수에 대한 반격)
  final List<int>? wrongMoveResponse;

  const LifeDeathProblem({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.type,
    required this.playerColor,
    required this.boardSize,
    required this.blackStones,
    required this.whiteStones,
    required this.correctMoves,
    this.alternativeMoves,
    this.explanation,
    this.moveSequence,
    this.wrongMoveResponse,
  });
}

// 사활 문제 데이터베이스
class LifeDeathProblems {
  static const List<LifeDeathProblem> problems = [
    // ===== 입문 (Beginner) - 단순 잡기와 기본 살기 =====

    // 1-1: 단수치기 - 마지막 활로 막기
    LifeDeathProblem(
      id: 1,
      name: '단수치기',
      difficulty: ProblemDifficulty.beginner,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 2], [1, 0]],
      whiteStones: [[0, 0], [0, 1]],
      correctMoves: [[1, 1]],
      explanation: '단수(單手)란 돌의 활로가 하나만 남은 상태입니다. 백돌의 마지막 활로를 막으면 백돌이 잡힙니다.',
    ),

    // 1-2: 단수치기 - 3점 잡기
    LifeDeathProblem(
      id: 2,
      name: '단수치기',
      difficulty: ProblemDifficulty.beginner,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 3], [1, 0], [1, 1]],
      whiteStones: [[0, 0], [0, 1], [0, 2]],
      correctMoves: [[1, 2]],
      explanation: '연결된 돌들은 하나의 그룹으로 활로를 공유합니다. 그룹 전체의 마지막 활로를 막으면 모든 돌이 한꺼번에 잡힙니다.',
    ),

    // 1-3: 단수치기 - 귀에서 1점 잡기
    LifeDeathProblem(
      id: 3,
      name: '단수치기',
      difficulty: ProblemDifficulty.beginner,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 1], [1, 1], [2, 0]],
      whiteStones: [[1, 0]],
      correctMoves: [[0, 0]],
      explanation: '귀(꼭짓점)에 있는 돌은 활로가 2개뿐입니다. 변에서는 3개, 중앙에서는 4개입니다. 귀의 돌은 잡기 쉽습니다.',
    ),

    // 1-4: 단수치기 - 귀에서 3점 잡기
    LifeDeathProblem(
      id: 4,
      name: '단수치기',
      difficulty: ProblemDifficulty.beginner,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 2], [1, 2], [2, 0], [2, 1]],
      whiteStones: [[0, 0], [1, 0], [1, 1]],
      correctMoves: [[0, 1]],
      explanation: '귀에서는 돌이 여러 개 연결되어 있어도 변과 귀로 활로가 제한됩니다. 급소를 찾아 단수를 치면 잡을 수 있습니다.',
    ),

    // 1-5: 기본 살기 - 두 눈 만들기
    LifeDeathProblem(
      id: 5,
      name: '기본 살기',
      difficulty: ProblemDifficulty.beginner,
      type: ProblemType.live,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 0], [0, 1], [0, 3], [0, 4]],
      whiteStones: [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [0, 5]],
      correctMoves: [[0, 2]],
      explanation: '돌이 살려면 반드시 두 개의 눈이 필요합니다. 가운데를 막아 양쪽에 눈을 만들면 절대로 잡히지 않습니다.',
    ),

    // 1-6: 기본 살기 - 늘어서 살기
    LifeDeathProblem(
      id: 6,
      name: '기본 살기',
      difficulty: ProblemDifficulty.beginner,
      type: ProblemType.live,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 0], [0, 1], [0, 2]],
      whiteStones: [[1, 0], [1, 1], [1, 2], [1, 3], [0, 4]],
      correctMoves: [[0, 3]],
      explanation: '공간이 부족하면 확장해서 두 눈을 만들 자리를 확보해야 합니다. 늘어서 영역을 넓히는 것이 살기의 기본입니다.',
    ),

    // ===== 중급 (Intermediate) - 3궁도 패턴 =====

    // 2-1: 직삼궁 - 치중 (가운데 급소)
    LifeDeathProblem(
      id: 7,
      name: '직삼궁',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 3], [1, 3], [2, 0], [2, 1], [2, 2], [2, 3]],
      whiteStones: [[1, 0], [1, 1], [1, 2]],
      correctMoves: [[0, 1]],
      explanation: '직삼궁(直三宮)은 일직선으로 3칸의 공간입니다. 가운데 급소에 치중하면 상대는 한쪽만 막을 수 있어 두 눈을 만들지 못합니다.',
    ),

    // 2-2: 곡삼궁 - 꺾인 3궁도 급소
    LifeDeathProblem(
      id: 8,
      name: '곡삼궁',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 2], [1, 2], [2, 1], [3, 0], [3, 1]],
      whiteStones: [[1, 0], [2, 0]],
      correctMoves: [[1, 1]],
      explanation: '곡삼궁(曲三宮)은 ㄱ자로 꺾인 3칸 공간입니다. 꺾인 부분이 급소이며, 여기에 치중하면 두 눈을 만들 수 없습니다.',
    ),

    // 2-3: 직삼궁 살리기 (백선)
    LifeDeathProblem(
      id: 9,
      name: '직삼궁 살리기',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.live,
      playerColor: Stone.white,
      boardSize: 7,
      blackStones: [[0, 3], [1, 3], [2, 0], [2, 1], [2, 2], [2, 3]],
      whiteStones: [[1, 0], [1, 1], [1, 2]],
      correctMoves: [[0, 1]],
      explanation: '3궁도에서 살려면 급소에 먼저 두어야 합니다. 가운데를 먼저 차지하면 양쪽에 눈을 만들어 살 수 있습니다.',
    ),

    // 2-4: 2선 급소
    LifeDeathProblem(
      id: 10,
      name: '2선 급소',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 2], [1, 2], [2, 2], [3, 0], [3, 1], [3, 2]],
      whiteStones: [[1, 0], [2, 0], [2, 1]],
      correctMoves: [[1, 1]],
      explanation: '2선(변에서 두 번째 줄)의 급소는 사활에서 매우 중요합니다. 이 자리를 차지하면 상대의 눈 공간을 효과적으로 줄일 수 있습니다.',
    ),

    // 2-5: 환격 (던져넣기)
    LifeDeathProblem(
      id: 11,
      name: '환격',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 2], [1, 2], [2, 0], [2, 1]],
      whiteStones: [[0, 0], [1, 0], [1, 1]],
      correctMoves: [[0, 1]],
      explanation: '환격(還擊)은 상대 집 안에 돌을 던져넣는 수법입니다. 잡히더라도 되잡으면서 상대를 잡을 수 있는 묘수입니다.',
    ),

    // 2-6: 눈 자리 축소
    LifeDeathProblem(
      id: 12,
      name: '눈 자리 축소',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 4], [1, 4], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4]],
      whiteStones: [[0, 0], [1, 0], [1, 1], [1, 2], [1, 3]],
      correctMoves: [[0, 2]],
      explanation: '궁도가 넓으면 살기 쉽습니다. 잡으려면 궁도를 좁혀 3궁도 이하로 만들어야 합니다. 급소에 치중하여 공간을 줄이세요.',
    ),

    // ===== 고급 (Advanced) - 4궁도, 5궁도, 특수형 =====

    // 3-1: 귀곡사 (귀의 곡사궁)
    LifeDeathProblem(
      id: 13,
      name: '귀곡사',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 2], [1, 2], [2, 2], [3, 0], [3, 1], [3, 2]],
      whiteStones: [[1, 0], [1, 1], [2, 0], [2, 1]],
      correctMoves: [[0, 1]],
      explanation: '귀곡사(龜曲四)는 귀에서 ㄱ자로 꺾인 4궁도입니다. 일반적인 4궁도는 살 수 있지만, 귀에서는 특수한 규칙으로 죽는 모양입니다.',
    ),

    // 3-2: 직사궁 급소 (4궁도 직선)
    LifeDeathProblem(
      id: 14,
      name: '직사궁',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 4], [1, 4], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4]],
      whiteStones: [[1, 0], [1, 1], [1, 2], [1, 3]],
      correctMoves: [[0, 1], [0, 2]],
      explanation: '직사궁(直四宮)은 일직선 4칸입니다. 보통은 살 수 있지만, 양쪽 2선에 치중하면 3궁도로 줄여서 잡을 수 있습니다.',
    ),

    // 3-3: 꽃사궁 (뭉친 4궁도)
    LifeDeathProblem(
      id: 15,
      name: '꽃사궁',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 2], [1, 2], [2, 2], [3, 0], [3, 1], [3, 2]],
      whiteStones: [[1, 0], [2, 0], [2, 1]],
      correctMoves: [[1, 1]],
      explanation: '꽃사궁은 T자 모양의 4궁도입니다. 가운데 치중 한 수로 3궁도가 되어 죽습니다. 모양이 뭉쳐있어 약한 형태입니다.',
    ),

    // 3-4: 오궁도화 (5궁도 급소)
    LifeDeathProblem(
      id: 16,
      name: '오궁도화',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 5], [1, 5], [2, 0], [2, 1], [2, 2], [2, 3], [2, 4], [2, 5]],
      whiteStones: [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4]],
      correctMoves: [[0, 2]],
      explanation: '오궁도화(五宮桃花)는 5궁도 중 특수한 죽는 모양입니다. 보통 5궁도는 살지만, 이 모양은 급소에 치중당하면 죽습니다.',
    ),

    // 3-5: 복잡한 귀 살리기
    LifeDeathProblem(
      id: 17,
      name: '귀 살리기',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.live,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 0], [0, 1], [0, 3], [0, 4]],
      whiteStones: [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [0, 5]],
      correctMoves: [[0, 2]],
      explanation: '복잡한 상황에서도 기본 원리는 같습니다. 두 눈을 만들 수 있는 급소를 찾아 먼저 차지하면 살 수 있습니다.',
    ),

    // 3-6: 수상전 (활로 싸움)
    LifeDeathProblem(
      id: 18,
      name: '수상전',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 3], [1, 3], [2, 3], [3, 0], [3, 1], [3, 2], [3, 3]],
      whiteStones: [[0, 0], [0, 1], [1, 1], [2, 0], [2, 1], [2, 2]],
      correctMoves: [[1, 2], [0, 2], [1, 0]],
      explanation: '수상전(手相戰)은 서로 잡으려는 활로 싸움입니다. "바깥 공배부터 메우라"는 격언처럼, 바깥쪽 활로를 먼저 줄여야 이길 수 있습니다.',
    ),

    // 3-7: 변의 궁도 (변에서 백 잡기)
    LifeDeathProblem(
      id: 19,
      name: '변의 궁도',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 5], [1, 4], [2, 0], [2, 1], [2, 2], [2, 3]],
      whiteStones: [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1]],
      correctMoves: [[1, 2]],
      explanation: '변에서 백의 눈 모양을 깨는 급소입니다. 이 자리에 치중하면 백은 두 눈을 만들 수 없어 죽습니다.',
    ),

    // 3-8: 귀의 복잡한 사활 (오른쪽 위 패턴)
    LifeDeathProblem(
      id: 20,
      name: '귀의 사활',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 6], [1, 4], [2, 3], [2, 4], [3, 4], [3, 5], [4, 6]],
      whiteStones: [[0, 4], [0, 5], [1, 5], [1, 6], [2, 5], [2, 6], [3, 6], [4, 5]],
      correctMoves: [[1, 3]],
      alternativeMoves: [[0, 3]],
      explanation: '귀에서 백의 근거를 빼앗는 급소입니다. 백의 눈 공간을 줄여 잡을 수 있습니다.',
    ),

    // 3-9: 중앙 연결 끊기 (중앙 패턴)
    LifeDeathProblem(
      id: 21,
      name: '연결 끊기',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.cut,
      playerColor: Stone.white,
      boardSize: 7,
      blackStones: [[3, 1], [3, 2], [3, 3], [3, 4], [3, 5]],
      whiteStones: [[4, 1], [4, 3], [4, 5], [5, 2], [5, 4]],
      correctMoves: [[4, 2]],
      alternativeMoves: [[4, 4]],
      explanation: '흑의 돌 연결을 끊는 급소입니다. 이 자리를 차지하면 흑돌을 분단하여 약화시킬 수 있습니다.',
    ),

    // 3-10: 다수 문제 - 귀에서 3수 잡기
    LifeDeathProblem(
      id: 22,
      name: '귀 3수',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[0, 3], [1, 3], [2, 3], [3, 0], [3, 1], [3, 2], [3, 3]],
      whiteStones: [[0, 0], [0, 1], [1, 1], [2, 0], [2, 1], [2, 2]],
      correctMoves: [[1, 2]],
      moveSequence: [
        [1, 2],  // 흑1: 급소 치중
        [0, 2],  // 백2: 저항
        [1, 0],  // 흑3: 마무리
      ],
      explanation: '귀에서 3수 만에 백을 잡는 문제입니다. 흑1로 급소 치중, 백2 저항 후 흑3으로 마무리합니다.',
    ),

    // 3-11: 수상전 (활로 싸움) - 새 문제
    LifeDeathProblem(
      id: 23,
      name: '수상전',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [[1, 5], [3, 3], [3, 4], [3, 5], [4, 1], [4, 2], [5, 0], [5, 1], [5, 2]],
      whiteStones: [[3, 6], [4, 3], [4, 4], [4, 5], [4, 6], [5, 3], [5, 4], [5, 5], [5, 6]],
      correctMoves: [[2, 5]],
      explanation: '수상전에서 바깥쪽 활로부터 메워야 합니다. 이 급소에 두면 백의 활로를 효과적으로 줄여 잡을 수 있습니다.',
    ),

    // 3-12: 대마 사활 - 복잡한 눈 모양
    LifeDeathProblem(
      id: 24,
      name: '대마 잡기',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.white,
      boardSize: 9,
      blackStones: [
        [1, 2], [1, 3], [1, 4], [1, 5],
        [2, 4], [2, 5],
        [3, 2], [3, 4], [3, 5],
        [4, 3], [4, 5], [4, 6],
        [5, 3], [5, 4], [5, 6],
        [6, 2], [6, 3], [6, 4], [6, 5], [6, 6],
      ],
      whiteStones: [
        [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7],
        [1, 1], [1, 6], [1, 7],
        [2, 1], [2, 3], [2, 6], [2, 7],
        [3, 1], [3, 6], [3, 7],
        [4, 2], [4, 7],
        [5, 2], [5, 5], [5, 7],
        [6, 1], [6, 7],
        [7, 2], [7, 3], [7, 4], [7, 5], [7, 6],
      ],
      correctMoves: [[1, 7]],
      alternativeMoves: [[4, 4]],
      explanation: '백이 급소에 치중하여 흑의 눈 모양을 깨는 문제입니다. 이 자리에 두면 흑은 두 눈을 만들 수 없습니다.',
    ),

    // 3-13: 7수 수상전 - 순서대로 두기
    LifeDeathProblem(
      id: 25,
      name: '7수 수상전',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [
        [1, 6], [2, 6], [3, 5], [3, 6], [4, 1], [4, 5],
      ],
      whiteStones: [
        [1, 5], [2, 5], [3, 2], [3, 3], [3, 4],
      ],
      correctMoves: [[4, 4]],
      moveSequence: [
        [4, 4],  // 흑1: 치중
        [5, 3],  // 백2: 응수
        [4, 6],  // 흑3: 연결
        [5, 2],  // 백4: 응수
        [2, 4],  // 흑5: 급소
        [5, 4],  // 백6: 응수
        [0, 5],  // 흑7: 마무리
      ],
      explanation: '7수 만에 백을 잡는 수상전입니다. 흑1 치중, 백2 응수, 흑3 연결, 백4 응수, 흑5 급소, 백6 응수, 흑7로 마무리합니다.',
    ),

    // 3-14: 3수 사활 - 귀 급소
    LifeDeathProblem(
      id: 26,
      name: '3수 급소',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [
        [1, 3], [1, 4],
        [2, 2], [2, 3], [2, 4], [2, 5],
        [3, 3], [3, 4],
        [4, 2], [4, 3], [4, 4],
      ],
      whiteStones: [
        [1, 0], [1, 5], [1, 6],
        [2, 0], [2, 1], [2, 5], [2, 6],
        [3, 0], [3, 1], [3, 2], [3, 5], [3, 6],
        [4, 0], [4, 1], [4, 5], [4, 6],
        [5, 1], [5, 2], [5, 3], [5, 4], [5, 5],
      ],
      correctMoves: [[1, 2]],
      moveSequence: [
        [1, 2],  // 흑1: 급소 치중
        [0, 3],  // 백2: 응수
        [0, 1],  // 흑3: 마무리
      ],
      explanation: '3수 만에 백을 잡는 문제입니다. 흑1로 급소 치중 후, 백2 응수에 흑3으로 마무리합니다.',
    ),

    // 3-15: 13수 수상전 - 복잡한 순서
    LifeDeathProblem(
      id: 27,
      name: '13수 수상전',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [
        [3, 1], [4, 1], [4, 2], [4, 3], [4, 4], [5, 2],
      ],
      whiteStones: [],
      correctMoves: [[0, 5]],
      moveSequence: [
        [0, 5],  // 흑1
        [1, 6],  // 백2
        [0, 3],  // 흑3
        [1, 3],  // 백4
        [0, 1],  // 흑5
        [1, 5],  // 백6
        [0, 4],  // 흑7
        [2, 3],  // 백8
        [0, 6],  // 흑9
        [1, 1],  // 백10
        [1, 0],  // 흑11
        [1, 2],  // 백12
        [0, 2],  // 흑13: 마무리
      ],
      explanation: '13수 만에 백을 잡는 복잡한 수상전입니다. 정확한 순서로 두어야 백을 잡을 수 있습니다.',
    ),

    // 3-16: 7수 사활 - 눈 모양 파괴
    LifeDeathProblem(
      id: 28,
      name: '7수 사활',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [
        [0, 3], [0, 4], [0, 5],
        [1, 2], [1, 3], [1, 4],
        [3, 4],
        [4, 1], [4, 4], [4, 5],
        [5, 0], [5, 1], [5, 2], [5, 3], [5, 5],
      ],
      whiteStones: [
        [2, 1], [2, 4], [2, 6],
        [3, 1], [3, 2],
        [4, 2], [4, 3],
        [5, 6],
      ],
      correctMoves: [[2, 3]],
      moveSequence: [
        [2, 3],  // 흑1: 급소 치중
        [2, 2],  // 백2: 응수
        [1, 5],  // 흑3: 연결
        [3, 3],  // 백4: 응수
        [2, 5],  // 흑5: 압박
        [5, 4],  // 백6: 응수
        [3, 5],  // 흑7: 마무리
      ],
      explanation: '7수 만에 백의 눈 모양을 파괴하여 잡는 문제입니다. 흑1 급소 치중이 핵심입니다.',
    ),

    // 3-17: 6수 수상전
    LifeDeathProblem(
      id: 29,
      name: '6수 수상전',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [
        [3, 1], [3, 2], [3, 3],
        [4, 0], [4, 4], [4, 5],
      ],
      whiteStones: [
        [0, 3], [0, 4],
        [1, 1], [1, 3], [1, 4], [1, 5],
        [2, 0], [2, 1], [2, 2], [2, 3], [2, 5],
        [3, 4], [3, 5],
        [5, 5],
        [6, 5],
      ],
      correctMoves: [[5, 1]],
      moveSequence: [
        [5, 1],  // 흑1: 활로 줄이기
        [5, 0],  // 백2: 응수
        [5, 2],  // 흑3: 계속 압박
        [6, 2],  // 백4: 응수
        [6, 1],  // 흑5: 압박
        [6, 3],  // 백6: 응수
      ],
      explanation: '6수 만에 백의 활로를 줄여 잡는 수상전입니다.',
    ),

    // 3-18: 7수 수상전
    LifeDeathProblem(
      id: 30,
      name: '7수 수상전',
      difficulty: ProblemDifficulty.advanced,
      type: ProblemType.kill,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [
        [0, 5],
        [1, 5],
        [2, 6],
        [3, 2], [3, 6],
        [4, 0], [4, 6],
        [5, 0], [5, 5], [5, 6],
      ],
      whiteStones: [
        [1, 3], [1, 4],
        [2, 3], [2, 4],
        [3, 3], [3, 4], [3, 5],
        [4, 2], [4, 4], [4, 5],
        [5, 1], [5, 3], [5, 4],
        [6, 5],
      ],
      correctMoves: [[5, 2]],
      moveSequence: [
        [5, 2],  // 흑1: 치중
        [4, 3],  // 백2: 응수
        [6, 2],  // 흑3: 압박
        [6, 4],  // 백4: 응수
        [2, 5],  // 흑5: 끊기
        [6, 3],  // 백6: 응수
        [6, 1],  // 흑7: 마무리
      ],
      explanation: '7수 만에 백을 잡는 복잡한 수상전입니다. 흑5 끊기가 핵심입니다.',
    ),

    // 3-19: 5수 사활
    LifeDeathProblem(
      id: 31,
      name: '5수 사활',
      difficulty: ProblemDifficulty.intermediate,
      type: ProblemType.live,
      playerColor: Stone.black,
      boardSize: 7,
      blackStones: [
        [0, 4],
        [1, 4],
        [2, 1], [2, 2], [2, 5],
        [3, 3],
      ],
      whiteStones: [
        [0, 1],
        [1, 1], [1, 2], [1, 5],
        [2, 0], [2, 3], [2, 4], [2, 6],
        [3, 2], [3, 5], [3, 6],
      ],
      correctMoves: [[0, 5]],
      moveSequence: [
        [0, 5],  // 흑1: 눈 만들기
        [1, 6],  // 백2: 응수
        [0, 3],  // 흑3: 연결
        [0, 2],  // 백4: 응수
        [1, 3],  // 흑5: 두 눈 확보
      ],
      explanation: '5수 만에 흑이 두 눈을 만들어 사는 문제입니다.',
    ),
  ];

  static List<LifeDeathProblem> getByDifficulty(ProblemDifficulty difficulty) {
    return problems.where((p) => p.difficulty == difficulty).toList();
  }

  static LifeDeathProblem? getById(int id) {
    try {
      return problems.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // 유형별 문제 ID 매핑
  static const Map<String, List<int>> categoryProblems = {
    'youtubeBasics': [1, 2, 3, 4],           // 바둑 입문 (단수치기)
    'youtubeCapture': [1, 2, 3, 4],           // 돌 잡기 기초
    'youtubeLifeDeath': [5, 6, 9, 17, 24, 31],     // 사활 기초 (살기)
    'youtube3Space': [7, 8, 9],               // 3궁도 (직삼궁/곡삼궁)
    'youtube4Space': [13, 14, 15],            // 4궁도 (직사궁/곡사궁/꽃사궁)
    'youtube5Space': [16],                    // 5궁도 (오궁도화)
    'youtubeCorner': [13, 20, 22, 26],         // 귀 사활 (귀곡사)
    'youtubeThrowIn': [11],                   // 환격 (던져넣기)
    'youtubeCapturingRace': [18, 23, 25, 27, 28, 29, 30], // 수상전 (활로싸움)
  };

  static List<LifeDeathProblem> getByCategory(String category) {
    final ids = categoryProblems[category] ?? [];
    return problems.where((p) => ids.contains(p.id)).toList();
  }
}

// 사활 문제 선택 화면
class LifeDeathProblemSelector extends StatefulWidget {
  final GameLanguage language;

  const LifeDeathProblemSelector({
    super.key,
    required this.language,
  });

  @override
  State<LifeDeathProblemSelector> createState() => _LifeDeathProblemSelectorState();
}

class _LifeDeathProblemSelectorState extends State<LifeDeathProblemSelector> {
  Set<int> _solvedProblems = {};

  // 사활 유형 목록
  final List<Map<String, String>> _categories = [
    {'key': 'youtubeBasics', 'search': '바둑 입문 강좌'},
    {'key': 'youtubeCapture', 'search': '바둑 돌 잡기 기초'},
    {'key': 'youtubeLifeDeath', 'search': '바둑 사활 기초'},
    {'key': 'youtube3Space', 'search': '바둑 직삼궁 곡삼궁'},
    {'key': 'youtube4Space', 'search': '바둑 직사궁 곡사궁 꽃사궁'},
    {'key': 'youtube5Space', 'search': '바둑 오궁도화'},
    {'key': 'youtubeCorner', 'search': '바둑 귀곡사'},
    {'key': 'youtubeThrowIn', 'search': '바둑 환격 던져넣기'},
    {'key': 'youtubeCapturingRace', 'search': '바둑 수상전 활로싸움'},
  ];

  @override
  void initState() {
    super.initState();
    _loadSolvedProblems();
  }

  Future<void> _loadSolvedProblems() async {
    final prefs = await SharedPreferences.getInstance();
    final solved = prefs.getStringList('solvedProblems') ?? [];
    setState(() {
      _solvedProblems = solved.map((s) => int.parse(s)).toSet();
    });
  }

  void _openYoutubeSearch(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = 'https://www.youtube.com/results?search_query=$encodedQuery';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openProblemList(String categoryKey) {
    final problems = LifeDeathProblems.getByCategory(categoryKey);
    if (problems.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LifeDeathProblemGame(
          problems: problems,
          language: widget.language,
          categoryKey: categoryKey,
        ),
      ),
    ).then((_) => _loadSolvedProblems());
  }

  int _getSolvedCount(String categoryKey) {
    final problems = LifeDeathProblems.getByCategory(categoryKey);
    return problems.where((p) => _solvedProblems.contains(p.id)).length;
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 언어 상태 읽기
    final languageProvider = context.watch<LanguageProvider>();
    final language = languageProvider.language;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(language, 'lifeDeathProblems')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(2.5),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // 헤더
            TableRow(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Text(L10n.get(language, 'problemType'), style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Text(L10n.get(language, 'progress'), style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Text(L10n.get(language, 'video'), style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Text(L10n.get(language, 'problem'), style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              ],
            ),
            // 데이터 행
            ..._categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              final categoryKey = category['key']!;
              final searchQuery = category['search']!;
              final problems = LifeDeathProblems.getByCategory(categoryKey);
              final solvedCount = _getSolvedCount(categoryKey);
              final isEven = index % 2 == 0;

              return TableRow(
                decoration: BoxDecoration(
                  color: isEven ? Colors.white : Colors.grey.shade50,
                ),
                children: [
                  // 유형 이름
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Text(
                      L10n.get(widget.language, categoryKey),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  // 진행 상황
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Text(
                      problems.isEmpty ? '-' : '$solvedCount/${problems.length}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: solvedCount == problems.length && problems.isNotEmpty
                            ? Colors.green
                            : Colors.black87,
                        fontWeight: solvedCount == problems.length && problems.isNotEmpty
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  // 유튜브 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: IconButton(
                      onPressed: () => _openYoutubeSearch(searchQuery),
                      icon: const Icon(Icons.play_circle_fill, color: Colors.red),
                      tooltip: L10n.get(widget.language, 'watchYoutube'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  // 문제 풀기 버튼
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: problems.isEmpty
                      ? const Icon(Icons.remove, color: Colors.grey)
                      : IconButton(
                          onPressed: () => _openProblemList(categoryKey),
                          icon: const Icon(Icons.edit_note, color: Colors.blue),
                          tooltip: L10n.get(widget.language, 'solveProblem'),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// 유형별 문제 목록 화면
class CategoryProblemList extends StatefulWidget {
  final GameLanguage language;
  final String categoryKey;

  const CategoryProblemList({
    super.key,
    required this.language,
    required this.categoryKey,
  });

  @override
  State<CategoryProblemList> createState() => _CategoryProblemListState();
}

class _CategoryProblemListState extends State<CategoryProblemList> {
  Set<int> _solvedProblems = {};

  @override
  void initState() {
    super.initState();
    _loadSolvedProblems();
  }

  Future<void> _loadSolvedProblems() async {
    final prefs = await SharedPreferences.getInstance();
    final solved = prefs.getStringList('solvedProblems') ?? [];
    setState(() {
      _solvedProblems = solved.map((s) => int.parse(s)).toSet();
    });
  }

  Future<void> _markAsSolved(int problemId) async {
    final prefs = await SharedPreferences.getInstance();
    _solvedProblems.add(problemId);
    await prefs.setStringList(
      'solvedProblems',
      _solvedProblems.map((i) => i.toString()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final problems = LifeDeathProblems.getByCategory(widget.categoryKey);
    final solvedCount = problems.where((p) => _solvedProblems.contains(p.id)).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(widget.language, widget.categoryKey)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 진행 상황
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  '${L10n.get(widget.language, 'solvedCount')}: $solvedCount/${problems.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    value: problems.isEmpty ? 0 : solvedCount / problems.length,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Colors.blue),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          // 문제 목록
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: problems.length,
              itemBuilder: (context, index) {
                final problem = problems[index];
                final isSolved = _solvedProblems.contains(problem.id);

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LifeDeathProblemGame(
                          problems: problems,
                          initialIndex: index,
                          language: widget.language,
                          categoryKey: widget.categoryKey,
                        ),
                      ),
                    );
                    await _loadSolvedProblems();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSolved ? Colors.green.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSolved ? Colors.green : Colors.grey.shade300,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSolved)
                          const Icon(Icons.check_circle, color: Colors.green, size: 24),
                        Text(
                          problem.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSolved ? Colors.green.shade700 : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          problem.type == ProblemType.kill
                              ? (problem.playerColor == Stone.black
                                  ? L10n.get(widget.language, 'killWhite')
                                  : L10n.get(widget.language, 'killBlack'))
                              : problem.type == ProblemType.cut
                                  ? (problem.playerColor == Stone.black
                                      ? L10n.get(widget.language, 'cutWhite')
                                      : L10n.get(widget.language, 'cutBlack'))
                                  : (problem.playerColor == Stone.black
                                      ? L10n.get(widget.language, 'liveWithBlack')
                                      : L10n.get(widget.language, 'liveWithWhite')),
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// 사활 문제 풀이 화면
class LifeDeathProblemGame extends StatefulWidget {
  final List<LifeDeathProblem> problems;
  final int initialIndex;
  final GameLanguage language;
  final String? categoryKey;

  const LifeDeathProblemGame({
    super.key,
    required this.problems,
    this.initialIndex = 0,
    required this.language,
    this.categoryKey,
  });

  @override
  State<LifeDeathProblemGame> createState() => _LifeDeathProblemGameState();
}

class _LifeDeathProblemGameState extends State<LifeDeathProblemGame> {
  late List<List<Stone>> _board;
  late int _boardSize;
  late int _currentIndex;
  late LifeDeathProblem _currentProblem;
  bool _isSolved = false;
  bool _showingAnswer = false;
  List<List<int>> _playerMoves = [];
  String _message = '';
  List<int>? _lastMove;
  List<int>? _hintMove;
  int _sequenceStep = 0; // 다수 문제에서 현재 단계
  bool _waitingForAI = false; // AI 응수 대기 중
  Set<int> _solvedProblems = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _currentProblem = widget.problems[_currentIndex];
    _loadSolvedProblems();
    _initializeBoard();
  }

  Future<void> _loadSolvedProblems() async {
    final prefs = await SharedPreferences.getInstance();
    final solved = prefs.getStringList('solvedProblems') ?? [];
    setState(() {
      _solvedProblems = solved.map((s) => int.parse(s)).toSet();
    });
  }

  Future<void> _markCurrentAsSolved() async {
    final prefs = await SharedPreferences.getInstance();
    _solvedProblems.add(_currentProblem.id);
    await prefs.setStringList(
      'solvedProblems',
      _solvedProblems.map((i) => i.toString()).toList(),
    );
  }

  void _switchToProblem(int index) {
    if (index < 0 || index >= widget.problems.length) return;
    setState(() {
      _currentIndex = index;
      _currentProblem = widget.problems[index];
      _initializeBoard();
    });
  }

  void _initializeBoard() {
    _boardSize = _currentProblem.boardSize;
    _board = List.generate(
      _boardSize,
      (_) => List.generate(_boardSize, (_) => Stone.none),
    );

    // 흑돌 배치
    for (final pos in _currentProblem.blackStones) {
      if (pos[0] < _boardSize && pos[1] < _boardSize) {
        _board[pos[0]][pos[1]] = Stone.black;
      }
    }

    // 백돌 배치
    for (final pos in _currentProblem.whiteStones) {
      if (pos[0] < _boardSize && pos[1] < _boardSize) {
        _board[pos[0]][pos[1]] = Stone.white;
      }
    }

    _isSolved = false;
    _showingAnswer = false;
    _playerMoves = [];
    _message = '';
    _lastMove = null;
    _hintMove = null;
    _sequenceStep = 0;
    _waitingForAI = false;
  }

  void _resetBoard() {
    setState(() {
      _initializeBoard();
    });
  }

  // 다수 문제인지 확인
  bool get _isMultiMoveProbblem =>
      _currentProblem.moveSequence != null &&
      _currentProblem.moveSequence!.length > 1;

  // 현재 단계의 정답 확인
  bool _isCorrectMoveForStep(int row, int col, int step) {
    debugPrint('_isCorrectMoveForStep: isMultiMove=$_isMultiMoveProbblem');
    if (_isMultiMoveProbblem) {
      final sequence = _currentProblem.moveSequence!;
      // step * 2가 사용자의 수 (0, 2, 4, ...)
      final playerMoveIndex = step * 2;
      debugPrint('_isCorrectMoveForStep: playerMoveIndex=$playerMoveIndex, seqLen=${sequence.length}');
      if (playerMoveIndex < sequence.length) {
        final expected = sequence[playerMoveIndex];
        debugPrint('_isCorrectMoveForStep: expected=$expected, got=[$row,$col]');
        return expected[0] == row && expected[1] == col;
      }
      return false;
    } else {
      // 기존 한 수 문제
      for (final correct in _currentProblem.correctMoves) {
        if (correct[0] == row && correct[1] == col) {
          return true;
        }
      }
      if (_currentProblem.alternativeMoves != null) {
        for (final alt in _currentProblem.alternativeMoves!) {
          if (alt[0] == row && alt[1] == col) {
            return true;
          }
        }
      }
      return false;
    }
  }

  // AI 응수 색상 (사용자 반대)
  Stone get _aiColor => _currentProblem.playerColor == Stone.black
      ? Stone.white
      : Stone.black;

  // AI 응수 실행
  void _executeAIResponse() {
    if (!_isMultiMoveProbblem) return;

    final sequence = _currentProblem.moveSequence!;
    // step * 2 + 1이 AI의 수 (1, 3, 5, ...)
    final aiMoveIndex = _sequenceStep * 2 + 1;

    if (aiMoveIndex < sequence.length) {
      final aiMove = sequence[aiMoveIndex];
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _board[aiMove[0]][aiMove[1]] = _aiColor;
            _lastMove = aiMove;
            _sequenceStep++;
            _waitingForAI = false;
            _hintMove = null; // 힌트 마커 초기화
            _message = ''; // 메시지 초기화
          });
        }
      });
    }
  }

  // 다수 문제의 총 사용자 수 개수
  int get _totalPlayerMoves {
    if (!_isMultiMoveProbblem) return 1;
    return (_currentProblem.moveSequence!.length + 1) ~/ 2;
  }

  void _onTap(int row, int col) {
    debugPrint('_onTap: _isSolved=$_isSolved, _showingAnswer=$_showingAnswer, _waitingForAI=$_waitingForAI');
    if (_isSolved || _waitingForAI) {
      debugPrint('_onTap: early return due to state');
      return;
    }

    // 정답 보기 상태 처리
    bool wasShowingAnswer = _showingAnswer;
    if (_showingAnswer) {
      if (_hintMove == null || _hintMove![0] != row || _hintMove![1] != col) {
        debugPrint('_onTap: showing answer but wrong position tapped');
        return;
      }
      debugPrint('_onTap: correct answer position tapped, clearing _showingAnswer');
    }

    debugPrint('_onTap: board[$row][$col]=${_board[row][col]}');
    if (_board[row][col] != Stone.none) {
      debugPrint('_onTap: early return - cell not empty');
      return;
    }

    final isCorrect = _isCorrectMoveForStep(row, col, _sequenceStep);
    debugPrint('_onTap: isCorrect=$isCorrect, step=$_sequenceStep');

    if (isCorrect) {
      // 정답
      setState(() {
        _hintMove = null;
        _showingAnswer = false;  // 정답 보기 상태 해제
        _board[row][col] = _currentProblem.playerColor;
        _playerMoves.add([row, col]);
        _lastMove = [row, col];
      });

      if (_isMultiMoveProbblem) {
        final sequence = _currentProblem.moveSequence!;
        final aiMoveIndex = _sequenceStep * 2 + 1;

        if (aiMoveIndex < sequence.length) {
          // AI 응수가 있으면 실행
          setState(() {
            _waitingForAI = true;
            _message = '';
          });
          _executeAIResponse();
        } else {
          // 마지막 수였으면 성공
          setState(() {
            _isSolved = true;
            _message = L10n.get(widget.language, 'correct');
          });
        }
      } else {
        // 한 수 문제는 바로 성공
        setState(() {
          _isSolved = true;
          _message = L10n.get(widget.language, 'correct');
        });
      }
    } else {
      // 오답
      setState(() {
        _board[row][col] = _currentProblem.playerColor;
        _lastMove = [row, col];
        _message = L10n.get(widget.language, 'incorrect');
      });

      // 잠시 후 돌 제거 (또는 AI 반격)
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _board[row][col] = Stone.none;
            _lastMove = null;
            _message = '';
          });
        }
      });
    }
  }

  void _showAnswer() {
    if (_isSolved) return;
    setState(() {
      _showingAnswer = true;
      if (_isMultiMoveProbblem) {
        // 현재 단계의 정답을 표시
        final sequence = _currentProblem.moveSequence!;
        final playerMoveIndex = _sequenceStep * 2;
        if (playerMoveIndex < sequence.length) {
          _hintMove = sequence[playerMoveIndex];
        }
      } else if (_currentProblem.correctMoves.isNotEmpty) {
        final answer = _currentProblem.correctMoves[0];
        _hintMove = answer;
      }
    });
  }

  void _showHint() {
    debugPrint('_showHint: _isSolved=$_isSolved, _showingAnswer=$_showingAnswer, _waitingForAI=$_waitingForAI, step=$_sequenceStep');
    // AI가 응수 중일 때는 힌트를 표시하지 않음
    if (_isSolved || _showingAnswer || _waitingForAI) {
      debugPrint('_showHint: early return');
      return;
    }
    setState(() {
      if (_isMultiMoveProbblem) {
        // 현재 단계의 힌트
        final sequence = _currentProblem.moveSequence!;
        final playerMoveIndex = _sequenceStep * 2;
        debugPrint('_showHint: playerMoveIndex=$playerMoveIndex, seqLen=${sequence.length}');
        if (playerMoveIndex < sequence.length) {
          _hintMove = sequence[playerMoveIndex];
          debugPrint('_showHint: set hintMove=$_hintMove');
        }
      } else if (_currentProblem.correctMoves.isNotEmpty) {
        _hintMove = _currentProblem.correctMoves[0];
        debugPrint('_showHint: set hintMove from correctMoves=$_hintMove');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryKey != null
              ? '${L10n.get(widget.language, widget.categoryKey!)} (${_currentIndex + 1}/${widget.problems.length})'
              : _currentProblem.name,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: _showHint,
            tooltip: L10n.get(widget.language, 'hint'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 문제 설명
          Container(
            padding: const EdgeInsets.all(16),
            color: _currentProblem.playerColor == Stone.black
                ? Colors.grey.shade800
                : Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentProblem.playerColor == Stone.black
                        ? Colors.black
                        : Colors.white,
                    border: Border.all(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  _currentProblem.type == ProblemType.kill
                      ? (_currentProblem.playerColor == Stone.black
                          ? L10n.get(widget.language, 'killWhite')
                          : L10n.get(widget.language, 'killBlack'))
                      : _currentProblem.type == ProblemType.cut
                          ? (_currentProblem.playerColor == Stone.black
                              ? L10n.get(widget.language, 'cutWhite')
                              : L10n.get(widget.language, 'cutBlack'))
                          : (_currentProblem.playerColor == Stone.black
                              ? L10n.get(widget.language, 'liveWithBlack')
                              : L10n.get(widget.language, 'liveWithWhite')),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _currentProblem.playerColor == Stone.black
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // 메시지 표시
          if (_message.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              color: _isSolved ? Colors.green : Colors.red.shade100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isSolved ? Icons.check_circle : Icons.close,
                    color: _isSolved ? Colors.white : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _message,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _isSolved ? Colors.white : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          // 정답 시 설명 표시
          if (_isSolved && _currentProblem.explanation != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.blue.shade50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _currentProblem.explanation!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue.shade900,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // 바둑판
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // 문제 영역만 표시 (7x7 영역으로 제한)
                        final displaySize = 7;
                        final cellSize = constraints.maxWidth / displaySize;

                        return CustomPaint(
                          painter: ProblemBoardPainter(
                            boardSize: displaySize,
                          ),
                          child: SizedBox.expand(
                            child: Stack(
                              children: [
                                // 돌 및 터치 영역
                                for (int row = 0; row < displaySize; row++)
                                  for (int col = 0; col < displaySize; col++)
                                    Positioned(
                                      left: col * cellSize,
                                      top: row * cellSize,
                                      width: cellSize,
                                      height: cellSize,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          debugPrint('TAP: row=$row, col=$col');
                                          _onTap(row, col);
                                        },
                                        child: Center(
                                          child: _buildStone(row, col, cellSize),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 하단 버튼
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _resetBoard,
                  icon: const Icon(Icons.refresh),
                  tooltip: L10n.get(widget.language, 'retry'),
                ),
                if (!_isSolved && !_showingAnswer)
                  IconButton(
                    onPressed: _showAnswer,
                    icon: const Icon(Icons.visibility, color: Colors.orange),
                    tooltip: L10n.get(widget.language, 'showAnswer'),
                  ),
                // 마지막 문제가 아닐 때만 다음 버튼 표시
                if (_isSolved && _currentIndex < widget.problems.length - 1)
                  IconButton(
                    onPressed: () async {
                      await _markCurrentAsSolved();
                      _switchToProblem(_currentIndex + 1);
                    },
                    icon: const Icon(Icons.arrow_forward, color: Colors.green),
                    tooltip: L10n.get(widget.language, 'nextProblem'),
                  ),
              ],
            ),
          ),
          // 문제 번호 선택
          Container(
            padding: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.problems.length, (index) {
                  final problem = widget.problems[index];
                  final isCurrent = index == _currentIndex;
                  final isSolved = _solvedProblems.contains(problem.id);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => _switchToProblem(index),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? Colors.blue
                              : isSolved
                                  ? Colors.green.shade100
                                  : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isCurrent
                                ? Colors.blue.shade700
                                : isSolved
                                    ? Colors.green
                                    : Colors.grey.shade400,
                            width: isCurrent ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: isSolved && !isCurrent
                              ? const Icon(Icons.check, color: Colors.green, size: 20)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCurrent ? Colors.white : Colors.black87,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStone(int row, int col, double cellSize) {
    final stone = _board[row][col];
    final isLastMove = _lastMove != null && _lastMove![0] == row && _lastMove![1] == col;
    final isHint = _hintMove != null && _hintMove![0] == row && _hintMove![1] == col;

    if (stone == Stone.none) {
      // 힌트 또는 정답 표시
      if (isHint) {
        // 정답 보기: 초록색, 힌트: 노란색
        final isAnswer = _showingAnswer;
        final markerColor = isAnswer ? Colors.green.withOpacity(0.7) : Colors.yellow.withOpacity(0.7);
        final borderColor = isAnswer ? Colors.green.shade700 : Colors.orange;
        final icon = isAnswer ? Icons.check : Icons.lightbulb;

        // IgnorePointer로 감싸서 Icon이 터치 이벤트를 방해하지 않도록 함
        return IgnorePointer(
          child: Container(
            width: cellSize * 0.5,
            height: cellSize * 0.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: markerColor,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Icon(icon, size: 16, color: borderColor),
          ),
        );
      }
      return const SizedBox();
    }

    final stoneSize = cellSize * 0.9;
    return Container(
      width: stoneSize,
      height: stoneSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: stone == Stone.black
              ? [Colors.grey.shade700, Colors.black]
              : [Colors.white, Colors.grey.shade300],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 3,
            offset: const Offset(2, 2),
          ),
        ],
        border: stone == Stone.white
            ? Border.all(color: Colors.grey.shade400, width: 0.5)
            : null,
      ),
      child: isLastMove
          ? Center(
              child: Container(
                width: stoneSize * 0.3,
                height: stoneSize * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stone == Stone.black ? Colors.white : Colors.black,
                ),
              ),
            )
          : null,
    );
  }
}

// 문제용 바둑판 페인터
class ProblemBoardPainter extends CustomPainter {
  final int boardSize;

  ProblemBoardPainter({required this.boardSize});

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = size.width / boardSize;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final padding = cellSize / 2;

    // 세로선 - 왼쪽 위 귀 바둑판
    // 모든 세로선은 첫 번째 가로줄(위쪽 변)에서 시작하여 아래쪽 끝까지 연장
    for (int i = 0; i < boardSize; i++) {
      final x = padding + i * cellSize;
      canvas.drawLine(
        Offset(x, padding),  // 위쪽 변에서 시작
        Offset(x, size.height),  // 아래쪽 끝까지 연장
        paint,
      );
    }

    // 가로선 - 왼쪽 위 귀 바둑판
    // 모든 가로선은 첫 번째 세로줄(왼쪽 변)에서 시작하여 오른쪽 끝까지 연장
    for (int i = 0; i < boardSize; i++) {
      final y = padding + i * cellSize;
      canvas.drawLine(
        Offset(padding, y),  // 왼쪽 변에서 시작
        Offset(size.width, y),  // 오른쪽 끝까지 연장
        paint,
      );
    }

    // 화점 (3x3 위치에만)
    if (boardSize >= 7) {
      final dotPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;
      final dotRadius = cellSize * 0.1;

      // 귀 화점
      canvas.drawCircle(
        Offset(padding + 2 * cellSize, padding + 2 * cellSize),
        dotRadius,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ProblemBoardPainter oldDelegate) {
    return oldDelegate.boardSize != boardSize;
  }
}

// MCTS 노드 클래스
class MCTSNode {
  final List<int>? move;
  MCTSNode? parent;
  List<MCTSNode> children = [];
  int visits = 0;
  double wins = 0.0;
  List<List<int>> untriedMoves;
  final Stone player;

  MCTSNode({
    this.move,
    this.parent,
    required this.untriedMoves,
    required this.player,
  });

  // UCB1 값 계산
  double ucb1(double explorationConstant) {
    if (visits == 0) return double.infinity;
    return (wins / visits) +
        explorationConstant * sqrt(log(parent!.visits) / visits);
  }

  // 가장 좋은 자식 선택 (UCB1 기반)
  MCTSNode selectChild(double explorationConstant) {
    MCTSNode? best;
    double bestValue = double.negativeInfinity;
    for (var child in children) {
      double value = child.ucb1(explorationConstant);
      if (value > bestValue) {
        bestValue = value;
        best = child;
      }
    }
    return best!;
  }

  // 확장 가능한지 확인
  bool get isFullyExpanded => untriedMoves.isEmpty;

  // 터미널 노드인지 확인
  bool get isTerminal => children.isEmpty && untriedMoves.isEmpty;

  // 가장 많이 방문한 자식 반환 (최종 수 선택용)
  MCTSNode? getMostVisitedChild() {
    if (children.isEmpty) return null;
    return children.reduce((a, b) => a.visits > b.visits ? a : b);
  }
}

// AI 설정 클래스
class AISettings {
  final int mctsIterations;
  final int playoutDepth;
  final double explorationConstant;
  final bool useHeuristics;
  final double randomness;
  final int candidateCount;

  const AISettings({
    required this.mctsIterations,
    required this.playoutDepth,
    required this.explorationConstant,
    required this.useHeuristics,
    required this.randomness,
    required this.candidateCount,
  });

  // 디바이스 성능을 고려한 AI 설정 생성
  static AISettings forDifficulty(AIDifficulty difficulty) {
    final multiplier = DeviceBenchmark.multiplier;

    // 기본값 (중간 성능 기준)
    int baseIterations;
    int baseDepth;
    double exploration;
    bool useHeuristics;
    double randomness;
    int baseCandidates;

    switch (difficulty) {
      case AIDifficulty.advanced:
        // 고급: 강한 AI
        baseIterations = 2000;
        baseDepth = 100;
        exploration = 1.5;
        useHeuristics = true;
        randomness = 0.05;
        baseCandidates = 15;
        break;
      case AIDifficulty.expert:
        // 전문가: PC 성능 기준 최대 성능
        baseIterations = 5000;
        baseDepth = 150;
        exploration = 1.6;
        useHeuristics = true;
        randomness = 0.01;
        baseCandidates = 20;
        break;
    }

    // 디바이스 성능에 따라 조정
    return AISettings(
      mctsIterations: (baseIterations * multiplier).round().clamp(10, 10000),
      playoutDepth: (baseDepth * multiplier).round().clamp(10, 300),
      explorationConstant: exploration,
      useHeuristics: useHeuristics,
      randomness: randomness,
      candidateCount: (baseCandidates * multiplier).round().clamp(3, 30),
    );
  }

  // 설정 정보 문자열
  String get info => 'MCTS: $mctsIterations, Depth: $playoutDepth, Candidates: $candidateCount';
}

extension StoneExtension on Stone {
  Stone get opponent {
    switch (this) {
      case Stone.black:
        return Stone.white;
      case Stone.white:
        return Stone.black;
      case Stone.none:
        return Stone.none;
    }
  }
}

class BadukGame extends StatefulWidget {
  final bool vsAI;
  final Stone playerColor;
  final GameLanguage language;
  final AIDifficulty aiDifficulty;
  final bool loadSavedGame;

  const BadukGame({
    super.key,
    required this.vsAI,
    this.playerColor = Stone.black,
    required this.language,
    this.aiDifficulty = AIDifficulty.advanced,
    this.loadSavedGame = false,
  });

  @override
  State<BadukGame> createState() => _BadukGameState();
}

class _BadukGameState extends State<BadukGame> {
  late int boardSize;
  late List<List<Stone>> board;
  Stone currentPlayer = Stone.black;
  bool gameOver = false;
  String gameMessage = '';
  int blackCaptures = 0;
  int whiteCaptures = 0;
  int consecutivePasses = 0;
  String? lastBoardState;
  List<List<int>>? lastMove;
  bool showTerritory = false;
  Map<String, int> territoryCount = {'black': 0, 'white': 0};
  bool isAIThinking = false;
  final Random _random = Random();
  late AISettings _aiSettings;

  // AI 계산 시간 표시
  Timer? _thinkingTimer;
  int _thinkingSeconds = 0;
  Stopwatch? _thinkingStopwatch;

  // 힌트 관련 변수
  List<int>? hintMove;
  bool showHint = false;

  // 이어하기를 위한 수 기록
  List<Map<String, dynamic>> moveHistory = [];

  // 패턴 데이터베이스
  final Map<String, List<List<int>>> _josekiDatabase = {};

  // 트랜스포지션 테이블 (캐시)
  final Map<String, double> _transpositionTable = {};

  String tr(String key) => L10n.get(widget.language, key);

  Stone get aiColor => widget.playerColor.opponent;

  @override
  void initState() {
    super.initState();
    boardSize = 19;
    _aiSettings = AISettings.forDifficulty(widget.aiDifficulty);
    _initJosekiDatabase();
    _initBoard();

    // 이어하기: 저장된 게임 자동 불러오기
    if (widget.loadSavedGame) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadGame();
      });
    } else if (widget.vsAI && aiColor == Stone.black) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _aiMove();
      });
    }
  }

  @override
  void dispose() {
    _stopThinkingTimer();
    super.dispose();
  }

  // 타이머 시작 (AI 계산 시간 표시)
  void _startThinkingTimer() {
    _thinkingSeconds = 0;
    _thinkingStopwatch = Stopwatch()..start();
    _thinkingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _thinkingSeconds = _thinkingStopwatch?.elapsed.inSeconds ?? 0;
        gameMessage = tr('aiThinkingTime').replaceAll('{time}', '$_thinkingSeconds');
      });
    });
  }

  // 타이머 정지
  void _stopThinkingTimer() {
    _thinkingTimer?.cancel();
    _thinkingTimer = null;
    _thinkingStopwatch?.stop();
    _thinkingStopwatch = null;
  }

  // 정석 데이터베이스 초기화
  void _initJosekiDatabase() {
    // 화점 정석
    _josekiDatabase['corner_33'] = [
      [3, 3], [15, 3], [3, 15], [15, 15]
    ];

    // 소목 정석
    _josekiDatabase['corner_34'] = [
      [3, 4], [4, 3], [15, 4], [16, 3],
      [3, 14], [4, 15], [15, 14], [16, 15]
    ];

    // 고목 정석
    _josekiDatabase['corner_35'] = [
      [3, 5], [5, 3], [15, 5], [16, 5],
      [3, 13], [5, 15], [15, 13], [16, 13]
    ];

    // 화점 협공
    _josekiDatabase['approach_33'] = [
      [5, 3], [3, 5], [5, 15], [3, 13],
      [13, 3], [15, 5], [13, 15], [15, 13]
    ];

    // 날일자 정석
    _josekiDatabase['knight_move'] = [
      [4, 6], [6, 4], [4, 12], [6, 14],
      [14, 6], [12, 4], [14, 12], [12, 14]
    ];

    // 두 칸 벌림
    _josekiDatabase['two_space_extension'] = [
      [3, 6], [6, 3], [3, 12], [6, 15],
      [15, 6], [12, 3], [15, 12], [12, 15]
    ];
  }

  void _initBoard() {
    board = List.generate(
      boardSize,
      (_) => List.generate(boardSize, (_) => Stone.none),
    );
    currentPlayer = Stone.black;
    gameOver = false;
    if (widget.vsAI) {
      String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
      if (aiColor == Stone.black) {
        gameMessage = tr('aiThinking');
      } else {
        gameMessage = '${tr('yourTurn')} ($colorName)';
      }
    } else {
      gameMessage = tr('blackTurn');
    }
    blackCaptures = 0;
    whiteCaptures = 0;
    consecutivePasses = 0;
    lastBoardState = null;
    lastMove = null;
    showTerritory = false;
    territoryCount = {'black': 0, 'white': 0};
    isAIThinking = false;
    hintMove = null;
    showHint = false;
    moveHistory = [];
  }

  void _resetGame() {
    setState(() {
      _initBoard();
    });
    if (widget.vsAI && aiColor == Stone.black) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _aiMove();
      });
    }
  }

  void _changeBoardSize(int size) {
    setState(() {
      boardSize = size;
      _initBoard();
    });
  }

  String _boardToString() {
    return board.map((row) => row.map((s) => s.index).join()).join();
  }

  bool _tryPlaceStone(int row, int col, {bool isAI = false}) {
    if (gameOver || board[row][col] != Stone.none) return false;
    if (!isAI && isAIThinking) return false;

    board[row][col] = currentPlayer;

    List<List<int>> capturedStones = [];
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == currentPlayer.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          capturedStones.addAll(group);
        }
      }
    }

    if (capturedStones.isEmpty) {
      var myGroup = _getGroup(row, col);
      if (_getLiberties(myGroup).isEmpty) {
        board[row][col] = Stone.none;
        return false;
      }
    }

    String beforeCapture = _boardToString();

    for (var stone in capturedStones) {
      board[stone[0]][stone[1]] = Stone.none;
    }

    String afterCapture = _boardToString();
    if (lastBoardState != null && afterCapture == lastBoardState) {
      board[row][col] = Stone.none;
      for (var stone in capturedStones) {
        board[stone[0]][stone[1]] = currentPlayer.opponent;
      }
      if (!isAI) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('koViolation'))),
        );
      }
      return false;
    }

    setState(() {
      if (currentPlayer == Stone.black) {
        blackCaptures += capturedStones.length;
      } else {
        whiteCaptures += capturedStones.length;
      }

      // 수 기록 저장
      moveHistory.add({
        'row': row,
        'col': col,
        'player': currentPlayer.index,
        'captures': capturedStones.length,
        'isPass': false,
      });

      lastBoardState = beforeCapture;
      lastMove = [[row, col]];
      consecutivePasses = 0;

      currentPlayer = currentPlayer.opponent;
      _updateMessage();
    });

    // 자동 저장
    _autoSave();

    return true;
  }

  void _placeStone(int row, int col) {
    if (!_tryPlaceStone(row, col)) return;

    // 힌트 숨기기
    setState(() {
      showHint = false;
      hintMove = null;
    });

    if (widget.vsAI && currentPlayer == aiColor && !gameOver) {
      _aiMove();
    }
  }

  // 힌트 기능: 플레이어에게 추천 수를 보여줌
  void _showHint() {
    if (gameOver || isAIThinking) return;

    // vs AI 모드에서만, 플레이어 차례일 때만
    if (widget.vsAI && currentPlayer != widget.playerColor) return;

    setState(() {
      isAIThinking = true;
      gameMessage = tr('aiThinking');
    });
    _startThinkingTimer();

    Future.delayed(const Duration(milliseconds: 100), () {
      List<int>? hint = _findHintMove();

      _stopThinkingTimer();
      setState(() {
        isAIThinking = false;
        if (hint != null) {
          hintMove = hint;
          showHint = true;
          gameMessage = tr('hintMessage');
        } else {
          hintMove = null;
          showHint = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('noHint'))),
          );
          _updateMessage();
        }
      });
    });
  }

  // 힌트용 최적 수 찾기 (초반 정석 + 중후반 MCTS)
  List<int>? _findHintMove() {
    Stone playerColor = widget.vsAI ? widget.playerColor : currentPlayer;

    List<List<int>> validMoves = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && _isValidMove(i, j, playerColor)) {
          validMoves.add([i, j]);
        }
      }
    }

    if (validMoves.isEmpty) return null;

    // 초반 정석 기반 힌트 (빠른 응답)
    int stoneCount = _countStones();
    int earlyGameThreshold = boardSize == 19 ? 20 : (boardSize == 13 ? 12 : 8);

    if (stoneCount < earlyGameThreshold) {
      List<int>? josekiHint = _findHintMoveJoseki(validMoves, playerColor);
      if (josekiHint != null) return josekiHint;
    }

    // 중후반: MCTS (전문가 레벨, 디바이스 성능에 따라 자동 조정)
    final expertSettings = AISettings.forDifficulty(AIDifficulty.expert);
    final int hintIterations = expertSettings.mctsIterations;
    final int hintPlayoutDepth = expertSettings.playoutDepth;
    final double hintExploration = expertSettings.explorationConstant;
    final int hintCandidateCount = expertSettings.candidateCount;

    // 보드 상태 저장
    List<List<Stone>> originalBoard = List.generate(
      boardSize, (i) => List.from(board[i])
    );

    // 영향력 맵 계산
    _calculateInfluenceMap();

    // 후보 수 점수화 (플레이어 관점으로 평가)
    List<MapEntry<List<int>, int>> scoredMoves = [];
    for (var move in validMoves) {
      int score = _evaluateMoveForHint(move[0], move[1], playerColor);
      scoredMoves.add(MapEntry(move, score));
    }
    scoredMoves.sort((a, b) => b.value.compareTo(a.value));

    // 상위 후보만 MCTS 수행
    int candidateCount = min(hintCandidateCount, scoredMoves.length);
    List<List<int>> candidates = scoredMoves.take(candidateCount).map((e) => e.key).toList();

    // 루트 노드 생성
    MCTSNode root = MCTSNode(
      untriedMoves: List.from(candidates),
      player: playerColor,
    );

    // MCTS 반복
    for (int i = 0; i < hintIterations; i++) {
      // 보드 복원
      _restoreBoard(originalBoard);

      // Selection & Expansion
      MCTSNode node = root;
      Stone currentMCTSPlayer = playerColor;

      // Selection: 트리를 따라 내려가기
      while (node.isFullyExpanded && node.children.isNotEmpty) {
        node = node.selectChild(hintExploration);
        if (node.move != null) {
          board[node.move![0]][node.move![1]] = currentMCTSPlayer;
          _removeCapturedStones(node.move![0], node.move![1], currentMCTSPlayer);
        }
        currentMCTSPlayer = currentMCTSPlayer.opponent;
      }

      // Expansion: 새 노드 추가
      if (node.untriedMoves.isNotEmpty) {
        var move = node.untriedMoves.removeAt(_random.nextInt(node.untriedMoves.length));
        if (_isValidMoveSimple(move[0], move[1], currentMCTSPlayer)) {
          board[move[0]][move[1]] = currentMCTSPlayer;
          _removeCapturedStones(move[0], move[1], currentMCTSPlayer);

          List<List<int>> nextMoves = _getValidMovesForPlayer(currentMCTSPlayer.opponent);
          MCTSNode child = MCTSNode(
            move: move,
            parent: node,
            untriedMoves: nextMoves.take(10).toList(),
            player: currentMCTSPlayer,
          );
          node.children.add(child);
          node = child;
          currentMCTSPlayer = currentMCTSPlayer.opponent;
        }
      }

      // Simulation: 가중치 기반 플레이아웃
      double result = _hintPlayout(currentMCTSPlayer, playerColor, hintPlayoutDepth);

      // Backpropagation: 결과 전파 (플레이어 관점)
      while (node.parent != null) {
        node.visits++;
        if (node.player == playerColor) {
          node.wins += result;
        } else {
          node.wins += 1.0 - result;
        }
        node = node.parent!;
      }
      root.visits++;
    }

    // 보드 복원
    _restoreBoard(originalBoard);

    // 가장 많이 방문한 수 선택
    MCTSNode? bestChild = root.getMostVisitedChild();
    if (bestChild != null && bestChild.move != null) {
      return bestChild.move;
    }

    // 폴백: 상위 후보 중 첫 번째
    return candidates.isNotEmpty ? candidates.first : null;
  }

  // 초반 정석 기반 힌트 (플레이어 관점)
  List<int>? _findHintMoveJoseki(List<List<int>> validMoves, Stone playerColor) {
    int stoneCount = _countStones();
    Stone opponent = playerColor.opponent;

    // 첫 수: 화점 또는 소목 추천
    if (stoneCount == 0) {
      List<List<int>> openings = [
        ..._josekiDatabase['corner_33'] ?? [],
        ..._josekiDatabase['corner_34'] ?? [],
      ];
      for (var move in openings) {
        if (validMoves.any((m) => m[0] == move[0] && m[1] == move[1])) {
          return move;
        }
      }
    }

    // 빈 코너 차지하기
    List<List<int>> corners = [
      ..._josekiDatabase['corner_33'] ?? [],
      ..._josekiDatabase['corner_34'] ?? [],
      ..._josekiDatabase['corner_35'] ?? [],
    ];
    for (var corner in corners) {
      if (validMoves.any((m) => m[0] == corner[0] && m[1] == corner[1])) {
        // 주변에 돌이 없으면 추천
        bool hasNearbyStone = false;
        for (int di = -2; di <= 2; di++) {
          for (int dj = -2; dj <= 2; dj++) {
            int ni = corner[0] + di;
            int nj = corner[1] + dj;
            if (_isValidPosition(ni, nj) && board[ni][nj] != Stone.none) {
              hasNearbyStone = true;
              break;
            }
          }
          if (hasNearbyStone) break;
        }
        if (!hasNearbyStone) return corner;
      }
    }

    // 상대 코너에 협공
    for (var corner in _josekiDatabase['corner_33'] ?? []) {
      if (board[corner[0]][corner[1]] == opponent) {
        List<List<int>> approaches = _josekiDatabase['approach_33'] ?? [];
        for (var approach in approaches) {
          if (_isNearCorner(approach, corner) &&
              validMoves.any((m) => m[0] == approach[0] && m[1] == approach[1])) {
            return approach;
          }
        }
      }
    }

    // 자기 돌 근처 날일자 확장
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == playerColor && _isCornerStone(i, j)) {
          for (var knight in _josekiDatabase['knight_move'] ?? []) {
            if (_isNearCorner(knight, [i, j]) &&
                validMoves.any((m) => m[0] == knight[0] && m[1] == knight[1])) {
              return knight;
            }
          }
          // 두 칸 벌림
          for (var ext in _josekiDatabase['two_space_extension'] ?? []) {
            if (_isNearCorner(ext, [i, j]) &&
                validMoves.any((m) => m[0] == ext[0] && m[1] == ext[1])) {
              return ext;
            }
          }
        }
      }
    }

    // 변 차지하기 (3선 또는 4선)
    List<List<int>> sidePoints = [];
    int line3 = boardSize == 19 ? 2 : (boardSize == 13 ? 2 : 2);
    int line4 = boardSize == 19 ? 3 : (boardSize == 13 ? 3 : 2);

    for (int i = line3; i <= line4; i++) {
      for (int j = 5; j < boardSize - 5; j += 3) {
        sidePoints.add([i, j]);
        sidePoints.add([boardSize - 1 - i, j]);
        sidePoints.add([j, i]);
        sidePoints.add([j, boardSize - 1 - i]);
      }
    }

    for (var point in sidePoints) {
      if (validMoves.any((m) => m[0] == point[0] && m[1] == point[1])) {
        bool hasNearbyStone = false;
        for (int di = -2; di <= 2; di++) {
          for (int dj = -2; dj <= 2; dj++) {
            int ni = point[0] + di;
            int nj = point[1] + dj;
            if (_isValidPosition(ni, nj) && board[ni][nj] != Stone.none) {
              hasNearbyStone = true;
              break;
            }
          }
          if (hasNearbyStone) break;
        }
        if (!hasNearbyStone) return point;
      }
    }

    return null;  // 정석 힌트 없음 -> MCTS로 폴백
  }

  // 힌트용 수 평가 (플레이어 관점)
  int _evaluateMoveForHint(int row, int col, Stone player) {
    int score = 0;
    Stone opponent = player.opponent;

    // 1. 잡을 수 있는 돌
    int captures = _countCaptures(row, col, player);
    score += captures * 100;

    // 2. 단수 상태 그룹 구하기
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player) {
        var group = _getGroup(nr, nc);
        var liberties = _getLiberties(group);
        if (liberties.length == 1) {
          board[row][col] = player;
          var newLiberties = _getLiberties(_getGroup(nr, nc));
          board[row][col] = Stone.none;
          if (newLiberties.length >= 2) {
            score += 80 + group.length * 10;
          }
        }
      }
    }

    // 3. 상대 위협 방어
    int threatCaptures = _countCaptures(row, col, opponent);
    if (threatCaptures >= 1) {
      score += threatCaptures * 50;
    }

    // 4. 연결성
    int connections = 0;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player) {
        connections++;
      }
    }
    score += connections * 15;

    // 5. 활로 확보
    board[row][col] = player;
    var group = _getGroup(row, col);
    var liberties = _getLiberties(group);
    board[row][col] = Stone.none;
    score += liberties.length * 8;

    // 6. 전략적 위치
    score += _calculateStrategicValue(row, col);

    // 7. 영향력
    double influence = _influenceMap[row][col];
    if (player == Stone.black) {
      score -= (influence * 10).round();
    } else {
      score += (influence * 10).round();
    }

    // 8. 공격 잠재력 (상대 단수 만들기)
    board[row][col] = player;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == opponent) {
        var oppGroup = _getGroup(nr, nc);
        var oppLiberties = _getLiberties(oppGroup);
        if (oppLiberties.length <= 2) {
          score += (4 - oppLiberties.length) * oppGroup.length * 5;
        }
      }
    }
    board[row][col] = Stone.none;

    return score;
  }

  // 힌트용 플레이아웃 (플레이어 관점 승률 계산)
  double _hintPlayout(Stone startPlayer, Stone hintPlayer, int maxMoves) {
    Stone currentSim = startPlayer;
    int moves = 0;
    int passes = 0;

    while (moves < maxMoves && passes < 2) {
      List<List<int>> simMoves = [];
      List<double> weights = [];

      for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
          if (board[i][j] == Stone.none && _isValidMoveSimple(i, j, currentSim)) {
            simMoves.add([i, j]);
            double weight = _calculateMoveWeight(i, j, currentSim);
            weights.add(weight);
          }
        }
      }

      if (simMoves.isEmpty) {
        passes++;
        currentSim = currentSim.opponent;
        continue;
      }

      passes = 0;

      // 가중치 기반 선택
      double totalWeight = weights.reduce((a, b) => a + b);
      double r = _random.nextDouble() * totalWeight;
      int selectedIndex = 0;
      double cumulative = 0;
      for (int i = 0; i < weights.length; i++) {
        cumulative += weights[i];
        if (r <= cumulative) {
          selectedIndex = i;
          break;
        }
      }

      var move = simMoves[selectedIndex];
      board[move[0]][move[1]] = currentSim;
      _removeCapturedStones(move[0], move[1], currentSim);

      currentSim = currentSim.opponent;
      moves++;
    }

    // 점수 계산 (플레이어 관점)
    int playerScore = 0;
    int opponentScore = 0;
    Stone opponent = hintPlayer.opponent;

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == hintPlayer) {
          playerScore++;
        } else if (board[i][j] == opponent) {
          opponentScore++;
        } else {
          // 영역 추정
          int playerInfluence = 0;
          int opponentInfluence = 0;
          for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
            int nr = i + dir[0];
            int nc = j + dir[1];
            if (_isValidPosition(nr, nc)) {
              if (board[nr][nc] == hintPlayer) playerInfluence++;
              if (board[nr][nc] == opponent) opponentInfluence++;
            }
          }
          if (playerInfluence > opponentInfluence) playerScore++;
          else if (opponentInfluence > playerInfluence) opponentScore++;
        }
      }
    }

    // 덤 적용
    double finalPlayerScore = playerScore.toDouble();
    double finalOpponentScore = opponentScore + 6.5;
    if (hintPlayer == Stone.white) {
      finalPlayerScore = playerScore + 6.5;
      finalOpponentScore = opponentScore.toDouble();
    }

    if (finalPlayerScore > finalOpponentScore) {
      return 1.0;
    } else if (finalPlayerScore < finalOpponentScore) {
      return 0.0;
    }
    return 0.5;
  }

  void _updateMessage() {
    if (widget.vsAI) {
      String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
      if (currentPlayer == widget.playerColor) {
        gameMessage = '${tr('yourTurn')} ($colorName)';
      } else {
        gameMessage = tr('aiThinking');
      }
    } else {
      gameMessage = currentPlayer == Stone.black ? tr('blackTurn') : tr('whiteTurn');
    }
  }

  // ============ 게임 저장/불러오기 ============

  // 게임 저장
  Future<void> _saveGame() async {
    final prefs = await SharedPreferences.getInstance();

    // 게임 상태를 JSON으로 변환
    Map<String, dynamic> gameState = {
      'boardSize': boardSize,
      'board': board.map((row) => row.map((s) => s.index).toList()).toList(),
      'currentPlayer': currentPlayer.index,
      'gameOver': gameOver,
      'blackCaptures': blackCaptures,
      'whiteCaptures': whiteCaptures,
      'consecutivePasses': consecutivePasses,
      'lastBoardState': lastBoardState,
      'lastMove': lastMove,
      'moveHistory': moveHistory,
      'vsAI': widget.vsAI,
      'playerColor': widget.playerColor.index,
      'aiDifficulty': widget.aiDifficulty.index,
      'saveTime': DateTime.now().toIso8601String(),
    };

    await prefs.setString('savedGame', jsonEncode(gameState));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('gameSaved'))),
      );
    }
  }

  // 자동 저장 (무음)
  Future<void> _autoSave() async {
    // 게임이 끝났으면 저장 안 함
    if (gameOver) return;

    final prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> gameState = {
      'boardSize': boardSize,
      'board': board.map((row) => row.map((s) => s.index).toList()).toList(),
      'currentPlayer': currentPlayer.index,
      'gameOver': gameOver,
      'blackCaptures': blackCaptures,
      'whiteCaptures': whiteCaptures,
      'consecutivePasses': consecutivePasses,
      'lastBoardState': lastBoardState,
      'lastMove': lastMove,
      'moveHistory': moveHistory,
      'vsAI': widget.vsAI,
      'playerColor': widget.playerColor.index,
      'aiDifficulty': widget.aiDifficulty.index,
      'saveTime': DateTime.now().toIso8601String(),
    };

    await prefs.setString('savedGame', jsonEncode(gameState));
  }

  // 저장된 게임이 있는지 확인
  static Future<Map<String, dynamic>?> getSavedGameInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('savedGame');

    if (savedData != null) {
      try {
        return jsonDecode(savedData) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // 게임 불러오기
  Future<void> _loadGame() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('savedGame');

    if (savedData == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('noSavedGame'))),
        );
      }
      return;
    }

    try {
      Map<String, dynamic> gameState = jsonDecode(savedData);

      setState(() {
        boardSize = gameState['boardSize'];
        board = (gameState['board'] as List)
            .map((row) => (row as List).map((s) => Stone.values[s]).toList())
            .toList();
        currentPlayer = Stone.values[gameState['currentPlayer']];
        gameOver = gameState['gameOver'];
        blackCaptures = gameState['blackCaptures'];
        whiteCaptures = gameState['whiteCaptures'];
        consecutivePasses = gameState['consecutivePasses'];
        lastBoardState = gameState['lastBoardState'];

        if (gameState['lastMove'] != null) {
          lastMove = (gameState['lastMove'] as List)
              .map((m) => (m as List).cast<int>().toList())
              .toList();
        } else {
          lastMove = null;
        }

        if (gameState['moveHistory'] != null) {
          moveHistory = (gameState['moveHistory'] as List)
              .map((m) => Map<String, dynamic>.from(m))
              .toList();
        } else {
          moveHistory = [];
        }

        showTerritory = false;
        territoryCount = {'black': 0, 'white': 0};
        isAIThinking = false;
        hintMove = null;
        showHint = false;

        _updateMessage();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tr('gameLoaded'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // 저장된 게임 삭제
  static Future<void> deleteSavedGame() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedGame');
  }

  void _aiMove() {
    setState(() {
      isAIThinking = true;
      gameMessage = tr('aiThinking');
    });
    _startThinkingTimer();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (gameOver) {
        _stopThinkingTimer();
        return;
      }

      List<int>? bestMove = _findBestMove();

      if (bestMove != null) {
        _tryPlaceStone(bestMove[0], bestMove[1], isAI: true);
      } else {
        _pass(isAI: true);
      }

      _stopThinkingTimer();
      setState(() {
        isAIThinking = false;
        if (!gameOver) {
          String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
          gameMessage = '${tr('yourTurn')} ($colorName)';
        }
      });
    });
  }

  // ============ 고급 AI ============

  // 영향력 맵 캐시
  late List<List<double>> _influenceMap;

  List<int>? _findBestMove() {
    List<List<int>> validMoves = [];

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && _isValidMove(i, j, aiColor)) {
          validMoves.add([i, j]);
        }
      }
    }

    if (validMoves.isEmpty) return null;

    // 초반 정석 기반 빠른 응답 (모든 난이도)
    int stoneCount = _countStones();
    int earlyGameThreshold = boardSize == 19 ? 20 : (boardSize == 13 ? 12 : 8);

    if (stoneCount < earlyGameThreshold) {
      List<int>? josekiMove = _findAIJosekiMove(validMoves);
      if (josekiMove != null) return josekiMove;
    }

    // 난이도별 랜덤성 추가 (초급은 가끔 실수)
    if (_random.nextDouble() < _aiSettings.randomness) {
      // 좋은 수 중에서 랜덤 선택
      List<List<int>> reasonableMoves = _getReasonableMoves(validMoves);
      if (reasonableMoves.isNotEmpty) {
        return reasonableMoves[_random.nextInt(reasonableMoves.length)];
      }
    }

    // 영향력 맵 계산
    _calculateInfluenceMap();

    // 우선순위 1: 많은 돌을 잡을 수 있는 수 (2개 이상)
    int maxCaptures = 0;
    List<int>? captureMove;
    for (var move in validMoves) {
      int captures = _countCaptures(move[0], move[1], aiColor);
      if (captures > maxCaptures) {
        maxCaptures = captures;
        captureMove = move;
      }
    }
    if (maxCaptures >= 2) return captureMove;

    // 우선순위 2: 단수인 자기 그룹 구하기 (중요 그룹)
    List<int>? saveMove = _findSaveMove(validMoves);
    if (saveMove != null) return saveMove;

    // 우선순위 3: 사활 - 상대 그룹 죽이기
    List<int>? killMove = _findKillMoveAdvanced(validMoves);
    if (killMove != null) return killMove;

    // 우선순위 4: 사다리 공격 (고급 난이도에서만)
    if (_aiSettings.useHeuristics) {
      List<int>? ladderMove = _findLadderAttack(validMoves);
      if (ladderMove != null) return ladderMove;
    }

    // 우선순위 5: 상대 그룹을 단수로 만들기 (큰 그룹)
    List<int>? atariMove = _findAtariMove(validMoves);
    if (atariMove != null) return atariMove;

    // 우선순위 6: 1개라도 잡기
    if (captureMove != null) return captureMove;

    // 우선순위 7: 상대 공격 방어
    List<int>? blockMove = _findBlockMove(validMoves);
    if (blockMove != null) return blockMove;

    // 우선순위 8: 끊기 수 (상대 연결 차단)
    if (_aiSettings.useHeuristics) {
      List<int>? cutMove = _findCutMove(validMoves);
      if (cutMove != null) return cutMove;
    }

    // 우선순위 9: 압박 수
    List<int>? pressureMove = _findPressureMove(validMoves);
    if (pressureMove != null) return pressureMove;

    // 우선순위 10: 코시미/날일자 공격
    if (_aiSettings.useHeuristics) {
      List<int>? kosimiMove = _findKosimiMove(validMoves);
      if (kosimiMove != null) return kosimiMove;
    }

    // 우선순위 11: MCTS 또는 몬테카를로 시뮬레이션 기반 최적 수
    if (widget.aiDifficulty == AIDifficulty.expert) {
      return _findBestMoveWithMCTS(validMoves);
    } else {
      return _findBestMoveWithMonteCarlo(validMoves);
    }
  }

  // 합리적인 수 목록 (초급 AI용)
  List<List<int>> _getReasonableMoves(List<List<int>> validMoves) {
    List<List<int>> reasonable = [];
    for (var move in validMoves) {
      // 1선 피하기
      if (move[0] == 0 || move[0] == boardSize - 1 ||
          move[1] == 0 || move[1] == boardSize - 1) {
        continue;
      }
      // 자기 돌 근처 또는 상대 돌 근처
      bool nearStone = false;
      for (int dr = -2; dr <= 2; dr++) {
        for (int dc = -2; dc <= 2; dc++) {
          int nr = move[0] + dr;
          int nc = move[1] + dc;
          if (_isValidPosition(nr, nc) && board[nr][nc] != Stone.none) {
            nearStone = true;
            break;
          }
        }
        if (nearStone) break;
      }
      if (nearStone || _countStones() < 4) {
        reasonable.add(move);
      }
    }
    return reasonable.isEmpty ? validMoves : reasonable;
  }

  // AI 초반 정석 기반 수 (빠른 응답)
  List<int>? _findAIJosekiMove(List<List<int>> validMoves) {
    int stoneCount = _countStones();
    Stone opponent = aiColor.opponent;

    // 첫 수: 화점 또는 소목
    if (stoneCount == 0) {
      List<List<int>> openings = [
        ..._josekiDatabase['corner_33'] ?? [],
        ..._josekiDatabase['corner_34'] ?? [],
      ];
      openings.shuffle(_random);
      for (var move in openings) {
        if (validMoves.any((m) => m[0] == move[0] && m[1] == move[1])) {
          return move;
        }
      }
    }

    // 긴급 상황 체크: 단수 그룹 구하기
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == aiColor) {
          var group = _getGroup(i, j);
          var liberties = _getLiberties(group);
          if (liberties.length == 1 && group.length >= 2) {
            // 단수 탈출
            for (var move in validMoves) {
              board[move[0]][move[1]] = aiColor;
              var newLiberties = _getLiberties(_getGroup(i, j));
              board[move[0]][move[1]] = Stone.none;
              if (newLiberties.length >= 2) {
                return move;
              }
            }
          }
        }
      }
    }

    // 잡을 수 있는 돌 체크
    for (var move in validMoves) {
      int captures = _countCaptures(move[0], move[1], aiColor);
      if (captures >= 2) return move;
    }

    // 빈 코너 차지하기
    List<List<int>> corners = [
      ..._josekiDatabase['corner_33'] ?? [],
      ..._josekiDatabase['corner_34'] ?? [],
    ];
    corners.shuffle(_random);
    for (var corner in corners) {
      if (validMoves.any((m) => m[0] == corner[0] && m[1] == corner[1])) {
        bool hasNearbyStone = false;
        for (int di = -2; di <= 2; di++) {
          for (int dj = -2; dj <= 2; dj++) {
            int ni = corner[0] + di;
            int nj = corner[1] + dj;
            if (_isValidPosition(ni, nj) && board[ni][nj] != Stone.none) {
              hasNearbyStone = true;
              break;
            }
          }
          if (hasNearbyStone) break;
        }
        if (!hasNearbyStone) return corner;
      }
    }

    // 상대 코너에 협공
    for (var corner in _josekiDatabase['corner_33'] ?? []) {
      if (board[corner[0]][corner[1]] == opponent) {
        List<List<int>> approaches = _josekiDatabase['approach_33'] ?? [];
        List<List<int>> validApproaches = [];
        for (var approach in approaches) {
          if (_isNearCorner(approach, corner) &&
              validMoves.any((m) => m[0] == approach[0] && m[1] == approach[1])) {
            validApproaches.add(approach);
          }
        }
        if (validApproaches.isNotEmpty) {
          return validApproaches[_random.nextInt(validApproaches.length)];
        }
      }
    }

    // 자기 돌 근처 날일자/두칸 벌림
    List<List<int>> myCornerStones = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == aiColor && _isCornerStone(i, j)) {
          myCornerStones.add([i, j]);
        }
      }
    }

    if (myCornerStones.isNotEmpty) {
      myCornerStones.shuffle(_random);
      for (var stone in myCornerStones) {
        // 날일자 확장
        List<List<int>> knightMoves = [];
        for (var knight in _josekiDatabase['knight_move'] ?? []) {
          if (_isNearCorner(knight, stone) &&
              validMoves.any((m) => m[0] == knight[0] && m[1] == knight[1])) {
            knightMoves.add(knight);
          }
        }
        if (knightMoves.isNotEmpty) {
          return knightMoves[_random.nextInt(knightMoves.length)];
        }

        // 두 칸 벌림
        List<List<int>> extensions = [];
        for (var ext in _josekiDatabase['two_space_extension'] ?? []) {
          if (_isNearCorner(ext, stone) &&
              validMoves.any((m) => m[0] == ext[0] && m[1] == ext[1])) {
            extensions.add(ext);
          }
        }
        if (extensions.isNotEmpty) {
          return extensions[_random.nextInt(extensions.length)];
        }
      }
    }

    // 변 차지하기 (3선/4선)
    List<List<int>> sidePoints = [];
    int line3 = boardSize == 19 ? 2 : (boardSize == 13 ? 2 : 2);
    int line4 = boardSize == 19 ? 3 : (boardSize == 13 ? 3 : 2);

    for (int i = line3; i <= line4; i++) {
      for (int j = 5; j < boardSize - 5; j += 3) {
        sidePoints.add([i, j]);
        sidePoints.add([boardSize - 1 - i, j]);
        sidePoints.add([j, i]);
        sidePoints.add([j, boardSize - 1 - i]);
      }
    }
    sidePoints.shuffle(_random);

    for (var point in sidePoints) {
      if (validMoves.any((m) => m[0] == point[0] && m[1] == point[1])) {
        bool hasNearbyStone = false;
        for (int di = -2; di <= 2; di++) {
          for (int dj = -2; dj <= 2; dj++) {
            int ni = point[0] + di;
            int nj = point[1] + dj;
            if (_isValidPosition(ni, nj) && board[ni][nj] != Stone.none) {
              hasNearbyStone = true;
              break;
            }
          }
          if (hasNearbyStone) break;
        }
        if (!hasNearbyStone) return point;
      }
    }

    return null;  // 정석 수 없음 -> 일반 로직으로 폴백
  }

  // 고급 정석 수
  List<int>? _getOpeningMoveAdvanced(List<List<int>> validMoves) {
    int stoneCount = _countStones();

    // 첫 수: 정석 데이터베이스에서 선택
    if (stoneCount == 0) {
      List<List<int>> openings = [
        ..._josekiDatabase['corner_33'] ?? [],
        ..._josekiDatabase['corner_34'] ?? [],
      ];
      openings.shuffle(_random);
      for (var move in openings) {
        if (validMoves.any((m) => m[0] == move[0] && m[1] == move[1])) {
          return move;
        }
      }
    }

    // 정석 응수
    if (stoneCount < 8) {
      List<int>? josekiResponse = _findJosekiResponse(validMoves);
      if (josekiResponse != null) return josekiResponse;
    }

    // 코너 접근
    if (stoneCount < 12) {
      List<int>? cornerApproach = _findCornerApproach(validMoves);
      if (cornerApproach != null) return cornerApproach;
    }

    return null;
  }

  // 정석 응수 찾기
  List<int>? _findJosekiResponse(List<List<int>> validMoves) {
    // 상대가 코너에 두었으면 협공 또는 협공
    for (var corner in _josekiDatabase['corner_33'] ?? []) {
      if (board[corner[0]][corner[1]] == widget.playerColor) {
        // 협공 수 찾기
        List<List<int>> approaches = _josekiDatabase['approach_33'] ?? [];
        for (var approach in approaches) {
          if (_isNearCorner(approach, corner) &&
              validMoves.any((m) => m[0] == approach[0] && m[1] == approach[1])) {
            return approach;
          }
        }
      }
    }

    // 날일자 확장
    for (var stone in _getAIStones()) {
      if (_isCornerStone(stone[0], stone[1])) {
        for (var knight in _josekiDatabase['knight_move'] ?? []) {
          if (_isNearCorner(knight, stone) &&
              validMoves.any((m) => m[0] == knight[0] && m[1] == knight[1])) {
            return knight;
          }
        }
      }
    }

    return null;
  }

  bool _isNearCorner(List<int> point, List<int> corner) {
    int dist = (point[0] - corner[0]).abs() + (point[1] - corner[1]).abs();
    return dist <= 6;
  }

  bool _isCornerStone(int row, int col) {
    int margin = boardSize == 19 ? 5 : (boardSize == 13 ? 4 : 3);
    return (row < margin || row >= boardSize - margin) &&
           (col < margin || col >= boardSize - margin);
  }

  List<List<int>> _getAIStones() {
    List<List<int>> stones = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == aiColor) {
          stones.add([i, j]);
        }
      }
    }
    return stones;
  }

  // 코시미 (붙여두기) 수 찾기
  List<int>? _findKosimiMove(List<List<int>> validMoves) {
    int bestScore = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      int score = 0;

      // 상대 돌에 대각선으로 붙이기 (코시미)
      for (var diag in [[-1, -1], [-1, 1], [1, -1], [1, 1]]) {
        int dr = move[0] + diag[0];
        int dc = move[1] + diag[1];
        if (_isValidPosition(dr, dc) && board[dr][dc] == widget.playerColor) {
          // 빈 점이 공유되는지 확인
          int sharedEmpty = 0;
          for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
            int nr = move[0] + dir[0];
            int nc = move[1] + dir[1];
            int or = dr + dir[0];
            int oc = dc + dir[1];
            if (_isValidPosition(nr, nc) && board[nr][nc] == Stone.none &&
                _isValidPosition(or, oc) && board[or][oc] == Stone.none) {
              sharedEmpty++;
            }
          }
          if (sharedEmpty >= 1) {
            var group = _getGroup(dr, dc);
            score += group.length * 5;
          }
        }
      }

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    if (bestScore >= 10) return bestMove;
    return null;
  }

  // 고급 사활 분석
  List<int>? _findKillMoveAdvanced(List<List<int>> validMoves) {
    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      // 인접한 상대 그룹 확인
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);

          // 활로가 1-2개이고 눈이 없는 그룹
          if (liberties.length <= 2 && group.length >= 2) {
            // 진짜 눈 분석
            int realEyes = _countRealEyes(group);
            if (realEyes < 2) {
              board[move[0]][move[1]] = Stone.none;
              return move;
            }
          }

          // 큰 그룹이지만 눈이 부족한 경우
          if (liberties.length <= 3 && group.length >= 5) {
            int realEyes = _countRealEyes(group);
            if (realEyes == 0) {
              board[move[0]][move[1]] = Stone.none;
              return move;
            }
          }
        }
      }
      board[move[0]][move[1]] = Stone.none;
    }
    return null;
  }

  // 진짜 눈 개수 계산
  int _countRealEyes(List<List<int>> group) {
    Set<String> groupSet = {};
    for (var stone in group) {
      groupSet.add('${stone[0]},${stone[1]}');
    }

    int realEyes = 0;
    Set<String> checkedEmpty = {};

    for (var stone in group) {
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = stone[0] + dir[0];
        int nc = stone[1] + dir[1];
        String key = '$nr,$nc';

        if (!checkedEmpty.contains(key) && _isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
          checkedEmpty.add(key);

          // 진짜 눈인지 확인: 4방향 모두 자기 돌 또는 가장자리
          int surrounded = 0;
          int diagonal = 0;
          int diagonalOpponent = 0;

          for (var d in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
            int nnr = nr + d[0];
            int nnc = nc + d[1];
            if (!_isValidPosition(nnr, nnc) || groupSet.contains('$nnr,$nnc')) {
              surrounded++;
            }
          }

          // 대각선 확인 (코너 안전성)
          for (var d in [[-1, -1], [-1, 1], [1, -1], [1, 1]]) {
            int nnr = nr + d[0];
            int nnc = nc + d[1];
            if (_isValidPosition(nnr, nnc)) {
              if (board[nnr][nnc] == widget.playerColor) {
                diagonalOpponent++;
              } else if (groupSet.contains('$nnr,$nnc') || !_isValidPosition(nnr, nnc)) {
                diagonal++;
              }
            } else {
              diagonal++;
            }
          }

          // 진짜 눈 조건: 4방향 둘러싸임 + 대각선 안전
          if (surrounded == 4 && diagonalOpponent <= 1) {
            realEyes++;
          }
        }
      }
    }

    return realEyes;
  }

  // MCTS (Monte Carlo Tree Search) 알고리즘
  List<int>? _findBestMoveWithMCTS(List<List<int>> validMoves) {
    if (validMoves.isEmpty) return null;

    // 보드 상태 저장
    List<List<Stone>> originalBoard = List.generate(
      boardSize, (i) => List.from(board[i])
    );

    // 후보 수 점수화 및 필터링
    List<MapEntry<List<int>, int>> scoredMoves = [];
    for (var move in validMoves) {
      int score = _evaluateMoveAdvanced(move[0], move[1]);
      scoredMoves.add(MapEntry(move, score));
    }
    scoredMoves.sort((a, b) => b.value.compareTo(a.value));

    // 상위 후보만 MCTS 수행
    int candidateCount = min(_aiSettings.candidateCount, scoredMoves.length);
    List<List<int>> candidates = scoredMoves.take(candidateCount).map((e) => e.key).toList();

    // 루트 노드 생성
    MCTSNode root = MCTSNode(
      untriedMoves: List.from(candidates),
      player: aiColor,
    );

    // MCTS 반복
    for (int i = 0; i < _aiSettings.mctsIterations; i++) {
      // 보드 복원
      _restoreBoard(originalBoard);

      // Selection & Expansion
      MCTSNode node = root;
      Stone currentMCTSPlayer = aiColor;

      // Selection: 트리를 따라 내려가기
      while (node.isFullyExpanded && node.children.isNotEmpty) {
        node = node.selectChild(_aiSettings.explorationConstant);
        if (node.move != null) {
          board[node.move![0]][node.move![1]] = currentMCTSPlayer;
          _removeCapturedStones(node.move![0], node.move![1], currentMCTSPlayer);
        }
        currentMCTSPlayer = currentMCTSPlayer.opponent;
      }

      // Expansion: 새 노드 추가
      if (node.untriedMoves.isNotEmpty) {
        var move = node.untriedMoves.removeAt(_random.nextInt(node.untriedMoves.length));
        if (_isValidMoveSimple(move[0], move[1], currentMCTSPlayer)) {
          board[move[0]][move[1]] = currentMCTSPlayer;
          _removeCapturedStones(move[0], move[1], currentMCTSPlayer);

          List<List<int>> nextMoves = _getValidMovesForPlayer(currentMCTSPlayer.opponent);
          MCTSNode child = MCTSNode(
            move: move,
            parent: node,
            untriedMoves: nextMoves.take(10).toList(),
            player: currentMCTSPlayer,
          );
          node.children.add(child);
          node = child;
          currentMCTSPlayer = currentMCTSPlayer.opponent;
        }
      }

      // Simulation: 랜덤 플레이아웃 (가중치 적용)
      double result = _weightedPlayout(currentMCTSPlayer);

      // Backpropagation: 결과 전파
      while (node.parent != null) {
        node.visits++;
        // AI 관점에서의 승률
        if (node.player == aiColor) {
          node.wins += result;
        } else {
          node.wins += 1.0 - result;
        }
        node = node.parent!;
      }
      root.visits++;
    }

    // 보드 복원
    _restoreBoard(originalBoard);

    // 가장 많이 방문한 수 선택
    MCTSNode? bestChild = root.getMostVisitedChild();
    if (bestChild != null && bestChild.move != null) {
      return bestChild.move;
    }

    // 폴백: 기존 몬테카를로
    return _findBestMoveWithMonteCarlo(validMoves);
  }

  void _restoreBoard(List<List<Stone>> originalBoard) {
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        board[i][j] = originalBoard[i][j];
      }
    }
  }

  List<List<int>> _getValidMovesForPlayer(Stone player) {
    List<List<int>> moves = [];
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && _isValidMoveSimple(i, j, player)) {
          moves.add([i, j]);
        }
      }
    }
    return moves;
  }

  // 가중치 기반 플레이아웃
  double _weightedPlayout(Stone startPlayer) {
    Stone currentSim = startPlayer;
    int moves = 0;
    int maxMoves = _aiSettings.playoutDepth;
    int passes = 0;

    while (moves < maxMoves && passes < 2) {
      List<List<int>> simMoves = [];
      List<double> weights = [];

      for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
          if (board[i][j] == Stone.none && _isValidMoveSimple(i, j, currentSim)) {
            simMoves.add([i, j]);
            // 가중치 계산
            double weight = _calculateMoveWeight(i, j, currentSim);
            weights.add(weight);
          }
        }
      }

      if (simMoves.isEmpty) {
        passes++;
      } else {
        passes = 0;
        // 가중치 기반 선택
        List<int> selectedMove = _selectWeightedMove(simMoves, weights);
        board[selectedMove[0]][selectedMove[1]] = currentSim;
        _removeCapturedStones(selectedMove[0], selectedMove[1], currentSim);
      }

      currentSim = currentSim.opponent;
      moves++;
    }

    // 결과 평가
    int aiTerritory = _countTerritory(aiColor);
    int playerTerritory = _countTerritory(widget.playerColor);

    if (aiTerritory > playerTerritory) {
      return 1.0;
    } else if (aiTerritory < playerTerritory) {
      return 0.0;
    } else {
      return 0.5;
    }
  }

  double _calculateMoveWeight(int row, int col, Stone player) {
    double weight = 1.0;

    // 1선 페널티
    int edgeDist = _getEdgeDistance(row, col);
    if (edgeDist == 0) weight *= 0.1;
    else if (edgeDist == 1) weight *= 0.5;

    // 잡기 보너스
    int captures = _countCaptures(row, col, player);
    if (captures > 0) weight *= (1.0 + captures * 2.0);

    // 연결 보너스
    int connections = 0;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player) {
        connections++;
      }
    }
    weight *= (1.0 + connections * 0.3);

    // 상대 근처 보너스
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == player.opponent) {
        weight *= 1.5;
        break;
      }
    }

    return weight;
  }

  List<int> _selectWeightedMove(List<List<int>> moves, List<double> weights) {
    double totalWeight = weights.fold(0.0, (sum, w) => sum + w);
    if (totalWeight <= 0) {
      return moves[_random.nextInt(moves.length)];
    }

    double r = _random.nextDouble() * totalWeight;
    double cumulative = 0.0;
    for (int i = 0; i < moves.length; i++) {
      cumulative += weights[i];
      if (r <= cumulative) {
        return moves[i];
      }
    }
    return moves.last;
  }

  // 초반 정석 수
  List<int>? _getOpeningMove(List<List<int>> validMoves) {
    int stoneCount = _countStones();

    // 첫 수: 화점 또는 소목
    if (stoneCount == 0) {
      List<List<int>> goodOpenings = [];
      if (boardSize == 19) {
        goodOpenings = [[3, 3], [3, 15], [15, 3], [15, 15], [3, 4], [4, 3], [15, 4], [16, 3]];
      } else if (boardSize == 13) {
        goodOpenings = [[3, 3], [3, 9], [9, 3], [9, 9], [6, 6]];
      } else {
        goodOpenings = [[2, 2], [2, 6], [6, 2], [6, 6], [4, 4]];
      }
      for (var move in goodOpenings) {
        if (validMoves.any((m) => m[0] == move[0] && m[1] == move[1])) {
          return move;
        }
      }
    }

    // 코너 접근
    if (stoneCount < 8) {
      List<int>? cornerApproach = _findCornerApproach(validMoves);
      if (cornerApproach != null) return cornerApproach;
    }

    return null;
  }

  // 코너 접근 수
  List<int>? _findCornerApproach(List<List<int>> validMoves) {
    // 상대 코너 돌에 접근
    List<List<int>> corners = boardSize == 19
        ? [[3, 3], [3, 15], [15, 3], [15, 15]]
        : boardSize == 13
            ? [[3, 3], [3, 9], [9, 3], [9, 9]]
            : [[2, 2], [2, 6], [6, 2], [6, 6]];

    for (var corner in corners) {
      if (board[corner[0]][corner[1]] == widget.playerColor) {
        // 접근 수 찾기
        List<List<int>> approaches = _getApproachMoves(corner[0], corner[1]);
        for (var approach in approaches) {
          if (validMoves.any((m) => m[0] == approach[0] && m[1] == approach[1])) {
            return approach;
          }
        }
      }
    }
    return null;
  }

  List<List<int>> _getApproachMoves(int row, int col) {
    List<List<int>> approaches = [];
    int offset = boardSize == 19 ? 3 : 2;

    // 한 칸 날일자, 두 칸 벌림 등
    List<List<int>> offsets = [
      [-offset, 1], [-offset, -1], [offset, 1], [offset, -1],
      [1, -offset], [-1, -offset], [1, offset], [-1, offset],
      [-offset + 1, 0], [offset - 1, 0], [0, -offset + 1], [0, offset - 1],
    ];

    for (var off in offsets) {
      int nr = row + off[0];
      int nc = col + off[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
        approaches.add([nr, nc]);
      }
    }
    return approaches;
  }

  // 사활: 상대 그룹 죽이기
  List<int>? _findKillMove(List<List<int>> validMoves) {
    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      // 인접한 상대 그룹 확인
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);

          // 활로가 1-2개이고 눈이 없는 그룹
          if (liberties.length <= 2 && group.length >= 3 && !_hasEyeSpace(group)) {
            board[move[0]][move[1]] = Stone.none;
            return move;
          }
        }
      }
      board[move[0]][move[1]] = Stone.none;
    }
    return null;
  }

  // 눈 공간이 있는지 확인
  bool _hasEyeSpace(List<List<int>> group) {
    Set<String> groupSet = {};
    for (var stone in group) {
      groupSet.add('${stone[0]},${stone[1]}');
    }

    int potentialEyes = 0;
    Set<String> checkedEmpty = {};

    for (var stone in group) {
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = stone[0] + dir[0];
        int nc = stone[1] + dir[1];
        String key = '$nr,$nc';

        if (!checkedEmpty.contains(key) && _isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
          checkedEmpty.add(key);

          // 이 빈 점이 눈이 될 수 있는지 확인
          int surroundingOwn = 0;
          int surroundingEdge = 0;
          for (var d in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
            int nnr = nr + d[0];
            int nnc = nc + d[1];
            if (!_isValidPosition(nnr, nnc)) {
              surroundingEdge++;
            } else if (groupSet.contains('$nnr,$nnc')) {
              surroundingOwn++;
            }
          }

          if (surroundingOwn + surroundingEdge >= 3) {
            potentialEyes++;
          }
        }
      }
    }

    return potentialEyes >= 2;
  }

  // 사다리 공격
  List<int>? _findLadderAttack(List<List<int>> validMoves) {
    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          if (group.length <= 2) {
            var liberties = _getLiberties(group);
            if (liberties.length == 1) {
              // 사다리 성공 여부 확인
              if (_isLadderWorking(group, 0)) {
                board[move[0]][move[1]] = Stone.none;
                return move;
              }
            }
          }
        }
      }
      board[move[0]][move[1]] = Stone.none;
    }
    return null;
  }

  // 사다리가 성공하는지 확인 (재귀적)
  bool _isLadderWorking(List<List<int>> group, int depth) {
    if (depth > 15) return false; // 깊이 제한

    var liberties = _getLiberties(group);
    if (liberties.isEmpty) return true; // 잡힘
    if (liberties.length >= 2) return false; // 탈출

    // 상대가 도망가는 수
    String libKey = liberties.first;
    var parts = libKey.split(',');
    int escapeRow = int.parse(parts[0]);
    int escapeCol = int.parse(parts[1]);

    if (!_isValidMove(escapeRow, escapeCol, widget.playerColor)) {
      return true; // 도망갈 수 없음
    }

    board[escapeRow][escapeCol] = widget.playerColor;
    var newGroup = _getGroup(escapeRow, escapeCol);
    var newLiberties = _getLiberties(newGroup);

    if (newLiberties.length >= 3) {
      board[escapeRow][escapeCol] = Stone.none;
      return false; // 탈출 성공
    }

    // AI가 쫓는 수
    for (String lib in newLiberties) {
      var p = lib.split(',');
      int chaseRow = int.parse(p[0]);
      int chaseCol = int.parse(p[1]);

      if (_isValidMove(chaseRow, chaseCol, aiColor)) {
        board[chaseRow][chaseCol] = aiColor;
        bool works = _isLadderWorking(newGroup, depth + 1);
        board[chaseRow][chaseCol] = Stone.none;

        if (works) {
          board[escapeRow][escapeCol] = Stone.none;
          return true;
        }
      }
    }

    board[escapeRow][escapeCol] = Stone.none;
    return false;
  }

  // 끊기 수
  List<int>? _findCutMove(List<List<int>> validMoves) {
    int bestScore = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      int score = 0;

      // 대각선 방향으로 상대 돌이 있는지 확인
      List<List<int>> diagonals = [[-1, -1], [-1, 1], [1, -1], [1, 1]];
      int opponentDiagonals = 0;

      for (var diag in diagonals) {
        int dr = move[0] + diag[0];
        int dc = move[1] + diag[1];
        if (_isValidPosition(dr, dc) && board[dr][dc] == widget.playerColor) {
          opponentDiagonals++;
        }
      }

      // 직선 방향 빈 점 또는 자기 돌
      int emptyOrOwn = 0;
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] != widget.playerColor) {
          emptyOrOwn++;
        }
      }

      // 끊기가 효과적인 경우
      if (opponentDiagonals >= 2 && emptyOrOwn >= 2) {
        board[move[0]][move[1]] = aiColor;

        // 끊은 후 두 그룹의 크기 확인
        Set<String> counted = {};
        int minGroupSize = 100;

        for (var diag in diagonals) {
          int dr = move[0] + diag[0];
          int dc = move[1] + diag[1];
          String key = '$dr,$dc';
          if (_isValidPosition(dr, dc) && board[dr][dc] == widget.playerColor && !counted.contains(key)) {
            var group = _getGroup(dr, dc);
            for (var g in group) {
              counted.add('${g[0]},${g[1]}');
            }
            if (group.length < minGroupSize) {
              minGroupSize = group.length;
            }
          }
        }

        score = opponentDiagonals * 10 + minGroupSize * 5;
        board[move[0]][move[1]] = Stone.none;
      }

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    if (bestScore >= 25) return bestMove;
    return null;
  }

  // 영향력 맵 계산
  void _calculateInfluenceMap() {
    _influenceMap = List.generate(boardSize, (_) => List.filled(boardSize, 0.0));

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] != Stone.none) {
          double value = board[i][j] == aiColor ? 1.0 : -1.0;

          // 주변으로 영향력 전파
          for (int di = -4; di <= 4; di++) {
            for (int dj = -4; dj <= 4; dj++) {
              int ni = i + di;
              int nj = j + dj;
              if (_isValidPosition(ni, nj)) {
                double dist = sqrt(di * di + dj * dj);
                if (dist > 0) {
                  _influenceMap[ni][nj] += value / (dist * dist);
                }
              }
            }
          }
        }
      }
    }
  }

  // 몬테카를로 시뮬레이션 기반 최적 수
  List<int>? _findBestMoveWithMonteCarlo(List<List<int>> validMoves) {
    if (validMoves.isEmpty) return null;

    // 상위 후보만 시뮬레이션
    List<MapEntry<List<int>, int>> scored = [];
    for (var move in validMoves) {
      int score = _evaluateMoveAdvanced(move[0], move[1]);
      scored.add(MapEntry(move, score));
    }
    scored.sort((a, b) => b.value.compareTo(a.value));

    // 상위 10개만 몬테카를로
    int candidateCount = min(10, scored.length);
    List<int>? bestMove;
    double bestWinRate = -1;

    for (int i = 0; i < candidateCount; i++) {
      var move = scored[i].key;
      double winRate = _monteCarloSimulation(move[0], move[1], 30);

      // 기본 점수 + 승률 조합
      double combinedScore = scored[i].value * 0.3 + winRate * 100;

      if (combinedScore > bestWinRate) {
        bestWinRate = combinedScore;
        bestMove = move;
      }
    }

    return bestMove ?? scored.first.key;
  }

  // 몬테카를로 시뮬레이션
  double _monteCarloSimulation(int row, int col, int simulations) {
    int wins = 0;

    // 현재 보드 저장
    List<List<Stone>> originalBoard = List.generate(
      boardSize, (i) => List.from(board[i])
    );

    for (int sim = 0; sim < simulations; sim++) {
      // 보드 복원
      for (int i = 0; i < boardSize; i++) {
        for (int j = 0; j < boardSize; j++) {
          board[i][j] = originalBoard[i][j];
        }
      }

      // 첫 수 두기
      board[row][col] = aiColor;
      Stone currentSim = widget.playerColor;

      // 랜덤 플레이아웃
      int moves = 0;
      int maxMoves = boardSize * boardSize ~/ 2;
      int passes = 0;

      while (moves < maxMoves && passes < 2) {
        List<List<int>> simMoves = [];
        for (int i = 0; i < boardSize; i++) {
          for (int j = 0; j < boardSize; j++) {
            if (board[i][j] == Stone.none && _isValidMoveSimple(i, j, currentSim)) {
              simMoves.add([i, j]);
            }
          }
        }

        if (simMoves.isEmpty) {
          passes++;
        } else {
          passes = 0;
          var randomMove = simMoves[_random.nextInt(simMoves.length)];
          board[randomMove[0]][randomMove[1]] = currentSim;
          _removeCapturedStones(randomMove[0], randomMove[1], currentSim);
        }

        currentSim = currentSim.opponent;
        moves++;
      }

      // 결과 평가
      int aiTerritory = _countTerritory(aiColor);
      int playerTerritory = _countTerritory(widget.playerColor);

      if (aiTerritory > playerTerritory) wins++;
    }

    // 보드 복원
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        board[i][j] = originalBoard[i][j];
      }
    }

    return wins / simulations;
  }

  // 간단한 유효 수 확인 (시뮬레이션용)
  bool _isValidMoveSimple(int row, int col, Stone stone) {
    if (board[row][col] != Stone.none) return false;

    board[row][col] = stone;

    // 자충수 확인
    var group = _getGroup(row, col);
    var liberties = _getLiberties(group);

    if (liberties.isEmpty) {
      // 상대를 잡을 수 있는지 확인
      bool canCapture = false;
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = row + dir[0];
        int nc = col + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
          var oppGroup = _getGroup(nr, nc);
          if (_getLiberties(oppGroup).isEmpty) {
            canCapture = true;
            break;
          }
        }
      }
      if (!canCapture) {
        board[row][col] = Stone.none;
        return false;
      }
    }

    board[row][col] = Stone.none;
    return true;
  }

  // 잡힌 돌 제거 (시뮬레이션용)
  void _removeCapturedStones(int row, int col, Stone stone) {
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          for (var s in group) {
            board[s[0]][s[1]] = Stone.none;
          }
        }
      }
    }
  }

  // 영역 계산 (시뮬레이션용)
  int _countTerritory(Stone stone) {
    int territory = 0;
    Set<String> visited = {};

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == stone) {
          territory++;
        } else if (board[i][j] == Stone.none && !visited.contains('$i,$j')) {
          var result = _floodFillTerritory(i, j, visited);
          if (result['owner'] == stone) {
            territory += result['count'] as int;
          }
        }
      }
    }
    return territory;
  }

  List<int>? _findSaveMove(List<List<int>> validMoves) {
    Set<String> groupsInAtari = {};
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == aiColor) {
          String key = '$i,$j';
          if (!groupsInAtari.contains(key)) {
            var group = _getGroup(i, j);
            var liberties = _getLiberties(group);
            if (liberties.length == 1) {
              for (var stone in group) {
                groupsInAtari.add('${stone[0]},${stone[1]}');
              }

              for (var move in validMoves) {
                board[move[0]][move[1]] = aiColor;
                var newGroup = _getGroup(i, j);
                var newLiberties = _getLiberties(newGroup);
                board[move[0]][move[1]] = Stone.none;

                if (newLiberties.length >= 2) {
                  return move;
                }
              }

              for (var move in validMoves) {
                int captures = _countCaptures(move[0], move[1], aiColor);
                if (captures > 0) {
                  board[move[0]][move[1]] = aiColor;
                  List<List<int>> captured = [];
                  for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
                    int nr = move[0] + dir[0];
                    int nc = move[1] + dir[1];
                    if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
                      var g = _getGroup(nr, nc);
                      if (_getLiberties(g).isEmpty) {
                        captured.addAll(g);
                      }
                    }
                  }
                  for (var c in captured) {
                    board[c[0]][c[1]] = Stone.none;
                  }

                  var newLiberties = _getLiberties(_getGroup(i, j));

                  for (var c in captured) {
                    board[c[0]][c[1]] = widget.playerColor;
                  }
                  board[move[0]][move[1]] = Stone.none;

                  if (newLiberties.length >= 2) {
                    return move;
                  }
                }
              }
            }
          }
        }
      }
    }
    return null;
  }

  List<int>? _findAtariMove(List<List<int>> validMoves) {
    int bestGroupSize = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);
          if (liberties.length == 1 && group.length > bestGroupSize) {
            bestGroupSize = group.length;
            bestMove = move;
          }
        }
      }

      board[move[0]][move[1]] = Stone.none;
    }

    if (bestGroupSize >= 2) return bestMove;
    return null;
  }

  List<int>? _findBlockMove(List<List<int>> validMoves) {
    int maxThreat = 0;
    List<int>? bestBlock;

    for (var move in validMoves) {
      int threat = _countCaptures(move[0], move[1], widget.playerColor);
      if (threat > maxThreat) {
        maxThreat = threat;
        bestBlock = move;
      }
    }

    if (maxThreat > 0) return bestBlock;
    return null;
  }

  List<int>? _findPressureMove(List<List<int>> validMoves) {
    int bestScore = 0;
    List<int>? bestMove;

    for (var move in validMoves) {
      board[move[0]][move[1]] = aiColor;

      int score = 0;
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = move[0] + dir[0];
        int nc = move[1] + dir[1];
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          var group = _getGroup(nr, nc);
          var liberties = _getLiberties(group);
          if (liberties.length == 2) {
            score += group.length * 10;
          } else if (liberties.length == 3) {
            score += group.length * 3;
          }
        }
      }

      board[move[0]][move[1]] = Stone.none;

      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    if (bestScore >= 20) return bestMove;
    return null;
  }

  List<int>? _findBestScoredMove(List<List<int>> validMoves) {
    int bestScore = -100000;
    List<int>? bestMove;

    for (var move in validMoves) {
      int score = _evaluateMoveAdvanced(move[0], move[1]);
      if (score > bestScore) {
        bestScore = score;
        bestMove = move;
      }
    }

    return bestMove;
  }

  int _evaluateMoveAdvanced(int row, int col) {
    int score = 0;

    // 1. 영향력 맵 활용
    score += (_influenceMap[row][col] * 15).round();

    // 2. 연결성 평가
    score += _calculateConnectivity(row, col, aiColor) * 8;

    // 3. 공격 잠재력
    score += _calculateAttackPotential(row, col) * 6;

    // 4. 눈 형성 가능성
    score += _calculateEyePotential(row, col) * 12;

    // 5. 전략적 위치
    score += _calculateStrategicValue(row, col);

    // 6. 활로 확보
    board[row][col] = aiColor;
    var group = _getGroup(row, col);
    var liberties = _getLiberties(group);
    board[row][col] = Stone.none;
    score += liberties.length * 5;

    // 7. 약한 그룹 강화
    score += _strengthenWeakGroups(row, col) * 8;

    // 8. 상대 확장 차단
    score += _blockOpponentExpansion(row, col) * 6;

    // 9. 영역 확장 가치
    score += _calculateTerritoryValue(row, col) * 7;

    // 10. 모양 평가 (호구, 빈삼각형 등 나쁜 모양 피하기)
    score += _evaluateShape(row, col) * 10;

    // 11. 약간의 랜덤성
    score += _random.nextInt(3);

    return score;
  }

  // 영역 확장 가치 평가
  int _calculateTerritoryValue(int row, int col) {
    int value = 0;

    // 비어있는 영역에서의 가치
    int emptyNearby = 0;
    int ownNearby = 0;
    int oppNearby = 0;

    for (int dr = -2; dr <= 2; dr++) {
      for (int dc = -2; dc <= 2; dc++) {
        int nr = row + dr;
        int nc = col + dc;
        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == Stone.none) {
            emptyNearby++;
          } else if (board[nr][nc] == aiColor) {
            ownNearby++;
          } else {
            oppNearby++;
          }
        }
      }
    }

    // 자기 돌 근처의 빈 공간 확장
    if (ownNearby > 0 && emptyNearby > oppNearby) {
      value += emptyNearby * 2;
    }

    // 경계 지역에서의 가치
    if (ownNearby > 0 && oppNearby > 0) {
      value += 5;
    }

    return value;
  }

  // 모양 평가
  int _evaluateShape(int row, int col) {
    int value = 0;

    board[row][col] = aiColor;

    // 빈삼각형 피하기 (나쁜 모양)
    List<List<List<int>>> trianglePatterns = [
      [[-1, 0], [0, -1], [-1, -1]],
      [[-1, 0], [0, 1], [-1, 1]],
      [[1, 0], [0, -1], [1, -1]],
      [[1, 0], [0, 1], [1, 1]],
    ];

    for (var pattern in trianglePatterns) {
      int ownCount = 0;
      int emptyCorner = 0;
      for (int i = 0; i < 3; i++) {
        int nr = row + pattern[i][0];
        int nc = col + pattern[i][1];
        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == aiColor) {
            ownCount++;
          } else if (i == 2 && board[nr][nc] == Stone.none) {
            emptyCorner = 1;
          }
        }
      }
      // 빈삼각형: 2점이 자기 돌이고 대각선이 비어있음
      if (ownCount == 2 && emptyCorner == 1) {
        value -= 8; // 페널티
      }
    }

    // 호구 (좋은 모양)
    int directNeighbors = 0;
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == aiColor) {
        directNeighbors++;
      }
    }

    // 한 점에 연결하면서 활로가 많으면 좋음
    if (directNeighbors == 1) {
      var group = _getGroup(row, col);
      var liberties = _getLiberties(group);
      if (liberties.length >= 4) {
        value += 5;
      }
    }

    board[row][col] = Stone.none;
    return value;
  }

  int _calculateInfluence(int row, int col) {
    // 영향력 맵 사용
    return (_influenceMap[row][col] * 10).round();
  }

  int _calculateConnectivity(int row, int col, Stone stone) {
    int connectivity = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone) {
        connectivity += 5;
        var group = _getGroup(nr, nc);
        connectivity += group.length;
      }
    }

    for (var dir in [[-1, -1], [-1, 1], [1, -1], [1, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone) {
        connectivity += 2;
      }
    }

    for (var dir in [[-2, 0], [2, 0], [0, -2], [0, 2]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      int mr = row + dir[0] ~/ 2;
      int mc = col + dir[1] ~/ 2;
      if (_isValidPosition(nr, nc) && _isValidPosition(mr, mc)) {
        if (board[nr][nc] == stone && board[mr][mc] == Stone.none) {
          connectivity += 3;
        }
      }
    }

    return connectivity;
  }

  int _calculateAttackPotential(int row, int col) {
    int attack = 0;

    board[row][col] = aiColor;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
        var group = _getGroup(nr, nc);
        var liberties = _getLiberties(group);

        if (liberties.length <= 2) {
          attack += (4 - liberties.length) * group.length * 3;
        } else if (liberties.length <= 4) {
          attack += group.length;
        }
      }
    }

    board[row][col] = Stone.none;

    return attack;
  }

  int _calculateEyePotential(int row, int col) {
    int eyePotential = 0;

    int adjacentOwn = 0;
    int adjacentEmpty = 0;
    int adjacentEdge = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (!_isValidPosition(nr, nc)) {
        adjacentEdge++;
      } else if (board[nr][nc] == aiColor) {
        adjacentOwn++;
      } else if (board[nr][nc] == Stone.none) {
        adjacentEmpty++;
      }
    }

    if (adjacentOwn >= 3 && adjacentEmpty == 1) {
      eyePotential += 15;
    }
    if (adjacentEdge >= 1 && adjacentOwn >= 2) {
      eyePotential += 10;
    }

    return eyePotential;
  }

  int _calculateStrategicValue(int row, int col) {
    int stoneCount = _countStones();
    int value = 0;

    if (_isStarPoint(row, col)) {
      value += 25;
    }

    if (stoneCount < boardSize) {
      int edgeDist = _getEdgeDistance(row, col);
      if (edgeDist >= 2 && edgeDist <= 4) {
        value += 20;
      }
      if (_isCornerApproach(row, col)) {
        value += 15;
      }
    } else if (stoneCount < boardSize * 3) {
      int centerDist = (row - boardSize ~/ 2).abs() + (col - boardSize ~/ 2).abs();
      value += (boardSize - centerDist) * 2;
    } else {
      value += _getBoundaryValue(row, col) * 3;
    }

    return value;
  }

  int _getEdgeDistance(int row, int col) {
    int rowDist = min(row, boardSize - 1 - row);
    int colDist = min(col, boardSize - 1 - col);
    return min(rowDist, colDist);
  }

  bool _isStarPoint(int row, int col) {
    var starPoints = _getStarPoints();
    for (var point in starPoints) {
      if (point[0] == row && point[1] == col) return true;
    }
    return false;
  }

  int _getBoundaryValue(int row, int col) {
    int value = 0;

    bool hasOwn = false;
    bool hasOpponent = false;

    for (int dr = -2; dr <= 2; dr++) {
      for (int dc = -2; dc <= 2; dc++) {
        int nr = row + dr;
        int nc = col + dc;
        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == aiColor) hasOwn = true;
          if (board[nr][nc] == widget.playerColor) hasOpponent = true;
        }
      }
    }

    if (hasOwn && hasOpponent) {
      value += 10;
    }

    return value;
  }

  int _strengthenWeakGroups(int row, int col) {
    int value = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == aiColor) {
        var group = _getGroup(nr, nc);
        var liberties = _getLiberties(group);
        if (liberties.length <= 3) {
          board[row][col] = aiColor;
          var newLiberties = _getLiberties(_getGroup(nr, nc));
          board[row][col] = Stone.none;

          if (newLiberties.length > liberties.length) {
            value += (4 - liberties.length) * group.length;
          }
        }
      }
    }

    return value;
  }

  int _blockOpponentExpansion(int row, int col) {
    int value = 0;

    for (int dr = -2; dr <= 2; dr++) {
      for (int dc = -2; dc <= 2; dc++) {
        int nr = row + dr;
        int nc = col + dc;
        if (_isValidPosition(nr, nc) && board[nr][nc] == widget.playerColor) {
          int dist = dr.abs() + dc.abs();
          value += (5 - dist);
        }
      }
    }

    return value;
  }

  // ============ 기존 유틸리티 함수들 ============

  bool _isValidMove(int row, int col, Stone stone) {
    if (board[row][col] != Stone.none) return false;

    board[row][col] = stone;

    List<List<int>> captures = [];
    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          captures.addAll(group);
        }
      }
    }

    if (captures.isEmpty) {
      var myGroup = _getGroup(row, col);
      if (_getLiberties(myGroup).isEmpty) {
        board[row][col] = Stone.none;
        return false;
      }
    }

    for (var cap in captures) {
      board[cap[0]][cap[1]] = Stone.none;
    }
    String afterCapture = _boardToString();

    board[row][col] = Stone.none;
    for (var cap in captures) {
      board[cap[0]][cap[1]] = stone.opponent;
    }

    if (lastBoardState != null && afterCapture == lastBoardState) {
      return false;
    }

    return true;
  }

  int _countCaptures(int row, int col, Stone stone) {
    board[row][col] = stone;
    int captures = 0;

    for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
      int nr = row + dir[0];
      int nc = col + dir[1];
      if (_isValidPosition(nr, nc) && board[nr][nc] == stone.opponent) {
        var group = _getGroup(nr, nc);
        if (_getLiberties(group).isEmpty) {
          captures += group.length;
        }
      }
    }

    board[row][col] = Stone.none;
    return captures;
  }

  List<List<int>> _getStarPoints() {
    if (boardSize == 9) {
      return [[2, 2], [2, 6], [4, 4], [6, 2], [6, 6]];
    } else if (boardSize == 13) {
      return [[3, 3], [3, 9], [6, 6], [9, 3], [9, 9]];
    } else if (boardSize == 19) {
      return [[3, 3], [3, 9], [3, 15], [9, 3], [9, 9], [9, 15], [15, 3], [15, 9], [15, 15]];
    }
    return [];
  }

  bool _isCornerApproach(int row, int col) {
    int margin = boardSize <= 9 ? 2 : 3;
    return (row < margin || row >= boardSize - margin) &&
           (col < margin || col >= boardSize - margin);
  }

  int _countStones() {
    int count = 0;
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] != Stone.none) count++;
      }
    }
    return count;
  }

  void _pass({bool isAI = false}) {
    if (gameOver) return;
    if (!isAI && isAIThinking) return;

    setState(() {
      consecutivePasses++;
      lastMove = null;

      if (consecutivePasses >= 2) {
        gameOver = true;
        showTerritory = true;
        _calculateTerritory();
        int blackScore = territoryCount['black']! + blackCaptures;
        int whiteScore = territoryCount['white']! + whiteCaptures + 6;

        if (widget.vsAI) {
          int playerScore = widget.playerColor == Stone.black ? blackScore : whiteScore;
          int aiScore = widget.playerColor == Stone.black ? whiteScore : blackScore;
          if (playerScore > aiScore) {
            gameMessage = '${tr('congratsWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else if (aiScore > playerScore) {
            gameMessage = '${tr('aiWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else {
            gameMessage = '${tr('draw')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          }
        } else {
          if (blackScore > whiteScore) {
            gameMessage = '${tr('blackWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else if (whiteScore > blackScore) {
            gameMessage = '${tr('whiteWin')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          } else {
            gameMessage = '${tr('draw')} (${tr('black')}: $blackScore, ${tr('white')}: $whiteScore)';
          }
        }
      } else {
        currentPlayer = currentPlayer.opponent;
        if (widget.vsAI) {
          String colorName = widget.playerColor == Stone.black ? tr('black') : tr('white');
          if (currentPlayer == widget.playerColor) {
            gameMessage = '${tr('yourTurn')} ($colorName) - ${tr('aiPass')}';
          } else {
            gameMessage = tr('aiThinking');
          }
        } else {
          gameMessage = currentPlayer == Stone.black
              ? '${tr('blackTurn')} (${tr('whitePass')})'
              : '${tr('whiteTurn')} (${tr('blackPass')})';
        }
      }
    });

    // 게임 종료 시 저장된 게임 삭제, 진행 중이면 자동 저장
    if (gameOver) {
      deleteSavedGame();
    } else {
      _autoSave();
    }

    if (!isAI && widget.vsAI && currentPlayer == aiColor && !gameOver) {
      _aiMove();
    }
  }

  bool _isValidPosition(int row, int col) {
    return row >= 0 && row < boardSize && col >= 0 && col < boardSize;
  }

  List<List<int>> _getGroup(int row, int col) {
    Stone stone = board[row][col];
    if (stone == Stone.none) return [];

    List<List<int>> group = [];
    Set<String> visited = {};
    Queue<List<int>> queue = Queue();
    queue.add([row, col]);
    visited.add('$row,$col');

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      group.add(current);

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = current[0] + dir[0];
        int nc = current[1] + dir[1];
        String key = '$nr,$nc';

        if (_isValidPosition(nr, nc) && !visited.contains(key) && board[nr][nc] == stone) {
          visited.add(key);
          queue.add([nr, nc]);
        }
      }
    }

    return group;
  }

  Set<String> _getLiberties(List<List<int>> group) {
    Set<String> liberties = {};

    for (var stone in group) {
      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = stone[0] + dir[0];
        int nc = stone[1] + dir[1];

        if (_isValidPosition(nr, nc) && board[nr][nc] == Stone.none) {
          liberties.add('$nr,$nc');
        }
      }
    }

    return liberties;
  }

  void _calculateTerritory() {
    Set<String> visited = {};
    territoryCount = {'black': 0, 'white': 0};

    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (board[i][j] == Stone.none && !visited.contains('$i,$j')) {
          var result = _floodFillTerritory(i, j, visited);
          if (result['owner'] == Stone.black) {
            territoryCount['black'] = territoryCount['black']! + (result['count'] as int);
          } else if (result['owner'] == Stone.white) {
            territoryCount['white'] = territoryCount['white']! + (result['count'] as int);
          }
        }
      }
    }
  }

  Map<String, dynamic> _floodFillTerritory(int startRow, int startCol, Set<String> visited) {
    List<List<int>> territory = [];
    Set<Stone> borderingStones = {};
    Queue<List<int>> queue = Queue();
    queue.add([startRow, startCol]);
    visited.add('$startRow,$startCol');

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      territory.add(current);

      for (var dir in [[-1, 0], [1, 0], [0, -1], [0, 1]]) {
        int nr = current[0] + dir[0];
        int nc = current[1] + dir[1];
        String key = '$nr,$nc';

        if (_isValidPosition(nr, nc)) {
          if (board[nr][nc] == Stone.none && !visited.contains(key)) {
            visited.add(key);
            queue.add([nr, nc]);
          } else if (board[nr][nc] != Stone.none) {
            borderingStones.add(board[nr][nc]);
          }
        }
      }
    }

    Stone? owner;
    if (borderingStones.length == 1) {
      owner = borderingStones.first;
    }

    return {'owner': owner, 'count': territory.length, 'territory': territory};
  }

  Stone? _getTerritoryOwner(int row, int col) {
    if (board[row][col] != Stone.none) return null;

    Set<String> visited = {};
    var result = _floodFillTerritory(row, col, visited);
    return result['owner'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          gameMessage,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: gameOver
                ? (gameMessage.contains(tr('congratsWin')) ? Colors.green.shade800 : Colors.blue.shade800)
                : (isAIThinking ? Colors.orange.shade800 : Colors.black87),
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
            tooltip: tr('newGame'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // 왼쪽: 흑돌 점수
                Expanded(
                  flex: 1,
                  child: Center(
                    child: _buildScoreCard(
                      widget.vsAI
                        ? (widget.playerColor == Stone.black ? tr('me') : tr('ai'))
                        : tr('black'),
                      blackCaptures,
                      Colors.black
                    ),
                  ),
                ),
                // 중앙: 바둑판
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomPaint(
                      painter: BoardPainter(
                        boardSize: boardSize,
                        showTerritory: showTerritory,
                        getTerritoryOwner: _getTerritoryOwner,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double cellSize = constraints.maxWidth / boardSize;
                          return GestureDetector(
                            onTapUp: (details) {
                              if (isAIThinking) return;
                              double x = details.localPosition.dx;
                              double y = details.localPosition.dy;
                              int col = (x / cellSize).floor();
                              int row = (y / cellSize).floor();
                              if (row >= 0 && row < boardSize && col >= 0 && col < boardSize) {
                                _placeStone(row, col);
                              }
                            },
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: boardSize,
                              ),
                              itemCount: boardSize * boardSize,
                              itemBuilder: (context, index) {
                                int row = index ~/ boardSize;
                                int col = index % boardSize;
                                return Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: _buildStone(row, col),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                ),
                // 오른쪽: 백돌 점수
                Expanded(
                  flex: 1,
                  child: Center(
                    child: _buildScoreCard(
                      widget.vsAI
                        ? (widget.playerColor == Stone.white ? tr('me') : tr('ai'))
                        : tr('white'),
                      whiteCaptures,
                      Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: (gameOver || isAIThinking) ? null : () => _pass(),
                  icon: const Icon(Icons.skip_next),
                  label: Text(tr('pass')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: (gameOver || isAIThinking) ? null : _showHint,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: Text(tr('hint')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    backgroundColor: showHint ? Colors.amber.shade200 : null,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.replay),
                  label: Text(tr('newGame')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String label, int captures, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: color == Colors.black ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 돌 아이콘
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.grey.shade600, width: 1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color == Colors.black ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$captures',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color == Colors.black ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStone(int row, int col) {
    if (board[row][col] == Stone.none) {
      // 힌트 위치 표시
      if (showHint && hintMove != null && hintMove![0] == row && hintMove![1] == col) {
        double hintSize = boardSize <= 9 ? 26 : (boardSize <= 13 ? 20 : 16);
        Stone hintColor = widget.vsAI ? widget.playerColor : currentPlayer;
        return Container(
          width: hintSize,
          height: hintSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hintColor == Stone.black
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.7),
            border: Border.all(
              color: Colors.amber,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.6),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.lightbulb,
              size: hintSize * 0.6,
              color: Colors.amber.shade700,
            ),
          ),
        );
      }

      if (showTerritory) {
        Stone? owner = _getTerritoryOwner(row, col);
        if (owner != null) {
          return Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: owner == Stone.black
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.5),
              border: Border.all(
                color: owner == Stone.black ? Colors.black : Colors.grey,
                width: 1,
              ),
            ),
          );
        }
      }
      return const SizedBox();
    }

    bool isLastMove = lastMove != null &&
                      lastMove!.isNotEmpty &&
                      lastMove![0][0] == row &&
                      lastMove![0][1] == col;

    double stoneSize = boardSize <= 9 ? 28 : (boardSize <= 13 ? 22 : 18);

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: stoneSize,
          height: stoneSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: board[row][col] == Stone.white
                ? Border.all(color: Colors.grey, width: 1)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 3,
                offset: const Offset(2, 2),
              ),
            ],
            gradient: RadialGradient(
              colors: board[row][col] == Stone.black
                  ? [Colors.grey[600]!, Colors.black]
                  : [Colors.white, Colors.grey[300]!],
              center: const Alignment(-0.3, -0.3),
            ),
          ),
        ),
        if (isLastMove)
          Container(
            width: stoneSize * 0.4,
            height: stoneSize * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: board[row][col] == Stone.black ? Colors.white : Colors.black,
            ),
          ),
      ],
    );
  }
}

class BoardPainter extends CustomPainter {
  final int boardSize;
  final bool showTerritory;
  final Stone? Function(int, int) getTerritoryOwner;

  BoardPainter({
    required this.boardSize,
    required this.showTerritory,
    required this.getTerritoryOwner,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    double cellSize = size.width / boardSize;
    double padding = cellSize / 2;

    for (int i = 0; i < boardSize; i++) {
      canvas.drawLine(
        Offset(padding, padding + i * cellSize),
        Offset(size.width - padding, padding + i * cellSize),
        paint,
      );
      canvas.drawLine(
        Offset(padding + i * cellSize, padding),
        Offset(padding + i * cellSize, size.height - padding),
        paint,
      );
    }

    List<List<int>> starPoints = _getStarPoints();

    final starPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    double starSize = boardSize <= 9 ? 4 : (boardSize <= 13 ? 4 : 3);

    for (var point in starPoints) {
      canvas.drawCircle(
        Offset(padding + point[1] * cellSize, padding + point[0] * cellSize),
        starSize,
        starPaint,
      );
    }
  }

  List<List<int>> _getStarPoints() {
    if (boardSize == 9) {
      return [
        [2, 2], [2, 6],
        [4, 4],
        [6, 2], [6, 6],
      ];
    } else if (boardSize == 13) {
      return [
        [3, 3], [3, 9],
        [6, 6],
        [9, 3], [9, 9],
      ];
    } else if (boardSize == 19) {
      return [
        [3, 3], [3, 9], [3, 15],
        [9, 3], [9, 9], [9, 15],
        [15, 3], [15, 9], [15, 15],
      ];
    }
    return [];
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return oldDelegate.boardSize != boardSize ||
           oldDelegate.showTerritory != showTerritory;
  }
}

// 정보 페이지 메뉴
class InfoMenuPage extends StatelessWidget {
  final VoidCallback onBack;
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const InfoMenuPage({
    super.key,
    required this.onBack,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.brown[300]!, Colors.brown[600]!],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: onBack,
                  ),
                  Expanded(
                    child: Text(
                      L10n.get(language, 'info'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildInfoButton(
                    context,
                    L10n.get(language, 'about'),
                    Icons.info_outline,
                    () => _navigateTo(context, 'about'),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoButton(
                    context,
                    L10n.get(language, 'help'),
                    Icons.help_outline,
                    () => _navigateTo(context, 'help'),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoButton(
                    context,
                    L10n.get(language, 'privacyPolicy'),
                    Icons.privacy_tip_outlined,
                    () => _navigateTo(context, 'privacy'),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoButton(
                    context,
                    L10n.get(language, 'termsOfService'),
                    Icons.description_outlined,
                    () => _navigateTo(context, 'terms'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.white.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(icon, color: Colors.brown[700], size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[800],
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.brown[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, String page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          switch (page) {
            case 'about':
              return AboutPage(language: language, onLanguageChanged: onLanguageChanged);
            case 'help':
              return HelpPage(language: language, onLanguageChanged: onLanguageChanged);
            case 'privacy':
              return PrivacyPolicyPage(language: language, onLanguageChanged: onLanguageChanged);
            case 'terms':
              return TermsOfServicePage(language: language, onLanguageChanged: onLanguageChanged);
            default:
              return AboutPage(language: language, onLanguageChanged: onLanguageChanged);
          }
        },
      ),
    );
  }
}

// 앱 소개 페이지
class AboutPage extends StatelessWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const AboutPage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Provider에서 언어 상태 읽기
    final languageProvider = context.watch<LanguageProvider>();
    final currentLanguage = languageProvider.language;

    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: L10n.get(currentLanguage, 'about'),
        language: currentLanguage,
        onLanguageChanged: languageProvider.setLanguage,
      ),
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 타이틀
              Center(
                child: Text(
                  L10n.get(currentLanguage, 'aboutTitle'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 콘텐츠 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  L10n.get(currentLanguage, 'aboutContent'),
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 도움말 페이지
class HelpPage extends StatefulWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const HelpPage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String _selectedGameKey = 'baduk';
  final Set<String> _expandedCategories = {'cardGame', 'boardGame', 'sudoku'};

  List<Map<String, dynamic>> _getGameList() {
    return [
      {'key': 'baduk', 'icon': Icons.grid_on, 'color': Colors.black87},
      {'key': 'janggi', 'icon': Icons.castle, 'color': Colors.brown},
      {
        'key': 'cardGame', 'icon': Icons.style, 'color': Colors.red,
        'subGames': [
          {'key': 'mighty', 'icon': Icons.star},
          {'key': 'hearts', 'icon': Icons.favorite},
          {'key': 'hula', 'icon': Icons.layers},
          {'key': 'onecard', 'icon': Icons.filter_1},
          {'key': 'highlow', 'icon': Icons.swap_vert},
          {'key': 'sevenpoker', 'icon': Icons.casino},
        ],
      },
      {
        'key': 'boardGame', 'icon': Icons.dashboard, 'color': Colors.blue,
        'subGames': [
          {'key': 'gomoku', 'icon': Icons.circle_outlined},
          {'key': 'othello', 'icon': Icons.contrast},
          {'key': 'tetris', 'icon': Icons.view_module},
          {'key': 'minesweeper', 'icon': Icons.flag},
          {'key': 'solitaire', 'icon': Icons.style},
          {'key': 'maze', 'icon': Icons.route},
          {'key': 'bubble', 'icon': Icons.bubble_chart},
          {'key': 'whackamole', 'icon': Icons.pest_control},
          {'key': 'baseball', 'icon': Icons.sports_baseball},
        ],
      },
      {
        'key': 'sudoku', 'icon': Icons.grid_3x3, 'color': Colors.purple,
        'subGames': [
          {'key': 'sudoku_classic', 'icon': Icons.grid_3x3},
          {'key': 'sudoku_samurai', 'icon': Icons.view_comfy},
          {'key': 'sudoku_killer', 'icon': Icons.calculate},
          {'key': 'sudoku_sum', 'icon': Icons.functions},
        ],
      },
      {'key': 'yutnori', 'icon': Icons.casino, 'color': Colors.orange},
    ];
  }

  Map<String, dynamic>? _findGameByKey(String key) {
    for (var game in _getGameList()) {
      if (game['key'] == key) return game;
      if (game['subGames'] != null) {
        for (var subGame in game['subGames']) {
          if (subGame['key'] == key) {
            return {...subGame, 'color': game['color'], 'parentKey': game['key']};
          }
        }
      }
    }
    return null;
  }

  void _navigateToGame(String gameKey) {
    switch (gameKey) {
      case 'baduk':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => GameModeSelector(language: widget.language, onLanguageChanged: widget.onLanguageChanged),
        ));
        break;
      case 'janggi':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => JanggiSelectionScreen(language: widget.language, onLanguageChanged: widget.onLanguageChanged),
        ));
        break;
      case 'cardGame':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => card_game.GameSelectionScreen(language: widget.language, onLanguageChanged: widget.onLanguageChanged),
        ));
        break;
      case 'mighty':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const CardGameProviderWrapper(child: mighty_home.HomeScreen()),
        ));
        break;
      case 'hearts':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const CardGameProviderWrapper(child: HeartsHomeScreen()),
        ));
        break;
      case 'hula':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const CardGameProviderWrapper(child: HulaHomeScreen()),
        ));
        break;
      case 'onecard':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const CardGameProviderWrapper(child: OneCardHomeScreen()),
        ));
        break;
      case 'highlow':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const CardGameProviderWrapper(child: HiLoHomeScreen()),
        ));
        break;
      case 'sevenpoker':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const CardGameProviderWrapper(child: SevenCardHomeScreen()),
        ));
        break;
      case 'boardGame':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => BoardGameSelectionScreen(language: widget.language, onLanguageChanged: widget.onLanguageChanged),
        ));
        break;
      case 'gomoku':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const GomokuScreen(gameMode: GameMode.vsComputerWhite),
        ));
        break;
      case 'othello':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const OthelloScreen(gameMode: OthelloGameMode.vsComputerWhite),
        ));
        break;
      case 'tetris':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const TetrisScreen(),
        ));
        break;
      case 'minesweeper':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MinesweeperScreen(difficulty: MinesweeperDifficulty.hard),
        ));
        break;
      case 'solitaire':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const SolitaireScreen(),
        ));
        break;
      case 'maze':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MazeScreen(difficulty: MazeDifficulty.hard),
        ));
        break;
      case 'bubble':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const BubbleScreen(),
        ));
        break;
      case 'whackamole':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MoleScreen(),
        ));
        break;
      case 'baseball':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const BaseballScreen(difficulty: BaseballDifficulty.hard),
        ));
        break;
      case 'sudoku':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => SudokuSelectionScreen(language: widget.language, onLanguageChanged: widget.onLanguageChanged),
        ));
        break;
      case 'sudoku_classic':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const sudoku_classic.GameScreen(
            initialDifficulty: sudoku_state.Difficulty.expert,
          ),
        ));
        break;
      case 'sudoku_samurai':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const SamuraiGameScreen(
            initialDifficulty: SamuraiDifficulty.hard,
          ),
        ));
        break;
      case 'sudoku_killer':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => KillerGameScreen(
            initialDifficulty: KillerDifficulty.hard,
          ),
        ));
        break;
      case 'sudoku_sum':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => NumberSumsGameScreen(
            initialDifficulty: NumberSumsDifficulty.hard,
          ),
        ));
        break;
      case 'yutnori':
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => const YutnoriHomeScreen(),
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider에서 언어 상태 읽기
    final languageProvider = context.watch<LanguageProvider>();
    final language = languageProvider.language;

    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: L10n.get(language, 'help'),
        language: language,
        onLanguageChanged: languageProvider.setLanguage,
      ),
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isWideScreen
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 220, child: _buildGameList()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildGameDescription()),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(height: 50, child: _buildHorizontalGameList()),
                    const SizedBox(height: 16),
                    Expanded(child: _buildGameDescription()),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHorizontalGameList() {
    final allGames = <Map<String, dynamic>>[];
    for (var game in _getGameList()) {
      allGames.add(game);
      if (game['subGames'] != null) {
        for (var subGame in game['subGames']) {
          allGames.add({...subGame, 'color': game['color'], 'isSubGame': true});
        }
      }
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: allGames.length,
      itemBuilder: (context, index) {
        final game = allGames[index];
        final isSelected = game['key'] == _selectedGameKey;
        final isSubGame = game['isSubGame'] == true;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(
              isSubGame ? '  ${L10n.get(widget.language, game['key'])}' : L10n.get(widget.language, game['key']),
              style: TextStyle(fontSize: isSubGame ? 12 : 14),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) setState(() => _selectedGameKey = game['key']);
            },
            selectedColor: game['color'] as Color,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: _getGameList().map((game) {
            final hasSubGames = game['subGames'] != null;
            final isExpanded = _expandedCategories.contains(game['key']);
            final isSelected = game['key'] == _selectedGameKey;
            final color = game['color'] as Color;

            if (hasSubGames) {
              return Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  leading: Icon(game['icon'] as IconData, color: color),
                  title: Text(L10n.get(widget.language, game['key']),
                      style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                  initiallyExpanded: isExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() {
                      if (expanded) {
                        _expandedCategories.add(game['key']);
                      } else {
                        _expandedCategories.remove(game['key']);
                      }
                    });
                  },
                  children: (game['subGames'] as List).map<Widget>((subGame) {
                    final subKey = subGame['key'] as String;
                    final isSubSelected = subKey == _selectedGameKey;
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 56, right: 16),
                      leading: Icon(subGame['icon'] as IconData,
                          size: 20, color: isSubSelected ? color : Colors.grey),
                      title: Text(L10n.get(widget.language, subKey),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSubSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSubSelected ? color : Colors.black87,
                          )),
                      selected: isSubSelected,
                      selectedTileColor: color.withValues(alpha: 0.1),
                      onTap: () => setState(() => _selectedGameKey = subKey),
                    );
                  }).toList(),
                ),
              );
            } else {
              return ListTile(
                leading: Icon(game['icon'] as IconData,
                    color: isSelected ? color : Colors.grey),
                title: Text(L10n.get(widget.language, game['key']),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? color : Colors.black87,
                    )),
                selected: isSelected,
                selectedTileColor: color.withValues(alpha: 0.1),
                onTap: () => setState(() => _selectedGameKey = game['key']),
              );
            }
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildGameDescription() {
    final game = _findGameByKey(_selectedGameKey);
    if (game == null) return const SizedBox();

    final color = game['color'] as Color;
    final helpKey = 'help_$_selectedGameKey';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(game['icon'] as IconData, size: 32, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(L10n.get(widget.language, _selectedGameKey),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(L10n.get(widget.language, helpKey),
                style: TextStyle(fontSize: 16, height: 1.8, color: Colors.grey[800])),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _navigateToGame(_selectedGameKey),
                icon: const Icon(Icons.play_arrow),
                label: Text(
                  widget.language == GameLanguage.korean ? '게임 시작' :
                  widget.language == GameLanguage.japanese ? 'ゲーム開始' :
                  widget.language == GameLanguage.chinese ? '开始游戏' : 'Start Game',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 개인정보처리방침 페이지
class PrivacyPolicyPage extends StatelessWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const PrivacyPolicyPage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: L10n.get(language, 'privacyPolicy'),
        language: language,
        onLanguageChanged: onLanguageChanged,
      ),
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 타이틀
              Center(
                child: Text(
                  L10n.get(language, 'privacyPolicyTitle'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 콘텐츠 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  L10n.get(language, 'privacyPolicyContent'),
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 이용약관 페이지
class TermsOfServicePage extends StatelessWidget {
  final GameLanguage language;
  final Function(GameLanguage) onLanguageChanged;

  const TermsOfServicePage({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCommonAppBar(
        context: context,
        title: L10n.get(language, 'termsOfService'),
        language: language,
        onLanguageChanged: onLanguageChanged,
      ),
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 타이틀
              Center(
                child: Text(
                  L10n.get(language, 'termsOfServiceTitle'),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // 콘텐츠 박스
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  L10n.get(language, 'termsOfServiceContent'),
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.8,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
