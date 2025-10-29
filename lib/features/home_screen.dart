import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/data/models/trip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Trip? _mockTrip;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrip();
  }

  Future<void> _loadTrip() async {
    final repository = context.read<TripRepository>();
    try {
      final trip = await repository.getTrip('1');
      setState(() {
        _mockTrip = trip;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                  if (_mockTrip != null) _buildOngoingTripCard(context, _mockTrip!),

                  const SizedBox(height: 32),

                  // もうすぐの旅行セクション
                  _buildSectionHeader(
                    context,
                    '💡 もうすぐの旅行 (UP COMING)',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildUpcomingTripCard(
                    context,
                    '京都・紅葉巡り！',
                    '2025/11/25 - 11/27',
                    '3-5泊程度',
                    '残り73日',
                  ),
                  const SizedBox(height: 12),
                  _buildUpcomingTripCard(
                    context,
                    '冬の北海道グルメ旅',
                    '2025/12/28 - 2026/01/01',
                    'ソロ旅行',
                    '残り73日',
                  ),

                  const SizedBox(height: 32),

                  // 過去の思い出セクション
                  _buildSectionHeader(
                    context,
                    '🏔️ 過去の思い出 (PAST TRIPS)',
                    Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  _buildPastTripCard(context, '夏休み！富士山登山', '2024/08/10 - 08/11'),
                  const SizedBox(height: 12),
                  _buildPastTripCard(context, '水郷旅行 in 韓国', '2024/03/01 - 03/05'),

                  const SizedBox(height: 16),

                  // すべての過去の旅行を見る
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
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildOngoingTripCard(BuildContext context, Trip trip) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                      '${trip.destination}旅行',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '2025/10/20 - 10/22',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
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
                      value: 0.66,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('66% 完了 (2日目)', style: TextStyle(fontSize: 12)),
                ],
              ),

              const SizedBox(height: 16),

              // ボタン
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/trip/1');
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
  }

  Widget _buildUpcomingTripCard(
    BuildContext context,
    String title,
    String dates,
    String details,
    String remaining,
  ) {
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
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  dates,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.person, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  details,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              remaining,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastTripCard(
    BuildContext context,
    String title,
    String dates,
  ) {
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
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  dates,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
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
        currentIndex: 0,
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
              // ホーム（現在のページ）
              break;
            case 1:
              // スケジュール画面へ遷移
              // TODO: スケジュール画面を作成後に実装
              break;
            case 2:
              // 新規旅行作成
              context.go('/trip/create');
              break;
            case 3:
              // 共有画面へ遷移
              // TODO: 共有画面を作成後に実装
              break;
            case 4:
              // 設定画面へ遷移
              context.go('/settings');
              break;
          }
        },
      ),
    );
  }
}