class User < ApplicationRecord
    has_many :portfolio_lists
    has_many :stocks, through: :portfolio_lists

    has_secure_password

    validates :username, uniqueness: true
end
