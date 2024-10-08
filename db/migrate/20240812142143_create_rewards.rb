class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :title
      t.belongs_to :question, foreign_key: { on_delete: :cascade }
      t.belongs_to :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
