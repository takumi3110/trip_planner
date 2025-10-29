import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_screen.dart';
import 'package:trip_planner/features/create_trip/viewmodel/create_trip_viewmodel.dart';

class CreateTripDetail extends StatefulWidget {
  const CreateTripDetail({super.key});

  @override
  State<CreateTripDetail> createState() => _CreateTripDetailState();
}

class _CreateTripDetailState extends State<CreateTripDetail> {
  late final CreateTripViewModel _viewModel;
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _memoController = TextEditingController();

  String? _selectedCategory;
  String? _selectedTransport;
  DateTime _selectedDate = DateTime(2025, 10, 21);
  TimeOfDay _startTime = const TimeOfDay(hour: 12, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 13, minute: 30);
  bool _shareWithMembers = false;

  @override
  void initState() {
    super.initState();
    _viewModel = CreateTripViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.close, color: Colors.black),
        //   onPressed: () => ,
        // ),
        title: const Text(
          '新規スケジュールの追加',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: 保存処理
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTripScreen()));
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('保存'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 基本情報セクション
            _buildSectionHeader('📝 基本情報'),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '予定名 (必須)',
                hintText: '例：沖縄そばランチ、美ら海水族館',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),

            const SizedBox(height: 24),

            // カテゴリ選択
            _buildSectionLabel('カテゴリ選択'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCategoryChip('観光', '🏛️', Colors.green),
                _buildCategoryChip('写真', '📷', Colors.grey),
                _buildCategoryChip('観光', '🗺️', Colors.grey),
                _buildCategoryChip('宿泊', '🏨', Colors.grey),
                _buildCategoryChip('買い物', '🛍️', Colors.grey),
              ],
            ),

            const SizedBox(height: 24),

            // 次の場所への移動手段
            _buildSectionHeader('🚗 次の場所への移動手段'),
            const SizedBox(height: 12),
            const Text(
              'この予定が終わったあとで移動する手段を記録',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTransportChip('タクシー', '🚕', Colors.green),
                _buildTransportChip('バス', '🚌', Colors.grey),
                _buildTransportChip('電車', '🚃', Colors.grey),
                _buildTransportChip('レンタカー/モビリティ', '🚗', Colors.grey),
                _buildTransportChip('徒歩', '🚶', Colors.grey),
              ],
            ),

            const SizedBox(height: 24),

            // 時間と場所
            _buildSectionHeader('⏰ 時間と場所'),
            const SizedBox(height: 12),

            // 日付
            _buildLabelText('日付'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
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

            const SizedBox(height: 16),

            // 開始時間と出発時間
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabelText('開始時間'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _startTime,
                          );
                          if (time != null) {
                            setState(() => _startTime = time);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text('12:00', style: TextStyle(fontSize: 16)),
                              const Spacer(),
                              const Icon(Icons.access_time, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabelText('出発時間'),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _endTime,
                          );
                          if (time != null) {
                            setState(() => _endTime = time);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Text('13:30', style: TextStyle(fontSize: 16)),
                              const Spacer(),
                              const Icon(Icons.access_time, size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 所要時間
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.green[700]),
                  const SizedBox(width: 4),
                  Text(
                    '所要時間：1時間30分',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 場所
            _buildLabelText('場所（手入力可）'),
            const SizedBox(height: 8),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: '送り駅いません、など',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),

            const SizedBox(height: 12),

            // 地図選択ボタン
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: 地図選択機能
                },
                icon: const Icon(Icons.location_on),
                label: const Text('地図から選択・確認（推奨）'),
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

            // 詳細メモ
            _buildSectionHeader('📋 詳細メモ'),
            const SizedBox(height: 12),
            const Text(
              '予約: 予約番号など、その他の参考情報など',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '予約番号: 12345 / おすすめメニューはソーキそば',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),

            const SizedBox(height: 24),

            // メンバー共有
            Row(
              children: [
                Checkbox(
                  value: _shareWithMembers,
                  onChanged: (value) {
                    setState(() => _shareWithMembers = value ?? false);
                  },
                  activeColor: Colors.green,
                ),
                const Text(
                  'このプランをメンバーにも共有する',
                  style: TextStyle(fontSize: 14),
                ),
              ],
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
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

  Widget _buildCategoryChip(String label, String emoji, Color color) {
    final isSelected = _selectedCategory == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedCategory = selected ? label : null);
      },
      selectedColor: color,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildTransportChip(String label, String emoji, Color color) {
    final isSelected = _selectedTransport == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedTransport = selected ? label : null);
      },
      selectedColor: color,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
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
              // 追加画面（現在のページ）
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
