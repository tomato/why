# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    content_for :title do 
      if(@supplier)
        if(@supplier.logo)
          image_tag @supplier.logo.url, :height => '70px'
        else
          @supplier.name
        end
      else
        "From Where It's Grown"
      end
    end
  end

  def tab_name
    if controller.controller_name == "suppliers" && controller.action_name == "show"
       "dashboard"
    elsif controller.controller_name == "orders"
      "customers"
    elsif controller.controller_name == "suppliers" && controller.action_name == "edit"
      "settings"
    else
      controller.controller_name
    end
  end

  def to_pound(num)
    number_to_currency(num, :unit => "£")
  end

  def welcome_text(resource_name)
    if @supplier
      "Welcome to #{ @supplier.name }'s Ordering System"
    else
      "Welcome"
    end
  end
end
