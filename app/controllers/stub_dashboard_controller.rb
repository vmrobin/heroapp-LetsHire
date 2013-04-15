class StubDashboardController < ApplicationController
  before_filter :require_login

  def overview
    @openings = []
    @candidates = []

    if can? :manage, Opening
      @openings = Opening.owned(current_user.id)
    end

    if can? :manage, Candidate
      @candidates = Candidate.all
    end
  end
end
