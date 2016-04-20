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

class User < ActiveRecord::Base

  # Define User roles as an enum
  enum role: [:patient, :family]

  # User attribute validations
  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 30 }
  
  validates :email, presence: true
  validates :email, uniqueness: true

  validates :phone_number, presence: true
  validates :phone_number, uniqueness: true

  validates :password, presence: true
  validates :role, presence: true

  validates :patient_phone_number, presence: true, if: :family?

  
  # Naive password matching for authentication, NOT secure
  def self.authenticate(user, password)
    return user.password == password
  end

  # construct JSON for data representation of a user to be sent to the phone
  def get_json_data
    data = {}
    data["name"] = self.name
    data["email"] = self.email
    data["role"] = self.get_role

    return data
  end

  # returns whether this User is a "patient" or "family"
  def get_role
    if self.patient?
      return "patient"
    elsif self.family?
      return "family"
    else
      return "undefined"
    end
  end

end
