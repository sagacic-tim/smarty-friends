# app/controllers/api/v1/friends_controller.rb
require_relative 'concerns/name_contract'
require_relative 'concerns/contacts_contract'
require_relative 'concerns/demographics_contract'
require_relative 'concerns/geolocation_contract'
require_relative 'concerns/address_contract'
require 'dry-types'
require 'dry-validation'

class Api::V1::FriendsController < ApplicationController
  before_action :current_friend, only: [:show, :update, :destroy]

  def index
    @friends = Friend.all

    if @friends.any?
      render json: { status: "SUCCESS", message: "Fetched all the friends you got", data: @friends }, status: :ok
    else
      render json: { message: "No friends found" }, status: :not_found
    end
  end

  def show
    render json: { data: @friend }, status: :ok
  end

  def create
    # Assuming the params contain the data to be saved in the respective models
    name_data = name_contract.call(params[:name])
    contacts_data = contacts_contract.call(params[:contacts])
    demographics_data = demographics_contract.call(params[:demographics])
    geolocation_data = geolocation_contract.call(params[:geolocation])
    address_data = address_contract.call(params[:address])

    @friend = Friend.new(
      # Person's name attributes
      name_title: name_data[:name_title],
      name_first: name_data[:name_first],
      name_middle: name_data[:name_middle],
      name_last: name_data[:name_last],
      name_suffix: name_data[:name_suffix],

      # Contact information attributes
      email_1: contacts_data[:email_1],
      email_2: contacts_data[:email_2],
      phone_1: contacts_data[:phone_1],
      phone_2: contacts_data[:phone_2],
      twitter_handle: contacts_data[:twitter_handle],

      # Demographics attributes
      dob: demographics_data[:dob],
      sex: demographics_data[:sex],
      occupation: demographics_data[:occupation],
      available_to_party: demographics_data[:available_to_party],

      # Address attributes
      delivery_line_1: address_data[:delivery_line_1],
      last_line: address_data[:last_line],
      street_number: address_data[:street_number],
      street_predirection: address_data[:street_predirection],
      street_name: address_data[:street_name],
      street_suffix: address_data[:street_suffix],
      street_postdirection: address_data[:street_postdirection],
      city: address_data[:city],
      state_abbreviation: address_data[:state_abbreviation],
      country: address_data[:country],
      country_code: address_data[:country_code],
      postal_code: address_data[:postal_code],
      zip_plus_4_extension: address_data[:zip_plus_4_extension],

      # Geolocation attributes
      latitude: geolocation_data[:latitude],
      longitude: geolocation_data[:longitude],
      lat_long_location_precision: geolocation_data[:lat_long_location_precision]
    )

    if @friend.save
      render json: { status: "SUCCESS", message: "Friend created successfully", data: @friend }, status: :created
    else
      render json: { errors: @friend.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @friend.update(friend_params)
      render json: { status: "SUCCESS", message: "Friend updated successfully", data: @friend }, status: :ok
    else
      render json: { errors: @friend.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @friend.destroy
      head :ok # Return empty response with HTTP status 200 (OK)
    else
      render json: { message: "Friend could not be found" }, status: :not_found
    end
  end

  private

  def name_contract
    @name_contract ||= NameContract.new
  end

  def contacts_contract
    @contacts_contract ||= ContactsContract.new
  end

  def demographics_contract
    @demographics_contract ||= DemographicsContract.new
  end

  def geolocation_contract
    @geolocation_contract ||= GeolocationContract.new
  end

  def address_contract
    @address_contract ||= AddressContract.new
  end

  def friend_params
    params.require(:friend).permit(
      # Add permitted attributes from the Friend model here
    )
  end

  # Find friend by ID and handle ActiveRecord::RecordNotFound
  def current_friend
    @friend = Friend.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Friend could not be found" }, status: :not_found
  end
end