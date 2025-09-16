import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/data/mock_case_repository.dart';
import '../../../core/domain/entities.dart';

part 'track_state.dart';

class TrackCubit extends Cubit<TrackState> {
  TrackCubit(this.repo) : super(const TrackState.initial());

  final MockCaseRepository repo;

  void load() {
    emit(state.copyWith(status: TrackStatus.loading));
    final data = repo.fetchCases();
    emit(state.copyWith(status: TrackStatus.success, cases: data));
  }
}
