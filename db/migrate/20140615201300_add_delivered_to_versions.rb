class AddDeliveredToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :delivered, :boolean
  end
end
