class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.timestamps
      t.belongs_to :user, foreign_key: { on_delete: :cascade }
      t.belongs_to :question, foreign_key: { on_delete: :cascade }
    end
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
