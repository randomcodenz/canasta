class CreatePlayerActions < ActiveRecord::Migration
  def change
    create_table :player_actions do |t|
      t.string :type, :null => false
      t.references :round,
        :null => false,
        :index => true,
        :foreign_key => { :on_delete => :cascade }
      t.timestamps :null => false
    end
  end
end
