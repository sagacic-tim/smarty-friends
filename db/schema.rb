# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_02_180117) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "hstore"
  enable_extension "plpgsql"

  # this is the hstore branch

  create_table "friends", force: :cascade do |t|
    t.string "name_title"
    t.string "name_first"
    t.string "name_middle"
    t.string "name_last"
    t.string "name_suffix"
    t.string "dob"
    t.string "phone"
    t.string "twitter_handle"
    t.string "email"
    t.string "street_number"
    t.string "street_name"
    t.string "street_suffix"
    t.string "city"
    t.string "state_province"
    t.string "country"
    t.string "country_code"
    t.string "postal_code"
    t.decimal "latitude"
    t.decimal "longitude"
    t.boolean "available_to_party"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
