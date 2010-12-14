var why = {}

$(function(){
    why.hideFlash();
})

why.hideFlash = function(){
  $('#notice').delay(5000).slideUp();
}

why.createOrder = function()
{
  var Order = function(order) {
    this.delivery_id = order.find('h3').attr('data-delivery_id');
    this.note = $('textarea',order).val();
    this.items = why.map_slice(order.find('li.item'), function(a){ return new Item(a) });
  };

  var RegularOrder = function(order) {
    this.regular_order_id = order.find('h3').attr('data-regular_order_id');
    this.note = $('textarea',order).val();
    this.items = why.map_slice(order.find('li.item'), function(a){ return new RegularItem(a) });
  };

  var Item = function(li) {
      this.quantity = li.find('.quantity').val();
      this.product_id = li.attr('data-product_id');
  };

  var RegularItem = function(li) {
      this.quantity = li.find('.quantity').val();
      this.product_id = li.attr('data-product_id');
      this.frequency = li.find('#frequency').val();
      this.first_delivery_date = li.find('#start').val();
  };

  var regularOrders = why.map_slice($('.regularOrders .updated'), function(e){
    return new RegularOrder(e); 
  }) || [];

  var orders = why.map_slice($('.orders .updated'), function(e){
    return new Order(e); 
  }) || [];

  $.post($(location).attr('href'), 
      { orders: orders, regular_orders: regularOrders},
      function(data){
        $('#deliveries').html(data)
        why.setupOrders();
        why.displayMessage($('#hidden_msg').html());
      });

  return false;
};

why.displayMessage = function(msg)
{
  $('#content #notice').remove();
  $('#content').prepend('<div id="notice">' + msg + '</div>');
  why.hideFlash();
}

why.setupProducts = function(){
  $("#products li").draggable({ helper: "clone",revert: 'invalid', accept: '.order'});
  $("#products ul").hide();
  $("#products h3").toggle(function(){
    $('.catselector',this).html('-');
    $(this).next('ul').slideDown();
  },function(){
    $('.catselector',this).html('+');
    $(this).next('ul').slideUp();
  })
}

why.setupOrders = function(){
  
  var addItem = function(event, ui) {
    var convertProductToItem = function(order,product){
      $("<li data-product_id='" 
          + product.attr('data-product_id') +
          "' class='item'><input class='quantity' type='text' value='1'/><span class='product'>"
          + product.html() + "</span></li>")
      .insertBefore($(order).find('ul li.total'))
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
    $(order).addClass('updated');
    why.createOrder();
  }


  var subTotal = function(){
    $('.order li.item').attr('data-total', 
        function(){
          return $('.price', this).attr('data-price') 
            * $('input.quantity', this).val();
    })
    
    $('.order .total').html(function(index, html) {
        var order = $(this).parents('.order');
        var x = 0;
        why.map_slice($('li.item', order), function(a){ 
          return x += parseFloat(a.attr('data-total')) });
        return isNaN(x) ? '' : 'Total: £' + x.toFixed(2);
    });
  };

  var openNote = function(order){
    $('.editNote', order).fadeIn(); 
  }

  var closeNote = function(order){
    $('.editNote', order).fadeOut(); 
  }

  var updateNote = function(order){
    updateOrders(order) ; 
  }

  $(".order").droppable({ drop: addItem , accept: '.product'})
  $('.quantity').change(function(){ 
    var order = $(this).parents('.order')
    this.setAttribute('value', this.value);
    if(parseInt(this.value)===0){
      $(this).parents('li.item').effect("explode").remove();
    }
    updateOrders(order);
  });
  $('.note a').click(function(){ openNote($(this).parents('.order')); return false;} )
  $('.editNote a').click(function(){ closeNote($(this).parents('.order')); return false});
  $('.editNote textarea').change(function(){ updateNote($(this).parents('.order')); });
  $('.frequency, .start').change(function(){ updateOrders($(this).parents('.order')); });
  subTotal()
}

why.map_slice = function(elems, fn){
  var result = [];
  for(var n=0; n < elems.length; n++){
    result.push(fn(elems.slice(n, n+1)));
  }
  return result;
}




