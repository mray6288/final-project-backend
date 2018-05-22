class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :player1
      t.string :player2
      t.string :target, default: 'circle'
      t.integer :player1_score, default: 0
      t.integer :player2_score, default: 0
      t.boolean :will_rematch, default: false
      t.integer :timer, default: 0
      t.timestamps
    end
  end
end
