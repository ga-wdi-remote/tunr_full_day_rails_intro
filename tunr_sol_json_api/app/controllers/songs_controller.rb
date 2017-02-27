class SongsController < ApplicationController
  before_action :authenticate

  def index
    songs = Song.all

    render json: {status: 200, songs: songs}
  end

  def create
    artist = Artist.find_by(name: song_params[:artist_name])
    song = Song.new(song_params)
    song.artist_id = artist.id if artist

    if song.save
      render json: {status: 200, song: song}
    else
      render json: {status: 422, song: song.errors}
    end
  end

  def show
    song = Song.find(params[:id])

    render json: {status: 200, song: song}
  end

  def update
    song = Song.find(params[:id])

    song.update(song_params)

    render json: {status: 200, song: song}
  end

  def destroy
    song = Song.destroy(params[:id])

    render json: {status: 204}
  end

  private

  def song_params
    params.required(:song).permit(
      :title,
      :artist_name,
      :preview_url,
      :artwork,
      :price,
      :artist_id
    )
  end

end
