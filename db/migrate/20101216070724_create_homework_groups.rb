class CreateHomeworkGroups < ActiveRecord::Migration
  def self.up
    create_table :homework_groups do |t|
      t.string :name
      t.integer :batch_id
      t.string :homework_type
      t.boolean :is_published
      t.boolean :result_published
      t.date :homework_date

      t.timestamps
    end
  end

  def self.down
    drop_table :homework_groups
  end
end
