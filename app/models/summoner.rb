class Summoner < ActiveRecord::Base
	has_many :champion_masteries, :dependent => :destroy
	has_many :matches, :dependent => :destroy
	has_many :champions, through: :champs
	has_many :favorites
	has_many :users, through: :favorites
end
