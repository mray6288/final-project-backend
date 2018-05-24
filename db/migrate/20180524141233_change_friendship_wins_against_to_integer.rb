class ChangeFriendshipWinsAgainstToInteger < ActiveRecord::Migration[5.2]
  def change
  	change_column :friendships, :wins_against, 'integer USING CAST(wins_against AS integer)'
  end
end
