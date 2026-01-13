/// Gemini AI 서비스 (웹 스텁)
/// 웹에서는 Gemini API를 사용하지 않고 로컬 AI를 사용합니다.
class GeminiService {
  final String apiKey;

  GeminiService(this.apiKey);

  /// 장기 보드 상태를 문자열로 변환
  static String boardToString(List<List<dynamic>> board) {
    final buffer = StringBuffer();
    buffer.writeln('  0 1 2 3 4 5 6 7 8');
    buffer.writeln('  -----------------');

    for (int row = 0; row < 10; row++) {
      buffer.write('$row|');
      for (int col = 0; col < 9; col++) {
        final piece = board[row][col];
        if (piece == null) {
          buffer.write('. ');
        } else {
          String symbol = _getPieceSymbol(piece);
          buffer.write('$symbol ');
        }
      }
      buffer.writeln('|');
    }
    buffer.writeln('  -----------------');
    return buffer.toString();
  }

  static String _getPieceSymbol(dynamic piece) {
    final type = piece.type.toString().split('.').last;
    final isHan = piece.color.toString().contains('han');

    String symbol;
    switch (type) {
      case 'gung':
        symbol = isHan ? 'H궁' : 'C궁';
        break;
      case 'cha':
        symbol = isHan ? 'H차' : 'C차';
        break;
      case 'po':
        symbol = isHan ? 'H포' : 'C포';
        break;
      case 'ma':
        symbol = isHan ? 'H마' : 'C마';
        break;
      case 'sang':
        symbol = isHan ? 'H상' : 'C상';
        break;
      case 'sa':
        symbol = isHan ? 'H사' : 'C사';
        break;
      case 'byung':
        symbol = isHan ? 'H졸' : 'C병';
        break;
      default:
        symbol = '??';
    }
    return symbol;
  }

  /// Gemini에게 최선의 수를 요청 (웹에서는 항상 null 반환 → 로컬 AI 사용)
  Future<Map<String, int>?> getBestMove({
    required List<List<dynamic>> board,
    required String currentPlayer,
    required List<Map<String, dynamic>> legalMoves,
  }) async {
    // 웹에서는 Gemini API를 사용하지 않음
    return null;
  }
}
