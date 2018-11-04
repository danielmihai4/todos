$(document).ready(function(){
  var toggle_state = function(){
    var span = $(this);
    var state = span.hasClass("glyphicon-check") ? 0 : 1;
    var id = span.attr("id").substring("item-state-".length, span.attr("id").length);
    var url = "/toggle_item_state/" + id + "/" + state;

    $.ajax({
      type: "POST",
      url: url,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        $("button[item-id='" + id + "']").attr("data-content", data.item_info);

        if (span.hasClass("glyphicon-check")) {
          span.removeClass("glyphicon-check").addClass("glyphicon-unchecked");
        } else {
          span.removeClass("glyphicon-unchecked").addClass("glyphicon-check");
        }
      }
    });
  };

  $('[id^="item-state-"]').on("click", toggle_state);

  $("#new-item-name").on("input", function() {
    if ($(this).val() != '') {
      $("#create-new-item-button").prop('disabled', false);
    } else {
      $("#create-new-item-button").prop('disabled', true);
    }
  });

  $('#new-item-due-date').datepicker({
    format: "dd/mm/yyyy"
  });

  $('#new-item-due-date').on('changeDate', function(ev){
    $(this).datepicker('hide');
  });

  $('#new-item-modal').on('hidden.bs.modal', function () {
    $("#new-item-name").val("");
    $("#new-item-due-date-input").val("");
  });

  $('#create-new-item-button').on('click', function() {
    var item_name = $("#new-item-name").val();
    var item_due_date = $("#new-item-due-date-input").val();
    var list_id = $("#list_id").val();
    var url = "/lists/" + list_id + "/items?name=" + item_name + "&due_date=" + item_due_date;

    $("#new-item-modal").modal("hide");

    $.ajax({
      type: "POST",
      url: url,
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      success: function(data) {
        var span = document.createElement("span");
        $(span).addClass("glyphicon");
        $(span).addClass("glyphicon-unchecked");
        $(span).attr("aria-hidden", "true");
        $(span).attr("id", "item-state-" + data.id);
        $(span).on("click", toggle_state);

        var div_check_box = document.createElement("div");
        $(div_check_box).addClass("col-xs-1");
        $(div_check_box).addClass("col-md-1");
        $(div_check_box).append($(span));

        var button_name = document.createElement("button");
        $(button_name).addClass("label");
        $(button_name).addClass("label-default");
        $(button_name).attr("href", "#");
        $(button_name).attr("title");
        $(button_name).attr("data-toggle", "popover");
        $(button_name).attr("data-trigger", "focus");
        $(button_name).attr("data-content", "Item not yet completed");
        $(button_name).attr("item-id", data.id);
        $(button_name).attr("data-original-title", "Info");
        $(button_name).text(data.name);
        $(button_name).popover();

        var div_name = document.createElement("div");
        $(div_name).addClass("col-xs-5");
        $(div_name).addClass("col-md-5");
        $(div_name).append($(button_name));

        var div_due_date = document.createElement("div");
        $(div_due_date).addClass("col-xs-6");
        $(div_due_date).addClass("col-md-6");
        $(div_due_date).attr("align", "right");

        if (data.due_date != "") {
            $(div_due_date).append("Due " + data.due_date);
        }

        var div_row = document.createElement("div");
        $(div_row).addClass("row");
        $(div_row).append($(div_check_box));
        $(div_row).append($(div_name));
        $(div_row).append($(div_due_date));

        $("#items-container").append($(div_row));
      }
    });

  });
});
