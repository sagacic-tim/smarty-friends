class AddMapCoordinateToFriends < ActiveRecord::Migration[7.0]
  def up
    enable_extension 'hstore' # Enable hstore extension if not enabled already
    
    add_column :friends, :name, :hstore
    add_column :friends, :address, :hstore

  end

  def down
    remove_column :friends, :name
    remove_column :friends, :address
    rem
  end
end
