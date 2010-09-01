# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    content_for :title do 
      if(@supplier)
        @supplier.name
      else
        "From Where It's Grown"
      end
    end
  end

  def tab_name
    if current_page?(:controller => :suppliers, :action => :show)
       "dashboard"
    elsif controller.controller_name == "orders"
      "customers"
    else
      controller.controller_name
    end
  end

  def to_pound(num)
    number_to_currency(num, :unit => "£")
  end
end
