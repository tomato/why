class DeliveriesController < ApplicationController
  before_filter :authenticate_supplier!

  def edit
    @delivery = Delivery.find(params[:id])
  end

  def update
    @delivery = Delivery.find(params[:id])
    @delivery.update_attributes(params[:delivery])
    redirect_to round_url(@delivery.round_id)
  end

  def create
    problems = validate()
    if(problems.length == 0)
      set_count_notice(Delivery.create_all(
        params[:round].to_i, 
        convert_to_date(params[:from]),
        convert_to_date(params[:to]),
        params[:day].collect{|i| i.to_i},
        LastOrdersDuration.new(params[:last_order][:day].to_i,
                              params[:last_order][:hour].to_i)
      ))
    else
      flash[:notice] = problems.join('<br/>')
    end
    redirect_to round_url(params[:round])
  end

  private
  def validate()
    problems = []
    if(!params[:day] || params[:day].length == 0)
      problems << "You need to select the day(s) your round is on"
    end

    if(!valid_date?(params[:from]))
      problems << "Your 'from' date is not a valid"
      return problems
    end

    if(!valid_date?(params[:to]))
      problems << "Your 'to' date is not a valid"
      return problems
    end

    if(convert_to_date(params[:from])> convert_to_date(params[:to]))
      problems << "Your 'to' date needs to be after your 'from' date"
    end
    return problems
  end

  def convert_to_date(d)
    Date.new(d[:year].to_i, d[:month].to_i, d[:day].to_i)
  end

  def valid_date?(d)
    Date.valid_date?(d[:year].to_i, d[:month].to_i, d[:day].to_i)
  end

  def set_count_notice(count)
    flash[:notice] =
    case count      
    when 0
      "No new deliveries were added"
    when 1
      "1 new delivery was added"
    else
      "#{count} new deliveries were added"
    end
  end
end
