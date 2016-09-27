class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :game,
        :null => false,
        :index => true,
        :foreign_key => { :on_delete => :cascade }
      t.timestamps :null => false
    end
  end
end
