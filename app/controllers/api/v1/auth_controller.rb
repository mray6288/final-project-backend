class Api::V1::AuthController < ApplicationController

	def login
		@user = User.find_by(username: params[:username])

		if @user && @user.authenticate(params[:password])
			token = encode({user_id: @user.id})
			render json: {user: @user, jwt: token}
		else
			render json: {error: "error!"}
		end
	end

	def get_user
		if user_in_session
			render json: {user: user_in_session.as_json(:include => ['friends'])}
		else
			render json: {error: "error!"}
		end

	end

end