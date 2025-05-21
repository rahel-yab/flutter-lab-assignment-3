import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/album.dart';
import '../models/photo.dart';
import '../services/api_service.dart';

part 'album_event.dart';
part 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final ApiService apiService;

  AlbumBloc({required this.apiService}) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchAlbumPhotos>(_onFetchAlbumPhotos);
  }

  Future<void> _onFetchAlbums(FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await apiService.fetchAlbums();
      final photos = await apiService.fetchAllPhotos();

      final thumbnailMap = {
        for (var photo in photos)
          photo.albumId: photo.thumbnailUrl
      };

      emit(AlbumLoaded(albums: albums, thumbnailMap: thumbnailMap));
    } catch (e) {
      emit(AlbumError(message: 'Failed to load albums: ${e.toString()}'));
    }
  }

  Future<void> _onFetchAlbumPhotos(
      FetchAlbumPhotos event,
      Emitter<AlbumState> emit
      ) async {
    emit(AlbumPhotosLoading());
    try {
      final photos = await apiService.fetchPhotosByAlbumId(event.albumId);
      emit(AlbumPhotosLoaded(photos: photos));
    } catch (e) {
      emit(AlbumError(message: 'Failed to load photos: ${e.toString()}'));
    }
  }
}