class UsersController < ApplicationController

  def index
    @users = User.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html
      format.json { render :json => @users }
    end
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url }
      else
        format.html { redirect_to new_user_url }
      end
    end
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.json {render :json => @user}
    end
  end

  def show
    @user = User.find(params[:id])
    @role_name = Role.find(@user.role_id).name if @user.role_id
    @department_name = Department.find(@user.department_id).name if @user.department_id
    respond_to do |format|
      format.html
    end
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to( @user, :notice => 'User was successfully updated')}
      else
        format.html { redirect_to edit_user_path }
      end
    end
  end

  def edit
    @user = User.find(params[:id])
    @roles = Role.all
    @departments = Department.all
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
    end
  end
end
