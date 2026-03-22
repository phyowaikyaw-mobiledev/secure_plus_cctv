import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/language_button.dart';
import '../../../../core/widgets/secure_scaffold.dart';
import '../bloc/projects_cubit.dart';

class ProjectsGridScreen extends StatelessWidget {
  const ProjectsGridScreen({
    super.key,
    required this.isAdmin,
  });

  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit()..load(),
      child: SecureScaffold(
        appBar: AppBar(
          title: Text(
            isAdmin ? 'Projects (Admin)' : 'Completed Sites',
          ),
          actions: [
            const LanguageButton(),
            if (isAdmin)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  context.push(AppRoutes.ownerProjectEdit);
                },
              ),
          ],
        ),
        body: BlocBuilder<ProjectsCubit, ProjectsState>(
          builder: (context, state) {
            if (state.status == ProjectsStatus.loading &&
                state.projects.isEmpty) {
              return const _ProjectsShimmerGrid();
            }

            if (state.status == ProjectsStatus.failure &&
                state.projects.isEmpty) {
              return Center(
                child: Text(
                  state.errorMessage ??
                      'Unable to load projects at the moment.',
                ),
              );
            }

            if (state.projects.isEmpty) {
              return const Center(
                child: Text('No projects available yet.'),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: state.projects.length,
              itemBuilder: (context, index) {
                final project = state.projects[index];
                final imageUrl =
                    project.imageUrls.isNotEmpty ? project.imageUrls.first : '';
                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.customerProjectDetail.replaceFirst(
                        ':id',
                        project.id,
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: imageUrl.isEmpty
                                ? Container(
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.videocam_outlined,
                                      size: 40,
                                    ),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                      baseColor: Colors.grey.shade800,
                                      highlightColor:
                                          Colors.grey.shade700,
                                      child: Container(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.broken_image),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                project.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _ProjectsShimmerGrid extends StatelessWidget {
  const _ProjectsShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade700,
          child: Card(
            child: Column(
              children: [
                Expanded(
                  child: Container(color: Colors.white),
                ),
                Container(
                  height: 48,
                  margin: const EdgeInsets.all(12),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

