class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  # Testing patient creation: curl -H "Content-Type: application/json" -X POST -d '{"name":"testy", "role":"patient", "email":"test@gmail.com", "password":"password", "phone_number":"6083228874"}' http://localhost:3000/api/users
  # Testing family member creation: curl -H "Content-Type: application/json" -X POST -d '{"name":"testy", "role":"family", "email":"test@gmail.com", "password":"password", "phone_number":"6083228874"}' http://localhost:3000/api/users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /api/users/:id
  # Testing patient get info: curl -H "Content-Type: application/json" -X GET http://localhost:3000/api/users/3
  # Testing family member get info: curl -H "Content-Type: application/json" -X GET http://localhost:3000/api/users/4
  def get_user_info
    id = params["id"]
    error_list = []
    status = 1
    json_response = {}
    user = User.find_by(id: id)

    if user.nil?
      error_list.append("Error: The specified user doesn't exist.")
      status = -1
    else
      json_response["user"] = user.get_user_json_data
    end

    if status == -1
      json_response["errors"] = error_list
    end

    # Format the json_response into proper JSON and respond with it
    json_response = json_response.to_json

    respond_to do |format|
      format.json { render json: json_response }
    end
  end

  # GET /api/users/:id/relationships
  # Testing patient get info: curl -H "Content-Type: application/json" -X GET http://localhost:3000/api/users/3/relationships
  # Testing family member get info: curl -H "Content-Type: application/json" -X GET http://localhost:3000/api/users/4/relationship
  def get_user_relationships_info
    id = params["id"]
    error_list = []
    status = 1
    json_response = {}
    user = User.find_by(id: id)

    if user.nil?
      error_list.append("Error: The specified user doesn't exist.")
      status = -1
    else
      json_response["relationships"] = user.get_relationship_json_data
    end

    if status == -1
      json_response["errors"] = error_list
    end

    # Format the json_response into proper JSON and respond with it
    json_response = json_response.to_json

    respond_to do |format|
      format.json { render json: json_response }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :role, :phone_number, :patient_phone_number)
    end
end
