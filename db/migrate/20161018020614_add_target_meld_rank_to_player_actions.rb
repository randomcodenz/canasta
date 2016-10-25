class AddTargetMeldRankToPlayerActions < ActiveRecord::Migration
  def change
    add_column :player_actions, :target_meld_rank, :string
  end
end
