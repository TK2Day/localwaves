class AddSoundcloudIdIndexToTracks < ActiveRecord::Migration
  def change
    add_index :tracks, :soundcloud_id
  end
end
