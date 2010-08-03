class SuppliersController < ApplicationController
  before_filter :authenticate_admin!, :except => :show

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
    authenticate_supplier! params[:id]
    set_supplier_session params[:id]
    set_supplier
    @pending = OrderFactory.pending_customers params[:id]
    @delivery_dates = Delivery.next_10_dates(params[:id]).map { |d| [d[0].to_s(:short), d[1].join(',')] }
  end

  def accept
    Customer.accept_updates(params[:accept])
    flash[:notice] = "Customer changes have been accepted"
    redirect_to supplier_path(params[:id])
  end

  def download
    return labels() if params['format'] == 'labels'
    send_data Delivery.all_orders_csv(params[:deliveries]),
      :filename => 'deliveries.csv',
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

  private

  def set_supplier_session(id)
    session[:supplier_id] = id
    logger.debug "supplier session set to :#{ session[:supplier_id] }"
  end

end
