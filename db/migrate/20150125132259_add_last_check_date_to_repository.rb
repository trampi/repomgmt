class AddLastCheckDateToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :last_check_date, :datetime
  end
end
