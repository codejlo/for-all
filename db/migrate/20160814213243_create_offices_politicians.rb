class CreateOfficesPoliticians < ActiveRecord::Migration
  def change
    create_table :offices_politicians, id: false do |t|
      t.belongs_to :office, index: true
      t.belongs_to :politician, index: true
    end
  end
end
