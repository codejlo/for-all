class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :party
      t.string :state
      t.string :fecId
      t.string :fec_url
      t.belongs_to :race, index: true

      t.timestamps(null: false)
    end
  end
end
