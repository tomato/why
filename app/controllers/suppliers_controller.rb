class SuppliersController < ApplicationController
  before_filter :authenticate_admin!, :only => [:index, :new, :create]
  before_filter :authenticate_supplier!, :except => [:index, :new, :create]  

  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
    render :action => 'edit'
  end

  def edit
  end

  def create
    Supplier.create(params[:supplier])
    redirect_to :action => 'index'
  end

  def update
    if(@supplier.update_attributes(params[:supplier]))
      flash[:notice] = "Your settings have been updated"
      redirect_to supplier_path(@supplier)
    end
  end

  def show
    @pending = OrderFactory.pending_customers @supplier.id
    @delivery_dates = [['(select)','']] + Delivery.next_10_dates(@supplier.id).map { |d| [d] } 
  end

  def switch
    redirect_to supplier_url(params[:id], :subdomain => params[:id])
  end

  def accept
    Customer.accept_updates(params[:accept])
    flash[:notice] = "Customer changes have been accepted"
    redirect_to supplier_path(@supplier.id)
  end

  def download
    delivery_ids = Delivery.ids_for_dates(@supplier, 
                                          p_d(params[:one_date]), 
                                          p_d(params[:from_date]), 
                                          p_d(params[:to_date]))
    if delivery_ids.any? then
      return labels(delivery_ids) if params['format'] == 'Labels'
      return produce(delivery_ids) if params['format'] == 'Produce'
      return deliveries(delivery_ids)
    else
      redirect_to supplier_path(@supplier)
    end
  end

  private

  def p_d(d)
    return d unless d.present?
    Date.strptime(d, "%Y-%m-%d")
  end

  def deliveries(delivery_ids)
    send_data Delivery.all_orders_csv(delivery_ids),
      :filename => 'deliveries.csv',
      :type => 'text/csv',
      :disposition => 'attachment'
  end

  def produce(delivery_ids)
    send_data Delivery.all_produce_csv(delivery_ids),
      :filename => 'produce.csv',
      :type => 'text/csv',
      :disposition => 'attachment'
  end

  def labels(delivery_ids)
    pdf = PdfLabelMaker.avery_labels(Delivery.all_orders(delivery_ids))
    send_data pdf.render, 
      :filename => 'labels.pdf', 
      :type => 'application/pdf',
      :disposition => 'attachment'
  end
end
