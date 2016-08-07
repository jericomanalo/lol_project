class User < ActiveRecord::Base
  has_secure_password
  belongs_to :summoner
  has_many :favorites
  has_many :summoners, through: :favorites
  has_many :champion_masteries, through: :summoners
  has_many :matches, through: :summoners
  has_many :champions, through: :matches
  has_many :champions, through: :champion_masteries
  # Follow relationships
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  # Post relationships
  has_many :posts, dependent: :destroy


  # Validations upon create User
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :name, presence: true, length: { in: 2..255 }
	validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
	validates :password, confirmation: true

	before_save do
    self.name.downcase!
		self.email.downcase!
	end

  # Follows a user.
 def follow(other_user)
   active_relationships.create(followed_id: other_user.id)
 end

 # Unfollows a user.
 def unfollow(other_user)
   active_relationships.find_by(followed_id: other_user.id).destroy
 end

 # Returns true if the current user is following the other user.
 def following?(other_user)
   following.include?(other_user)
 end

end
