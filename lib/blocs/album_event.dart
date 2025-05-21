part of 'album_bloc.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object> get props => [];
}

class FetchAlbums extends AlbumEvent {}

class FetchAlbumPhotos extends AlbumEvent {
  final int albumId;

  const FetchAlbumPhotos(this.albumId);

  @override
  List<Object> get props => [albumId];
}