class ApplicationController < ActionController::API

	def encode(payload)
		JWT.encode(payload, "ray")
	end

	def decode
		jwt = request.headers["Authorization"]
		JWT.decode(jwt, "ray")[0]
	end

	def user_in_session
		id = decode["user_id"]
		User.find(id)
	end
end
