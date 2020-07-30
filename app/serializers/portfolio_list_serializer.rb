class PortfolioListSerializer < ActiveModel::Serializer
  attributes :id, :volume, :price, :stock, :pending
end
