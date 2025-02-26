class Post < ApplicationRecord
  belongs_to :user
  has_many :ratings
  validates :title, :body, :ip, :user, presence: true


  def average_rating
    ratings.average(:value).to_f.round(2)
  end
end
