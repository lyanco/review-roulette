class EntriesController < ApplicationController
  before_action :authenticate_user!, except: [:create_api]
  after_action :verify_authorized, except: [:index, :others, :create_api]
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
      render 'new'
    end
  end

  def create_api
    if call_has_valid_user_password(api_entry_params[:api_data][:user_id], api_entry_params[:api_data][:auth_token])
      user = User.find(api_entry_params[:api_data][:user_id])
      @entry = user.entries.build(entry_params)
      if @entry.save
        respond_to do |format|
          format.json { render json: @entry }
        end
      else
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    else
      respond_to do |format|
        format.json { render json: { error: 'user id and password do not match', status: :unprocessable_entity } }
      end
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

    def api_entry_params
      params.require(:entry).permit(:content, api_data: [:user_id, :auth_token])
      #TODO: Refactor this to chain off of entry params to DRY it up a bit
    end

    def call_has_valid_user_password(user_id, encrypted_password)
      user = User.find_by_id(user_id)
      if !user_id.nil? && !encrypted_password.nil? && !user.nil?
        User.find_by_id(user_id).encrypted_password == encrypted_password
      else
        return false
      end
    end

end


