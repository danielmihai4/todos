class CreateListUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :list_users do |t|
      t.integer :list_id
      t.integer :user_id
    end
  end
end
