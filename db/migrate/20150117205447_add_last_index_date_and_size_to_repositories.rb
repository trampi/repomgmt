class AddLastIndexDateAndSizeToRepositories < ActiveRecord::Migration
  def change
    add_column :repositories, :last_index_date, :datetime
    add_column :repositories, :size_in_bytes, :integer, { limit: 8 }
  end
end
