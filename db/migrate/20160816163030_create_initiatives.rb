class CreateInitiatives < ActiveRecord::Migration
  def change
    create_table :initiatives do |t|
      t.string :title
      t.string :subject
      t.string :description
      t.belongs_to :division

      t.timestamps(null: false)
    end
  end
end
