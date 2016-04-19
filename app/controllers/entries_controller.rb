class EntriesController < ApplicationController
  before_action :authenticate_user!

  def show
    @entry = Entry.find(params[:id])
  end

  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = 'Entry created!'
      redirect_to @entry
    else
      render current_user
    end
  end

  def new
    @entry = current_user.entries.new
  end



  private

    def entry_params
      params.require(:entry).permit(:content)
    end

end
