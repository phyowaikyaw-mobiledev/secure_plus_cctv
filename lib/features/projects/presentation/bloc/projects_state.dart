part of 'projects_cubit.dart';

enum ProjectsStatus { initial, loading, success, failure }

class ProjectsState extends Equatable {
  const ProjectsState({
    required this.status,
    required this.projects,
    this.errorMessage,
  });

  const ProjectsState.initial()
      : status = ProjectsStatus.initial,
        projects = const [],
        errorMessage = null;

  final ProjectsStatus status;
  final List<Project> projects;
  final String? errorMessage;

  ProjectsState copyWith({
    ProjectsStatus? status,
    List<Project>? projects,
    String? errorMessage,
  }) {
    return ProjectsState(
      status: status ?? this.status,
      projects: projects ?? this.projects,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, projects, errorMessage];
}

