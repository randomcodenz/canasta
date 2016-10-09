class CreateCardSuits < ActiveRecord::Migration
  def change
    create_table :card_suits do |t|
      t.string :suit, :null => false, :limit => 10

      t.timestamps :null => false
    end

    add_index :card_suits, :suit, :unique => true
  end
end
