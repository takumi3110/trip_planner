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
      appBar: AppBar(title: const Text('新しい旅行プラン')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(
                    labelText: '目的地',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Date pickers will be added later
                const Text('（ここに日付選択のUIが入るよ）'),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    _viewModel.createTrip();
                    // Navigate to the details screen with a hardcoded ID for now
                    context.go('/trip/1');
                  },
                  child: const Text('プランを作成'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
