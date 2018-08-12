class CreateListItem < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.belongs_to :list
      t.boolean :is_done, :null => false, :default => 0
      t.datetime :due_date
      t.timestamps
    end
  end
end
