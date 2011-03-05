Factory.sequence :email do |n|
  "person#{n}@example.com"
end

Factory.define :customer do |u|
  u.round_id 1
  u.name 'tom'
  u.address '42 East End Road'
  u.postcode 'gl53 8qe'
  u.telephone '01242 523607'
  u.email {Factory.next(:email)}
  u.password 'ab1234'
  u.password_confirmation 'ab1234'
  u.association :supplier
end

Factory.define :customer_with_orders, :parent => :customer do |u|
  u.orders {|a| [a.association(:order_future)] }
  u.regular_orders {|a| [a.association(:regular_order)] }
end

Factory.define :customer_with_round, :parent => :customer do |u|
  u.association :round
end

Factory.define :invited_customer, :parent => :customer_with_round do |u|
  u.invitation_token 'pXx3BBJYzOCBXv6tijyG'
  u.invitation_sent_at DateTime.now
end

Factory.define :lost_customer, :parent => :customer_with_round do |u|
  u.reset_password_token 'pXx3BBJYzOCBXv6tijyG'
end

Factory.define :customer_with_orders_and_round, :parent => :customer do |u|
  u.orders {|a| [a.association(:order)] }
  u.regular_orders {|a| [a.association(:regular_order)] }
  u.association :round
end

Factory.define :supplier do |u|
  u.name 'fred'
  u.products {|a| [a.association(:product)]}
  u.from_email 'to.@to.com'
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

Factory.define :order_past, :parent => :order do |u|
  u.delivery {|a| a.association(:delivery_past) }
end

Factory.define :order_future, :parent => :order do |u|
  u.delivery {|a| a.association(:delivery_future) }
end

Factory.define :order_with_real_customer, :parent => :order do |u|
  u.customer {|a| a.association(:customer_with_round) }
end

Factory.define :regular_order do |u|
  u.customer_id 1
  u.regular_order_items {|a| [a.association(:regular_order_item)] }
  u.note "regular order note"
end

Factory.define :order_item do |u|
  u.product {|a| a.association(:product) }
  u.quantity 1
  u.order_id  1
end

Factory.define :regular_order_item do |u|
  u.product {|a| a.association(:product) }
  u.quantity 1
  u.regular_order_id  1
  u.frequency 1
  u.first_delivery_date DateTime.new(2010,1,1)
end

Factory.define :biweekly_regular_order_item, :parent => :regular_order_item do |u|
  u.frequency 2
  u.first_delivery_date DateTime.now
end

Factory.define :product do |u|
  u.name 'asparagus'
  u.supplier_id 1
  u.price 1.32
end

Factory.define :round do |u|
  u.name 'test'
  u.supplier {|a| a.association(:supplier)}
end

Factory.define :delivery do |u|
  u.date DateTime.new
  u.round {|a| a.association(:round)}
end

Factory.define :delivery_past, :parent => :delivery do |u|
  u.date DateTime.new + 1.day
  u.last_order DateTime.new(2010,1,1)
end

Factory.define :delivery_future, :parent => :delivery do |u|
  u.date DateTime.new 
  u.last_order DateTime.new(2110,1,1)
end

Factory.define :delivery_with_order, :parent => :delivery do |u|
  u.orders {|a| [a.association(:order)] }
end
  
