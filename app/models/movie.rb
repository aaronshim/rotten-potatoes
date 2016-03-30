class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  # class method for extracting the possible ratings of movies
  def self.all_ratings
  	self.all.pluck(:rating).uniq.sort
  end
end
