class CreatePlayerActionCards < ActiveRecord::Migration
  def change
    create_table :player_action_cards do |t|
      t.belongs_to :card_rank,
        :null => false, :index => true

      t.belongs_to :card_suit,
        :null => false, :index => true

      t.belongs_to :player_action,
        :null => false, :index => true

      t.timestamps :null => false
    end
  end
end
