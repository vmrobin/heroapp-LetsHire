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
        format.json { render :json => @user, :status => 'created', :location => @user }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @user.errors, :status => :unprocessable_entity}
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
    respond_to do |format|
      format.html
      format.json { render :json => @user}
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, notice: 'Invalid user'
  end

  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user}
        format.json { render :no_content }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, notice: 'Invalid user'
  end

  def edit
    @user = User.find(params[:id])
    @departments = Department.all
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, notice: 'Invalid user'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { render :no_content}
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to users_url, notice: 'Invalid user'
  end
end
