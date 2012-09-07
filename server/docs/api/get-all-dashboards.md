Get all dashboards
===

Fetches all your dashboards


<span class="badge badge-get">GET</span> <span class="url">/api/dashboards</span>

    curl -H "Content-Type: application/json" "DASHKU_API_URLapi/dashboards?apiKey=API_KEY"

Response
---

You should expect to get back an array of dashboards, like the example below.

    [
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
    ]