Create a dashboard
===

Creates a new dashboard

<span class="badge badge-post">POST</span> <span class="url">/api/dashboards</span>

Post Body
---

You will want to post a body with the following attributes:

- name: The name for your dashboard e.g. "Account Management"
- screenWidth: The screen width of the dashboard e.g. "fixed" | "fluid"
- css: The custom CSS for the dashboard

    curl -X POST -d "name=Account%20Management" "DASHKU_API_URLapi/dashboards?apiKey=API_KEY"

If you want, go ahead and run that command in your terminal, then take a look at the list of dashboards in the navigation bar at the top.

Response
---

You should expect to get back a new dashboard, like the example below.

    {
      "name"        : "Account Management",
      "userId"      : "4fd1f55b7e9b8705a1000053",
      "_id"         : "4fd2037a152714faa1000003",
      "widgets"     : [],
      "css"         : "",
      "screenWidth" : "fixed",
      "updatedAt"   : "2012-06-08T13:51:54.972Z",
      "createdAt"   : "2012-06-08T13:51:54.972Z"
    }