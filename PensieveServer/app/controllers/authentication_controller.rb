class AuthenticationController < ApplicationController
  before_filter :set_errors

  # Defines constants for SessionsController use
  def set_errors
    @auth_errors = {
                      missing_email: "Error: you must provide an email address.", 
                      missing_password: "Error: you must provide a password.", 
                      bad_credentials: "Error: the provided email address and password do not match.", 
                      nonexistent_user: "Error: the user you are trying to authenticate doesn't exist.",
                    }
  end

  # POST /api/login
  # POST /api/login.json
  # Testing: curl -H "Content-Type: application/json" -X POST -d '{"email":"grandma@gmail.com","password":"password"}' http://localhost:3000/api/login
  # Attempt to login a User. If the login is successful, return the user profile information
  def login
    email = params["email"]
    password = params["password"]
    error_list = []
    status = 1
    json_response = {}

    # Check for missing email in params
    if email.nil?
      error_list.append(@auth_errors[:missing_email])
      status = -1
    end

    # Check for missing password in params
    if password.nil?
      error_list.append(@auth_errors[:missing_password])
      status = -1
    end

    # Find the user that this email address is associated with
    user = User.find_by(email: email)

    # Check to see if the user exists
    if user.nil?
      error_list.append(@auth_errors[:nonexistent_user])
      status = -1
    else
      # Try to authenticate the user
      if not User.authenticate(user, password)
        # prevent authorization
        error_list.append(@auth_errors[:bad_credentials])
        status = -1
      else
        # authentication successful - return user information
        json_response["user"] = user.get_user_json_data
      end
    end

    # Check if we need to add errors to the json_response
    if status == -1
      json_response["errors"] = error_list
    end

    json_response["status"] = status

    # Format the json_response into proper JSON and respond with it
    json_response = json_response.to_json

    respond_to do |format|
      format.json { render json: json_response }
    end
  end

end
