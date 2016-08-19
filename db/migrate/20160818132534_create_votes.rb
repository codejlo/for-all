class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.belongs_to :user
      t.belongs_to :race
      t.belongs_to :candidate
      t.belongs_to :initiative

      t.string :initiative_selection

      t.timestamps(null: false)
    end
  end
end
