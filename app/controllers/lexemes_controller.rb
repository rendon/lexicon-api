class LexemesController < ApplicationController
  before_action :set_lexeme, only: %i[ show update destroy ]
  before_action :check_api_key, except: %i[ index show ]

  # GET /lexemes
  def index
    @lexemes = Lexeme.all

    render json: @lexemes
  end

  # GET /lexemes/1
  def show
    render json: @lexeme
  end

  # POST /lexemes
  def create
    @lexeme = Lexeme.new(lexeme_params)

    if Lexeme.find_by(name: lexeme_params[:name])
      render json: {message: 'Lexeme already exists' }, status: :bad_request
      return
    end

    if @lexeme.save
      render json: @lexeme, status: :created, location: @lexeme
    else
      render json: @lexeme.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lexemes/1
  def update
    if @lexeme.update(lexeme_params)
      render json: @lexeme
    else
      render json: @lexeme.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lexemes/1
  def destroy
    @lexeme.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lexeme
      if params[:id] =~ /^\d+$/
        @lexeme = Lexeme.find(params[:id])
      else
        @lexeme = Lexeme.find_by(name: params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def lexeme_params
      if params[:lexeme][:created_at] && params[:lexeme][:updated_at]
        params.require(:lexeme).permit(:name, :definition, :source, :created_at, :updated_at)
      else
        params.require(:lexeme).permit(:name, :definition, :source)
      end
    end

    def check_api_key
      unless ENV['API_KEY'] == request.headers.fetch('X-API-KEY', '')
        render json: {message: 'Invalid API key' }, status: :forbidden
      end
    end
end
