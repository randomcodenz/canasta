class AddDeckSeedToRounds < ActiveRecord::Migration
  def up
    add_column :rounds, :deck_seed, :bigint

    Round.reset_column_information

    Round.all.each do |round|
      round.deck_seed = Random.new_seed
      reound.save!
    end

    change_column :rounds, :deck_seed, :bigint, :null => false
  end

  def down
    remove_column :rounds, :deck_seed
  end
end
