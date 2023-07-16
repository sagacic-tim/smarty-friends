class Api::V1::FriendsController < ApplicationController
  before_action :set_friend, only: %i[update show destroy]
  require 'debug'
  require 'dotenv'
  
  def index
    @friends = Friend.all 
    if @friends
      render json: {status: "SUCCESS", message: "Fetched all the friends you got", data: @friends}, status: :ok
    else
      render json: @friends.errors, status: :bad_request
    end
  end

  # Show a specific friend GET request
  def show
    if @friend
      render json: {data: @friend}, state: :ok
    else
      render json: {message: "Friend could not be found"}, status: :bad_request
    end
  end

  # GET /api/v1/friends/:id Show a specific friend GET request
  def show
    if @friend
      render json: { data: @friend }, status: :ok
    else
      render json: { message: "Friend could not be found" }, status: :not_found
    end

  rescue ActiveRecord::RecordNotFound
    render json: { message: "Friend could not be found" }, status: :not_found
  end
  
  def create
    @friend = Friend.new(friend_params)
    
    if @friend.save
      render json: {status: "SUCCESS", message: "Amazing, a new friend was successfully created!", data: @friend}, status: :created
    else
      render json: @friend.errors, status: :unprocessable_entity
    end
  end

  def update 
    if @friend.update(friend_params)
      render json: {status: "SUCCESS", message: "Amazing, your friend was successfully updated!", data: @friend}, status: :ok
    else
      render json: @friend.errors, status: :unprocessable_entity
    end
  end

  # Delete a specific friend DELETE request
  def destroy

    if @friend.destroy!
      render json: {message: "Friend was deleted successfully"}, status: :ok
    else
      render json: {message: "Friend does not exist"}, status: :bad_request
    end
  end

  private

  def friend_params
    params.require(:friend).permit(
      { 
        name: 
        [
          :name_title, 
          :name_first, 
          :name_middle, 
          :name_last, 
          :name_suffix
        ] 
    },
    :dob,
    :phone,
    :twitter_handle,
    :email,
    { 
      address: 
      [
        :delivery_line_1, 
        :last_line, 
        :delivery_point_bar_code, 
        :street_number, 
        :street_name, 
        :street_suffix, 
        :city, 
        :county, 
        :county_FIPS, 
        :state_abbreviation, 
        :country, :country_code, 
        :postal_code, 
        :zip_plus_4_extension, 
        :zip_type, 
        :delivery_point, 
        :delivery_point_check_digit, 
        :carrier_route, 
        :record_type, 
        :latitude, 
        :longitude
      ]
    },
      :available_to_party
    )
  end
  def set_friend
    @friend = Friend.find(params[:id])
  end
end
