class CreateAchievements < ActiveRecord::Migration[5.1]
  def change
    create_table :achievements do |t|
      t.string :title
      t.string :description
      t.string :source
      t.integer :year
      t.integer :amount, default: 0
      t.string :party
      t.string :location
      t.string :status
      t.integer :user_id
      t.string :photo
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
