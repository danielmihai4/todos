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

    respond_to do |format|
      format.js
    end
  end
end
