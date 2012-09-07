Get a dashboard
===

Fetches a dashboard, based on an id passed in the url.

<span class="badge badge-get">GET</span> <span class="url">/api/dashboards/:id</span>

Url Parameters
---

- ID: the id of the dashboard e.g. 4fd1f55b7e9b8705a1000054


    curl -H "Content-Type: application/json" "DASHKU_API_URLapi/dashboards/ID?apiKey=API_KEY"


Response
---

You should expect to get back a dashboard, like the example below.

    {
      "name"         : "Your Dashboard",
      "userId"       : "4fd1f55b7e9b8705a1000053",
      "_id"          : "4fd1f55b7e9b8705a1000054",
      "widgets"      : [],
      "css"          : "",
      "screenWidth"  : "fixed",
      "updatedAt"    : "2012-06-08T12:51:39.695Z",
      "createdAt"    : "2012-06-08T12:51:39.695Z"
    }