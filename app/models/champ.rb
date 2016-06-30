class Champ < ActiveRecord::Base
  belongs_to :champion
  belongs_to :match
  belongs_to :champion_mastery
end
