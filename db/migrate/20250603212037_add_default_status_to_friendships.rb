class AddDefaultStatusToFriendships < ActiveRecord::Migration[7.1]
  def change
    change_column_default :friendships, :status, from: nil, to: 0
    # Optional: Also ensure existing null values get updated (run only once)
    Friendship.where(status: nil).update_all(status: 0)
  end
end
