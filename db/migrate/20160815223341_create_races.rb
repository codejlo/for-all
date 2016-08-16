class CreateRaces < ActiveRecord::Migration
  def change
    create_table :races do |t|
      t.belongs_to :office, index: true
      t.string :office_name
      t.string :division

      t.timestamps(null: false)
    end
  end
end
