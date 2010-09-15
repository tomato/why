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
   
  def create
    Supplier.create(params[:supplier])
    redirect_to :action => 'index'
  end

  def show
    @pending = OrderFactory.pending_customers @supplier.id
    @delivery_dates = Delivery.next_10_dates(@supplier.id).map { |d| [d[0].to_s(:short), d[1].join(',')] }
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
    return labels() if params['format'] == 'Labels'
    return produce() if params['format'] == 'Produce'

    send_data Delivery.all_orders_csv(params[:deliveries]),
      :filename => 'deliveries.csv',
      :type => 'text/csv',
      :disposition => 'attachment'
  end

  def produce
    send_data Delivery.all_produce_csv(params[:deliveries]),
      :filename => 'produce.csv',
      :type => 'text/csv',
      :disposition => 'attachment'
  end

  def labels
    pdf = PdfLabelMaker.avery_labels(Delivery.all_orders(params[:deliveries]))
    send_data pdf.render, 
      :filename => 'labels.pdf', 
      :type => 'application/pdf',
      :disposition => 'attachment'
  end
end
