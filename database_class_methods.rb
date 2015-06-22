require "active_support"
require "active_support/inflector"

# This module will be **extended** in all of my classes. It contains methods
# that will become **class** methods for the class.

module DatabaseClassMethods
  
  
  # Get all of the rows for a table.
  #
  # Returns an Array containing objects for each row.
  def all
    # Figure out the table's name from the class we're calling the method on.
    table_name = self.to_s.pluralize.underscore
    
    results = MOVIEDB.execute("SELECT * FROM #{table_name}")

    results_as_objects = []
    
    results.each do |result_hash|
      results_as_objects << self.new(result_hash)
    end
    
    return results_as_objects
  end
  
  
  
  # Adds a record to the database.
  #
  #
  # Return an Integer of ID of inserted row.
  def add_to_database(options={})
    table_name = self.to_s.pluralize.underscore
    
    column_names = options.keys
    column_names_for_sql = column_names.join(", ")
    
    values = options.values
    individual_values_for_sql = []
    
    values.each do |value|
      if value.is_a?(String)
        individual_values_for_sql << "'#{value}'"
      else
        individual_values_for_sql << value
      end
    end
    values_for_sql = individual_values_for_sql.join(", ") 

    MOVIEDB.execute("INSERT INTO #{table_name} (#{column_names_for_sql}) VALUES (#{values_for_sql});")

    MOVIEDB.last_insert_row_id
  end
  
  
  
  # Get a single row.
  #
  # record_id - The record's Integer ID.
  #
  # Returns an Array containing the Hash of the row.
  def find(record_id)
    # Figure out the table's name from the class we're calling the method on.
    table_name = self.to_s.pluralize.underscore
    MOVIEDB.execute("SELECT * FROM #{table_name} WHERE id = #{record_id}")
  end  
  
  
  
  # Gets all movies with a given location id
  #
  # TODO still need to put sqlite in module
  # Returns an Array of movie objects
  def where_id_is(id)
    table_name = self.to_s.pluralize.underscore
    results = MOVIEDB.execute("SELECT * FROM #{table_name} WHERE location_id = #{id};")
    temp = Movie.new
    results_as_objects =[]
    
    results.each do |result_hash|
      results_as_objects << Movie.new(result_hash)
    end
    return results_as_objects
  end

end












