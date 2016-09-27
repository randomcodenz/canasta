class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, :null => false, :limit => 50
      t.references :game,
        :null => false,
        :index => true,
        :foreign_key => { :on_delete => :cascade }
      t.timestamps :null => false
    end

    add_index :players, [:game_id, :name], :unique => true
  end
end
