class CreateHomeworks < ActiveRecord::Migration
  def self.up
    create_table :homeworks do |t|
      t.integer :homework_group_id
      t.integer :subject_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :maximum_marks
      t.integer :minimum_marks
      t.integer :grading_level_id
      t.integer :weightage
      t.integer :event_id
      t.datetime :created_at
      t.datetime :updated_at
      t.string  :hw_filename 
      t.string  :hw_content_type  
      t.binary  :hw_data          
      
            t.timestamps
    end
  end

  def self.down
    drop_table :homeworks
  end
end
