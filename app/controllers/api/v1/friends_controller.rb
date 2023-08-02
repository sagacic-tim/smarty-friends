class Api::V1::FriendsController < ApplicationController
  before_action :current_friend, only: [:update, :show, :destroy]

  def index
    @friends = Friend.all

    if @friends.any?
      render json: { status: "SUCCESS", message: "Fetched all the friends you got", data: @friends }, status: :ok
    else
      render json: { message: "No friends found" }, status: :not_found
    end
  end

  # GET /api/v1/friends/:id Show a specific friend via a GET request
  def show
    render json: { data: @friend }, status: :ok
  end

  def create
    @friend = Friend.new(friend_params)

    if @friend.save
      render json: { status: "SUCCESS", message: "Amazing, a new friend was successfully created!", data: @friend }, status: :created
    else
      render json: { errors: @friend.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @friend.update(friend_params)
      render json: { status: "SUCCESS", message: "Amazing, your friend was successfully updated!", data: @friend }, status: :ok
    else
      render json: { errors: @friend.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # Delete a specific friend DELETE request
  def destroy
    if @friend.destroy
      head :ok # Return empty response with HTTP status 200 (OK)
    else
      render json: { message: "Friend does not exist" }, status: :not_found
    end
  end

  private

  def friend_params
    params.require(:friend).permit(
      # Person's name attributes
      :name_title, :name_first, :name_middle, :name_last, :name_suffix,
  
      # Contact information attributes
      :email_1, :email_2, :phone_1, :phone_2, :twitter_handle,
  
      # Demographics attributes
      :dob, :sex, :occupation, :available_to_party,
  
      # Address attributes
      :delivery_line_1, :last_line, :street_number, :street_predirection,
      :street_name, :street_suffix, :street_postdirection, :city, :county,
      :state_abbreviation, :country, :country_code, :postal_code, :zip_plus_4_extension,
  
      # Geolocation attributes
      :latitude, :longitude, :lat_long_location_precision
    )
  end
  
  # Find friend by ID and handle ActiveRecord::RecordNotFound
  def current_friend
    @friend = Friend.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Friend could not be found" }, status: :not_found
  end
end