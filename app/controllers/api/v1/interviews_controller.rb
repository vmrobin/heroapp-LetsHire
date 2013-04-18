class Api::V1::InterviewsController < Api::V1::ApiController

  before_filter :authenticate_user!

  INTERVAL_MAPPINGS = {
    '1d' => 1.day,
    '1w' => 1.week,
    '1m' => 1.month
  }

  ATTRIBUTE_MAPPINGS = %w[candidate attachment]

  OK = 'success'
  ERROR = 'error'

  def index
    interval = params['interval'] || '1d'
    return invalid_params unless INTERVAL_MAPPINGS.keys.include? interval
    @interviews = Interview.where(:scheduled_at => (Time.now )..(Time.now + INTERVAL_MAPPINGS[interval]))
    render :json => {:ret => OK, :interviews => @interviews}, :status => 200
  end

  def show
    return missing_params unless params['id']

    requested_attrs = ATTRIBUTE_MAPPINGS.select { |key| params[key] == '1' }

    @interview = Interview.find(params['id'])
    @candidate = nil
    if requested_attrs.include? 'candidate'
      candidate_id = @interview.opening_candidate.candidate_id
      @candidate = Candidate.find(candidate_id)
    end
    @attachment = nil
    render :json => {:ret => OK, :interviews => @interviews, :candidate => @candidate, :attachment => @attachment}
  rescue ActiveRecord::RecordNotFound
    return unavailable_instance
  end

  def update
    render :json => {:ret => OK, :message => 'not implemented'}, :status => 200
  end

  private

  def missing_params
    render :json => {:ret => ERROR, :message => 'missing some key params'}, :status => 401
  end

  def invalid_params
    render :json => {:ret => ERROR, :message => 'invalid params'}, :status => 401
  end

  def unavailable_instance
    render :json => {:ret => ERROR, :message => 'record not found'}, status => 500
  end
end