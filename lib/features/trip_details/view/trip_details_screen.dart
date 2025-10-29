import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/features/trip_details/viewmodel/trip_details_viewmodel.dart';
import 'package:provider/provider.dart';

class TripDetailsScreen extends StatelessWidget {
  final String tripId;

  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => TripDetailsViewModel(
            tripId: tripId,
            tripRepository: Provider.of(
              context,
              listen: false,
            ), // ここでTripRepositoryを渡す
          )..loadTripDetails(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.go('/'),
          ),
          title: Consumer<TripDetailsViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.trip == null) return const SizedBox.shrink();
              final trip = viewModel.trip!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trip.destination}旅行',
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
              );
            },
          ),
        ),
        body: Consumer<TripDetailsViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.trip == null) {
              return const Center(child: Text('旅行プランが見つかりませんでした。'));
            }

            final Trip trip = viewModel.trip!;
            
            if (trip.itineraries.isEmpty) {
              return const Center(child: Text('まだ旅程がありません。'));
            }

            final itinerary = trip.itineraries.first;

            return SingleChildScrollView(
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
                        ...itinerary.activities.asMap().entries.map((entry) {
                          final index = entry.key;
                          final activity = entry.value;
                          final isLast = index == itinerary.activities.length - 1;
                          
                          return _buildTimelineItem(
                            context,
                            activity.time.format(context),
                            _getActivityDuration(index),
                            _getActivityIcon(index),
                            activity.name,
                            activity.location,
                            _getActivityDetail(index),
                            isLast,
                            index == 2, // 12:00のランチをハイライト
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

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

  String _getActivityDuration(int index) {
    const durations = ['〜朝10', '30分', '1時間\n14分', '2時間', '2.5時間', '〜翌一\n日'];
    return index < durations.length ? durations[index] : '';
  }

  IconData _getActivityIcon(int index) {
    const icons = [
      Icons.flight_land,
      Icons.shopping_bag_outlined,
      Icons.restaurant,
      Icons.beach_access,
      Icons.restaurant_menu,
      Icons.hotel,
    ];
    return index < icons.length ? icons[index] : Icons.place;
  }

  String? _getActivityDetail(int index) {
    const details = [
      '14:00 抜港 (AI便201号)',
      '〜1:00 抜港 (歩程距離3分)',
      '〜13:30 抜港 (横田町・東石垣市町)',
      '〜16:30 抜港 (人幕音季市町前点)',
      '〜21:00 抜港 (みやび町当地路10分)',
      null,
    ];
    return index < details.length ? details[index] : null;
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
        currentIndex: 1, // スケジュールタブを選択状態に
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
            icon: Icon(Icons.add_circle, size: 40),
            label: '',
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
              // スケジュール画面（現在のページ）
              break;
            case 2:
              context.go('/trip/create');
              break;
            case 3:
              // TODO: 共有画面を作成後に実装
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
