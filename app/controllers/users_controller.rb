class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  before_action :authenticate_user!, except: [:index, :show]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.page(params[:page]).per(25)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.includes(:favorite_hacks, :hacks, :comments).find(params[:id])
    @favorite_hacks = @user.favorite_hacks
    @hacks = @user.hacks
    @comments = @user.comments
  end

  # GET /users/1/edit
  def edit
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username)
    end

end
