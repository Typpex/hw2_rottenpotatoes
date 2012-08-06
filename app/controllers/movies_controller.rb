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

    #Si les parametres sont nul
    if params[:sort_by].nil? and session[:sort_by].nil?
       session[:sort_by] = "title"
    end
       
    if params[:order].nil? and session[:order].nil?
      session[:order] = :asc
    end
    
    #Basculent de l'ordre de tri
    if !params[:order].nil? and params[:order] ==:asc.to_s
      session[:order] = :desc
    elsif !params[:order].nil? and params[:order] ==:desc.to_s
      session[:order] = :asc
    end
      
    
      if !params[:sort_by].nil?
        session[:sort_by] = params[:sort_by]
      end
      
      if session[:sort_by]=="title"
        @hilite_title="hilite"
      else session[:sort_by]=="release_date"
        @hilite_release_date = "hilite"
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

      @movies = Movie.find_all_by_rating(@ratings, :order=>session[:sort_by].to_s + " " + session[:order].to_s)
      @sort_by = session[:sort_by]
      @order = session[:order]
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
