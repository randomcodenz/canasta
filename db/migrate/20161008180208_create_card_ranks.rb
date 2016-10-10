class CreateCardRanks < ActiveRecord::Migration
  def change
    create_table :card_ranks do |t|
      t.string :rank, :null => false, :limit => 10

      t.timestamps :null => false
    end

    add_index :card_ranks, :rank, :unique => true
  end
end
