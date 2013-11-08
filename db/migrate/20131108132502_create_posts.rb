class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.text :question, :null => false
      t.text :answer, :null => false
      t.text :message, :null => false

      t.timestamps
    end

    change_column :posts, :created_at, :datetime, :null => false
    change_column :posts, :updated_at, :datetime, :null => false
  end
end
