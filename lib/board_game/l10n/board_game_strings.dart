/// 보드게임 한국어 문자열
class BoardGameStrings {
  static const Map<String, String> _strings = {
    // Common
    'common.easy': '쉬움',
    'common.normal': '보통',
    'common.hard': '어려움',
    'common.playerCount': '{count}인',
    'common.confirm': '확인',
    'common.cancel': '취소',
    'common.win': '승리!',
    'common.lose': '패배',
    'common.hint': '힌트',
    'common.giveUp': '포기',
    'common.watchAd': '확인',
    'common.watchAdRevive': '부활하기',

    // App common
    'app.continue': '이어하기',
    'app.newGame': '새 게임',
    'app.confirm': '확인',
    'app.cancel': '취소',
    'app.rules': '게임 방법',
    'app.restart': '다시 시작',

    // Dialog
    'dialog.selectMode': '모드 선택',
    'dialog.selectDifficulty': '난이도 선택',
    'dialog.hintTitle': '힌트',
    'dialog.hintMessage': '힌트를 사용하시겠습니까?',
    'dialog.reviveMessage': '부활하시겠습니까?',

    // VS mode
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
    'games.tetris.gameOverTitle': '게임 오버',
    'games.tetris.gameOverDesc': '블록이 위에 닿으면 게임이 끝납니다.',
    'games.tetris.newGame': '새 게임',
    'games.tetris.pause': '일시정지',
    'games.tetris.paused': '일시정지',
    'games.tetris.resume': '계속',
    'games.tetris.selectStartLevel': '시작 레벨 선택',
    'games.tetris.levelValue': 'Lv {level}',
    'games.tetris.start': '시작',
    'games.tetris.startGame': '게임 시작',
    'games.tetris.cancel': '취소',
    'games.tetris.playAgain': '다시 하기',
    'games.tetris.rulesTitle': '게임 방법',
    'games.tetris.objective': '목표',
    'games.tetris.objectiveDesc': '떨어지는 블록을 쌓아 가로 줄을 완성하세요.',
    'games.tetris.controls': '조작',
    'games.tetris.controlsDesc': '좌우로 이동, 위로 회전, 아래로 빠르게 내리기',
    'games.tetris.scoring': '점수',
    'games.tetris.scoringDesc': '한 줄 완성: 100점, 여러 줄 동시 완성 시 보너스!',

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
    'games.minesweeper.progress': '진행',
    'games.minesweeper.win': '승리!',
    'games.minesweeper.gameOver': '게임 오버',
    'games.minesweeper.mineExploded': '지뢰가 폭발했습니다!',
    'games.minesweeper.rulesTitle': '게임 방법',
    'games.minesweeper.rulesObjective': '목표',
    'games.minesweeper.rulesObjectiveDesc': '지뢰가 없는 모든 칸을 열어야 합니다.',
    'games.minesweeper.rulesControls': '조작',
    'games.minesweeper.rulesControlsDesc': '클릭하여 칸 열기, 길게 클릭하여 깃발 표시',
    'games.minesweeper.rulesNumbers': '숫자',
    'games.minesweeper.rulesNumbersDesc': '숫자는 주변 8칸에 있는 지뢰 수를 나타냅니다.',
    'games.minesweeper.rulesTips': '팁',
    'games.minesweeper.rulesTipsDesc': '깃발을 사용하여 지뢰 위치를 표시하세요.',

    // Maze
    'games.maze.name': '미로',
    'games.maze.subtitle': '길찾기',
    'games.maze.description': '미로를 탈출하세요',
    'games.maze.start': '시작',
    'games.maze.goal': '도착',
    'games.maze.clear': '클리어!',
    'games.maze.movesLabel': '이동',
    'games.maze.timeLabel': '시간',
    'games.maze.congratulations': '축하합니다!',
    'games.maze.escaped': '미로를 탈출했습니다!',
    'games.maze.rulesTitle': '게임 방법',
    'games.maze.rulesObjective': '목표',
    'games.maze.rulesObjectiveDesc': '빨간 시작점에서 노란 도착점까지 이동하세요.',
    'games.maze.rulesControls': '조작',
    'games.maze.rulesControlsDesc': '방향키 또는 스와이프로 이동합니다.',
    'games.maze.rulesButtons': '버튼',
    'games.maze.rulesButtonsDesc': '화면 하단의 버튼으로도 이동할 수 있습니다.',
    'games.maze.rulesTips': '팁',
    'games.maze.rulesTipsDesc': '막다른 길에서는 돌아가야 합니다.',

    // Bubble
    'games.bubble.name': '버블팝',
    'games.bubble.subtitle': '버블 터트리기',
    'games.bubble.description': '같은 색 버블 3개 이상 연결하세요',
    'games.bubble.score': '점수',
    'games.bubble.highScore': '최고점수',
    'games.bubble.next': '다음',
    'games.bubble.gameOver': '게임 오버',
    'games.bubble.gameWon': '승리!',
    'games.bubble.retry': '다시 하기',
    'games.bubble.playAgain': '다시 하기',
    'games.bubble.hintTitle': '힌트',
    'games.bubble.hintMessage': '힌트를 사용하시겠습니까?',
    'games.bubble.rulesTitle': '게임 방법',
    'games.bubble.rulesObjective': '목표',
    'games.bubble.rulesObjectiveDesc': '같은 색 버블 3개 이상을 연결하여 터트리세요.',
    'games.bubble.rulesControls': '조작',
    'games.bubble.rulesControlsDesc': '화면을 터치하여 버블을 발사합니다.',
    'games.bubble.rulesScoring': '점수',
    'games.bubble.rulesScoringDesc': '많은 버블을 한번에 터트릴수록 높은 점수!',
    'games.bubble.rulesTips': '팁',
    'games.bubble.rulesTipsDesc': '벽을 이용해 버블을 반사시킬 수 있습니다.',

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
