class MatchesController < ApplicationController
  before_action :set_match, only: [:show]
  load_and_authorize_resource

  def index
    @round = Round.all.first
    @matches = Match.where(round_id: 1)
    @users = User.all
  end

  def show
  end

  private
    def set_match
      @match = Match.find(params[:id])
    end

    def match_params
      params.require(:match).permit(:first_team_id, :second_team_id, :played, :first_score, :second_score)
    end
end
