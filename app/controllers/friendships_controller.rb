class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(friend_id: params[:friend_id])

    if @friendship.save
      flash[:notice] = "Successfully requesting as friend"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @friendship = current_user.friendships.where(friend_id: params[:id]).first
    @friendship.destroy
    flash[:alert] = "Friendship destroyed"
    redirect_back(fallback_location: root_path)
  end

  def cancel
    puts "Cancel"
    @friendship = current_user.friendships.where(friend_id: params[:id]).first
    @friendship.destroy
    flash[:alert] = "Cancel friend request"
    redirect_back(fallback_location: root_path)    
  end

  def accept
    @friendship = current_user.inverse_friendships.where(friend_id: params[:id]).first
    @friendship.confirmed = true
    if @friendship.save
      flash[:notice] = "Successfully become friend"
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @friendship.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end
end


