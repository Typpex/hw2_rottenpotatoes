class Movie < ActiveRecord::Base
  def self.rating_list
    Movie.connection.select_values('select distinct (rating) from movies')
  end
end
