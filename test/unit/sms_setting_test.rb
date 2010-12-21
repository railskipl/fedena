require 'test_helper'

class SmsSettingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: sms_settings
#
#  id           :integer(4)      not null, primary key
#  settings_key :string(255)
#  is_enabled   :boolean(1)      default(FALSE)
#

