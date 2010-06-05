var why = {}

$(function(){
  $('#notice').delay(2000).fadeOut();
})

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
  $("#products li").draggable({ helper: "clone",revert: 'invalid', accept: '.order'});
}

why.setupOrders = function(){

  var binItem = function(event, ui) {
    var order = $(event.srcElement).parents('.order')
    $(ui.draggable).effect("explode").remove();
    updateOrders(order);
  }
  
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
      quantity.setAttribute('value', quantity.value);
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
  
  var updateOrders = function(order){
    
    var isRegularMaster = function(order){
      return $(order).parents('.regularOrders').length
    }

    $(order).addClass('updated');
    if(!isRegularMaster(order)){
      $(order).removeClass('regular');
    }
    why.setupOrders();
  }


  $('.orders .regular ul').html($('.regularOrders .order ul').html());
  $(".order").droppable({ drop: addItem , accept: '.product'})
  $('.order li').draggable({ revert: 'invalid'});
  $('.quantity').change(function(){ 
    this.setAttribute('value', this.value);
    var order = $(this).parents('.order')
    updateOrders(order);
  });
  $("#bin").droppable({ drop: binItem });
}

why.updateResponse = function(msg){
  $('.updated').removeClass("updated");
  $('#content #notice').remove();
  $('#content').prepend('<div id="notice">' + msg + '</div>');
}

why.map_slice = function(elems, fn){
  var result = [];
  for(var n=0; n < elems.length; n++){
    result.push(fn(elems.slice(n, n+1)));
  }
  return result;
}

