class AddPatientPhoneNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :patient_phone_number, :string
  end
end
