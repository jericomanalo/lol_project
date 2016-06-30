class Profile < ActiveRecord::Base
	has_many :champion_masteries, :dependent => :destroy
	has_many :matches, :dependent => :destroy	
end
