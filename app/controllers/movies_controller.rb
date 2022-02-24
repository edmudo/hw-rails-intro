class MoviesController < ApplicationController

    def self.ratings
      return Movie.select(:rating).order(:rating).distinct.map { |movie| movie.rating }
    end

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = MoviesController.ratings

      used_session = false
      if params.has_key?(:sort)
        @order = params[:sort]
        session[:sort] = params[:sort]
      elsif session.has_key?(:sort)
        @order = session[:sort]
        used_session = true
      else
        @order = nil
      end

      if params.has_key?(:commit) && params.has_key?(:ratings)
        @filter = params[:ratings].keys
        session[:ratings] = @filter
      elsif session.has_key?(:ratings)
        @filter = session[:ratings]
        used_session = true
      else
        @filter = @all_ratings
      end

      if used_session
        flash.keep
        redirect_to movies_path(ratings: @filter.map {|rating| [rating, 1]}.to_h, sort: @order, commit: 'Redirect')
      end
      @movies = Movie.all.where(rating: @filter).order(@order)
      
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end
