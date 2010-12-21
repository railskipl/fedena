class ArchivedStudent < ActiveRecord::Base
  belongs_to :country
  belongs_to :batch
  belongs_to :student_category
  belongs_to :nationality, :class_name => 'Country'
  has_many :archived_guardians, :foreign_key => 'ward_id', :dependent => :destroy
  has_one :immediate_contact

  #has_and_belongs_to_many :graduated_batches, :class_name => 'Batch', :join_table => 'batch_students',:foreign_key => 'student_id' ,:finder_sql =>'SELECT * FROM `batches`,`archived_students`  INNER JOIN `batch_students` ON `batches`.id = `batch_students`.batch_id WHERE (`batch_students`.student_id = `archived_students`.former_id )'

  def gender_as_text
    self.gender == 'm' ? 'Male' : 'Female'
  end

  def first_and_last_name
    "#{first_name} #{last_name}"
  end

  def full_name
    "#{first_name} #{middle_name} #{last_name}"
  end

  def immediate_contact
    ArchivedGuardian.find(self.immediate_contact_id) unless self.immediate_contact_id.nil?
  end

  def all_batches
    self.graduated_batches + self.batch.to_a
  end

  def graduated_batches
   # SELECT * FROM `batches` INNER JOIN `batch_students` ON `batches`.id = `batch_students`.batch_id
    Batch.find(:all,:conditions=> 'batch_students.student_id = ' + self.former_id, :joins =>'INNER JOIN `batch_students` ON `batches`.id = `batch_students`.batch_id' )
  end
end
# == Schema Information
#
# Table name: archived_students
#
#  id                   :integer(4)      not null, primary key
#  admission_no         :string(255)
#  class_roll_no        :string(255)
#  admission_date       :date
#  first_name           :string(255)
#  middle_name          :string(255)
#  last_name            :string(255)
#  batch_id             :integer(4)
#  date_of_birth        :date
#  gender               :string(255)
#  blood_group          :string(255)
#  birth_place          :string(255)
#  nationality_id       :integer(4)
#  language             :string(255)
#  religion             :string(255)
#  student_category_id  :integer(4)
#  address_line1        :string(255)
#  address_line2        :string(255)
#  city                 :string(255)
#  state                :string(255)
#  pin_code             :string(255)
#  country_id           :integer(4)
#  phone1               :string(255)
#  phone2               :string(255)
#  email                :string(255)
#  photo_filename       :string(255)
#  photo_content_type   :string(255)
#  photo_data           :binary(16777215
#  status_description   :string(255)
#  is_active            :boolean(1)      default(TRUE)
#  is_deleted           :boolean(1)      default(FALSE)
#  immediate_contact_id :integer(4)
#  is_sms_enabled       :boolean(1)      default(TRUE)
#  former_id            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

