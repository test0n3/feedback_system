class AddDefaultStatusToFeedbacks < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE feedbacks SET status = 0 WHERE status IS NULL"
    change_column_default :feedbacks, :status, 0
    change_column_null :feedbacks, :status, false, 0
  end

  def down
    change_column_null :feedbacks, :status, true
    change_column_default :feedbacks, :status, nil
  end
end
