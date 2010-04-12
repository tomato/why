class RoundsController < ApplicationController

  def index
    @rounds = Round.find_all_by_supplier_id(session[:supplier_id])
  end

  def new
    @round = Round.new
    render :action => 'edit'
  end

  def edit
    @round = Round.find(params[:id])
  end

  def create
    r = Round.create(params[:round].merge(:supplier_id => session[:supplier_id]))
    redirect_to round_path(r)
  end

  def update
    r = Round.find(params[:id])
    r.update_attributes(params[:round])
    redirect_to rounds_path
  end

  def show
    @round = Round.find(params[:id])
    @deliveries = Delivery.find_by_round_id(params[:id])
  end
end
