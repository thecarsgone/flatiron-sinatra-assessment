class User < ActiveRecord::Base
  has_secure_password
	validates_presence_of :username, :password
  has_many :pictures
end
