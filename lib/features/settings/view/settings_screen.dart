import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:trip_planner/core/theme/theme_notifier.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _reminderEnabled = true;
  String _notificationTime = '15分前';

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
          '設定',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          // アカウント情報セクション
          _buildSectionHeader('👤 アカウント情報'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.person_outline,
                  title: 'プロフィール編集',
                  onTap: () {
                    // TODO: プロフィール編集画面へ
                  },
                ),
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.lock_outline,
                  title: 'パスワードを変更',
                  onTap: () {
                    // TODO: パスワード変更画面へ
                  },
                ),
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.logout,
                  title: 'ログアウト',
                  titleColor: Colors.red,
                  onTap: () {
                    _showLogoutConfirmDialog(context);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // アプリケーション設定セクション
          _buildSectionHeader('⚙️ アプリケーション設定'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                    color: Colors.grey[700],
                  ),
                  title: const Text('リマインダー通知を有効にする'),
                  trailing: Switch(
                    value: _reminderEnabled,
                    onChanged: (value) {
                      setState(() => _reminderEnabled = value);
                    },
                    activeColor: Colors.green,
                  ),
                ),
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.access_time,
                  title: '通知する時間',
                  trailing: _notificationTime,
                  onTap: () {
                    _showNotificationTimeDialog(context);
                  },
                ),
                const Divider(height: 1),
                Consumer<ThemeNotifier>(
                  builder: (context, themeNotifier, child) {
                    return ListTile(
                      leading: Icon(
                        Icons.palette_outlined,
                        color: Colors.grey[700],
                      ),
                      title: const Text('テーマカラー変更'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: themeNotifier.currentTheme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                      onTap: () {
                        _showThemeColorPickerDialog(context);
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.language,
                  title: '言語設定',
                  trailing: '日本語',
                  onTap: () {
                    _showLanguageDialog(context);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ヘルプと情報セクション
          _buildSectionHeader('ヘルプと情報'),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.help_outline,
                  title: 'よくある質問（FAQ）',
                  onTap: () {
                    // TODO: FAQ画面へ
                  },
                ),
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.description_outlined,
                  title: '利用規約',
                  onTap: () {
                    // TODO: 利用規約画面へ
                  },
                ),
                const Divider(height: 1),
                _buildListTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'プライバシーポリシー',
                  onTap: () {
                    // TODO: プライバシーポリシー画面へ
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? trailing,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: titleColor ?? Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: titleColor,
          fontSize: 15,
        ),
      ),
      trailing: trailing != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            )
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ログアウトしますか？'),
        content: const Text('本当にログアウトしますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: ログアウト処理
              context.go('/');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
  }

  void _showNotificationTimeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('通知する時間'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTimeOption('5分前'),
            _buildTimeOption('10分前'),
            _buildTimeOption('15分前'),
            _buildTimeOption('30分前'),
            _buildTimeOption('1時間前'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOption(String time) {
    return ListTile(
      title: Text(time),
      trailing: _notificationTime == time ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        setState(() => _notificationTime = time);
        Navigator.pop(context);
      },
    );
  }

  void _showThemeColorPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final currentThemeNotifier = Provider.of<ThemeNotifier>(dialogContext);
        return AlertDialog(
          title: const Text('テーマカラーを選択'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeColorOption(
                  dialogContext,
                  'ライトブルー',
                  Colors.lightBlue,
                  currentThemeNotifier,
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'ピンク',
                  Colors.pink,
                  currentThemeNotifier,
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'グリーン',
                  Colors.green,
                  currentThemeNotifier,
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'パープル',
                  Colors.purple,
                  currentThemeNotifier,
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'ミントグリーン',
                  Colors.teal.shade100,
                  currentThemeNotifier,
                ),
                _buildThemeColorOption(
                  dialogContext,
                  'ラベンダー',
                  Colors.deepPurple.shade100,
                  currentThemeNotifier,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('キャンセル'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThemeColorOption(
    BuildContext context,
    String title,
    Color seedColor,
    ThemeNotifier themeNotifier,
  ) {
    final isSelected = themeNotifier.currentTheme.colorScheme.primary.toARGB32() ==
        ColorScheme.fromSeed(seedColor: seedColor).primary.toARGB32();

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundColor: seedColor,
        radius: 16,
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        final newTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.light,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'YasashisaGothicBold',
              fontSize: 57.0,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: TextStyle(
              fontFamily: 'YasashisaGothicBold',
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'YasashisaGothicBold',
              fontSize: 16.0,
              height: 1.5,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'YasashisaGothicBold',
              fontSize: 14.0,
              height: 1.4,
            ),
            labelSmall: TextStyle(
              fontFamily: 'YasashisaGothicBold',
              fontSize: 11.0,
              color: Colors.grey,
            ),
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        );
        themeNotifier.setTheme(newTheme);
        Navigator.of(context).pop();
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('言語設定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('日本語'),
            _buildLanguageOption('English'),
            _buildLanguageOption('中文'),
            _buildLanguageOption('한국어'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: language == '日本語' ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        // TODO: 言語変更処理
        Navigator.pop(context);
      },
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
        currentIndex: 4,
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
              context.go('/trip/1');
              break;
            case 2:
              context.go('/trip/create');
              break;
            case 3:
              // TODO: 共有画面
              break;
            case 4:
              // 設定画面（現在のページ）
              break;
          }
        },
      ),
    );
  }
}
