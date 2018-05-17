class ApplicationController < ActionController::Base

	def encode(payload)
		JWT.encode(payload, "arbi")
	end

	def decode
		jwt = request.headers["Authorization"]
		JWT.decode(jwt, "arbi")[0]
	end

	def user_in_session
		id = decode["user_id"]
		User.find(id)
	end
end
