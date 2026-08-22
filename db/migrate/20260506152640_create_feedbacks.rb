class CreateFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :feedbacks do |t|
      t.string :description
      t.integer :qualification, default: nil
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
