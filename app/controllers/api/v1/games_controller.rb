class Api::V1::GamesController < ApplicationController

	def create
		@game = Game.create(game_params)
		LobbyChannel.broadcast_to('lobby', Game.all)
		@game.set_target()
		render json: @game
	end

	def update
		@game = Game.find(params[:id])
		@game.update(game_params)
		LobbyChannel.broadcast_to('lobby', Game.all)
		render json: @game
	end

	def destroy
		@game = Game.find(params[:id])
		Game.delete(@game)
		LobbyChannel.broadcast_to('lobby', Game.all)
	end

	private

	def game_params
		params.require(:game).permit(:player1, :player2, :target)
	end
end
