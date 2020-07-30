class CreatePortfolioLists < ActiveRecord::Migration[6.0]
  def change
    create_table :portfolio_lists do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :price
      t.integer :volume

      t.timestamps
    end
  end
end
