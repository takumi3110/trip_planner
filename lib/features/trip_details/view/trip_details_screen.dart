import 'package:flutter/material.dart';
import 'package:trip_planner/data/repositories/trip_repository.dart';
import 'package:trip_planner/features/trip_details/viewmodel/trip_details_viewmodel.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({
    super.key,
    required this.tripId,
    required this.tripRepository,
  });

  final String tripId;
  final TripRepository tripRepository;

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late final TripDetailsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = TripDetailsViewModel(
      tripRepository: widget.tripRepository,
      tripId: widget.tripId,
    );
    _viewModel.fetchTripDetails();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            return Text(_viewModel.trip?.destination ?? '読み込み中...');
          },
        ),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_viewModel.trip == null) {
            return const Center(child: Text('旅行プランが見つかりませんでした。'));
          }

          final trip = _viewModel.trip!;
          return ListView.builder(
            itemCount: trip.itineraries.length,
            itemBuilder: (context, index) {
              final itinerary = trip.itineraries[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${itinerary.date.month}月${itinerary.date.day}日',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  ...itinerary.activities.map(
                    (activity) => ListTile(
                      title: Text(activity.name),
                      subtitle: Text(activity.location),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
