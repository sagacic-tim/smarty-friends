class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|

      t.string :name_title, limit: 8
      t.string :name_first, limit: 32
      t.string :name_middle, limit: 32
      t.string :name_last, limit: 32
      t.string :name_suffix, limit: 8

      t.string :email_1, limit: 64
      t.string :email_1, limit: 64
      t.string :phone_1, limit: 20
      t.string :phone_2, limit: 20
      t.string :twitter_handle, limit: 32

      t.date :dob
      t.string :sex, limit: 6
      t.string :occupation, limit: 32
      t.boolean :available_to_party

      t.string :street_number, limit: 30
      t.string :street_predirection, limit: 16
      t.string :street_name, limit: 64
      t.string :street_suffix, limit: 16
      t.string :street_postdirection, limit: 16
      t.string :default_city_name, limit: 64
      t.string :city, limit: 64
      t.string :county, limit: 64
      t.string :state_abbreviation, limit: 2
      t.string :postal_code, limit: 5
      t.string :coutry, limit: 32
      t.string :country_code, limit: 4
      t.string :zip_plus_4_extension, limit: 4
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.string :lat_long_location_precision, limit: 18

      t.timestamps
    end
  end
end
