class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_movie
  def index
    set_movie
    @reviews = @movie.reviews
  end

  def new
    set_movie
    @review = @movie.reviews.new
  end

  def create
    set_movie
    @review = @movie.reviews.new(review_params)
    @review.user = current_user
    if @review.save
      redirect_to movie_reviews_path(@movie), notice: "Thanks for your review!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:comment, :stars)
  end

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end
end
