class EntriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :others]
  before_action :set_entry, only: [:show, :edit, :update]

  def index
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @entries = @user.entries.all
  end

  def others
    @entries = Entry.where("user_id <> #{current_user.id}")
  end

  def show
    authorize @entry
    @comment = @entry.comments.new
    @comments = @entry.comments.all
  end

  def new
    @entry = current_user.entries.new
    authorize @entry
  end

  def edit
    authorize @entry
  end

  def create
    @entry = current_user.entries.build(entry_params)
    authorize @entry
    if @entry.save
      flash[:success] = 'Entry created!'
      redirect_to @entry
    else
      render current_user
    end
  end

  def update
    authorize @entry
    if @entry.update_attributes(entry_params)
      flash[:success] = 'Entry updated'
      redirect_to @entry
    else
      render 'edit'
    end
  end


  private

    def set_entry
      @entry = Entry.find(params[:id])
    end

    def entry_params
      params.require(:entry).permit(:content)
    end

end
