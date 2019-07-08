class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists, id: :string do |t|
      t.integer :genre
      t.string :isbn
      t.string :title
      t.string :auther
      t.string :label_name
      t.integer :label_id
      t.date :release_date
      t.integer :decision_flg
      t.timestamps
    end
  end
end
