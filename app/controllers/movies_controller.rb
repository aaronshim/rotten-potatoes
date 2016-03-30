class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # for SQL
    order = params[:asc] ? :asc : :desc
    # for arrows next to the column being sorted
    glyph = params[:asc] ? "glyphicon glyphicon-triangle-top" : "glyphicon glyphicon-triangle-bottom"
    glyph_html = "<span class=\"#{glyph}\" aria-hidden=\"true\"></span>"
    # for switching ascending versus descending on every click
    @next_order = params[:asc] ? nil : true

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
    else
      @movies = Movie.all
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
