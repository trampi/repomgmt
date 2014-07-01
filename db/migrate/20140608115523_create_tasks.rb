class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :version, index: true
      t.integer :author_id
      t.integer :assignee_id
      t.string :title
      t.text :message
      t.boolean :solved

      t.timestamps
    end
  end
end
