class CreateArists < ActiveRecord::Migration[5.0]
  def change
    create_table :artists do |t|
      t.string :name
      t.text :img_url
      t.string :nationality
      t.string :genre

      t.timestamps

    end
  end
end
