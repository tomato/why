class DeliveriesController < ApplicationController

  def create
    Delivery.create_all(params[:round].to_i, 
      convert_to_date(params[:from]),
      convert_to_date(params[:to]),
      params[:day])
    redirect_to round_url(params[:round])
  end

  private

  def convert_to_date(d)
    Date.new(d[:year].to_i, d[:month].to_i, d[:day].to_i)
  end
end
