class EntriesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized, except: [:index, :others]

  def index
    @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    @entries = @user.entries.all
  end

  def others
    @entries = Entry.where("user_id <> #{current_user.id}")
  end

  def show
    @entry = Entry.find(params[:id])
    authorize @entry
  end

  def new
    @entry = current_user.entries.new
    authorize @entry
  end

  def edit
    @entry = Entry.find(params[:id])
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
    @entry = Entry.find(params[:id])
    authorize @entry
    if @entry.update_attributes(entry_params)
      flash[:success] = 'Entry updated'
      redirect_to @entry
    else
      render 'edit'
    end
  end


  private

    def entry_params
      params.require(:entry).permit(:content)
    end

end
