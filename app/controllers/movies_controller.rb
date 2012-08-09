class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  # Company.find(:first, :conditions => "name = 'Next Angle'")
  #Person.find(:all, :conditions => { :friends => ["Bob", "Steve", "Fred"] }
  
  # override session values with params values
  params.each { |key,value| session[key] = value }
  # now on : use session params
	@all_ratings = Movie.all_ratings;
  # update list of ratings to filter	
	selected_ratings = []
	if (!(session[:ratings].nil?))
		selected_ratings = session[:ratings].keys
	end	
	@ratings_checked = {}
	#update checked value to display in view
	@all_ratings.each { |rating|
		@ratings_checked[rating] = (session[:ratings].nil? || session[:ratings][rating].nil?) ? false : true;
	}
	
	if (session[:sort_by]=='title')
		@movies = Movie.find(:all, :order => "title" , :conditions => { :rating => selected_ratings})
	elsif (session[:sort_by]=='release_date')
		@movies = Movie.find(:all, :order => "release_date" , :conditions => { :rating => selected_ratings})
	else
		@movies = Movie.find(:all,  :conditions => { :rating => selected_ratings})
	end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
