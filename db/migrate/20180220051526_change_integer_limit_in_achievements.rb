class ChangeIntegerLimitInAchievements < ActiveRecord::Migration[5.1]
  def change
  	change_column :achievements, :amount, :integer, limit: 8
  end
end
