class UsersController < AuthenticatedController

  before_filter :require_admin, :except => [:index_for_tokens]

  def index
    @users = User.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html
      format.json { render :json => @users }
    end
  end

  def index_for_tokens
    unless user_signed_in?
      redirect_to new_user_session_path, :notice => REQUIRE_LOGIN
    end
    @participants = User.select("id, name, email").where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.html
      format.json { render :json => @participants.map(&:attributes) }
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

  def deactivate
    @user = User.find(params[:id])
    active_openings = Opening.published.owned_by(@user.id).count
    active_interviews = @user.interviews.where(Interview.arel_table[:status].not_eq(Interview::STATUS_CLOSED)).count
    if active_openings > 0 || active_interviews > 0
    return redirect_to users_url, notice: "Cannot disable user because he or she owns #{active_openings} active opening and #{active_interviews} active interviews."
    end
    toggle(params, false)
  rescue
    redirect_to users_url, notice: 'Invalid user'
  end

  def reactivate
    toggle(params, true)
  rescue
    redirect_to users_url, notice: 'Invalid user'
  end

  private

  def toggle(params, active)
    @user = User.find(params[:id])
    if current_user == @user
      return redirect_to users_url :notice => 'Cannot toggle your own active status'
    end
    option = {:deleted_at => (active ? nil : Time.current)}
    if @user.update_without_password(option) && @user.save
      return redirect_to users_url
    else
      return redirect_to users_url, :notice => "Operation Failed, error = #{@user.errors.inspect}"
    end
  end

  private


end
