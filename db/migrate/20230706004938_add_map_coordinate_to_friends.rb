class AddMapCoordinateToFriends < ActiveRecord::Migration[7.0]
  def up
    enable_extension 'hstore' # Enable hstore extension if not enabled already
  end

  def down
    remove_column :friends, :name
    remove_column :friends, :address
  end
end
