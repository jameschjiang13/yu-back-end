class StockSerializer < ActiveModel::Serializer
  attributes :id, :Name, :Symbol, :Sector
end
