import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:trip_planner/data/models/activity.dart';
import 'package:trip_planner/features/create_trip/view/create_trip_screen.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/utils/date_utils.dart';
import 'package:trip_planner/widgets/common_bottom_navigation_bar.dart';

class TripDetailsScreen extends ConsumerStatefulWidget {
  final int tripId;

  const TripDetailsScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  final dateFormatter = DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    super.initState();
    // initStateで一度だけloadTripDetailsを呼び出す
    // ref.readはinitState内では使えないので、WidgetsBinding.instance.addPostFrameCallbackを使う
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tripByIdProvider(widget.tripId));
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(tripByIdProvider(widget.tripId), (_, next) {
      if (!next.isLoading) {
        // エラーハンドリングや、旅行が見つからなかった場合の処理
        // 例: context.go('/error');
      }
    });
    final tripAsync = ref.watch(tripByIdProvider(widget.tripId));

    return tripAsync.when(
      data: (trip) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => context.go('/'),
            ),
            title:
                trip == null
                    ? const SizedBox.shrink()
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          trip.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${dateFormatter.format(trip.startDate)} (${formatWeekday(trip.startDate)}) ~ ${dateFormatter.format(trip.endDate)} (${formatWeekday(trip.endDate)})',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
            actions: [
              if (trip != null)
                TextButton(
                  onPressed: () {
                    // context.go('/trip/edit/${trip.id}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => CreateTripScreen(initialTrip: trip),
                      ),
                    );
                  },
                  child: Text('編集'),
                ),
            ],
          ),
          body:
              trip == null
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'まだ旅行の予定はありません',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 今日の重要事項カード
                        if (trip.memo != null && trip.memo != '')
                          Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.yellow[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.lightbulb_outline,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '今日の重要事項',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        trip.memo!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // タイムラインスケジュール
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              // 予定のハイライトバナー
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.yellow[700],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '次の予定はココ！',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '14:00',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '古宇利島オーシャンタワー',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),
                              // アクティビティのタイムライン
                              ...trip.activities.map((activity) {
                                final isLast = trip.activities.length - 1 == 2;
                                return _buildTimelineItem(
                                  activity,
                                  isLast,
                                  false, // ハイライトは一旦なし
                                );
                              }),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
          bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 1),
        );
      },
      error: (_, __) => const Center(child: Text('旅行予定を取得できませんでした。')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildTimelineItem(
    Activity activity,
    bool isLast,
    bool isHighlighted,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 時間とタイムライン
        SizedBox(
          width: 60,
          child: Column(
            children: [
              Text(
                formatTimeOfDay(activity.time),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.green : Colors.black,
                ),
              ),
              Text(
                activity.timeInMinutes.toString(),
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
            ],
          ),
        ),

        // タイムライン（縦線とドット）
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isHighlighted ? Colors.green : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 100, color: Colors.grey[300]),
          ],
        ),

        const SizedBox(width: 12),

        // アクティビティカード
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isHighlighted ? Colors.green[50] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isHighlighted ? Colors.green : Colors.grey[200]!,
                width: isHighlighted ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.abc, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity.description,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              activity.location,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
