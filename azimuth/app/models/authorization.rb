class Authorization < ActiveRecord::Base
	belongs_to :user
	validates :provider, :uid, :secret, :token, :presence => true
end
