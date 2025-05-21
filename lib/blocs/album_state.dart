part of 'album_bloc.dart';

abstract class AlbumState extends Equatable {
  const AlbumState();

  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;
  final Map<int, String> thumbnailMap;

  const AlbumLoaded({required this.albums, required this.thumbnailMap});

  @override
  List<Object> get props => [albums, thumbnailMap];
}

class AlbumPhotosLoading extends AlbumState {}

class AlbumPhotosLoaded extends AlbumState {
  final List<Photo> photos;

  const AlbumPhotosLoaded({required this.photos});

  @override
  List<Object> get props => [photos];
}

class AlbumError extends AlbumState {
  final String message;

  const AlbumError({required this.message});

  @override
  List<Object> get props => [message];
}