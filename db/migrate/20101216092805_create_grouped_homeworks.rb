class CreateGroupedHomeworks < ActiveRecord::Migration
  def self.up
    create_table :grouped_homeworks do |t|
      t.integer :homework_group_id
      t.integer :batch_id

      t.timestamps
    end
  end

  def self.down
    drop_table :grouped_homeworks
  end
end
