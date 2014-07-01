class CreateRepositoryAccesses < ActiveRecord::Migration
  def change
    create_table :repository_accesses do |t|
      t.references :user, index: true
      t.references :repository, index: true

      t.timestamps
    end
  end
end
