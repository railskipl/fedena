class ArchivedGuardian < ActiveRecord::Base
  belongs_to :country
  belongs_to :ward, :class_name => 'ArchivedStudent'



  def full_name
    "#{first_name} #{last_name}"
  end

  def is_immediate_contact?
    ward.immediate_contact_id == id
  end
end
# == Schema Information
#
# Table name: archived_guardians
#
#  id                   :integer(4)      not null, primary key
#  ward_id              :integer(4)
#  first_name           :string(255)
#  last_name            :string(255)
#  relation             :string(255)
#  email                :string(255)
#  office_phone1        :string(255)
#  office_phone2        :string(255)
#  mobile_phone         :string(255)
#  office_address_line1 :string(255)
#  office_address_line2 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country_id           :integer(4)
#  dob                  :date
#  occupation           :string(255)
#  income               :string(255)
#  education            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

