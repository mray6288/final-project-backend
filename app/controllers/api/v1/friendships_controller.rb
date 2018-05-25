class Api::V1::FriendshipsController < ApplicationController

	def create 
		@friend = User.find_by(username: params[:friend])
		
		Friendship.create({user_id: params[:user][:id], friend_id: @friend[:id], wins_against: 0})
	end
end
