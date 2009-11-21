window.addEvent("domready", function() {
  // msg-error, msg-notice, msg-success
  var flash = new Flash("msg");
  // With title
  // flash.error("Error", "Application failed");
  // flash.notice("Notice", "Order was sent");
  // success

  // Without title
  // flash.error("Application failed");
  // flash.notice("Order was sent");
})
