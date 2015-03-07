class Authorization < ActiveRecord::Base
	belongs_to :user
	validates  :secret, :token, :presence => true
end
