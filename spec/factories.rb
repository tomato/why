Factory.define :customer do |u|
  u.round_id 1
  u.email 't@t.com'
  u.password 'ab1234'
  u.password_confirmation 'ab1234'
  u.association :supplier
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
