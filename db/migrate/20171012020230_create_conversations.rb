class CreateConversations < ActiveRecord::Migration[5.1]
  def change
    create_table :conversations do |t|
      t.references :recipient, index: { unique: true }, foreign_key: { to_table: :users }
      t.references :sender, index: { unique: true }, foreign_key: { to_table: :users}

      t.timestamps
    end
    #add_index :conversations, :recipient_id
    #add_index :conversations, :sender_id
    #add_index :conversations, [:recipient_id, :sender_id], unique: true
  end
end
