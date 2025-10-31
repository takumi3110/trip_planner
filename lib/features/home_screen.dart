import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/providers/trip_provider.dart';
import 'package:trip_planner/widgets/common_bottom_navigation_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final dateFormatter = DateFormat('yyyy/MM/dd');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _loadTrip();
    });
  }

  // Future<void> _loadTrip() async {
  //   final repository = context.read<TripRepository>();
  //   try {
  //     final trip = await repository.getTrip('1');
  //     setState(() {
  //       _mockTrip = trip;
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'TabiMate',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 開催中の旅行セクション
            _buildSectionHeader(
              context,
              '🗓️ 開催中の旅行 (ONGOING NOW)',
              Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildOngoingTripCard(context),

            const SizedBox(height: 32),

            // もうすぐの旅行セクション
            _buildSectionHeader(context, '💡 もうすぐの旅行 (UP COMING)', Colors.blue),
            const SizedBox(height: 12),
            _buildUpcomingTripCard(context),
            const SizedBox(height: 32),

            // 過去の思い出セクション
            _buildSectionHeader(
              context,
              '🏔️ 過去の思い出 (PAST TRIPS)',
              Colors.grey,
            ),
            const SizedBox(height: 12),
            _buildPastTripCard(context),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, Color color) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildOngoingTripCard(BuildContext context) {
    final todayTrip = ref.watch(todayTripsProvider);

    return todayTrip.when(
      data: (trip) {
        return trip == null
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '開催中の旅行はありません',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
            : Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withAlpha(100),
                      Colors.white,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // タイトルと進行中バッジ
                      Row(
                        children: [
                          const Text('🏖️', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trip.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '進行中',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 日程
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${dateFormatter.format(trip.startDate)} ~ ${dateFormatter.format(trip.endDate)}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // 進捗
                      Row(
                        children: [
                          const Text('進捗', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: _calculateProgress(trip.startDate, trip.endDate)['progress'],
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.primary,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(_calculateProgress(trip.startDate, trip.endDate)['progress'] * 100).toInt()}% 完了 (${_calculateProgress(trip.startDate, trip.endDate)['daysPassed']}日目)',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ボタン
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/trip/${trip.id}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[400],
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.arrow_forward_ios, size: 16),
                              SizedBox(width: 8),
                              Text(
                                '今すぐ予定を確認！',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
      },
      error: (_, __) => const Center(child: Text('当日の旅行日程を取得できませんでした。')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildUpcomingTripCard(BuildContext context) {
    final upcomingTrip = ref.watch(upcomingTripsProvider);
    return upcomingTrip.when(
      data: (trips) {
        return trips.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '旅行の計画はありません',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/trip/create');
                    },
                    child: Text(
                      '✨ 新しい旅行の計画をたてる',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                return InkWell(
                  onTap: () {
                    context.go('/trip/${trip.id}');
                  },
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${dateFormatter.format(trip.startDate)} - ${dateFormatter.format(trip.endDate)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
      },
      error: (_, __) => const Center(child: Text('未来の旅行日程を取得できませんでした。')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildPastTripCard(BuildContext context) {
    final pastTrips = ref.watch(pastTripsProvider);

    return pastTrips.when(
      data: (trips) {
        return trips.isEmpty
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '旅行の計画はありません',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            )
            : Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trips.length,
                  itemBuilder: (context, index) {
                    final trip = trips[index];
                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${dateFormatter.format(trip.startDate)} - ${dateFormatter.format(trip.endDate)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                // すべての過去の旅行を見る
                const SizedBox(height: 16),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      // TODO: 過去の旅行一覧へ遷移
                    },
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('すべての過去の旅行を見る'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            );
      },
      error: (_, __) => const Center(child: Text('過去の旅行日程を取得できませんでした。')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  // 進捗を計算する関数
  Map<String, dynamic> _calculateProgress(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // 旅行の総日数
    final totalDays = endDate.difference(startDate).inDays + 1;

    // 現在の日付が旅行の何日目か
    final daysPassed = today.difference(startDate).inDays + 1;

    // 進捗率
    final progress = daysPassed / totalDays;

    return {
      'totalDays': totalDays,
      'daysPassed': daysPassed,
      'progress': progress.clamp(0.0, 1.0), // 0.0から1.0の範囲にクランプ
    };
  }
}
