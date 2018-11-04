class ItemsController < ApplicationController
  def show

  end

  def toggle_state
    @item = Item.find(params[:id])
    is_done = params[:state] == "1"

    @item.is_done = is_done
    @item.completed_by = is_done ? current_user : nil
    @item.completed_at = is_done ? DateTime.now : nil
    @item.save

    render :json => {:item_info => @item.info}
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render :json => {:id => @item.id, :name => @item.name, :due_date => @item.due_date.to_formatted_s(:short)}
    else

    end

  end

  private
    def item_params
      params.permit(:name, :due_date, :list_id)
    end
end
