class PlaylistsController < ApplicationController
  def index
    playlists = Playlist.all

    render json: {status: 200, playlist: playlists}
  end

  def show
    playlist = Playlist.includes(:songs).find(params[:id])

    render json: {
      status: 200,
      playlist: playlist,
      songs: playlist.songs
    }
  end

  def create
    playlist = Playlist.new(playlist_params)

    if playlist.save
      render json: {status: 200, playlist: playlist}
    else
      render json: {status: 400, playlist: playlist}
    end
  end

  def update
    playlist = Playlist.find(params[:id])
    playlist.update(playlist_params)

    render json: {status: 200, playlist: playlist}
  end

  def destroy
    playlist = Playlist.find(params[:id])
    playlist.destroy

    render json: {status: 204}
  end

  def add_song
    playlist = Playlist.includes(:songs).find(params[:id])
    song = Song.find(params[:song_id])
    playlist.add_song(song)

    render json: {
      status: 200,
      playlist: playlist,
      songs: playlist.songs
    }
  end

  def remove_song
    playlist = Playlist.includes(:songs).find(params[:id])
    song = Song.find(params[:song_id])
    playlist.remove_song(song)

    render json: {
      status: 204,
      playlist: playlist,
      songs: playlist.songs
    }
  end

  private

  def playlist_params
    params.require(:playlist).permit(:name)
  end
end
