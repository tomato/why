require 'rss/2.0'
require 'hpricot'

class HomeController < ApplicationController

  def index
    if customer_signed_in?
      redirect_to customer_orders_path(current_customer.id) 
    elsif supplier_user_signed_in?
      redirect_to  new_supplier_user_session_path
    elsif admin_signed_in?
      redirect_to suppliers_path
    end

    @news = get_feed
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
