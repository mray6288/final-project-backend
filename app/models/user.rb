class User < ApplicationRecord
	has_many :friendships
	has_many :friends, :through => :friendships, :source => 'friend'
	has_many :user_targets

	has_secure_password
end
