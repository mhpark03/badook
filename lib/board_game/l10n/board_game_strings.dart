/// 보드게임 한국어 문자열
class BoardGameStrings {
  static const Map<String, String> _strings = {
    // Common
    'common.easy': '쉬움',
    'common.normal': '보통',
    'common.hard': '어려움',
    'common.playerCount': '{count}인',
    'app.continue': '이어하기',
    'app.newGame': '새 게임',
    'dialog.selectMode': '모드 선택',
    'dialog.selectDifficulty': '난이도 선택',
    'vs.vsComputer': 'AI 대전',
    'vs.twoPlayer': '2인 대전',
    'vs.playAs': '{piece}으로 플레이',
    'vs.first': '선공',
    'vs.second': '후공',

    // Tetris
    'games.tetris.name': '테트리스',
    'games.tetris.subtitle': '블록 쌓기',
    'games.tetris.description': '블록을 회전하여 줄을 완성하세요',
    'games.tetris.level': '레벨',
    'games.tetris.lines': '줄',
    'games.tetris.score': '점수',
    'games.tetris.next': '다음',
    'games.tetris.gameOver': '게임 오버',
    'games.tetris.newGame': '새 게임',
    'games.tetris.pause': '일시정지',
    'games.tetris.resume': '계속',
    'games.tetris.selectStartLevel': '시작 레벨 선택',
    'games.tetris.levelValue': 'Lv {level}',
    'games.tetris.start': '시작',

    // Gomoku
    'games.gomoku.name': '오목',
    'games.gomoku.subtitle': '5개 연속',
    'games.gomoku.description': '5개의 돌을 먼저 연속으로 놓으세요',
    'games.gomoku.black': '흑',
    'games.gomoku.white': '백',
    'games.gomoku.blackWin': '흑 승리!',
    'games.gomoku.whiteWin': '백 승리!',
    'games.gomoku.draw': '무승부!',
    'games.gomoku.yourTurn': '당신 차례',
    'games.gomoku.aiThinking': 'AI 생각 중...',

    // Othello
    'games.othello.name': '오셀로',
    'games.othello.subtitle': '뒤집기 게임',
    'games.othello.description': '상대 돌을 뒤집어 더 많은 돌을 가지세요',
    'games.othello.black': '흑',
    'games.othello.white': '백',
    'games.othello.blackWin': '흑 승리!',
    'games.othello.whiteWin': '백 승리!',
    'games.othello.draw': '무승부!',
    'games.othello.noMove': '놓을 수 없음',
    'games.othello.pass': '패스',

    // Chess
    'games.chess.name': '체스',
    'games.chess.subtitle': '전략 게임',
    'games.chess.description': '상대 왕을 체크메이트하세요',
    'games.chess.white': '백',
    'games.chess.black': '흑',
    'games.chess.check': '체크!',
    'games.chess.checkmate': '체크메이트!',
    'games.chess.stalemate': '스테일메이트!',
    'games.chess.whiteWin': '백 승리!',
    'games.chess.blackWin': '흑 승리!',

    // Janggi (Korean Chess)
    'games.janggi.name': '장기',
    'games.janggi.subtitle': '한국 체스',
    'games.janggi.description': '상대 궁을 잡으세요',
    'games.janggi.cho': '초',
    'games.janggi.han': '한',
    'games.janggi.choWin': '초 승리!',
    'games.janggi.hanWin': '한 승리!',

    // Minesweeper
    'games.minesweeper.name': '지뢰찾기',
    'games.minesweeper.subtitle': '폭탄 피하기',
    'games.minesweeper.description': '지뢰를 피해 모든 칸을 열어보세요',
    'games.minesweeper.mines': '지뢰',
    'games.minesweeper.win': '승리!',
    'games.minesweeper.gameOver': '게임 오버',

    // Maze
    'games.maze.name': '미로',
    'games.maze.subtitle': '길찾기',
    'games.maze.description': '미로를 탈출하세요',
    'games.maze.start': '시작',
    'games.maze.goal': '도착',
    'games.maze.clear': '클리어!',

    // Bubble
    'games.bubble.name': '버블팝',
    'games.bubble.subtitle': '버블 터트리기',
    'games.bubble.description': '같은 색 버블 3개 이상 연결하세요',

    // Mole
    'games.mole.name': '두더지잡기',
    'games.mole.subtitle': '반응 게임',
    'games.mole.description': '두더지를 빠르게 잡으세요',
    'games.mole.score': '점수',
    'games.mole.time': '시간',
    'games.mole.seconds': '초',
    'games.mole.highScore': '최고점수',
    'games.mole.start': '시작',
    'games.mole.playing': '진행중',
    'games.mole.gameOver': '게임 오버',
    'games.mole.rulesTitle': '게임 방법',
    'games.mole.rulesObjective': '목표',
    'games.mole.rulesObjectiveDesc': '제한 시간 내에 최대한 많은 두더지를 잡으세요.',
    'games.mole.rulesControls': '조작',
    'games.mole.rulesControlsDesc': '두더지가 나타나면 빠르게 클릭하세요.',
    'games.mole.rulesScoring': '점수',
    'games.mole.rulesScoringDesc': '두더지를 잡을 때마다 1점을 얻습니다.',
    'games.mole.rulesTips': '팁',
    'games.mole.rulesTipsDesc': '빠른 반응 속도가 중요합니다!',
    'common.confirm': '확인',
    'app.confirm': '확인',

    // Solitaire
    'games.solitaire.name': '솔리테어',
    'games.solitaire.subtitle': '카드 게임',
    'games.solitaire.description': '카드를 정리하세요',

    // Sudoku
    'games.sudoku.name': '스도쿠',
    'games.sudoku.subtitle': '숫자 퍼즐',
    'games.sudoku.description': '1-9 숫자를 채우세요',
    'games.sudoku.classic': '클래식',
    'games.sudoku.samurai': '사무라이',
    'games.sudoku.killer': '킬러',

    // Number Sums
    'games.numberSums.name': '숫자합',
    'games.numberSums.subtitle': '덧셈 퍼즐',
    'games.numberSums.description': '숫자를 합하여 목표를 맞추세요',

    // Baseball
    'games.baseball.name': '숫자야구',
    'games.baseball.subtitle': '숫자 맞추기',
    'games.baseball.description': '숫자를 추리하세요',

    // Yutnori
    'games.yutnori.name': '윷놀이',
    'games.yutnori.subtitle': '전통 게임',
    'games.yutnori.description': '윷을 던져 말을 움직이세요',

    // Hula
    'games.hula.name': '훌라',
    'games.hula.subtitle': '카드 게임',
    'games.hula.description': '카드를 모아 세트를 만드세요',

    // OneCard
    'games.onecard.name': '원카드',
    'games.onecard.subtitle': '카드 게임',
    'games.onecard.description': '카드를 먼저 버리세요',
  };

  static String get(String key, {Map<String, String>? namedArgs}) {
    String value = _strings[key] ?? key;
    if (namedArgs != null) {
      namedArgs.forEach((argKey, argValue) {
        value = value.replaceAll('{$argKey}', argValue);
      });
    }
    return value;
  }
}

/// easy_localization의 .tr() 확장 메서드를 대체
extension StringTranslation on String {
  String tr({Map<String, String>? namedArgs}) {
    return BoardGameStrings.get(this, namedArgs: namedArgs);
  }
}
