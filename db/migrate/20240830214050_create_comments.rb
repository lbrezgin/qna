class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.string :content
      t.belongs_to :commentable, polymorphic: true
      t.belongs_to :user, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
