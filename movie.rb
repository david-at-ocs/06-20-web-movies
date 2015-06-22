require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Movie

  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_reader :id
  attr_accessor :title, :genre, :location_id
  
  
  # Initializes a new movie object
  #
  # options - hash contianing
  #   - id (optional)          - int
  #   - title (optional)       - string
  #   - genre (optional)       - string
  #   - location_id (optional) - int
  #
  # Example:
  #   Movie.new({"id" => 4, "title" => "Alien", "genre" => "Comedy", "location_id" => 3})
  #
  # Returns a movie object
  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @genre = options["genre"]
    @location_id = options["location_id"]
  end
  
    
  
  # Get all student records from the database.
  #
  # Returns an Array containing Student objects.
  # def self.all_as_objects
  #   # Here, I'm using the `all` method from DatabaseClassMethods.
  #   results = Movie.all
  #   results_as_objects = []
  #
  #   results.each do |result_hash|
  #     results_as_objects << Movie.new(result_hash)
  #   end
  #
  #   return results_as_objects
  # end
  
  
  
  # Find a student based on their ID.
  #
  # student_id - The Integer ID of the student to return.
  #
  # Returns a Student object.
  def self.find_as_object(movie_id)
    @id = movie_id
    results = Movie.find(movie_id).first
    Movie.new(results)
  end
  
  

  # Adds a row to the "students" table, using this object's attribute values.
  #
  # Returns the Integer ID that the database sends back.
  def self.add(options={})
    if options["location_id"] == 0
      options.delete("location_id")
    end
        
    if options["genre"].blank? || options["title"].blank?
      return false
    else
      self.add_to_database(options)
    end
  end
    
  
  
  
  # Gets all movies with a given location id
  #
  # TODO still need to put sqlite in module
  # Returns an Array of movie objects
  # def self.locations(loc_id)
  #   results = MOVIEDB.execute("SELECT * FROM movies WHERE location_id = '#{loc_id}';")
  #
  #   results_as_objects =[]
  #
  #   results.each do |result_hash|
  #     results_as_objects << Movie.new(result_hash)
  #   end
  #   binding.pry
  #   return results_as_objects
  # end
    
  
  
  # --------------------------- Instance Methods ----------------------------------------------------
  
  
  # Deletes an entry
  # This will also have to delete any record in 
  # def delete(movie_id)
  #   MOVIEDB.execute("DELETE FROM movies WHERE id = #{@id};")
  # end
  
  def delete(movie_id)
    movie_to_delete = Movie.new(movie_id)
    movie_to_delete.delete_mod       
  end
  
  
  

  # Updates the database with all values for the student.
  #
  # Returns an empty Array. TODO - This should return something better.
  def save
    MOVIEDB.execute("UPDATE movies SET title = '#{@title}', location_id = '#{@location_id}', genre = '#{@genre}' WHERE id = #{@id};")
  end
  

  # get 2 arguments. Id is an int. and new_movie_name is a string
  # changes name of movie in database
  def change_name(new_movie_name)
    MOVIEDB.execute("UPDATE movies SET title = '#{new_movie_name}' WHERE id = #{@id};")
  end
  
  # 
  # adds location to movie
  def add_location(loc)
    MOVIEDB.execute("UPDATE movies SET location_id = '#{loc}' WHERE id = '#{@id}';")
  end
  
  
  # Returns a hash of a movie title (or maybe an array, with a hash in it, I can't remember)
  def display
    results = MOVIEDB.execute("SELECT * FROM movies WHERE id = '#{@id}';")
    
    results_as_objects =[]
    
    results.each do |result_hash|
      results_as_objects << Movie.new(result_hash["id"], result_hash["title"], result_hash["genre"], result_hash["location_id"])
    end
    
    return results_as_objects
    
  end
  
  
  # Find a student based on their ID.
  #
  # student_id - The Integer ID of the student to return.
  #
  # Returns a Student object.
  # def self.find(movie_id)
 #    @id = movie_id
 #
 #    result = MOVIEDB.execute("SELECT * FROM movies WHERE id = #{@id};").first
 #
 #    temp_title = result["title"]
 #    temp_genre = result["genre"]
 #
 #    Movie.new(movie_id, temp_title, temp_genre)
 #  end
  
  def delete_movie
    MOVIEDB.execute("DELETE FROM movies WHERE id = '#{@id}';")
  end
  
  def change_title(new_title)
    MOVIEDB.execute("UPDATE movies SET title = '#{new_title}' WHERE id = '#{@id}';")
  end
  
  def change_genre(new_genre)
    MOVIEDB.execute("UPDATE movies SET genre = '#{new_genre}' WHERE id = '#{@id}';")
  end
  
  def remove_location
    MOVIEDB.execute("UPDATE movies SET location_id = null WHERE id = '#{@id}';")
  end
  
  def has_location?
    @location_id.nil?
  end
  

end