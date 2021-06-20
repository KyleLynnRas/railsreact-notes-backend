class NotesController < ApplicationController
  #target a specific note it'll grab id from param 
  #before actions are things that should run before anything else 
  before_action :set_note, only: [:show, :update, :destroy]
  #need to have token auth before hitting any of these routes 
  before_action :authorized

  # GET /notes - get users notes 
  def index
    @notes = Note.where user: @user.id

    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    #attach user to note when created 
    @note.user = @user

    if @note.save
      render json: @note, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :body, :user_id)
    end
end
