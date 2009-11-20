window.addEvent("domready", function() {
  // initialization
  var url = "/search/autocomplete";
  var id  = "search";

  // the code
  if ($(id)) {
    new Autocompleter.Request.HTML(id, url, {
      'selectMode': 'type-ahead',
      'indicatorClass': 'autocompleter-loading',
      'minLength': 1,
      'injectChoice': function(choice) {
        // choice is one <li> element
        var text = choice.getFirst();
        // the first element in this <li> is the <span> with the text
        var value = text.innerHTML;
        // inputValue saves value of the element for later selection
        choice.inputValue = value;
        // overrides the html with the marked query value (wrapped in a <span>)
        text.set('html', this.markQueryValue(value));
        // add the mouse events to the <li> element
        this.addChoiceEvents(choice);
      }
    })
  }
})
