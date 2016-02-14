class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    # params[:sort_by] ? sort=params[:sort_by] : sort=session[:sort_by]
    # params[:ratings] ? ratings=params[:ratings] : ratings=session[:ratings]
    sort=params[:sort_by]
    ratings=params[:ratings]
    
    if sort
      @movies = Movie.order(sort)
      session[:sort_by] = sort
    else
      @movies = Movie.all
    end
    if ratings
      session[:ratings] = ratings
      @checks = ratings.keys
      @movies=@movies.where(:rating => @checks)
    end
    
    if (!sort and session[:sort_by]) or (!ratings and session[:ratings])
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
    end
    
    @movies
  end
  
  def sort
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
