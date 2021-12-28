class AddStartedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_at, :datetime
  end
end
