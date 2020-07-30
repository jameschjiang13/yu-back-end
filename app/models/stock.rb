class Stock < ApplicationRecord
    has_many :portfolio_lists
    has_many :users, through: :portfolio_lists
end
