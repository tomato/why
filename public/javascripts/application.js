var why = {}

why.addItem = function(event, ui) {
  $(this).addClass('updated');
  $("<li><span class='quantity'>1</span><span class='product' data-product_id='"
    + ui.draggable.attr('data-product_id') + "'>" 
    + ui.draggable.text() + "</span></li>")
    .appendTo($(this).find("ul"))
    .effect("highlight")
    .hover(why.editItem, why.updateItem)
    .draggable();
}

why.binItem = function(event, ui) {
  $(event.srcElement).parents('.order').addClass('updated')
  $(ui.draggable).effect("explode").remove();
}

why.createOrder = function()
{

  var regularOrders = why.map_slice($('.regularOrders .updated'), function(e){
    return new why.RegularOrder(e); 
  }) || [];

  var orders = why.map_slice($('.orders .updated'), function(e){
    return new why.Order(e); 
  }) || [];

  $.post('', { orders: orders, regular_orders: regularOrders});
}

why.map_slice = function(elems, fn){
  var result = [];
  for(var n=0; n < elems.length; n++){
    result.push(fn(elems.slice(n, n+1)));
  }
  return result;
}

why.editItem = function(){
  var quantity = $('.quantity', this).html();
  $(this).addClass('editableItem');
  $('.quantity', this)
    .replaceWith('<input type="text" class="editableQuantity" data-quantity="' 
        + quantity + '"/>')
  $('input', this).val(quantity);
}

why.updateItem = function(){
  $(this).removeClass('editableItem');
  var quantity = $('.editableQuantity', this).val();
  if(quantity != $('.editableQuantity', this).attr('data-quantity')){
    $(this).parents('.order').addClass('updated');
  }
  $('.editableQuantity', this)
    .replaceWith("<span class='quantity'>" + quantity + "</span");
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
    this.quantity = li.find('.quantity').html();
    this.product_id = li.find('.product').attr('data-product_id');
}

