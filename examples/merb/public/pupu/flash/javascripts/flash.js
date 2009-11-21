
// var flash = new Flash("msg", {duration: "small"});
// <div id="msg-error"></div>
Flash = new Class({
  initialize: function(prefix, options) {
    this.prefix          = prefix;
    this.error_element   = $(this.prefix + "-error");
    this.notice_element  = $(this.prefix + "-notice");
    this.success_element = $(this.prefix + "-success");
    this.first_run();
  },

  message: function(element, title, text) {
    if (title) { text = "<h3>" + title + "</h3>" + text }
    var slide = new Fx.Slide(element);
    slide.hide();
    element.set("html", text);
    slide.slideIn();
    (function() { slide.slideOut() }).delay(2500);
  },

  error: function(title, text) {
    if (text) {
      // flash.error("Just an alert");
      this.message(this.error_element, title, text);
    } else {
      // flash.error("Just an alert");
      this.message(this.error_element, null, title);
    }
  },

  notice: function(title, text) {
    if (text) {
      // flash.notice("Just an alert");
      this.message(this.notice_element, title, text);
    } else {
      // flash.notice("Just an alert");
      this.message(this.notice_element, null, title);
    }
  },

  success: function(title, text) {
    if (text) {
      // flash.error("Just an alert");
      this.message(this.success_element, title, text);
    } else {
      // flash.error("Just an alert");
      this.message(this.success_element, null, title);
    }
  },

  first_run: function() {
    var flash = this;
    [this.error_element, this.notice_element, this.success_element].each(function(element) {
      element.setStyle("display", "block");
      if (element.get("html") != "") {
        flash.message(element, "", element.get("html"));
      } else {
        element.slide("hide");
      }
    });
  },
});
