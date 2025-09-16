part of 'track_cubit.dart';

enum TrackStatus { initial, loading, success, failure }

class TrackState extends Equatable {
  final TrackStatus status;
  final List<ClientCase> cases;
  final String? error;

  const TrackState({required this.status, required this.cases, this.error});

  const TrackState.initial()
    : status = TrackStatus.initial,
      cases = const [],
      error = null;

  TrackState copyWith({
    TrackStatus? status,
    List<ClientCase>? cases,
    String? error,
  }) => TrackState(
    status: status ?? this.status,
    cases: cases ?? this.cases,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [status, cases, error];
}
