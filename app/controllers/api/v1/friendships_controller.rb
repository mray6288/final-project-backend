class Api::V1::FriendshipsController < ApplicationController

	def create 
		@friend = User.find_by(username: params[:friend])
		scoreboard = params[:scoreboard]
		user_wins = 0
		friend_wins = 0
		scoreboard.each do |player, score|
			if player == params[:user][:username]
				user_wins = score
			elsif player == @friend[:username]
				friend_wins = score
			end
		end
		Friendship.create({user_id: params[:user][:id], friend_id: @friend[:id], wins_against: user_wins})
	end
end
