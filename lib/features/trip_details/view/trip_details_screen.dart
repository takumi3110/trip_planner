import 'package:flutter/material.dart';
import 'package:trip_planner/data/models/trip.dart';
import 'package:trip_planner/features/trip_details/viewmodel/trip_details_viewmodel.dart';
import 'package:provider/provider.dart'; // Providerを使うために追加

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
        appBar: AppBar(
          title: const Text(
            '旅程詳細',
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trip.destination,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${trip.startDate.toLocal().toIso8601String().split('T')[0]} - ${trip.endDate.toLocal().toIso8601String().split('T')[0]}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '人数: ${trip.numberOfPeople}人',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Text('旅程', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  if (trip.itineraries.isEmpty)
                    const Text('まだ旅程がありません。')
                  else
                    ...trip.itineraries.map((itinerary) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '日付: ${itinerary.date.toLocal().toIso8601String().split('T')[0]}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ...itinerary.activities.map((activity) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        activity.name,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge,
                                      ),
                                      Text(
                                        '時間: ${activity.time.format(context)}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                      Text(
                                        '場所: ${activity.location}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                      if (activity.description != null)
                                        Text(
                                          '詳細: ${activity.description}',
                                          style:
                                              Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                        ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
