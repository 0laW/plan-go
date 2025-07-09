class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def save_friends
    friend_ids = params[:friend_ids] || []
    friend_ids.each do |fid|
      Friendship.find_or_create_by(user: current_user, friend_id: fid, status: 'accepted')
      Friendship.find_or_create_by(user_id: fid, friend_id: current_user.id, status: 'accepted')
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("onboarding_step", partial: "onboarding/steps/complete")
      end
      format.html { redirect_to onboarding_steps_path(step: "complete") }
    end
  end

  def create
    friend = User.find(params[:friend_id])
    puts "DEBUG: Current user: #{current_user.id} - Trying to friend: #{friend.id}"

    existing_friendship = Friendship.where(user: current_user, friend: friend)
                                    .or(Friendship.where(user: friend, friend: current_user))
                                    .first

    if existing_friendship
      puts "DEBUG: Existing friendship found with ID #{existing_friendship.id} - status: #{existing_friendship.status}"

      case existing_friendship.status
      when "accepted"
        respond_to do |format|
          format.turbo_stream { head :unprocessable_entity }
          format.html { redirect_back fallback_location: root_path, alert: "You are already friends." }
        end
      when "pending"
        respond_to do |format|
          format.turbo_stream { head :unprocessable_entity }
          format.html { redirect_back fallback_location: root_path, alert: "Friend request already sent and pending." }
        end
      when "declined"
        friendship = current_user.sent_requests.create!(friend: friend, status: :pending)
        puts "DEBUG: Created friendship with ID #{friendship.id} and status #{friendship.status}"
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_back fallback_location: root_path, notice: "Friend request sent." }
        end
      else
        friendship = current_user.sent_requests.create!(friend: friend, status: :pending)
        puts "DEBUG: Created friendship with ID #{friendship.id} and status #{friendship.status}"
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_back fallback_location: root_path, notice: "Friend request sent." }
        end
      end

    else
      friendship = current_user.sent_requests.create!(friend: friend, status: :pending)
      puts "DEBUG: Created friendship with ID #{friendship.id} and status #{friendship.status}"
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: root_path, notice: "Friend request sent." }
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    puts "DEBUG ERROR: #{e.message}"
    redirect_back fallback_location: root_path, alert: "Failed to send friend request: #{e.message}"
  end

  def index
    @pending_requests = current_user.pending_friend_requests
  end

  def update
    friendship = current_user.inverse_friendships.find(params[:id])
    if params[:status] == 'accepted'
      friendship.update(status: :accepted)
    elsif params[:status] == 'declined'
      friendship.update(status: :declined)
    end
    redirect_to user_path(current_user)
  end
end
