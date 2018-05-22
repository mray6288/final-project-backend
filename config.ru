# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

ActionCable.server.config.allowed_request_origins = [
	'http://localhost:3001',
	'https://ray-final-project-test.herokuapp.com',
	'http://ray-final-project-test.herokuapp.com'
]
