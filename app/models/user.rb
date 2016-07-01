class User < ActiveRecord::Base
  has_secure_password
  has_attached_file :avatar, :styles => {:thumb => "200x200"}, default_url: "/images/default_avatar.jpg"
  belongs_to :summoner
  has_many :favorites
  has_many :summoners, through: :favorites
  has_many :champion_masteries, through: :summoners
  has_many :matches, through: :summoners
  has_many :champions, through: :matches
  has_many :champions, through: :champion_masteries

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :name, presence: true, length: { in: 2..255 }
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
	validates :password, confirmation: true
  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  
	before_save do
		self.email.downcase!
	end
end
