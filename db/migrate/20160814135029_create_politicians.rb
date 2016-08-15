class CreatePoliticians < ActiveRecord::Migration
  def change
    create_table :politicians do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :party
      t.string :phone
      t.string :website_url
      t.string :photo_url
      t.string :twitter_id
      t.string :status
      t.integer :campaign_office_id

      t.timestamps(null: false)
    end
  end
end
