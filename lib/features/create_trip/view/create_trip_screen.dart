import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_detail.dart';
import 'package:trip_planner/features/create_trip/viewmodel/create_trip_viewmodel.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  late final CreateTripViewModel _viewModel;
  final _tripNameController = TextEditingController();
  final _memoController = TextEditingController();
  
  DateTime _startDate = DateTime(2025, 10, 21);
  DateTime _endDate = DateTime(2025, 10, 23);

  @override
  void initState() {
    super.initState();
    _viewModel = CreateTripViewModel();
    _tripNameController.text = '沖縄リフレッシュ旅行';
    _memoController.text = 'とにかく海を楽しむ！🌊 昼食は地元で評判、タコライスのお店に行って欲しい！';
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _tripNameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.go('/'),
        ),
        title: const Text(
          '旅行全体の編集',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 更新処理
              context.go('/');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('更新'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 旅行の基本設定
            _buildSectionHeader('✈️ 旅行の基本設定'),
            const SizedBox(height: 12),
            _buildLabelText('旅行名（必須）'),
            const SizedBox(height: 8),
            TextField(
              controller: _tripNameController,
              decoration: InputDecoration(
                hintText: '例：沖縄リフレッシュ旅行',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // 期間
            _buildSectionHeader('📅 期間'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() => _startDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '2025/10/21',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('-', style: TextStyle(fontSize: 20)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: _startDate,
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() => _endDate = date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '2025/10/23',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              const Icon(Icons.calendar_today, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 全体の共有メモ
            _buildSectionHeader('📝 全体の共有メモ'),
            const SizedBox(height: 8),
            const Text(
              '旅のテーマ、大事な注意事項など',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 12),
            Text(
              '※このメモは、スケジュール画面のトップページに表示されます。',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),

            const SizedBox(height: 24),

            // 自動スケジュール生成ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTripDetail()));
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('個別スケジュールを追加'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 追加済みの予定
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader('📍 追加済みの予定（1件）'),
                TextButton(
                  onPressed: () {
                    context.push('/trip/create/detail');
                  },
                  child: const Text(
                    'タップで詳細へ',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 予定カード
            _buildScheduleCard(
              '10/21 (火) 12:00～13:30',
              '🍴 沖縄そばランチ',
              '場所：送り駅いません、など',
            ),

            const SizedBox(height: 24),

            // 参加メンバー
            _buildSectionHeader('👥 参加メンバー'),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '👧',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ギャル子ちゃん（あなた）',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: メンバー招待機能
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_add, size: 16),
                      SizedBox(width: 4),
                      Text('メンバーを招待'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // この旅行を削除
            _buildSectionHeader('🗑️ この旅行を削除'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showDeleteConfirmDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('この旅行のデータを全て削除する'),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLabelText(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildScheduleCard(String datetime, String title, String location) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            datetime,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('旅行を削除しますか？'),
        content: const Text('この操作は取り消せません。本当に削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: 削除処理
              context.go('/');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'スケジュール',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.green),
            label: '追加',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share_outlined),
            activeIcon: Icon(Icons.share),
            label: '共有',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/trip/1');
              break;
            case 2:
              // 追加画面
              context.push('/trip/create/detail');
              break;
            case 3:
              // TODO: 共有画面
              break;
            case 4:
              context.go('/settings');
              break;
          }
        },
      ),
    );
  }
}
