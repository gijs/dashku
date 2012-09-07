How does Dashku work?
===

Dashku is a single page application, built using the SocketStream web framework. For more information on SocketStream, click [here](https://github.com/socketstream/socketstream).

Dashku works by allowing you to create highly-customised Dashboards and Widgets. The Widgets comprise of HTML, CSS, and JavaScript. This allows you to control not just the look and feel of the Widget, but also what data it receives, and how it presents that data.

Data is transmitted to the Widgets as JSON, via a HTTP API. You can download server scripts in a variety of languages, and then configure the server script to transmit whatever JSON data you like, and whenever.

When you hit the HTTP API, your widget on the dashboard receives the data, and acts on it. Below is a graphic that illustrates this:

<div id="dash-work">
  ![The Widget editor](/images/docs/dashku-work.png)
</div>