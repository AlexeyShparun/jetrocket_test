class CreateRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :ratings do |t|
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end

    add_index :ratings, [:post_id, :user_id], unique: true
  end
end
