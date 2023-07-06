class EnableHstore < ActiveRecord::Migration[7.0]
  def self.up
    enable_extension 'hstore' unless extension_enabled?('hstore')
  end
  def self.down
    disable_extension "hstore"
  end
end
