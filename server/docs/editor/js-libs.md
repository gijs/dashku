Using 3rd-party JS libraries
===

One of the cool features of Dashku is being able to use 3rd-party JavaScript libraries to handle presenting the data received by the widget.

That said, because Dashku is SSL secured, it is not possible to call 3rd-party JavaScript libraries that are hosted on an external domain. What we do instead is locally host a copy of some popular 3rd-party JavaScript libraries, so that you can use them in your widgets.

JS libraries available
---

These are the JS libraries available for use:

- [Cubism](http://square.github.com/cubism) (cubism.v1.min.js)
- [D3](http://d3js.org) (d3.v2.min.js)
- [g.Raphael](http://g.raphaeljs.com) (g.raphael-min.js , g.bar-min.js , g.dot-min.js , g.line-min.js , g.pie-min.js)
- [jQuery.knob](http://anthonyterrien.com/knob) (knob-1.1.1.js)
- [jQuery.Sparklines](http://omnipotent.net/jquery.sparkline/#s-about) (jquery.sparkline.min.js)
- [NVD3.js](http://novus.github.com/nvd3/) (nv.d3.min.js)
- [Peity](http://benpickles.github.com/peity) (peity.min.js)      
- [Raphael](http://raphaeljs.com) (raphael-min.js)
- [Rickshaw](http://code.shutterstock.com/rickshaw/) (see 'Using Rickshaw' section below)    
- [Smoothie](http://smoothiecharts.org) (smoothie.js)     

If there's a JS library that you would like to have available, send an email to [admin@dashku.com](mailto://admin@dashku.com).

How to use those libraries in your widget
---

We use [head.js](http://headjs.com/) to handle the loading of 3rd-party JS libraries, like this:
    
    head.js('/javascripts/THE_JS_FILE (e.g. d3.v2.min.js)');
    head.ready(function(){ 
      // your code
    });

Here's an example of how that code would be inserted into a widget's code:

    // The widget's html as a jQuery object
    var widget = this.widget;

    // This runs when the widget is loaded
    this.on('load', function(data){

      head.js('/javascripts/d3.v2.min.js');
      head.ready(function(){ 
        // your code
        widget.append("<div id='message'>awaiting transmission</div>").hide().fadeIn('slow');
      });

    });

    // This runs when the widget receives a transmission
    this.on('transmission', function(data){
      var message = widget.find('#message');
      message.text(data.message).hide().fadeIn();
    });

On a sidenote, because Dashku uses them, both [jQuery](http://jquery.com) and [Underscore](http://underscorejs.org) are available (as $ and _ global variables).

Using Rickshaw
---

Rickshaw is built on top of the D3 library, and requires multiple assets. To use it, you will need to do the following:

1 - Place a link in your widget's html tab:

    <link href='/stylesheets/rickshaw.min.css' type="text/stylesheet">

2 - Use head.js to load 3 javascript files in the widget's javascript load function:

    head.js(
      '/javascripts/d3.min.js', 
      '/javascripts/d3.layout.min.js', 
      '/javascripts/rickshaw.min.js'
    );

3 - After the head.js call, write your JS code for rickshaw inside of the head.ready function:

    head.ready(function(){
      // your code here
    }); 
