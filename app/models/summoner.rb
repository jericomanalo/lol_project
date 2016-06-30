class Summoner < ActiveRecord::Base
	has_many :champion_masteries
	has_many :matches
	has_many :champions, through: :matches
	has_many :champions, through: :champion_masteries
end
