class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # for checkbox form on ratings
    @all_ratings = Movie.all_ratings
    # for SQL
    order = params[:asc] ? :asc : :desc
    # for arrows next to the column being sorted
    glyph = params[:asc] ? "glyphicon glyphicon-triangle-top" : "glyphicon glyphicon-triangle-bottom"
    glyph_html = "<span class=\"#{glyph}\" aria-hidden=\"true\"></span>"
    # for switching ascending versus descending on every click
    @last_column = params[:key]
    @next_order = params[:asc] ? nil : true
    # save our settings in the session store
    if params[:key]
      params[:ratings] ||= session[:settings][:ratings]
      session[:settings] = {
        :key => params[:key],
        :asc => params[:asc],
      }
    end
    if params[:ratings]
      session[:settings] = {} unless session[:settings]
      session[:settings][:ratings] = params[:ratings]
    end
    puts params
    puts session[:settings]
    # switches for individual ordering based on our parameters
    if params[:key] == 'title'
      @title_glyph = glyph_html
      @title_css = 'hilite'
      @movies = Movie.order(title: order)
    elsif params[:key] == 'rating'
      @rating_glyph = glyph_html
      @rating_css = 'hilite'
      @movies = Movie.order(rating: order)
    elsif params[:key] == 'release_date'
      @release_glyph = glyph_html
      @release_css = 'hilite'
      @movies = Movie.order(release_date: order)
    # if there were saved settings, redirect to that
    else
      # restructure this catch case of no params elements?
      if session[:settings]
        flash.keep
        if session[:settings][:key]
          redirect_to movies_path(key: session[:settings][:key], asc: session[:settings][:asc], ratings: session[:settings][:ratings])
        elsif params[:ratings].nil? && session[:settings][:ratings]
          redirect_to movies_path(ratings: session[:settings][:ratings])
        end
      end
      # no session store catch-all case
      @movies = Movie.all
    end
    params[:ratings] ||= session[:settings][:ratings] if session[:settings]
    params[:ratings] ||= Hash[ @all_ratings.map { |x| [x,1] } ]
    @movies = @movies.where(rating: params[:ratings].keys)
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
