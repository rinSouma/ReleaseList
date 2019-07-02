class ListAddFlg < ActiveRecord::Migration[5.1]
  def change
    add_column :lists, :decision_flg, :integer
  end
end
