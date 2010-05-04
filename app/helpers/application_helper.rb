# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    content_for :title do 
      if(@supplier)
        @supplier.name
      else
        "Where's my eggs?"
      end
    end
  end
end
