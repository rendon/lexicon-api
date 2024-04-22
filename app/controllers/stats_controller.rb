class StatsController < ApplicationController
  def index
    count = Lexeme.count
    stats = [{ name: 'Count', value: count }]
    render json: stats
  end
end
