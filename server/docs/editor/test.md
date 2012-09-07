Testing the widget
===

The widget editor allows you to change the widget's code, and see the widget updated in realtime.

In order to test that the widget will act the way that you expect it to, there is a specific flow to follow.

1. Make changes to your widget's code (HTML, CSS, JavaScript, Example JSON).
2. Once those changes are made, click on the "Load Function" button.
   
   This executes the widget's load function, which you'll need to do if you've changed what the widget will do on load (i.e. load a 3rd-party library like D3)

3. Click on the "Test Transmission" button.

   This tests the widget's transmission function. What it will do is use the example JSON as specified in that widget, and pass it to the transmission function. This simulates what will happen when you use the HTTP API to transmit JSON data to the widget.

   There will probably be cases where you want to test multiple transmissions, but with different values in the example JSON. Simply alter the JSON in the code tab, and then click on the "Test Transmission" to see how the widget responds. That way you can check how the widget handles differing values (especially useful in the case of widgets using graphs, or appending elements to the widget's DOM upon transmission).

You can imagine the flow as going across the code tabs at the top of the editor window, and then, and then across the buttons at the bottom.