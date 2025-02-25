class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :login

      t.timestamps
    end

    add_index :users, :login, unique: true
  end
end
