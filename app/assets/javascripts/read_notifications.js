$(document).on('show.bs.dropdown', function () {
  if ($("a.dropdown-toggle").hasClass("unread-notifications")){
    $.ajax({
      type: "GET",
      url: "/read_notifications.js"
    });
  };
})