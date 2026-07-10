class AddDefaultQualificationToFeedbacks < ActiveRecord::Migration[8.1]
  def change
    change_column_default :feedbacks, :qualification, from: 0, to: nil
  end
end
