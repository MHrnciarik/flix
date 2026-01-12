class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy

  RATINGS = %w[G PG PG-13 R NC-17]

  def flop?
    unless reviews.count > 50 && average_stars >= 4
      (total_gross.blank? || total_gross < 225_000_000)
    end
  end

  def self.released
    where("released_on < ?", Time.now).order(released_on: :desc)
  end

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, format: { with: /\w+\.(jpg|png)\z/i,
                                        message: "must be a JPG or PNG image" }
  validates :rating, inclusion: { in: RATINGS }

  def average_stars
    reviews.average(:stars) || 0.00
  end
end
