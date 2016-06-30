class User < ActiveRecord::Base
  has_secure_password
  belongs_to :summoner
  has_many :favorites
  has_many :summoners, through: :favorites
  has_many :champion_masteries, through: :summoners
  has_many :matches, through: :summoners
  has_many :champions, through: :matches
  has_many :champions, through: :champion_masteries
end
