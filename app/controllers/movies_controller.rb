class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order = :asc
    @all_ratings = Hash.new(0);
    Movie.rating_list.each do |m|
      @all_ratings[m] = false
    end
    
    #Basculent de l'ordre de tri
    if params[:order]==:asc.to_s
      @order = :desc
    else
      @order = :asc
    end
    
    #Par defaut on tri par titre
    if params[:sort_by] == nil
      sort_by = "title"
    else
      sort_by = params[:sort_by]
      #SI on a cliaue sur titre ou date de sortie alors on surligne en jaune le header du tableau
      if sort_by=="title"
        @hilite_title="hilite"
      else sort_by=="release_date"
        @hilite_release_date = "hilite"
      end
    end
    
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end 
    if !session[:ratings].nil?
      @ratings = session[:ratings].keys
      @ratings.each do |r|
        @all_ratings[r] = true
      end       
    end
    
      @movies = Movie.find_all_by_rating(@ratings, :order=>sort_by + " " + @order.to_s)
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
