class Champ < ActiveRecord::Base
	has_many :champions
 	belongs_to :champion
  	belongs_to :match
  	belongs_to :champion_mastery
end
