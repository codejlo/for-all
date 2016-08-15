class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :name
      t.string :identifier
    end
  end
end
