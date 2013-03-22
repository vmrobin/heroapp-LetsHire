class OpeningsController < ApplicationController
  # GET /openings
  # GET /openings.json
  def index
    @openings = Opening.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @openings }
    end
  end

  # GET /openings/1
  # GET /openings/1.json
  def show
    @opening = Opening.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @opening }
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to openings_url, notice: 'Invalid opening'
  end

  # GET /openings/new
  # GET /openings/new.json
  def new
    @opening = Opening.new(:title => '', :description => description_template)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @opening }
    end
  end

  # GET /openings/1/edit
  def edit
    @opening = Opening.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to openings_url, notice: 'Invalid opening'
  end

  # POST /openings
  # POST /openings.json
  def create
    @opening = Opening.new(params[:opening])

    respond_to do |format|
      if @opening.save
        format.html { redirect_to @opening, notice: 'Opening was successfully created.' }
        format.json { render json: @opening, status: :created, location: @opening }
      else
        format.html { render action: "new" }
        format.json { render json: @opening.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /openings/1
  # PUT /openings/1.json
  def update
    @opening = Opening.find(params[:id])

    respond_to do |format|
      #if params[:opening].present?
      #  params[:opening][:participants] = params[:opening][:opening_participants].present? ? User.find_all_by_id(params[:opening][:opening_participants]) : [ ]
      #
      #  params[:opening].delete(:opening_participants)
      #end
      puts params[:opening]
      if @opening.update_attributes(params[:opening])
        format.html { redirect_to @opening, notice: 'Opening was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @opening.errors, status: :unprocessable_entity }
      end
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to openings_url, notice: 'Invalid opening'
  end

  # DELETE /openings/1
  # DELETE /openings/1.json
  def destroy
    @opening = Opening.find(params[:id])
    @opening.destroy

    respond_to do |format|
      format.html { redirect_to openings_url }
      format.json { head :no_content }
    end
  end


  def subregion_options
    render partial: 'subregion_select'
  end



  private
  def description_template
        #Fixme: need load from 'setting' page
        <<-END_OF_STRING
About Us

ABC is the world leader in virtualization and cloud infrastructure solutions.
We empower our 400,000 customers by simplifying, automating, and transforming
the way they build, deliver, and consume IT. We are a passionate and innovative
group of people, comprised of thousands of top-notch computer scientists and
software engineers spread across the world.

Job Description
We are seeking ....


Requirements
-	condition 1
-	condition 2

        END_OF_STRING
      end



end
