class CreateUserTargets < ActiveRecord::Migration[5.2]
  def change
    create_table :user_targets do |t|
      t.integer :user_id
      t.integer :target_id
      t.integer :fastest

      t.timestamps
    end
  end
end
