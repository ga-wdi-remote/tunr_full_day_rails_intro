class ArtistsController < ApplicationController

    def index
      artists = Artist.all

      render json: {status: 200, artists: artists}
    end

    def create
      artist = Artist.new(artist_params)

      if artist.save
        render json: {status: 200, artist: artist}
      else
        render json: {status: 422, artist: artist}
      end
    end

    def show
      artist = Artist.find(params[:id])

      render json: {status: 200, artist: artist}
    end

    def update
      artist = Artist.find(params[:id])

      artist.update(artist_params)

      render json: {status: 200, artist: artist}
    end

    def destroy
      artist = Artist.destroy(params[:id])

      render json: {status: 204}

    end

    private

    def artist_params
      params.required(:artist).permit(
        :name,
        :img_url,
        :nationality,
        :genre
      )
    end
end
