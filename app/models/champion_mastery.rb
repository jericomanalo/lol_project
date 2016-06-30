class ChampionMastery < ActiveRecord::Base
  belongs_to :summoner
  belongs_to :champion
  has_many :champs
  has_many :champions, through: :champs
end
