var why = {}

why.createOrder = function()
{
  var Order = function(order) {
    this.delivery_id = order.find('h3').attr('data-delivery_id');
    this.items = why.map_slice(order.find('li'), function(a){ return new Item(a) });
  };

  var RegularOrder = function(order) {
    this.regular_order_id = order.find('h3').attr('data-regular_order_id');
    this.items = why.map_slice(order.find('li'), function(a){ return new Item(a) });
  };

  var Item = function(li) {
      this.quantity = li.find('.quantity').val();
      this.product_id = li.attr('data-product_id');
  };

  var regularOrders = why.map_slice($('.regularOrders .updated'), function(e){
    return new RegularOrder(e); 
  }) || [];

  var orders = why.map_slice($('.orders .updated'), function(e){
    return new Order(e); 
  }) || [];

  $.post($(location).attr('href'), { orders: orders, regular_orders: regularOrders});

  return false;
};

why.setupProducts = function(){

  var binItem = function(event, ui) {
    var order = $(event.srcElement).parents('.order')
    $(ui.draggable).effect("explode").remove();
    why.updateOrders(order);
  }

  $("#products li").draggable({ helper: "clone",revert: 'invalid', accept: '.order'});
  $("#bin").droppable({ drop: binItem });
}

why.setupOrders = function(){

  var addItem = function(event, ui) {
    var convertProductToItem = function(order,product){
      $("<li data-product_id='" 
          + product.attr('data-product_id') +
          "'><input class='quantity' type='text' value='1'/><span class='product'>"
          + product.text() + "</span></li>")
      .appendTo($(order).find("ul"))
      .draggable();
    }

    var incrementQuantity = function(order, product){
      var productId =  product.attr('data-product_id');
      var quantity = $(order).find('li[data-product_id=' + productId + '] .quantity').get(0)
      quantity.value = parseInt(quantity.value) + 1;
    }

    var itemExists = function(order, product){
      return $(order).find('li[data-product_id=' + product.attr('data-product_id') + ']').length;
    }

    var order = this;
    var product = ui.draggable;
    
    if(itemExists(order, product)){
      incrementQuantity(order, product)
    } else {
      convertProductToItem(order, product);
    }
    updateOrders(order);

  }

  var updateRegularQuantities = function(input, order){
    var quantity = $(input).val();
    var product_id = $(input).parents('li').attr("data-product_id"); 
    $('.orders .regular ul li[data-product_id=' + product_id + '] .quantity').val(quantity);
  }
  
  var updateOrders = function(order){
    $(order).addClass('updated');
    if(!isRegularMaster(order)){
      $(order).removeClass('regular');
    }
    why.setupOrders();
  }

  var isRegularMaster = function(order){
    return $(order).parents('.regularOrders').length
  }

  $('.orders .regular ul').html($('.regularOrders .order ul').html());
  $(".order").droppable({ drop: addItem , accept: '.product'})
  $('.order li').draggable({ revert: 'invalid'});
  $('.quantity').change(function(){ 
    var order = $(this).parents('.order')
    if(isRegularMaster(order)){
      updateRegularQuantities(this, order);
    } else {
    updateOrders(order);
    }
  });
}

why.map_slice = function(elems, fn){
  var result = [];
  for(var n=0; n < elems.length; n++){
    result.push(fn(elems.slice(n, n+1)));
  }
  return result;
}

