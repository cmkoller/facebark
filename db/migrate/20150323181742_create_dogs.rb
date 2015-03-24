class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :name, null: false
      t.integer :age, null: false
      t.string :avatar_url
      t.integer :owner_id
    end

    add_index :dogs, :owner_id
  end
end
