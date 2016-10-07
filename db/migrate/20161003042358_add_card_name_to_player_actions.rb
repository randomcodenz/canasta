class AddCardNameToPlayerActions < ActiveRecord::Migration
  def change
    add_column :player_actions, :card_name, :string
  end
end
