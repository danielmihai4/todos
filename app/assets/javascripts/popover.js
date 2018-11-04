$(document).ready(function(){
    $('[data-toggle="popover"]').popover({html: true});

    // $('[data-toggle="popover"]').on('show.bs.popover',function(e) {
    //   var itemId = $(this).attr("item-id");
    //   var isDone = $("#item-state-" + itemId).hasClass("glyphicon-check");
    //
    //   console.log("ITEM ID: " + itemId);
    //   console.log("IS DONE: " + isDone);
    //
    //   if (!isDone) {
    //     console.log("WILL HIDE POPOVER");
    //     $(this).popover("hide");
    //   }
    // });
});
