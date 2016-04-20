class CommentsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments/1
  # GET /comments/1.json
  def show
  end


  # POST /comments
  # POST /comments.json
  def create
    @entry = Entry.find(comment_params[:entry_id])
    @comment = @entry.comments.build(comment_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @entry, notice: 'Comment was successfully created.' }
        #format.json { render entry_path(@entry), status: :created, location: @entry }
      else
        @comments = @entry.comments.all
        format.html { render 'entries/show' }
        #format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end


  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content, :entry_id)
    end
end
