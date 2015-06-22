require_relative "database_class_methods.rb"
require_relative "database_instance_methods.rb"

class Person

  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_reader :id
  attr_accessor :name, :profession
  
  def initialize(options={})
    @id = options["id"]
    @name = options["name"]
    @profession = options["profession"]
  end
  
  
  # Find a student based on their ID.
  #
  # student_id - The Integer ID of the student to return.
  #
  # Returns a Student object.
  def self.find_as_object(person_id)
    @id = person_id
    results = Person.find(person_id).first
    
    Person.new(results)
  end
  
  
  

  # Adds a row to the "person" table using options hash parameter
  #
  # Returns the Integer ID that the database sends back.
  def self.add(options={})
    
    # if options["name"] != "Actor" && options["profession"] != "Director"
    #   return false
    #   profession = gets.chomp.capitalize
    # end
    
    if options["name"].blank? || options["profession"].blank?
      return false
    else
      self.add_to_database(options)
    end
  end
  
  
  # Adds a row to the "students" table, using this object's attribute values.
  #
  #
  # Returns the Integer ID that the database sends back.
  # def add_to_database
  #     MOVIEDB.execute("INSERT INTO people (name, profession) VALUES ('#{@name}', '#{@profession}');")
  #
  #     @id = MOVIEDB.last_insert_row_id
  # end

  # gets new_director_name is a string
  # changes name of director in databas
  def change_name(new_director_name)
    MOVIEDB.execute("UPDATE movies_people SET director = '#{new_director_name}' WHERE id = #{@id};")
  end
  
  
  # Returns a hash with person's name
  def display
    MOVIEDB.execute("SELECT name FROM people WHERE id = '#{@id}';")
  end  
  
  # deletes a person from the db
  # def delete
  #   MOVIEDB.execute("DELETE FROM people WHERE id = '#{@id}';")
  # end
  
  
  # Updates the database with all values for the student.
  #
  # Returns an empty Array. TODO - This should return something better.
  def save
    if self.name.blank?
      return false
    else
      MOVIEDB.execute("UPDATE people SET name = '#{@name}', profession = '#{@profession}' WHERE id = #{@id};")
    end
  end
  
end