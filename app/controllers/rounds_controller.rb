class RoundsController < ApplicationController
  before_filter :authenticate_supplier!

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

  def past
    setup_show 'date < curdate()'
  end

  def future
    setup_show 'date >= curdate()'
  end

  def show
    setup_show nil
  end

  private

  def setup_show(conditions)
    @round = Round.find(params[:id])
    @deliveries = Delivery.find_all_by_round_id(params[:id], :order => 'date', :conditions => conditions) || []
    @delivery_months = @deliveries.group_by { |d| d.date.beginning_of_month }
    @days = Delivery.days
    render :action => 'show'
  end
end
