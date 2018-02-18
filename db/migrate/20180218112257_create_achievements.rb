class CreateAchievements < ActiveRecord::Migration[5.1]
  def change
    create_table :achievements do |t|
      t.string :title
      t.string :description
      t.string :source
      t.datetime :timeline
      t.integer :amount
      t.string :party
      t.string :location
      t.string :status
      t.integer :user_id
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
