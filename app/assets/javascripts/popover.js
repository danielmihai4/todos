$(document).ready(function(){
    $('[data-toggle="popover"]').popover();

    $('[data-toggle="popover"]').on('show.bs.popover',function(e) {
      var itemId = $(this).attr("item-id");
      var isDone = $("#item-state-" + itemId).hasClass("glyphicon-check");

      if (!isDone) {
        $(this).popover("hide");
      }
    });
});
