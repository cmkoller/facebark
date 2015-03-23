class CreateDogs < ActiveRecord::Migration
  def change
    create_table :dogs do |t|
      t.string :name, require: true
      t.text :bio
      t.string :avatar_url
      t.integer :owner_id, null: false
    end

    add_index :dogs, :owner_id
  end
end
