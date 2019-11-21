class ListsController < ApplicationController
  before_action :authenticate_user!

  def create
    @item = Item.find_by_id(params[:item_id])

    @item.lists.create(list_params.merge(user: current_user))

    redirect_to root_path
  end

  private

  def list_params
    params.require(:list).permit(:rank)
  end
end
