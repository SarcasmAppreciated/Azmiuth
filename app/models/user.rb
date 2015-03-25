class User < ActiveRecord::Base
  has_one :authorization, dependent: :destroy
  has_one :preference, dependent: :destroy
  has_many :tweets, dependent: :destroy
  validates :name, :user_name, :user_id, :presence => true
  validates :user_id, uniqueness: true
end

