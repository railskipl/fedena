class CreateArchivedHomeworkScores < ActiveRecord::Migration
  def self.up
    create_table :archived_homework_scores do |t|
      t.integer :student_id
      t.integer :homework_id
      t.decimal :marks
      t.integer :grading_level_id
      t.string :remarks
      t.boolean :is_failed
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :archived_homework_scores
  end
end
