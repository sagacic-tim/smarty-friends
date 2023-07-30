class Api::V1::FriendsController < ApplicationController
  before_action :current_friend, only: [:update, :show, :destroy]

  def index
    @friends = FriendRecord.all

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
      render json: { message: "Friend was deleted successfully" }, status: :ok
    else
      render json: { message: "Friend does not exist" }, status: :not_found
    end
  end
  
  private

  def friend_params
    params.require(:friend).permit(
      # arrays of symbols, which represents the permitted attri-
      # butes for each hash key.
      name_hash: %i[name_title name_first name_middle name_last name_suffix],
      contact_info_hash: %i[email_1 email_2 phone_1 phone_2 twitter_handle],
      demographics_hash: %i[dob sex occupation available_to_party],
      address_hash: %i[delivery_line_1 last_line street_number street_predirection street_name street_suffix street_postdirection city county state_abbreviation country country_code postal_code zip_plus_4_extension],
      geolocation_hash: %i[latitude longitude lat_long_location_precision]
    )
  end
  
  # case when no friends are found in the index action.
  def current_friend
    @friend = FriendRecord.find_by(id: params[:id])
    render json: { message: "Friend could not be found" }, status: :not_found unless @friend
  end
end
