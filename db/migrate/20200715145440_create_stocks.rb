class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :Name
      t.string :Symbol
      t.string :Sector

      t.timestamps
    end
  end
end
