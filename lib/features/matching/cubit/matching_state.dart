part of 'matching_cubit.dart';

enum MatchingStatus { initial, loading, success, error }

class MatchingState extends Equatable {
  final MatchingStatus status;
  final List<(Lawyer, double)> results;
  final String? message;

  const MatchingState({
    required this.status,
    required this.results,
    this.message,
  });

  const MatchingState.initial()
    : status = MatchingStatus.initial,
      results = const [],
      message = null;

  MatchingState copyWith({
    MatchingStatus? status,
    List<(Lawyer, double)>? results,
    String? message,
  }) => MatchingState(
    status: status ?? this.status,
    results: results ?? this.results,
    message: message ?? this.message,
  );

  @override
  List<Object?> get props => [status, results, message];
}
