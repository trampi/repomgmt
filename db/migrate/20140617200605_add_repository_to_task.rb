class AddRepositoryToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :repository, index: true
  end
end
