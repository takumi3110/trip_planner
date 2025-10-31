import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/providers/activity_provider.dart';
import 'package:trip_planner/providers/isar_provider.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/widgets/common_bottom_navigation_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  final Trip? initialTrip;

  const CreateTripScreen({super.key, this.initialTrip});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _memoController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final timeFormatter = DateFormat('HH:mm');

  @override
  void initState() {
    super.initState();
    if (widget.initialTrip != null) {
      _titleController.text = widget.initialTrip!.title;
      _destinationController.text = widget.initialTrip!.destination;
      _memoController.text = widget.initialTrip!.memo ?? '';
      _startDate = widget.initialTrip!.startDate;
      _endDate = widget.initialTrip!.endDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _memoController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activityAsync = ref.watch(allActivityProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '旅行日程の編集',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final activities = ref.read(allActivityProvider).value ?? [];
                if (activities.isEmpty) {
                  final bool? continueSaving = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('確認'),
                        content: const Text('アクティビティが追加されていません。このまま旅行を作成しますか？'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            // いいえ
                            child: const Text('いいえ'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            // はい
                            child: const Text('はい'),
                          ),
                        ],
                      );
                    },
                  );

                  if (continueSaving == null || !continueSaving) {
                    return; // 保存処理を中断
                  }
                }

                if (!context.mounted) return;
                _saveTrip(context);
                context.go('/');
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              '更新',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 旅行の基本設定
              _buildSectionHeader('✈️ 旅行の基本設定'),
              const SizedBox(height: 12),
              _buildLabelText('旅行名（必須）'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '例：沖縄リフレッシュ旅行',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '旅行名は必須です';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 8),
              // 目的地
              _buildLabelText('目的地（必須）'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(
                  hintText: '例: 沖縄',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '目的地は必須です';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // 期間
              _buildSectionHeader('📅 期間'),
              const SizedBox(height: 12),
              InkWell(
                // Row全体をInkWellで囲む
                onTap: () async {
                  final DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDateRange: DateTimeRange(
                      start: _startDate,
                      end: _endDate,
                    ),
                  );
                  if (picked != null &&
                      picked !=
                          DateTimeRange(start: _startDate, end: _endDate)) {
                    setState(() {
                      _startDate = picked.start;
                      _endDate = picked.end;
                    });
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${_startDate.year}/${_startDate.month}/${_startDate.day}',
                                  // _startDateで表示を更新
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
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
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${_endDate.year}/${_endDate.month}/${_endDate.day}', // _endDateで表示を更新
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Spacer(),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

              // スケジュール追加ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/trip/1/create/detail');
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTripDetail()));
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
              activityAsync.when(
                data: (activities) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader(
                            '📍 追加済みの予定（${activities.length}件）',
                          ),
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
                      activities.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'まだ予定がありません',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: activities.length,
                            itemBuilder: (context, index) {
                              return _buildScheduleCard(activities[index]);
                            },
                          ),
                    ],
                  );
                },
                error: (_, __) => const Center(child: Text('予定を取得できませんでした。')),
                loading: () => const Center(child: CircularProgressIndicator()),
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
                      child: Text('👧', style: TextStyle(fontSize: 24)),
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
                    if (widget.initialTrip != null) {
                      _showDeleteConfirmDialog(context, widget.initialTrip!.id);
                    } else {
                      // 新規作成モードで削除ボタンが押された場合の処理（通常は表示されないはず）
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('新規作成中の旅行は削除できません。')),
                      );
                    }
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
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildLabelText(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildScheduleCard(Activity activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            '${DateFormat('HH:mm').format(activity.arrivalTime)}~${DateFormat('HH:mm').format(activity.departureTime)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            activity.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  activity.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Id id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
                  _deleteTrip(context, id);
                  context.go('/');
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('削除'),
              ),
            ],
          ),
    );
  }

  Future<void> _saveTrip(context) async {
    final isarService = ref.read(isarServiceProvider);
    final activities = ref.read(allActivityProvider).value ?? [];

    debugPrint('[_saveTrip] activities.isEmpty: ${activities.isEmpty}');

    Trip newTrip;
    if (widget.initialTrip != null) {
      // 既存のTripを更新
      newTrip = widget.initialTrip!;
      newTrip.title = _titleController.text;
      newTrip.destination = _destinationController.text;
      newTrip.startDate = _startDate;
      newTrip.endDate = _endDate;
      newTrip.memo = _memoController.text;
    } else {
      // 新しいTripを作成
      newTrip = Trip(
        title: _titleController.text,
        destination: _destinationController.text,
        startDate: _startDate,
        endDate: _endDate,
        numberOfPeople: 1,
        memo: _memoController.text,
      );
    }

    final success = await isarService.saveTrip(newTrip);
    if (success) {
      final successToActivities = await isarService.saveActivitiesToTrip(
        newTrip,
        activities,
      );
      if (successToActivities) {
        ref.invalidate(allTripsProvider);
        ref.invalidate(todayTripsProvider);
        ref.invalidate(upcomingTripsProvider);
        ref.invalidate(pastTripsProvider);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('旅行の予定を追加しました。')));
      }
    }
  }

  Future<void> _deleteTrip(context, Id id) async {
    final isarService = ref.read(isarServiceProvider);
    final success = await isarService.deleteTrip(id);
    if (success) {
      ref.invalidate(allTripsProvider);
      ref.invalidate(todayTripsProvider);
      ref.invalidate(upcomingTripsProvider);
      ref.invalidate(pastTripsProvider);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('旅行の予定を削除しました。')));
    }
  }
}
