class User < ApplicationRecord
	has_many: :friendships
	has_many: :friends, :class_name => 'User', :through => :friendships
	has_many: :usertargets
end
