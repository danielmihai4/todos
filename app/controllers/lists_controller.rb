class ListsController < ApplicationController

  def new
    @list = List.new
    @friends = current_user.friends
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user

    if @list.save
      flash[:success] = "List was successfully created"
      listUser = ListUser.new(list: @list, user: current_user)
      listUser.save
      redirect_to lists_path
    else
      render "new"
    end
  end

  def index
    @lists = current_user.lists
  end

  def show
    @list = List.find(params[:id])
  end

  private
    def list_params
      params.require(:list).permit(:name, user_ids: [])
    end
end
