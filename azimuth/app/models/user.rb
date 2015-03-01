class User < ActiveRecord::Base
  has_many :authorizations, dependent: :destroy
  has_many :tweets, dependent: :destroy
  #Include default devise modules. Others available are:
  #:confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  		 :recoverable, :rememberable, :trackable, :validatable
  validates :name, :uid, :presence => true

  def email_required?
  	false
  end

  def email_changed?
  	false
  end

end
