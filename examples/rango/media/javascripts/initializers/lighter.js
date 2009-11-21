// See http://pradador.com/code/lighterjs
window.addEvent("domready", function() {
  // Syntax highlight using Fuel.js.js and default theme
  // <pre id="code" class="js">var myClass = new Class({})</pre>

  // Syntax highlight using Fuel.ruby.js and theme from Flame.twilight.js
  // <pre id="code" class="ruby:twilight">puts "hi"</pre>

  // Highlight all "pre" elements with "code" class
  //$$('pre.code').light({ altLines: 'hover' });
  alert("X");
  $$("pre.code").each(function(element) {
    console.log(element);
    new Lighter(element, { altLines: 'hover' });
  });
})
