# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  password   :string
#  role       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base

  # Define User roles
  enum role: [:patient, :family]

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
