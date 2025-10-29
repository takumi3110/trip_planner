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
        title: const Text(
          '新しい旅行プラン',
        ),
        actions: [
          // 追加
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go('/settings');
            },
          ),
        ],
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
                  decoration: const InputDecoration(
                    labelText: '目的地',
                  ),
                ),
                const SizedBox(height: 16),
                // Date pickers will be added later
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _viewModel.startDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            _viewModel.setStartDate(selectedDate);
                          }
                        },
                        child: Text(
                          _viewModel.startDate == null
                              ? '開始日を選択'
                              : '開始日: ${_viewModel.startDate!.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate:
                                _viewModel.endDate ??
                                _viewModel.startDate ??
                                DateTime.now(),
                            firstDate: _viewModel.startDate ?? DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            _viewModel.setEndDate(selectedDate);
                          }
                        },
                        child: Text(
                          _viewModel.endDate == null
                              ? '終了日を選択'
                              : '終了日: ${_viewModel.endDate!.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
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
