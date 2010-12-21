class CreateHomeworkScores < ActiveRecord::Migration
  def self.up
    create_table :homework_scores do |t|
      t.integer :student_id
      t.integer :homework_id
      t.decimal :marks
      t.integer :grading_level_id
      t.string :remarks
      t.boolean :is_failed
      t.datatime :created_at
      t.datatime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :homework_scores
  end
end
