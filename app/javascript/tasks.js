import "jquery"
(function() {
  if (window.sQuadLink == null) {
    window.sQuadLink = {};
  }

  jQuery.fn.countDone = function() {
    var done, notDone, percent;
    done = $(".tasks_percent").data("complete");
    notDone = $(".tasks_percent").data("notcomplete");
    if (done > 0) {
      percent = ((done / (notDone + done)) * 100).toFixed(0);
    } else {
      percent = '0';
    }
    return this.text(percent + '%');
  };

  jQuery.fn.submitDoneWithAjax = function(id) {
    return $.post("/todos/" + id, $(this).serialize(), null, "script");
  };

  sQuadLink.todosTab = function() {
    $(".logs_pluss").click(function() {
      $(".flash_notice").empty();
      NProgress.start();
      $(this).hide();
      $(this).next(".logs_minus").show();
      return $.get("/get_logs_todo/" + $(this).attr("id"));
    });
    $(".logs_minus").click(function() {
      var id;
      $(".flash_notice").empty();
      id = $(this).attr("id");
      $("#todo_logs_" + id).slideUp();
      $("#todo_logs_" + id).children().empty().remove();
      $(this).hide();
      return $(this).prev(".logs_pluss").show();
    });
    $(".done_box").on("click", function() {
      var id;
      id = $(this).attr("id");
      return $("#edit_done_todo_" + id).submitDoneWithAjax(id);
    });
    $(".todo_range_date").datepicker({
      onSelect: function() {
        return $("#todo_range_form").submit();
      }
    }).attr("readOnly", "true");
    return $('#todos_pr_date_select').pr_date_select();
  };

}).call(this);
