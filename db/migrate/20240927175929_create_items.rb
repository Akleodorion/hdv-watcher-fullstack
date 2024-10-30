class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :img_url
      t.string :ressource_type
      t.timestamps
    end
  end
end
