class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :name
      t.date :due_date
      t.references :repository, index: true

      t.timestamps
    end
  end
end
