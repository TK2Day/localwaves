json.array! @tracks do |track|
  json.(track, :soundcloud_id, :title, :description, :genre, :license,
    :permalink_url, :waveform_url, :stream_url, :purchase_url)

  if track.user.present?
    json.location do
      json.city track.user.city
      json.state track.user.state
    end
  end

  json.artist track.user
end
