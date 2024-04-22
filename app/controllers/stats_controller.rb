class StatsController < ApplicationController
  def index
    stats = [{ name: 'Count', value: Lexeme.count }]
    render json: stats
  end
end
