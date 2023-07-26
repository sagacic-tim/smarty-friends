class CreateFriends < ActiveRecord::Migration[7.0]
  def change
    create_table :friends do |t|

      t.string :name_title, limit => 8
      t.string :name_first, limit => 32
      t.string :name_middle, limit => 32
      t.string :name_last, limit => 32
      t.string :name_suffix, limit => 8

      t.date :dob
      t.string :phone, limit => 20
      t.string :twitter_handle, limit => 32
      t.string :email, limit => 64

      t.string :delivery_line_1, limit => 50
      t.string :last_line, limit => 50
      t.string :delivery_point_bar_code, limit => 12
      t.string :street_number, limit => 30
      t.string :street_predirection, limit => 16
      t.string :street_name, limit => 64
      t.string :street_suffix, limit => 16
      t.string :street_postdirection, limit => 16
      t.string :secondary_number, limit => 32
      t.string :secondary_designator, limit => 16
      t.string :extra_secondary_number, limit => 32
      t.string :extra_secondary_designator, limit => 16
      t.string :pmb_designator, limit => 16
      t.string :pmb_number, limit => 16
      t.string :default_city_name, limit => 64

      t.string :city, limit => 64
      t.string :county, limit => 64
      t.string :county_FIPS, limit => 5
      t.string :state_abbreviation, limit => 2
      t.string :postal_code, limit => 5
      t.string :zip_plus_4_extension, limit => 4
      t.string :zip_type, limit => 32
      t.string :delivery_point, limit => 2
      t.string :delivery_point_check_digit, limit => 1
      t.string :carrier_route, limit => 4
      t.string :record_type, limit => 1
      t.string :congressional_district, limit => 2
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6

      t.boolean :available_to_party

      t.timestamps
    end
  end
end
