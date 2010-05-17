var why = {}

why.addItem = function(event, ui) {
  $(this).addClass('updated');
  $("<li><span class='quantity'>1</span><span class='product' data-product_id='"
    + ui.draggable.attr('data-product_id') + "'>" 
    + ui.draggable.text() + "</span></li>")
    .appendTo($(this).find("ul"))
    .effect("highlight")
    .draggable();
}

why.binItem = function(event, ui) {
  $(event.srcElement).parents('.order').addClass('updated')
  $(ui.draggable).effect("explode").remove();
}

why.createOrder = function()
{
  var orders = why.map_slice($('.updated'), function(e){
    return new why.Order(e); 
  });
  $.post('', { orders: orders});
}

why.map_slice = function(elems, fn){
  var result = [];
  for(var n=0; n < elems.length; n++){
    result.push(fn(elems.slice(n, n+1)));
  }
  return result;
}

why.Order = function(order) {
    this.delivery_id = order.find('h3').attr('data-delivery_id'),
    this.items = why.map_slice(order.find('li'), function(a){ return new why.Item(a) })
}


why.Item = function(li) {
    this.quantity = li.find('.quantity').html();
    this.product_id = li.find('.product').attr('data-product_id');
}

