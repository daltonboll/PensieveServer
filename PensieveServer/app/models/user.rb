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

  # Construct JSON for data representation of a user to be sent to the phone
  def get_user_json_data
    data = {}
    data["id"] = self.id
    data["name"] = self.name
    data["email"] = self.email
    data["role"] = self.get_role
    data["phone_number"] = self.phone_number

    if self.family?
      data["patient_phone_number"] = self.patient_phone_number
    end

    return data
  end

  # Construct JSON data representation for a user's entire famly to be sent to the phone
  def get_relationship_json_data
    data = {}
    if self.patient?
      patient = self
    else
      patient = User.find_by(phone_number: self.patient_phone_number)
    end

    data["patient"] = patient.get_user_json_data
    data["family_members"] = []
    family_members = patient.get_family_members_for_patient

    family_members.each do |family_member|
      data["family_members"].append(family_member.get_user_json_data)
    end

    return data
  end

  # Returns whether this User is a "patient" or "family"
  def get_role
    if self.patient?
      return "patient"
    elsif self.family?
      return "family"
    else
      return "undefined"
    end
  end

  # Returns a collection of this patient's family members, excluding the patient
  def get_family_members_for_patient
    if self.family?
      return {}
    else
      family_members = User.where("patient_phone_number = '#{self.phone_number}' and phone_number != '#{self.phone_number}'")
      return family_members
    end
  end

  # Returns a collection of this family member's other family members, excluding themselves and the patient
  def get_family_members_for_family_member
    if self.patient?
      return {}
    else
      family_members = User.where("patient_phone_number = '#{self.patient_phone_number}' and phone_number != '#{self.phone_number}'")
      return family_members
    end
  end

  # Returns this family member's patient
  def get_patient_for_family_member
    if self.patient?
      return {}
    else
      patient = User.where("phone_number = #{self.patient_phone_number}").first
      return patient
    end
  end

  # Returns true if a patient already exists for this family member
  def patient_exists
    if self.patient?
      return true
    else
      patient = User.find_by(phone_number: self.patient_phone_number)
      if patient.nil?
        return false
      else
        return true
      end
    end
  end

end
