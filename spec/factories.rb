Factory.define :customer do |u|
  u.round_id 1
  u.email 't@t.com'
  u.password 'ab1234'
  u.password_confirmation 'ab1234'
  u.association :supplier
end

Factory.define :customer_with_orders, :parent => :customer do |u|
  u.orders {|a| [a.association(:order)] }
  u.regular_orders {|a| [a.association(:regular_order)] }
end

Factory.define :supplier do |u|
  u.name 'Test Supplier'
end

Factory.define :supplier_user do |u|
  u.email 's@t.com'
  u.password 'ab1234'
  u.password_confirmation 'ab1234'
  u.association :supplier
end

Factory.define :order do |u|
  u.customer_id 1
  u.delivery_id 1
  u.order_items {|a| [a.association(:order_item)] }
end

Factory.define :regular_order do |u|
  u.customer_id 1
  u.regular_order_items {|a| [a.association(:regular_order_item)] }
end

Factory.define :order_item do |u|
  u.product_id 1
  u.quantity 1
  u.order_id  1
end

Factory.define :regular_order_item do |u|
  u.product_id 1
  u.quantity 1
  u.regular_order_id  1
end

Factory.define :product do |u|
  u.name 'asparagus'
  u.supplier_id 1
end


  
