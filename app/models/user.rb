class User < ApplicationRecord
	has_many :friendships
	has_many :friends, :class_name => 'User', :through => :friendships
	has_many :user_targets

	has_secure_password
end
