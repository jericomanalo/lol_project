class User < ActiveRecord::Base
  has_secure_password
<<<<<<< HEAD
  belongs_to :summoner
  has_many :favorites
  has_many :summoners, through: :favorites
  has_many :champion_masteries, through: :summoners
  has_many :matches, through: :summoners
  has_many :champions, through: :matches
  has_many :champions, through: :champion_masteries
=======
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :name, presence: true, length: { in: 2..255 }
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
	validates :password, confirmation: true
	before_save do
		self.email.downcase!
	end
>>>>>>> f87882f367db4193b2be3ca88ac820eda7d6bf66
end
