import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/widgets/language_button.dart';
import '../../../../../core/widgets/secure_scaffold.dart';
import '../../../../projects/data/repositories/project_repository.dart';
import '../../../../projects/presentation/bloc/projects_cubit.dart';

class ProjectsAdminScreen extends StatelessWidget {
  const ProjectsAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProjectRepository();

    return BlocProvider(
      create: (_) => ProjectsCubit(repository: repository)..load(),
      child: SecureScaffold(
        appBar: AppBar(
          title: const Text('Projects Management'),
          actions: [
            const LanguageButton(),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () =>
                  context.read<ProjectsCubit>().load(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(AppRoutes.ownerProjectEdit),
          tooltip: 'Add Project',
          child: const Icon(Icons.add),
        ),
        body: BlocBuilder<ProjectsCubit, ProjectsState>(
          builder: (context, state) {
            if (state.status == ProjectsStatus.loading &&
                state.projects.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.projects.isEmpty) {
              return const Center(
                child: Text('No projects yet. Tap + to add one.'),
              );
            }

            return ListView.separated(
              itemCount: state.projects.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final project = state.projects[index];
                return ListTile(
                  title: Text(project.title),
                  subtitle: Text(project.location),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => context.push(
                          '${AppRoutes.ownerProjectEdit}?id=${project.id}',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Project'),
                              content: const Text(
                                'Are you sure you want to delete this project?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await repository.deleteProject(project);
                          }
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    context.push(
                      '/customer/projects/${project.id}',
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

