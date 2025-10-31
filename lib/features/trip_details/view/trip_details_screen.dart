import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/features/trip_details/viewmodel/trip_details_viewmodel.dart';
import 'package:trip_planner/widgets/common_bottom_navigation_bar.dart';

class TripDetailsScreen extends ConsumerWidget {
  final String tripId;

  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
        final viewModel = ref.watch(tripDetailsViewModelProvider(tripId));
    
        // TripDetailsScreenが表示されたときにloadTripDetailsを呼び出す
        // initStateの代わり
        ref.listen<TripDetailsViewModel>(
          tripDetailsViewModelProvider(tripId),
          (_, next) {
            if (!next.isLoading && next.trip == null) {
              // エラーハンドリングや、旅行が見つからなかった場合の処理
              // 例: context.go('/error');
            }
          },
        );
    
        // 初回ロード
        if (!viewModel.isLoading && viewModel.trip == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.loadTripDetails();
          });
        }
    
        return Scaffold(
            backgroundColor: const Color(0xFFFAFAFA),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.go('/'),
              ),
              title: viewModel.trip == null
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${viewModel.trip!.destination}旅行',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '10/21 (火)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.trip == null
                    ? const Center(child: Text('旅行プランが見つかりませんでした。'))
                    : viewModel.trip!.activities.isEmpty
                        ? const Center(child: Text('まだ旅程がありません。'))
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 今日の重要事項カード
                                Container(
                                  margin: const EdgeInsets.all(16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.lightbulb_outline, color: Colors.orange),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                              'とにかく海を楽しむ！🌊 昼食は地元で評判、タコライスのお店に行って欲しい',
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
                                      // ...itinerary.activities.asMap().entries.map((entry) {
                                      //   final index = entry.key;
                                      //   final activity = entry.value;
                                      //   final isLast = index == itinerary.activities.length - 1;
                                      //
                                      //   return _buildTimelineItem(
                                      //     context,
                                      //     activity.time.format(context),
                                      //     _getActivityDuration(index),
                                      //     _getActivityIcon(index),
                                      //     activity.name,
                                      //     activity.location,
                                      //     _getActivityDetail(index),
                                      //     isLast,
                                      //     index == 2, // 12:00のランチをハイライト
                                      //   );
                                      // }).toList(),
                                    ],
                                  ),
                                ),
    
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
            bottomNavigationBar:CommonBottomNavigationBar(currentIndex: 1),
          );}

  Widget _buildTimelineItem(
    BuildContext context,
    String time,
    String duration,
    IconData icon,
    String title,
    String location,
    String? detail,
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
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? Colors.green : Colors.black,
                ),
              ),
              Text(
                duration,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
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
              Container(
                width: 2,
                height: 100,
                color: Colors.grey[300],
              ),
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
                  child: Icon(icon, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (detail != null)
                        Text(
                          detail,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
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
                              location,
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
