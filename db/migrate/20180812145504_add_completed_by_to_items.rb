class AddCompletedByToItems < ActiveRecord::Migration[5.2]
  def change
    add_reference :items, :completed_by, foreign_key: { to_table: :users }
    add_column :items, :completed_at, :datetime
  end
end
