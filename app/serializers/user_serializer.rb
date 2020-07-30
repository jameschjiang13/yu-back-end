class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :manageable_fund
  # has_many :stocks
  has_many :portfolio_lists
end
