
class MoviePerson
  
  def initialize(movie_person)
    @id = movie_person
  end

  # get 2 arguments. title is a string and genre is a string
  # Adds genre and movie title to database
  def self.add(actor_id, film_id)
    MOVIEDB.execute("INSERT INTO moviespeople (person_id, movie_id) VALUES ('#{actor_id}', '#{film_id}');")
  end
  
  # gets an argument for director name as a string
  # Returns a hash of movie titles for a given director
  def self.get_movies_where_director(director_name)
    MOVIEDB.execute("SELECT title FROM movies WHERE director = '#{director_name}';")
  end
  
end