class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'hstore'
    create_table :friends do |t|
      t.hstore :name
      t.date :dob
      t.string :phone
      t.string :twitter_handle
      t.string :email
      t.hstore :address
      t.boolean :available_to_party

      t.timestamps
    end
  end
end
