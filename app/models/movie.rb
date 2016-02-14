class Movie < ActiveRecord::Base
    def self.ratings
        #returns array of all the ratings
        Movie.uniq.pluck(:rating).sort!
    end
end
