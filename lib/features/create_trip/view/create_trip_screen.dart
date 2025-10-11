import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_planner/features/create_trip/viewmodel/create_trip_viewmodel.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  late final CreateTripViewModel _viewModel;
  final _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = CreateTripViewModel();
    _destinationController.addListener(() {
      _viewModel.setDestination(_destinationController.text);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '新しい旅行プラン',
          style: Theme.of(context).textTheme.headlineSmall, // フォントをテーマに合わせる
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: '目的地',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0), // 角を丸くする
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Date pickers will be added later
                Text(
                  '（ここに日付選択のUIが入るよ）',
                  style:
                      Theme.of(context).textTheme.bodyMedium, // フォントをテーマに合わせる
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // 角を丸くする
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    _viewModel.createTrip();
                    // Navigate to the details screen with a hardcoded ID for now
                    context.go('/trip/1');
                  },
                  child: Text(
                    'プランを作成',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
