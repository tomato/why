var why = {}

why.addItem = function(event, ui) {
  var order = this;
  var product = ui.draggable;
  if(why.itemExists(order, product)){
    why.incrementQuantity(order, product)
  } else {
    why.convertProductToItem(order, product);
    why.updateOrders(order);
  }
}

why.convertProductToItem = function(order,product){
  $("<li><input class='quantity' type='text' value='1'/><span class='product' data-product_id='"
  + product.attr('data-product_id') + "'>" 
  + product.text() + "</span></li>")
  .appendTo($(order).find("ul"))
  .draggable();
  why.updateOrders(order);
}

why.itemExists = function(order, product){
  return $(order).find('.product[data-product_id=' + product.attr('data-product_id') + ']').length;
}

why.incrementQuantity = function(order, product){
  var productId =  product.attr('data-product_id');
  var quantity = $(order).find('.product[data-product_id=' + productId + ']').parent().children('.quantity').get(0)
  quantity.value = parseInt(quantity.value) + 1;
  why.updateOrders(order);
}


why.binItem = function(event, ui) {
  var order = $(event.srcElement).parents('.order')
  $(ui.draggable).effect("explode").remove();
  why.updateOrders(order);
}

why.createOrder = function()
{

  var regularOrders = why.map_slice($('.regularOrders .updated'), function(e){
    return new why.RegularOrder(e); 
  }) || [];

  var orders = why.map_slice($('.orders .updated'), function(e){
    return new why.Order(e); 
  }) || [];

  $.post($(location).attr('href'), { orders: orders, regular_orders: regularOrders});

  return false;
}

why.Order = function(order) {
    this.delivery_id = order.find('h3').attr('data-delivery_id'),
    this.items = why.map_slice(order.find('li'), function(a){ return new why.Item(a) })
}

why.RegularOrder = function(order) {
    this.regular_order_id = order.find('h3').attr('data-regular_order_id'),
    this.items = why.map_slice(order.find('li'), function(a){ return new why.Item(a) })
}

why.Item = function(li) {
    this.quantity = li.find('.quantity').get(0).value;
    this.product_id = li.find('.product').attr('data-product_id');
}

why.updateRegulars = function(){
  $('.orders .regular ul').html($('.regularOrders .order ul').html());
}

why.setupOrders = function(){
      why.updateRegulars();
      $(".order").droppable({ drop: why.addItem , accept: '.product'})
      $('.order li').draggable({ revert: 'invalid'});
}

why.map_slice = function(elems, fn){
  var result = [];
  for(var n=0; n < elems.length; n++){
    result.push(fn(elems.slice(n, n+1)));
  }
  return result;
}

why.updateOrders = function(order){
  $(order).addClass('updated');
  if($(order).parents('.regularOrders').length){
    why.setupOrders();
  } else {
    $(order).removeClass('regular');
  }
}
