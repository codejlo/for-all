class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.string :street
      t.string :unit
      t.string :city
      t.string :state
      t.string :zip
      t.string :party
      t.integer :age
      t.boolean :has_reps

      t.timestamps(null: false)
    end
  end
end
