class TrackImportJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    begin
      @importer = TrackImporter.new(user)
      @importer.run!
    rescue SoundCloud::ResponseError => e
      logger.error "Error: #{e.message}, Status Code: #{e.response.code}"
      if e.response.code == 401
        api = SoundcloudApi.new(access_token: user.soundcloud_token,
                                refresh_token: user.refresh_token).api
        api.get('/me') # This should update the access token
        if api.access_token != user.soundcloud_token
          user.update(soundcloud_token: api.access_token,
                      refresh_token: api.refresh_token)
        end
        TrackImportJob.perform_later(user)
      end
    end
  end
end
