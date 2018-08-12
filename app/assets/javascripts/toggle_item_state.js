$(document).ready(function() {
    $('[id^="item-state-"]').on("click", function(){
      var span = $(this);
      var state = span.hasClass("glyphicon-check") ? 0 : 1;
      var id = span.attr("id").substring("item-state-".length, span.attr("id").length);
      var url = "/toggle_item_state/" + id + "/" + state;

      $.ajax({
        type: "POST",
        url: url,
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        success: function() {
          if (span.hasClass("glyphicon-check")) {
            span.removeClass("glyphicon-check").addClass("glyphicon-unchecked");
          } else {
            span.removeClass("glyphicon-unchecked").addClass("glyphicon-check");
          }
        }
      });
    })
});
