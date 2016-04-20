# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  name                 :string
#  email                :string
#  password             :string
#  role                 :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  phone_number         :string
#  patient_phone_number :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
