part of 'case_cubit.dart';

class CaseState extends Equatable {
  final String description;
  final double budget;
  final String location;
  final CaseCategory? predicted;

  const CaseState({
    required this.description,
    required this.budget,
    required this.location,
    this.predicted,
  });

  const CaseState.initial()
    : description = '',
      budget = 0,
      location = '',
      predicted = null;

  CaseState copyWith({
    String? description,
    double? budget,
    String? location,
    CaseCategory? predicted,
  }) => CaseState(
    description: description ?? this.description,
    budget: budget ?? this.budget,
    location: location ?? this.location,
    predicted: predicted ?? this.predicted,
  );

  @override
  List<Object?> get props => [description, budget, location, predicted];
}
