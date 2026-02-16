import 'package:flutter/material.dart';

class MightyTutorialScreen extends StatelessWidget {
  const MightyTutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Icon(Icons.school, color: Colors.amber, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    '마이티 배우기',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // 본문
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      '1. 게임 소개',
                      Icons.info_outline,
                      '마이티는 5명이 즐기는 트릭테이킹 카드 게임입니다.\n'
                      '조커를 포함한 53장의 카드를 사용하며, 각 플레이어에게 10장씩 나누고 '
                      '3장은 바닥패(키티)로 남깁니다.\n\n'
                      '주공(1명)과 프렌드(1명)가 공격팀, 나머지 3명이 수비팀이 됩니다. '
                      '주공팀이 공약한 점수 이상을 획득하면 승리합니다.',
                    ),
                    _buildSection(
                      '2. 게임 진행 순서',
                      Icons.format_list_numbered,
                      '① 카드 분배 → ② 비딩 → ③ 바닥패 교환 → ④ 프렌드 선언 → ⑤ 카드 플레이 → ⑥ 점수 계산\n\n'
                      '각 단계는 순서대로 진행됩니다. 모든 플레이어가 패스하면 카드를 다시 나눕니다.',
                    ),
                    _buildSection(
                      '3. 비딩 (배팅)',
                      Icons.gavel,
                      '자신이 획득할 수 있는 점수 카드 수를 선언합니다.\n\n'
                      '• 최소 공약: 13점 (점수카드 총 20장 중)\n'
                      '• 기루다(으뜸패) 무늬를 함께 선언\n'
                      '• 노기루다: 기루다 없이 선언 (같은 숫자로 기루다 선언보다 우선)\n'
                      '• 가장 높은 공약을 한 플레이어가 주공이 됩니다\n\n'
                      '💡 손에 마이티, 조커, 기루다 A가 있으면 높은 공약이 가능합니다.',
                    ),
                    _buildSection(
                      '4. 바닥패 교환',
                      Icons.swap_horiz,
                      '주공은 바닥패 3장을 가져와 13장 중 3장을 버립니다.\n\n'
                      '• 약한 카드를 버려 핸드를 강화합니다\n'
                      '• 기루다를 변경할 수 있습니다 (공약 +2 추가)\n'
                      '• 점수 카드를 버릴 수도 있지만 수비팀에게 유리해질 수 있습니다',
                    ),
                    _buildSection(
                      '5. 프렌드 선언',
                      Icons.people,
                      '주공이 자신의 팀원(프렌드)을 지정합니다.\n\n'
                      '• 카드 프렌드: 특정 카드 소유자 (예: ♠A 가진 사람)\n'
                      '• 초구 프렌드: 첫 번째 트릭을 이기는 사람\n'
                      '• 노프렌드: 혼자서 (점수 ×2)\n\n'
                      '프렌드는 해당 카드를 낼 때까지 정체가 드러나지 않습니다. '
                      '수비팀은 누가 프렌드인지 추리해야 합니다.',
                    ),
                    _buildSection(
                      '6. 특수 카드',
                      Icons.star,
                      '♠A 마이티 (Mighty)\n'
                      '가장 강한 카드입니다. 어떤 카드도 이길 수 없습니다.\n'
                      '단, 조커콜 시 반드시 내야 하고, 기루다가 ♠이면 ♦A가 마이티입니다.\n\n'
                      '🃏 조커 (Joker)\n'
                      '마이티 다음으로 강한 카드입니다.\n'
                      '선공 시 무늬를 지정할 수 있고, 초구에는 효력이 없습니다.\n'
                      '조커콜을 당하면 반드시 조커를 내야 합니다.\n\n'
                      '기루다 (으뜸패)\n'
                      '주공이 정한 무늬의 카드입니다.\n'
                      '비기루다 무늬에서 기루다를 내면 "컷"으로 트릭을 이깁니다.',
                    ),
                    _buildSection(
                      '7. 조커콜',
                      Icons.campaign,
                      '선공 플레이어가 특정 무늬의 카드를 내면서 "조커콜"을 선언하면, '
                      '조커를 가진 플레이어는 반드시 조커를 내야 합니다.\n\n'
                      '• 초구에는 조커콜 불가\n'
                      '• 조커콜 시 조커는 가장 약한 카드가 됩니다\n'
                      '• 수비팀이 상대 조커를 무력화하는 핵심 전략입니다',
                    ),
                    _buildSection(
                      '8. 트릭 플레이',
                      Icons.style,
                      '10번의 트릭(라운드)을 진행합니다.\n\n'
                      '• 선공 플레이어가 카드 한 장을 냅니다\n'
                      '• 나머지 플레이어는 같은 무늬의 카드를 내야 합니다 (팔로우)\n'
                      '• 해당 무늬가 없으면 아무 카드나 낼 수 있습니다\n'
                      '• 가장 강한 카드를 낸 플레이어가 트릭을 이기고 다음 선공이 됩니다\n\n'
                      '카드 강도 순서:\n'
                      '마이티 > 조커 > 기루다(A~2) > 선공 무늬(A~2)',
                    ),
                    _buildSection(
                      '9. 점수 카드',
                      Icons.calculate,
                      '점수 카드: A, K, Q, J, 10 (각 무늬 5장 × 4무늬 = 20장)\n'
                      '각 점수 카드는 1점이며, 트릭에서 이긴 플레이어가 가져갑니다.\n\n'
                      '예시: 트릭에 ♠A, ♠K, ♥3, ♦7, ♣2가 나왔다면\n'
                      '→ 점수 카드 2장 (♠A, ♠K) = 2점을 트릭 승자가 획득',
                    ),
                    _buildSection(
                      '10. 승패 및 점수 계산',
                      Icons.emoji_events,
                      '주공팀이 공약 이상의 점수를 획득하면 승리합니다.\n\n'
                      '승리 시 기본 점수:\n'
                      '• (획득 점수 - 공약) + 1 + 추가 보너스\n'
                      '• 런(10트릭 전부 승리): 보너스 점수\n'
                      '• 노프렌드: 점수 ×2\n'
                      '• 노기루다: 점수 ×2\n\n'
                      '패배 시:\n'
                      '• 주공은 (수비팀 인원 × 기본 점수)만큼 감점\n'
                      '• 백런(수비 전승): 추가 감점',
                    ),
                    _buildSection(
                      '11. 전략 팁',
                      Icons.lightbulb_outline,
                      '주공 전략:\n'
                      '• 마이티/조커/기루다A가 있으면 적극적으로 비딩하세요\n'
                      '• 초반에 기루다를 소진시켜 상대 컷을 방지하세요\n'
                      '• 프렌드와 협력하여 점수 카드를 모으세요\n\n'
                      '수비 전략:\n'
                      '• 프렌드의 정체를 빨리 파악하세요\n'
                      '• 조커콜로 상대 조커를 무력화하세요\n'
                      '• 점수 카드를 주공팀에게 주지 않도록 주의하세요\n'
                      '• 기루다 컷으로 상대 비기루다 A를 잡으세요',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
