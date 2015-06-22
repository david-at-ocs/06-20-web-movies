require "sqlite3"
require "active_support"
require "active_support/core_ext/object/blank"
require "sinatra"
require "sinatra/reloader"
require "pry"

set :bind, '0.0.0.0'

# Load/create our database for this program.
# This is the tunnel to the db
MOVIEDB = SQLite3::Database.new("davids_movies.db")

# Make the tables, if they don't already exist.
MOVIEDB.execute("CREATE TABLE IF NOT EXISTS movies (id INTEGER PRIMARY KEY, title TEXT NOT NULL, genre TEXT NOT NULL, location_id INTEGER);")
MOVIEDB.execute("CREATE TABLE IF NOT EXISTS locations (id INTEGER PRIMARY KEY, location TEXT NOT NULL, description TEXT);")
MOVIEDB.execute("CREATE TABLE IF NOT EXISTS people (id INTEGER PRIMARY KEY, name TEXT NOT NULL, profession TEXT NOT NULL);")
MOVIEDB.execute("CREATE TABLE IF NOT EXISTS moviespeople (id INTEGER PRIMARY KEY, person_id INTEGER NOT NULL, movie_id INTEGER NOT NULL);")

# Get results as an Array of Hashes.
MOVIEDB.results_as_hash = true

# -------------------------------------------------------------------------------------------------------------------

require_relative "movie.rb"
require_relative "movie_person.rb"
require_relative "person.rb"
require_relative "location.rb"

# --------------------------------------------------------------------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------

get "/homepage" do
  erb :"homepage"
end


# --------------------------------------------------------------------------------------------------------------------
# -------------------------------------------- Add Menu --------------------------------------------------------------


get "/add_menu" do
  erb :"add_menu"
end

# -------------------------------------------- Add Movie --------------------------------------------------------------
get "/add_movie_form" do
  erb :"add_movie_form"
end

get "/save_movie" do
  new_movie_id = Movie.add({"title" => params["title"], "genre" => params["genre"]})
  
  if new_movie_id
    @new_movie = Movie.find_as_object(new_movie_id)
    erb:"movie_added"
  else
    erb:"movie_not_added"
  end
end




# -------------------------------------------- Add Person -----------------------------------------------------------
get "/add_person_form" do
  erb :"add_person_form"
end

get "/save_person" do
  new_person_id = Person.add({"name" => params["name"], "profession" => params["profession"]})
  if new_person_id
    @new_person = Person.find_as_object(new_person_id)
    erb:"person_added"
  else
    erb:"person_not_added"
  end
end



# -------------------------------------------- Add Location ----------------------------------------------------------
get "/add_location_form" do
  erb :"add_location_form"
end

get "/save_location" do
  new_location_id = Location.add({"location" => params["location"], "description" => params["description"]})
  if new_location_id
    @new_location = Location.find_as_object(new_location_id)
    erb:"location_added"
  else
    erb:"location_not_added"
  end
end

# -------------------------------------------- End Add Menu ----------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------------------
# --------------------------------------------Start View Menu --------------------------------------------------------

get "/view_menu" do
  erb :"view_menu"
end

get "/view_movies" do
  erb :"view_movies"
end

get "/view_people" do
  erb :"view_people"
end

get "/view_locations" do
  erb :"view_locations"
end

get "/view_movies_by_location" do
  erb :"view_movies_by_location"
end

get "/movies_by_location" do
  erb :"movies_by_location"
end

# -------------------------------------------- End View Menu ---------------------------------------------------------
# --------------------------------------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------------------------------------
# --------------------------------------------Start Edit Menu --------------------------------------------------------

get "/edit_menu" do
  erb :"edit_menu"
end

get "/edit_movie" do
  erb :"edit_movie_form"
end

# -------------------------------------------- Edit Movie Title -----------------------------------------------------

get "/edit_title" do
  @movie = Movie.find_as_object(params["movie_id"].to_i)
  @movie.title = params["title"]
  
  if @movie.save
    erb :"title_edited"
  else
    erb :"title_not_edited"
  end
end

# -------------------------------------------- Edit Movie Genre -----------------------------------------------------

get "/edit_movie_genre" do
  @movie = Movie.find_as_object(params["movie_id"].to_i)
  @movie.genre = params["genre"]
  
  if @movie.save
    erb :"genre_updated"
  else
    erb :"genre_not_updated"
  end
end

# -------------------------------------------- Edit: Change Movie Location ------------------------------------------

get "/change_movie_location" do
  @movie = Movie.find_as_object(params["movie_id"].to_i)
  @movie.location_id = params["location_id"]
  location_object = Location.find_as_object(params["location_id"].to_i)
  @location = location_object.location
  
  if @movie.save
    erb :"location_changed"
  else
    erb :"location_not_changed"
  end
end

# -------------------------------------------- Edit: Add Location to Movie -------------------------------------------

get "/add_movie_location" do
  new_location_id = Location.add({"location" => params["location"], "description" => params["description"]})
    if new_location_id
    @movie = Movie.find_as_object(params["movie_id"].to_i)
    @movie.location_id = new_location_id
  
    location_object = Location.find_as_object(new_location_id)
    @location = location_object.location
  
    if @movie.save
      erb :"movie_location_added"
    else
      erb :"movie_location_not_added"
    end    
  end
end


# -------------------------------------------- Edit Location ----------------------------------------------------------

get "/edit_location" do
  erb :"edit_location_form"
end

get "/edit_location_name" do
  # erb :"edit_location_name"  

  @new_location = Location.find_as_object(params["loc_id"].to_i)
  @new_location.location = params["location"]
  if @new_location.save
    erb :"location_name_changed"
  else
    @error = true
    erb :"edit_location_form"
  end
end


get "/edit_location_description" do
  # erb :"edit_location_name"  

  @new_location = Location.find_as_object(params["loc_id"].to_i)
  @new_location.description = params["description"]
  if @new_location.save
    erb :"location_description_changed"
  else
    @error = true
    erb :"edit_location_form"
  end
end


# -------------------------------------------- Edit Person ------------------------------------------------------------

get "/edit_person" do
  erb :"edit_person_form"
end

get "/edit_person_name" do
  # erb :"edit_location_name"  

  @new_person = Person.find_as_object(params["person_id"].to_i)
  @new_person.name = params["name"]
  if @new_person.save
    erb :"person_name_changed"
  else
    @error = true
    erb :"edit_location_form"
  end
end


get "/edit_person_profession" do
  # erb :"edit_location_name"  

  @new_person = Location.find_as_object(params["loc_id"].to_i)
  @new_person.description = params["description"]
  if @new_person.save
    erb :"person_profession_changed"
  else
    @error = true
    erb :"edit_person_form"
  end
end








