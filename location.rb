require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Location

  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_reader :id
  attr_accessor :location, :description
  
  # Initializes a new locatin object.
  #
  # id (optional)          - Integer of the location record in the 'locatoins' table.
  # location (optiona)     - String of the location.
  # description (optional) - String of the location's description.
  #
  # Returns a Location object.
  def initialize(options={})
    @id = options["id"]
    @location = options["location"]
    @description = options["description"]
  end
  
  
  
  # Find a student based on their ID.
  #
  # student_id - The Integer ID of the student to return.
  #
  # Returns a Student object.
  def self.find_as_object(loc_id)
    @id = loc_id

    # CONNECTION.execute returns an Array of Hashes, like:
    # [{"id" => 1, "name" => "Sumeet", "age" => 500}]

    # Here, I'm using the `find` method from DatabaseClassMethods.
    results = Location.find(loc_id).first
    # {"id" => 1, "name" => "Sumeet", "age" => 500}
    
    Location.new(results)
  end
  
  
  # Find a student based on their ID.
  #
  # student_id - The Integer ID of the student to return.
  #
  # Returns a Student object.  (That object can then be modified elsewhere and then saved.)
  # def self.find(loc_id)
  #   @id = loc_id
  #
  #   result = MOVIEDB.execute("SELECT * FROM locations WHERE id = #{@id};").first
  #
  #   temp_location = result["location"]
  #   temp_description = result["description"]
  #
  #   Location.new(loc_id, temp_location, temp_description)
  # end
  
  
  
  
  # Adds a row to the "locations" table using options hash parameter
  #
  # Returns the Integer ID that the database sends back.
  def self.add(options={})
    #checks if options["description"] is blank and sets it to nil if it is
    if options["description"].blank?
      options.delete("description")
    end
    
    if options["location"].blank?
      return false
    else
      self.add_to_database(options)
    end
  end
  
  
  # --------------------------- Instance Methods ----------------------------------------------------

  

  # get 2 arguments. Id is an int. and new_movie_name is a string
  # changes name of movie in database
  def change_locations(new_loc_name)
    MOVIEDB.execute("UPDATE locations SET location = '#{new_loc_name}' WHERE id = #{@id};")
  end

  def change_description(new_desc_name)
    MOVIEDB.execute("UPDATE locations SET description = '#{new_desc_name}' WHERE id = '#{@id}';")
  end
  
  # diesplays single location of given id
  #Returns Array with object
  def display
    results = MOVIEDB.execute("SELECT * FROM locations WHERE id = '#{@id}';")
    
    result_as_object =[]
    
    results.each do |result_hash|
      result_as_object << Movie.new(result_hash["id"], result_hash["location"], result_hash["description"])
    end
    
    return result_as_object
    
  end
  
  
  
  # Updates the database with all values for the student.
  #
  # Returns an empty Array. TODO - This should return something better.
  def save
    binding.pry
    MOVIEDB.execute("UPDATE locations SET location = '#{@location}', description = '#{description}' WHERE id = #{@id};")
  end
  
  
  # Deletes an entry
  # This will also have to delete any record in 
  def delete
    MOVIEDB.execute("DELETE FROM locations WHERE id = #{@id};")
  end
  

end