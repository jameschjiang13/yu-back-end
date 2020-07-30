class AddColumn < ActiveRecord::Migration[6.0]
  def change
    change_table :portfolio_lists do |t|
      t.boolean :pending
    end
  end
end
