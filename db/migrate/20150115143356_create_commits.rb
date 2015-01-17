class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.references :repository, index: true
      t.references :user, index: true
      t.string :sha
      t.string :branch
      t.text :message
      t.datetime :date
      t.string :author_email
      t.string :author_name
      t.datetime :commit_date
      t.string :committer_email
      t.string :committer_name

      t.timestamps null: false
    end
    add_foreign_key :commits, :repositories
  end
end
