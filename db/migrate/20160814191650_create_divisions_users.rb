class CreateDivisionsUsers < ActiveRecord::Migration
  def change
    create_table :divisions_users, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :division, index: true
    end
  end
end
