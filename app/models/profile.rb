class Profile < ActiveRecord::Base
	has_many :champion_masteries
	has_many :matches
	

end
