import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/providers/activity_provider.dart';
import 'package:trip_planner/widgets/common_bottom_navigation_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateTripDetail extends ConsumerStatefulWidget {
  final int tripId;
  const CreateTripDetail({super.key, required this.tripId});

  @override
  ConsumerState<CreateTripDetail> createState() => _CreateTripDetailState();
}

class _CreateTripDetailState extends ConsumerState<CreateTripDetail> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _memoController = TextEditingController();

  String? _selectedCategory;
  String? _selectedTransport;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  bool _shareWithMembers = false;

  final dateFormatter = DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
            onPressed: () async {
              await _saveActivity();
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
                _buildTransportChip('飛行機', '✈️', Colors.blue),
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
                      dateFormatter.format(_selectedDate),
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
                              Text(_startTime.format(context), style: const TextStyle(fontSize: 16)),
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
                              Text(_endTime.format(context), style: const TextStyle(fontSize: 16)),
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
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 2),
    );
  }

  Future<void> _saveActivity() async {
    final activityService = ref.read(activityProvider);

    final newActivity = Activity(
      name: _titleController.text,
      location: _locationController.text,
      description: _memoController.text,
      timeInMinutes: (_endTime.hour * 60 + _endTime.minute) - (_startTime.hour * 60 + _startTime.minute),
      category: _selectedCategory,
      arrivalTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime.hour,
        _startTime.minute,
      ),
      departureTime: DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime.hour,
        _endTime.minute,
      ),
      moved: _selectedTransport ?? '未選択',
    );

    final success = await activityService.saveActivity(newActivity);

    if (success) {
      debugPrint('アクティビティが保存されました！');
      ref.invalidate(allActivityProvider);
    } else {
      debugPrint('アクティビティの保存に失敗しました。');
    }
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
}
