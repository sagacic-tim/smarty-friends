class Api::V1::FriendsController < ApplicationController 
  def index
    friends = Friend.all 
    if friends
      render json: {status: "SUCCESS", message: "Fetched all the friends you got", data: friends}, status: :ok
    else
      render json: friends.errors, status: :bad_request
    end
  end
  # create a new friend Post request
  def create
    @friend = Friend.new(friend_params)
    # logger.debug "New post: #{@post.attributes.inspect}"
    # .debug "Post should be valid: #{@post.valid?}"
    if @friend.save
      render json: {status: "SUCCESS", message: "Amazing, a new friend was created!", data: friend}, status: :created
      # logger.debug "Post was successful: #{@post.valid?}"
    else
      # logger.debug "Post has ewrror: #{@post.valid?}"
      render json: friend.errors, status: :unprocessable_entity
    end
  end
  # Show a specific friend GET request
  def show
    friend = Friend.find(params[:id])

    if friend
      render json: {data: friend}, state: :ok
    else
      render json: {message: "Friend could not be found"}, status: :bad_request
    end
  end

  # Delete a specific friend DELETE request
  def destroy
    friend = Friend.find(params[:id])

    if friend.destroy!
      render json: {message: "Friend was deleted successfully"}, status: :ok
    else
      render json: {message: "Friend does not exist"}, status: :bad_request
    end
  end

  # Update details for a specific friend. PATCH request
  def update
    friend = Friend.find(params[:id])

    if friend.update!(friend_params)
      render json: {message: "Friend was updated successfully", data: friend}, status: :ok
    else
      render json: {message: "Friend cannot be updated"}, status: :unprocessable_entity
    end
  end

  private

  def friend_params
    params.require(:friend).permit(
      { name: [:name_title, :name_first, :name_middle, :name_last, :name_suffix] },
      :dob,
      :phone,
      :twitter_handle,
      :email,
      { address: [:delivery_line_1, :last_line, :delivery_point_bar_code, :street_number, :street_name, :street_suffix, :city, :county, :county_FIPS, :state_abbreviation, :country, :country_code, :postal_code, :zip_plus_4_extension, :zip_type, :delivery_point, :delivery_point_check_digit, :carrier_route, :record_type, :latitude, :longitude] },
      :available_to_party
    )
  end
end