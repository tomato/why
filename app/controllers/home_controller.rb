require 'rss/2.0'
require 'hpricot'

class HomeController < ApplicationController

  def index
    logger.info "Firing Home Controller Index action with subdomain: #{request.subdomain}"
    session[:embed] = false
    if(@supplier)
      if customer_signed_in?
        logger.info "redirecting from index to orders path"
        redirect_to customer_orders_path(current_customer.id) 
      elsif supplier_user_signed_in?
        redirect_to  new_supplier_user_session_path
      elsif admin_signed_in?
        logger.info "redirecting from index to suppliers_path"
        redirect_to suppliers_path
      elsif @supplier
        logger.info "redirecting from index to new_customer_session_path"
        redirect_to new_customer_session_path
      end
    end

    @news = get_feed
  end

  def index2
    @news = get_feed
  end

  def embed
    session[:embed] = true
    redirect_to '/customers/sign_in'
  end

  private

  def get_feed
    begin
      rss = SimpleRSS.parse(open('http://solittlecode.wordpress.com/category/news/feed/'))
      rss.items[0..3].map do |item|
        hpricot = Hpricot(item.content_encoded)
        hpricot.search("a[@rel='nofollow']").remove
        hpricot.search("img[@src*='wordpress']").remove
        {:title => item.title,
         :content_encoded => hpricot.html}
      end
    rescue
      return []
    end
  end
end
