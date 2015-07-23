class TrackImporter
  def initialize(user)
    @user = user
    @api = SoundcloudApi.new(access_token: user.soundcloud_token).api
  end

  def run!
    songs = @api.get("/users/#{@user.soundcloud_id}/tracks")
    songs.each do |song_data|
      begin
        self.import_track(song_data)
      rescue ActiveRecord::RecordInvalid => e
        logger.error ">>> Import Failed for User: #{@user.id}, Track: #{song_data.id}, Message: #{e.message}"
      end
    end
  end

  def import_track(song_data)
    if Track.exists?(soundcloud_id: song_data.id)
      logger.info "> Ignoring existing track #{song_data.title} for #{@user.username}"
    else
      @user.tracks.create!(soundcloud_id: song_data.id,
                           title:          song_data.title,
                           description:    song_data.description,
                           genre:          song_data.genre,
                           license:        song_data.license,
                           permalink_url:  song_data.permalink_url,
                           artwork_url:    song_data.artwork_url,
                           waveform_url:   song_data.waveform_url,
                           stream_url:     song_data.stream_url,
                           purchase_url:   song_data.purchase_url)
    end
  end
end
