import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/album_bloc.dart';
import '../models/album.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
        backgroundColor: Colors.deepPurple.shade300,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AlbumBloc>().add(FetchAlbums());
            },
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: BlocConsumer<AlbumBloc, AlbumState>(
        listener: (context, state) {
          if (state is AlbumError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.deepPurple.shade300,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    context.read<AlbumBloc>().add(FetchAlbums());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AlbumInitial || state is AlbumLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            );
          }

          if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.deepPurple.shade300),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.deepPurple.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Retry', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade300,
                    ),
                    onPressed: () {
                      context.read<AlbumBloc>().add(FetchAlbums());
                    },
                  ),
                ],
              ),
            );
          }

          if (state is AlbumLoaded) {
            return RefreshIndicator(
              color: Colors.deepPurple,
              onRefresh: () async {
                context.read<AlbumBloc>().add(FetchAlbums());
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.albums.length,
                itemBuilder: (context, index) {
                  final album = state.albums[index];
                  final thumbnailUrl = state.thumbnailMap[album.id] ?? '';

                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.shade100,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: _buildThumbnail(thumbnailUrl),
                      title: Text(
                        album.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Colors.deepPurple.shade300,
                      ),
                      onTap: () {
                        context.go('/album/${album.id}');
                        context.read<AlbumBloc>().add(FetchAlbumPhotos(album.id));
                      },
                    ),
                  );
                },
              ),
            );
          }

          return Center(
            child: Text(
              'Unknown state',
              style: TextStyle(color: Colors.deepPurple.shade800),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumbnail(String url) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.deepPurple.shade100,
          width: 1,
        ),
      ),
      child: url.isNotEmpty
          ? ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.deepPurple.shade300),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.deepPurple.shade300,
            ),
          ),
        ),
      )
          : Center(
        child: Icon(
          Icons.photo_album,
          size: 30,
          color: Colors.deepPurple.shade300,
        ),
      ),
    );
  }
}