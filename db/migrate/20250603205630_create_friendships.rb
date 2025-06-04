class CreateFriendships < ActiveRecord::Migration[7.1]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :friend_id, null: false
      t.integer :status

      t.timestamps
    end

    add_foreign_key :friendships, :users, column: :friend_id
    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
