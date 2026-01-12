import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:collection';
import 'dart:math';
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const BadukApp());
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
      'vsAI': '바둑 - vs AI',
      'twoPlayer': '바둑 - 2인 대국',
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
      'hintMessage': '추천 위치가 표시되었습니다',
      'noHint': '추천할 수 없습니다',
      'continue': '이어하기',
      'save': '저장',
      'load': '불러오기',
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
      'lifeDeathProblems': '사활 배우기',
      'problemList': '문제 목록',
      'problem': '문제',
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
      // 정보 페이지
      'about': '앱 소개',
      'help': '도움말',
      'privacyPolicy': '개인정보처리방침',
      'termsOfService': '이용약관',
      'info': '정보',
      'aboutTitle': '바둑 앱 소개',
      'aboutContent': '이 앱은 바둑을 즐기고 배울 수 있는 무료 앱입니다.\n\n• AI와 대국하기\n• 2인 대국\n• 사활 문제 풀이\n\n바둑은 약 4,000년의 역사를 가진 전략 보드게임입니다. 흑과 백이 번갈아 돌을 놓아 더 많은 영역을 차지하는 것이 목표입니다.',
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
      'vsAI': 'Go - vs AI',
      'twoPlayer': 'Go - 2 Players',
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
      'hintMessage': 'Recommended move shown',
      'noHint': 'No suggestion available',
      'continue': 'Continue',
      'save': 'Save',
      'load': 'Load',
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
      'lifeDeathProblems': 'Learn Life & Death',
      'problemList': 'Problem List',
      'problem': 'Problem',
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
      // Info pages
      'about': 'About',
      'help': 'Help',
      'privacyPolicy': 'Privacy Policy',
      'termsOfService': 'Terms of Service',
      'info': 'Info',
      'aboutTitle': 'About This App',
      'aboutContent': 'This is a free app to enjoy and learn Go (Baduk/Weiqi).\n\n• Play against AI\n• Two-player mode\n• Life & Death problems\n\nGo is a strategic board game with about 4,000 years of history. Players take turns placing black and white stones to control more territory.',
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
      'vsAI': '囲碁 - vs AI',
      'twoPlayer': '囲碁 - 対人戦',
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
      'hintMessage': 'おすすめの手を表示しました',
      'noHint': '提案できません',
      'continue': '続きから',
      'save': '保存',
      'load': '読込',
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
      'lifeDeathProblems': '詰碁を学ぶ',
      'problemList': '問題一覧',
      'problem': '問題',
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
      // 情報ページ
      'about': 'アプリについて',
      'help': 'ヘルプ',
      'privacyPolicy': 'プライバシーポリシー',
      'termsOfService': '利用規約',
      'info': '情報',
      'aboutTitle': 'アプリ紹介',
      'aboutContent': 'このアプリは囲碁を楽しみながら学べる無料アプリです。\n\n• AIと対局\n• 二人対局\n• 詰碁問題\n\n囲碁は約4,000年の歴史を持つ戦略ボードゲームです。黒と白が交互に石を置き、より多くの領域を確保することが目標です。',
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
      'vsAI': '围棋 - vs AI',
      'twoPlayer': '围棋 - 双人对战',
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
      'hintMessage': '已显示推荐位置',
      'noHint': '无法提供建议',
      'continue': '继续游戏',
      'save': '保存',
      'load': '读取',
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
      'lifeDeathProblems': '学习死活',
      'problemList': '题目列表',
      'problem': '题目',
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
      // 信息页面
      'about': '关于',
      'help': '帮助',
      'privacyPolicy': '隐私政策',
      'termsOfService': '服务条款',
      'info': '信息',
      'aboutTitle': '应用介绍',
      'aboutContent': '这是一款免费的围棋学习应用。\n\n• 与AI对弈\n• 双人对弈\n• 死活题练习\n\n围棋是一种拥有约4000年历史的策略棋盘游戏。黑白双方交替落子，目标是占领更多的领地。',
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

