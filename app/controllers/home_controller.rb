class HomeController < ApplicationController

  def index
    if customer_signed_in?
      redirect_to customer_orders_path(current_customer.id) 
    elsif supplier_user_signed_in?
      redirect_to  new_supplier_user_session_path
    elsif admin_signed_in?
      redirect_to suppliers_path
    end

    rss = SimpleRSS.parse(open('http://solittlecode.wordpress.com/category/news/feed/'))
    @news = rss.items[0..3]
  end
end
