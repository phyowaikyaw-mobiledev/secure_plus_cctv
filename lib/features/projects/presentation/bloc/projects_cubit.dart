import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/project_model.dart';
import '../../data/repositories/project_repository.dart';

part 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit({
    ProjectRepository? repository,
  })  : _repository = repository ?? ProjectRepository(),
        super(const ProjectsState.initial());

  final ProjectRepository _repository;
  StreamSubscription<List<Project>>? _subscription;

  Future<void> load() async {
    emit(state.copyWith(status: ProjectsStatus.loading));

    try {
      final cached = await _repository.loadCachedProjects();
      if (cached.isNotEmpty) {
        emit(
          state.copyWith(
            status: ProjectsStatus.success,
            projects: cached,
          ),
        );
      }
    } catch (_) {
      // Ignore cache errors.
    }

    _subscription?.cancel();
    _subscription = _repository.watchProjects().listen(
      (projects) {
        emit(
          state.copyWith(
            status: ProjectsStatus.success,
            projects: projects,
          ),
        );
      },
      onError: (_) {
        emit(
          state.copyWith(
            status: ProjectsStatus.failure,
            errorMessage:
                'Unable to load projects. Please check your connection.',
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