class BadukApp extends StatefulWidget {
  const BadukApp({super.key});

  @override
  State<BadukApp> createState() => _BadukAppState();
}

class _BadukAppState extends State<BadukApp> {
  GameLanguage _language = GameLanguage.korean;
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

  void _setLanguage(GameLanguage lang) {
    setState(() {
      _language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: L10n.get(_language, 'appTitle'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: _benchmarkDone
          ? GameModeSelector(
              language: _language,
              onLanguageChanged: _setLanguage,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(widget.language, 'appTitle')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.info_outline),
            tooltip: L10n.get(widget.language, 'info'),
            onSelected: (value) {
              Widget page;
              switch (value) {
                case 'about':
                  page = AboutPage(onBack: () => Navigator.pop(context), language: widget.language);
                  break;
                case 'help':
                  page = HelpPage(onBack: () => Navigator.pop(context), language: widget.language);
                  break;
                case 'privacy':
                  page = PrivacyPolicyPage(onBack: () => Navigator.pop(context), language: widget.language);
                  break;
                case 'terms':
                  page = TermsOfServicePage(onBack: () => Navigator.pop(context), language: widget.language);
                  break;
                default:
                  return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => page));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.brown[700]),
                    const SizedBox(width: 12),
                    Text(L10n.get(widget.language, 'about')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 20, color: Colors.brown[700]),
                    const SizedBox(width: 12),
                    Text(L10n.get(widget.language, 'help')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'privacy',
                child: Row(
                  children: [
                    Icon(Icons.privacy_tip_outlined, size: 20, color: Colors.brown[700]),
                    const SizedBox(width: 12),
                    Text(L10n.get(widget.language, 'privacyPolicy')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'terms',
                child: Row(
                  children: [
                    Icon(Icons.description_outlined, size: 20, color: Colors.brown[700]),
                    const SizedBox(width: 12),
                    Text(L10n.get(widget.language, 'termsOfService')),
                  ],
                ),
              ),
            ],
          ),
          PopupMenuButton<GameLanguage>(
            icon: const Icon(Icons.language),
            tooltip: L10n.get(widget.language, 'language'),
            onSelected: widget.onLanguageChanged,
            itemBuilder: (context) => GameLanguage.values.map((lang) {
              return PopupMenuItem(
                value: lang,
                child: Row(
                  children: [
                    if (lang == widget.language)
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10n.get(widget.language, 'appTitle'),
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            // AI 대국
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AIDifficultySelector(
                      language: widget.language,
                    ),
                  ),
                ).then((_) => _checkSavedGame());
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.brown.shade100,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.smart_toy, size: 28, color: Colors.brown),
                  const SizedBox(width: 12),
                  Text(
                    L10n.get(widget.language, 'vsAI'),
                    style: const TextStyle(fontSize: 18, color: Colors.brown),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 2인 대국
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BadukGame(
                      vsAI: false,
                      language: widget.language,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people, size: 28),
                  const SizedBox(width: 12),
                  Text(L10n.get(widget.language, 'twoPlayerMode'), style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 사활 문제
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LifeDeathProblemSelector(
                      language: widget.language,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.green.shade100,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.extension, size: 28, color: Colors.green),
                  const SizedBox(width: 12),
                  Text(
                    L10n.get(widget.language, 'lifeDeathProblems'),
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ],
              ),
            ),
            // 이어하기 버튼 (저장된 게임이 있을 때만 표시)
            if (_savedGameInfo != null) ...[
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              _buildContinueButton(),
            ],
          ],
        ),
      ),
    );
  }

  // 이어하기 버튼 위젯
  Widget _buildContinueButton() {
    if (_savedGameInfo == null) return const SizedBox();

    // 저장된 게임 정보 파싱
    final boardSize = _savedGameInfo!['boardSize'] ?? 19;
    final moveCount = (_savedGameInfo!['moveHistory'] as List?)?.length ?? 0;
    final vsAI = _savedGameInfo!['vsAI'] ?? true;
    final playerColorIndex = _savedGameInfo!['playerColor'] ?? 1;
    final aiDifficultyIndex = _savedGameInfo!['aiDifficulty'] ?? 1;
    final saveTimeStr = _savedGameInfo!['saveTime'] as String?;

    String saveTimeDisplay = '';
    if (saveTimeStr != null) {
      try {
        final saveTime = DateTime.parse(saveTimeStr);
        saveTimeDisplay = '${saveTime.month}/${saveTime.day} ${saveTime.hour}:${saveTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        saveTimeDisplay = '';
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.save, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    L10n.get(widget.language, 'savedGameInfo'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '$boardSize×$boardSize | ${L10n.get(widget.language, 'moveCount')}: $moveCount${saveTimeDisplay.isNotEmpty ? ' | $saveTimeDisplay' : ''}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // 저장된 게임을 불러와서 시작
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BadukGame(
                  vsAI: vsAI,
                  playerColor: Stone.values[playerColorIndex],
                  language: widget.language,
                  aiDifficulty: AIDifficulty.values[aiDifficultyIndex],
                  loadSavedGame: true,  // 자동 불러오기
                ),
              ),
            ).then((_) {
              // 화면 복귀 시 저장된 게임 정보 새로고침
              _checkSavedGame();
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.play_arrow, size: 28),
              const SizedBox(width: 12),
              Text(
                L10n.get(widget.language, 'continue'),
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ],
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
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(widget.language, 'lifeDeathProblems')),
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
                  child: Text('유형', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Text('진행', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Text('영상', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                  child: Text('문제', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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

  const InfoMenuPage({
    super.key,
    required this.onBack,
    required this.language,
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
              return AboutPage(onBack: () => Navigator.pop(context), language: language);
            case 'help':
              return HelpPage(onBack: () => Navigator.pop(context), language: language);
            case 'privacy':
              return PrivacyPolicyPage(onBack: () => Navigator.pop(context), language: language);
            case 'terms':
              return TermsOfServicePage(onBack: () => Navigator.pop(context), language: language);
            default:
              return AboutPage(onBack: () => Navigator.pop(context), language: language);
          }
        },
      ),
    );
  }
}

// 앱 소개 페이지
class AboutPage extends StatelessWidget {
  final VoidCallback onBack;
  final GameLanguage language;

  const AboutPage({
    super.key,
    required this.onBack,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(language, 'about')),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown[100]!, Colors.brown[200]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.brown[700],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.grid_on,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  L10n.get(language, 'appTitle'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.brown[600],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  L10n.get(language, 'aboutContent'),
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.brown[800],
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
class HelpPage extends StatelessWidget {
  final VoidCallback onBack;
  final GameLanguage language;

  const HelpPage({
    super.key,
    required this.onBack,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(language, 'help')),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown[100]!, Colors.brown[200]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              L10n.get(language, 'helpContent'),
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.brown[800],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 개인정보처리방침 페이지
class PrivacyPolicyPage extends StatelessWidget {
  final VoidCallback onBack;
  final GameLanguage language;

  const PrivacyPolicyPage({
    super.key,
    required this.onBack,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(language, 'privacyPolicy')),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown[100]!, Colors.brown[200]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              L10n.get(language, 'privacyPolicyContent'),
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.brown[800],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 이용약관 페이지
class TermsOfServicePage extends StatelessWidget {
  final VoidCallback onBack;
  final GameLanguage language;

  const TermsOfServicePage({
    super.key,
    required this.onBack,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.get(language, 'termsOfService')),
        backgroundColor: Colors.brown[700],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.brown[100]!, Colors.brown[200]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              L10n.get(language, 'termsOfServiceContent'),
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.brown[800],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
