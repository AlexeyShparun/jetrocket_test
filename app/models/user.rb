class User < ApplicationRecord
    has_many :ratings
    has_many :posts
    validates :login, presence: true, uniqueness: true
end
